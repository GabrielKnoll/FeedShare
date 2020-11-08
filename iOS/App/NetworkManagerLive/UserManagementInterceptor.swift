import Apollo
import Foundation
import NetworkManager

class UserManagementInterceptor: ApolloInterceptor {
    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {
        
        if let data = UserDefaults.standard.value(forKey: "viewer") as? Data {
            let viewer = try? PropertyListDecoder().decode(Viewer.self, from: data)
            if let token = viewer?.token {
                request.addHeader(name: "Authorization", value: "Bearer \(token)")
            }
        }
        
        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
