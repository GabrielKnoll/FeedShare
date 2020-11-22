// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum PodcastClientId: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case applePodcasts
  case castro
  case overcast
  case pocketCasts
  case spotify
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ApplePodcasts": self = .applePodcasts
      case "Castro": self = .castro
      case "Overcast": self = .overcast
      case "PocketCasts": self = .pocketCasts
      case "Spotify": self = .spotify
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .applePodcasts: return "ApplePodcasts"
      case .castro: return "Castro"
      case .overcast: return "Overcast"
      case .pocketCasts: return "PocketCasts"
      case .spotify: return "Spotify"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PodcastClientId, rhs: PodcastClientId) -> Bool {
    switch (lhs, rhs) {
      case (.applePodcasts, .applePodcasts): return true
      case (.castro, .castro): return true
      case (.overcast, .overcast): return true
      case (.pocketCasts, .pocketCasts): return true
      case (.spotify, .spotify): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PodcastClientId] {
    return [
      .applePodcasts,
      .castro,
      .overcast,
      .pocketCasts,
      .spotify,
    ]
  }
}

public final class FeedStreamModelQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query FeedStreamModel($after: String) {
      shares(last: 20, after: $after) {
        __typename
        edges {
          __typename
          cursor
          node {
            __typename
            id
            ...ShareFragment
          }
        }
      }
    }
    """

  public let operationName: String = "FeedStreamModel"

  public var queryDocument: String { return operationDefinition.appending("\n" + ShareFragment.fragmentDefinition).appending("\n" + EpisodeAttachmentFragment.fragmentDefinition) }

  public var after: String?

  public init(after: String? = nil) {
    self.after = after
  }

  public var variables: GraphQLMap? {
    return ["after": after]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("shares", arguments: ["last": 20, "after": GraphQLVariable("after")], type: .nonNull(.object(Share.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(shares: Share) {
      self.init(unsafeResultMap: ["__typename": "Query", "shares": shares.resultMap])
    }

    public var shares: Share {
      get {
        return Share(unsafeResultMap: resultMap["shares"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "shares")
      }
    }

    public struct Share: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ShareConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ShareConnection", "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ShareEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("cursor", type: .scalar(String.self)),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cursor: String? = nil, node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "ShareEdge", "cursor": cursor, "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var cursor: String? {
          get {
            return resultMap["cursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cursor")
          }
        }

        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Share"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("id", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(ShareFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var id: String {
            get {
              return resultMap["id"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "id")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var shareFragment: ShareFragment {
              get {
                return ShareFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class PodcastClientsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PodcastClients {
      podcastClient {
        __typename
        id
        icon
        displayName
      }
    }
    """

  public let operationName: String = "PodcastClients"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("podcastClient", type: .list(.object(PodcastClient.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(podcastClient: [PodcastClient?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "podcastClient": podcastClient.flatMap { (value: [PodcastClient?]) -> [ResultMap?] in value.map { (value: PodcastClient?) -> ResultMap? in value.flatMap { (value: PodcastClient) -> ResultMap in value.resultMap } } }])
    }

    public var podcastClient: [PodcastClient?]? {
      get {
        return (resultMap["podcastClient"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [PodcastClient?] in value.map { (value: ResultMap?) -> PodcastClient? in value.flatMap { (value: ResultMap) -> PodcastClient in PodcastClient(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [PodcastClient?]) -> [ResultMap?] in value.map { (value: PodcastClient?) -> ResultMap? in value.flatMap { (value: PodcastClient) -> ResultMap in value.resultMap } } }, forKey: "podcastClient")
      }
    }

    public struct PodcastClient: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PodcastClient"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(PodcastClientId.self))),
          GraphQLField("icon", type: .nonNull(.scalar(String.self))),
          GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: PodcastClientId, icon: String, displayName: String) {
        self.init(unsafeResultMap: ["__typename": "PodcastClient", "id": id, "icon": icon, "displayName": displayName])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: PodcastClientId {
        get {
          return resultMap["id"]! as! PodcastClientId
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var icon: String {
        get {
          return resultMap["icon"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "icon")
        }
      }

      public var displayName: String {
        get {
          return resultMap["displayName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "displayName")
        }
      }
    }
  }
}

public final class ViewerModelQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query ViewerModel {
      viewer {
        __typename
        ...ViewerFragment
      }
    }
    """

  public let operationName: String = "ViewerModel"

  public var queryDocument: String { return operationDefinition.appending("\n" + ViewerFragment.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .object(Viewer.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.flatMap { (value: Viewer) -> ResultMap in value.resultMap }])
    }

    public var viewer: Viewer? {
      get {
        return (resultMap["viewer"] as? ResultMap).flatMap { Viewer(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Viewer"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ViewerFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var viewerFragment: ViewerFragment {
          get {
            return ViewerFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateViewerMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateViewer($twitterId: String!, $twitterToken: String!, $twitterTokenSecret: String!) {
      createViewer(twitterId: $twitterId, twitterToken: $twitterToken, twitterTokenSecret: $twitterTokenSecret) {
        __typename
        ...ViewerFragment
      }
    }
    """

  public let operationName: String = "CreateViewer"

  public var queryDocument: String { return operationDefinition.appending("\n" + ViewerFragment.fragmentDefinition) }

  public var twitterId: String
  public var twitterToken: String
  public var twitterTokenSecret: String

  public init(twitterId: String, twitterToken: String, twitterTokenSecret: String) {
    self.twitterId = twitterId
    self.twitterToken = twitterToken
    self.twitterTokenSecret = twitterTokenSecret
  }

  public var variables: GraphQLMap? {
    return ["twitterId": twitterId, "twitterToken": twitterToken, "twitterTokenSecret": twitterTokenSecret]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createViewer", arguments: ["twitterId": GraphQLVariable("twitterId"), "twitterToken": GraphQLVariable("twitterToken"), "twitterTokenSecret": GraphQLVariable("twitterTokenSecret")], type: .object(CreateViewer.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createViewer: CreateViewer? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createViewer": createViewer.flatMap { (value: CreateViewer) -> ResultMap in value.resultMap }])
    }

    public var createViewer: CreateViewer? {
      get {
        return (resultMap["createViewer"] as? ResultMap).flatMap { CreateViewer(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createViewer")
      }
    }

    public struct CreateViewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Viewer"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ViewerFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var viewerFragment: ViewerFragment {
          get {
            return ViewerFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct EpisodeAttachmentFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment EpisodeAttachmentFragment on Episode {
      __typename
      title
      artwork
      durationSeconds
      description
      podcast {
        __typename
        title
        description
        publisher
      }
    }
    """

  public static let possibleTypes: [String] = ["Episode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("artwork", type: .scalar(String.self)),
      GraphQLField("durationSeconds", type: .scalar(Int.self)),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("podcast", type: .nonNull(.object(Podcast.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(title: String, artwork: String? = nil, durationSeconds: Int? = nil, description: String? = nil, podcast: Podcast) {
    self.init(unsafeResultMap: ["__typename": "Episode", "title": title, "artwork": artwork, "durationSeconds": durationSeconds, "description": description, "podcast": podcast.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var title: String {
    get {
      return resultMap["title"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "title")
    }
  }

  public var artwork: String? {
    get {
      return resultMap["artwork"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "artwork")
    }
  }

  public var durationSeconds: Int? {
    get {
      return resultMap["durationSeconds"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "durationSeconds")
    }
  }

  public var description: String? {
    get {
      return resultMap["description"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "description")
    }
  }

  public var podcast: Podcast {
    get {
      return Podcast(unsafeResultMap: resultMap["podcast"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "podcast")
    }
  }

  public struct Podcast: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Podcast"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("description", type: .scalar(String.self)),
        GraphQLField("publisher", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(title: String, description: String? = nil, publisher: String) {
      self.init(unsafeResultMap: ["__typename": "Podcast", "title": title, "description": description, "publisher": publisher])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var title: String {
      get {
        return resultMap["title"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "title")
      }
    }

    public var description: String? {
      get {
        return resultMap["description"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "description")
      }
    }

    public var publisher: String {
      get {
        return resultMap["publisher"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "publisher")
      }
    }
  }
}

public struct ShareFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ShareFragment on Share {
      __typename
      author {
        __typename
        handle
        displayName
        profilePicture
      }
      message
      createdAt
      episode {
        __typename
        ...EpisodeAttachmentFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["Share"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("author", type: .nonNull(.object(Author.selections))),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("episode", type: .nonNull(.object(Episode.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(author: Author, message: String? = nil, createdAt: String, episode: Episode) {
    self.init(unsafeResultMap: ["__typename": "Share", "author": author.resultMap, "message": message, "createdAt": createdAt, "episode": episode.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var author: Author {
    get {
      return Author(unsafeResultMap: resultMap["author"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "author")
    }
  }

  public var message: String? {
    get {
      return resultMap["message"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "message")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var episode: Episode {
    get {
      return Episode(unsafeResultMap: resultMap["episode"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "episode")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("handle", type: .nonNull(.scalar(String.self))),
        GraphQLField("displayName", type: .scalar(String.self)),
        GraphQLField("profilePicture", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(handle: String, displayName: String? = nil, profilePicture: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "handle": handle, "displayName": displayName, "profilePicture": profilePicture])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var handle: String {
      get {
        return resultMap["handle"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "handle")
      }
    }

    public var displayName: String? {
      get {
        return resultMap["displayName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "displayName")
      }
    }

    public var profilePicture: String? {
      get {
        return resultMap["profilePicture"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "profilePicture")
      }
    }
  }

  public struct Episode: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Episode"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(EpisodeAttachmentFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var episodeAttachmentFragment: EpisodeAttachmentFragment {
        get {
          return EpisodeAttachmentFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ViewerFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ViewerFragment on Viewer {
      __typename
      token
      personalFeed
      user {
        __typename
        id
        handle
        displayName
        profilePicture
      }
    }
    """

  public static let possibleTypes: [String] = ["Viewer"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("token", type: .nonNull(.scalar(String.self))),
      GraphQLField("personalFeed", type: .nonNull(.scalar(String.self))),
      GraphQLField("user", type: .nonNull(.object(User.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(token: String, personalFeed: String, user: User) {
    self.init(unsafeResultMap: ["__typename": "Viewer", "token": token, "personalFeed": personalFeed, "user": user.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var token: String {
    get {
      return resultMap["token"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "token")
    }
  }

  public var personalFeed: String {
    get {
      return resultMap["personalFeed"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "personalFeed")
    }
  }

  public var user: User {
    get {
      return User(unsafeResultMap: resultMap["user"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "user")
    }
  }

  public struct User: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(String.self))),
        GraphQLField("handle", type: .nonNull(.scalar(String.self))),
        GraphQLField("displayName", type: .scalar(String.self)),
        GraphQLField("profilePicture", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: String, handle: String, displayName: String? = nil, profilePicture: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "handle": handle, "displayName": displayName, "profilePicture": profilePicture])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var id: String {
      get {
        return resultMap["id"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "id")
      }
    }

    public var handle: String {
      get {
        return resultMap["handle"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "handle")
      }
    }

    public var displayName: String? {
      get {
        return resultMap["displayName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "displayName")
      }
    }

    public var profilePicture: String? {
      get {
        return resultMap["profilePicture"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "profilePicture")
      }
    }
  }
}
