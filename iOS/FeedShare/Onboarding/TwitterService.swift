import Combine
import CommonCrypto
import Shared
import SwiftUI

let TWITTER_URL_SCHEME = "twittersdk"

struct RequestOAuthTokenInput {
    let consumerKey: String
    let consumerSecret: String
    let callbackScheme: String
}

struct RequestOAuthTokenResponse {
    let oauthToken: String
    let oauthTokenSecret: String
    let oauthCallbackConfirmed: String
}

struct RequestAccessTokenInput {
    let consumerKey: String
    let consumerSecret: String
    let requestToken: String // = RequestOAuthTokenResponse.oauthToken
    let requestTokenSecret: String // = RequestOAuthTokenResponse.oauthTokenSecret
    let oauthVerifier: String
}

struct RequestAccessTokenResponse {
    public let accessToken: String
    public let accessTokenSecret: String
    public let userId: String
    public let screenName: String
}

class TwitterService: NSObject, ObservableObject {
    let objectWillChange = PassthroughSubject<TwitterService, Never>()

    @Published public var authUrl: URL? {
        willSet { objectWillChange.send(self) }
    }

    @Published public var showSheet: Bool = false {
        willSet { objectWillChange.send(self) }
    }

    func authorize(viewerModel: ViewerModel) {
        guard let TWITTER_CONSUMER_KEY = Bundle.main.object(forInfoDictionaryKey: "TWITTER_CONSUMER_KEY") as? String else {
            return
        }

        guard let TWITTER_CONSUMER_SECRET = Bundle.main.object(forInfoDictionaryKey: "TWITTER_CONSUMER_SECRET") as? String else {
            return
        }

        showSheet = true // opens the sheet containing our safari view

        // Start Step 1: Requesting an access token
        let oAuthTokenInput = RequestOAuthTokenInput(consumerKey: TWITTER_CONSUMER_KEY,
                                                     consumerSecret: TWITTER_CONSUMER_SECRET,
                                                     callbackScheme: TWITTER_URL_SCHEME)
        requestOAuthToken(args: oAuthTokenInput) { oAuthTokenResponse in
            // Kick off our Step 2 observer: start listening for user login callback in scene delegate (from handleOpenUrl)
            self.callbackObserver = NotificationCenter.default.addObserver(forName: .twitterCallback, object: nil, queue: .main) { notification in
                self.callbackObserver = nil // remove notification observer
                self.showSheet = false // hide sheet containing safari view
                self.authUrl = nil // remove safari view
                guard let url = notification.object as? URL else { return }
                guard let parameters = url.query?.urlQueryStringParameters else { return }
                /*
                 url => twittersdk://success?oauth_token=XXXX&oauth_verifier=ZZZZ
                 url.query => oauth_token=XXXX&oauth_verifier=ZZZZ
                 url.query?.urlQueryStringParameters => ["oauth_token": "XXXX", "oauth_verifier": "YYYY"]
                 */
                guard let verifier = parameters["oauth_verifier"] else { return }
                // Start Step 3: Request Access Token
                let accessTokenInput = RequestAccessTokenInput(consumerKey: TWITTER_CONSUMER_KEY,
                                                               consumerSecret: TWITTER_CONSUMER_SECRET,
                                                               requestToken: oAuthTokenResponse.oauthToken,
                                                               requestTokenSecret: oAuthTokenResponse.oauthTokenSecret,
                                                               oauthVerifier: verifier)
                self.requestAccessToken(args: accessTokenInput) { accessTokenResponse in
                    // Process Completed Successfully!
                    DispatchQueue.main.async {
                        viewerModel.twitterSignIn(
                            twitterId: accessTokenResponse.userId,
                            twitterToken: accessTokenResponse.accessToken,
                            twitterTokenSecret: accessTokenResponse.accessTokenSecret
                        )
                        self.authUrl = nil
                    }
                }
            }

            // Start Step 2: User Twitter Login
            let urlString = "https://api.twitter.com/oauth/authorize?oauth_token=\(oAuthTokenResponse.oauthToken)"
            guard let oauthUrl = URL(string: urlString) else { return }
            DispatchQueue.main.async {
                self.authUrl = oauthUrl // sets our safari view url
            }
        }
    }

    var callbackObserver: Any? {
        willSet {
            // we will add and remove this observer on an as-needed basis
            guard let token = callbackObserver else { return }
            NotificationCenter.default.removeObserver(token)
        }
    }

    func authorizationHeader(params: [String: Any]) -> String {
        var parts: [String] = []
        for param in params {
            let key = param.key.urlEncoded
            let val = "\(param.value)".urlEncoded
            parts.append("\(key)=\"\(val)\"")
        }
        return "OAuth " + parts.sorted().joined(separator: ", ")
    }

    func signatureKey(_ consumerSecret: String, _ oauthTokenSecret: String?) -> String {
        guard let oauthSecret = oauthTokenSecret?.urlEncoded
        else { return consumerSecret.urlEncoded + "&" }

        return consumerSecret.urlEncoded + "&" + oauthSecret
    }

    func signatureParameterString(params: [String: Any]) -> String {
        var result: [String] = []
        for param in params {
            let key = param.key.urlEncoded
            let val = "\(param.value)".urlEncoded
            result.append("\(key)=\(val)")
        }
        return result.sorted().joined(separator: "&")
    }

    func signatureBaseString(_ httpMethod: String = "POST",
                             _ url: String,
                             _ params: [String: Any]) -> String
    {
        let parameterString = signatureParameterString(params: params)
        return httpMethod + "&" + url.urlEncoded + "&" + parameterString.urlEncoded
    }

    func hmac_sha1(signingKey: String, signatureBase: String) -> String {
        // HMAC-SHA1 hashing algorithm returned as a base64 encoded string
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), signingKey, signingKey.count, signatureBase, signatureBase.count, &digest)
        let data = Data(digest)
        return data.base64EncodedString()
    }

    func oauthSignature(httpMethod: String = "POST",
                        url: String,
                        params: [String: Any],
                        consumerSecret: String,
                        oauthTokenSecret: String? = nil) -> String
    {
        let signingKey = signatureKey(consumerSecret, oauthTokenSecret)
        let signatureBase = signatureBaseString(httpMethod, url, params)
        return hmac_sha1(signingKey: signingKey, signatureBase: signatureBase)
    }

    func requestOAuthToken(args: RequestOAuthTokenInput, _ complete: @escaping (RequestOAuthTokenResponse) -> Void) {
        let request = (url: "https://api.twitter.com/oauth/request_token", httpMethod: "POST")
        let callback = args.callbackScheme + "://success"

        var params: [String: Any] = [
            "oauth_callback": callback,
            "oauth_consumer_key": args.consumerKey,
            "oauth_nonce": UUID().uuidString, // nonce can be any 32-bit string made up of random ASCII values
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": String(Int(NSDate().timeIntervalSince1970)),
            "oauth_version": "1.0",
        ]
        // Build the OAuth Signature from Parameters
        params["oauth_signature"] = oauthSignature(httpMethod: request.httpMethod,
                                                   url: request.url,
                                                   params: params,
                                                   consumerSecret: args.consumerSecret)

        // Once OAuth Signature is included in our parameters, build the authorization header
        let authHeader = authorizationHeader(params: params)

        guard let url = URL(string: request.url) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else { return }
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            // dataString should return: oauth_token=XXXX&oauth_token_secret=YYYY&oauth_callback_confirmed=true
            let attributes = dataString.urlQueryStringParameters
            let result = RequestOAuthTokenResponse(oauthToken: attributes["oauth_token"] ?? "",
                                                   oauthTokenSecret: attributes["oauth_token_secret"] ?? "",
                                                   oauthCallbackConfirmed: attributes["oauth_callback_confirmed"] ?? "")
            complete(result)
        }
        task.resume()
    }

    func requestAccessToken(args: RequestAccessTokenInput,
                            _ complete: @escaping (RequestAccessTokenResponse) -> Void)
    {
        let request = (url: "https://api.twitter.com/oauth/access_token", httpMethod: "POST")

        var params: [String: Any] = [
            "oauth_token": args.requestToken,
            "oauth_verifier": args.oauthVerifier,
            "oauth_consumer_key": args.consumerKey,
            "oauth_nonce": UUID().uuidString, // nonce can be any 32-bit string made up of random ASCII values
            "oauth_signature_method": "HMAC-SHA1",
            "oauth_timestamp": String(Int(NSDate().timeIntervalSince1970)),
            "oauth_version": "1.0",
        ]

        // Build the OAuth Signature from Parameters
        params["oauth_signature"] = oauthSignature(httpMethod: request.httpMethod,
                                                   url: request.url,
                                                   params: params,
                                                   consumerSecret: args.consumerSecret,
                                                   oauthTokenSecret: args.requestTokenSecret)

        // Once OAuth Signature is included in our parameters, build the authorization header
        let authHeader = authorizationHeader(params: params)

        guard let url = URL(string: request.url) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.httpMethod
        urlRequest.setValue(authHeader, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest) { data, _, _ in
            guard let data = data else { return }
            guard let dataString = String(data: data, encoding: .utf8) else { return }
            let attributes = dataString.urlQueryStringParameters
            let result = RequestAccessTokenResponse(accessToken: attributes["oauth_token"] ?? "",
                                                    accessTokenSecret: attributes["oauth_token_secret"] ?? "",
                                                    userId: attributes["user_id"] ?? "",
                                                    screenName: attributes["screen_name"] ?? "")

            complete(result)
        }
        task.resume()
    }
}

extension String {
    var urlEncoded: String {
        var charset: CharacterSet = .urlQueryAllowed
        charset.remove(charactersIn: "\n:#/?@!$&'()*+,;=")
        return addingPercentEncoding(withAllowedCharacters: charset) ?? ""
    }

    var urlQueryStringParameters: [String: String] {
        // breaks apart query string into a dictionary of values
        var params = [String: String]()
        let items = split(separator: "&")
        for item in items {
            let combo = item.split(separator: "=")
            if combo.count == 2 {
                let key = "\(combo[0])"
                let val = "\(combo[1])"
                params[key] = val
            }
        }
        return params
    }
}

public extension Notification.Name {
    static let twitterCallback = Notification.Name(rawValue: "Twitter.CallbackNotification.Name")
}
