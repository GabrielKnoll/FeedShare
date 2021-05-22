// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public enum FeedType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case global
  case personal
  case user
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "Global": self = .global
      case "Personal": self = .personal
      case "User": self = .user
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .global: return "Global"
      case .personal: return "Personal"
      case .user: return "User"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: FeedType, rhs: FeedType) -> Bool {
    switch (lhs, rhs) {
      case (.global, .global): return true
      case (.personal, .personal): return true
      case (.user, .user): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [FeedType] {
    return [
      .global,
      .personal,
      .user,
    ]
  }
}

public final class EpisodeOverlayQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query EpisodeOverlay($id: ID!) {
      node(id: $id) {
        __typename
        ... on Episode {
          ...EpisodeOverlayFragment
        }
      }
    }
    """

  public let operationName: String = "EpisodeOverlay"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + EpisodeOverlayFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("node", arguments: ["id": GraphQLVariable("id")], type: .object(Node.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(node: Node? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
      public static let possibleTypes: [String] = ["Episode", "Podcast", "PodcastClient", "Share", "User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLTypeCase(
            variants: ["Episode": AsEpisode.selections],
            default: [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            ]
          )
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makePodcast() -> Node {
        return Node(unsafeResultMap: ["__typename": "Podcast"])
      }

      public static func makePodcastClient() -> Node {
        return Node(unsafeResultMap: ["__typename": "PodcastClient"])
      }

      public static func makeShare() -> Node {
        return Node(unsafeResultMap: ["__typename": "Share"])
      }

      public static func makeUser() -> Node {
        return Node(unsafeResultMap: ["__typename": "User"])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var asEpisode: AsEpisode? {
        get {
          if !AsEpisode.possibleTypes.contains(__typename) { return nil }
          return AsEpisode(unsafeResultMap: resultMap)
        }
        set {
          guard let newValue = newValue else { return }
          resultMap = newValue.resultMap
        }
      }

      public struct AsEpisode: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Episode"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(EpisodeOverlayFragment.self),
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

          public var episodeOverlayFragment: EpisodeOverlayFragment {
            get {
              return EpisodeOverlayFragment(unsafeResultMap: resultMap)
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

public final class FeedQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Feed($after: String, $feedType: FeedType!) {
      shares(last: 40, after: $after, feedType: $feedType) {
        __typename
        pageInfo {
          __typename
          hasNextPage
        }
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

  public let operationName: String = "Feed"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ShareFragment.fragmentDefinition)
    document.append("\n" + EpisodeAttachmentFragment.fragmentDefinition)
    return document
  }

  public var after: String?
  public var feedType: FeedType

  public init(after: String? = nil, feedType: FeedType) {
    self.after = after
    self.feedType = feedType
  }

  public var variables: GraphQLMap? {
    return ["after": after, "feedType": feedType]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("shares", arguments: ["last": 40, "after": GraphQLVariable("after"), "feedType": GraphQLVariable("feedType")], type: .nonNull(.object(Share.selections))),
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
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(pageInfo: PageInfo, edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ShareConnection", "pageInfo": pageInfo.resultMap, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// https://facebook.github.io/relay/graphql/connections.htm#sec-undefined.PageInfo
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// https://facebook.github.io/relay/graphql/connections.htm#sec-Edge-Types
      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hasNextPage: Bool) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "hasNextPage": hasNextPage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Used to indicate whether more edges exist following the set defined by the clients arguments.
        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ShareEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("cursor", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cursor: String, node: Node? = nil) {
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

        /// https://facebook.github.io/relay/graphql/connections.htm#sec-Cursor
        public var cursor: String {
          get {
            return resultMap["cursor"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "cursor")
          }
        }

        /// https://facebook.github.io/relay/graphql/connections.htm#sec-Node
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
              GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
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

          /// Unique identifier for the resource
          public var id: GraphQLID {
            get {
              return resultMap["id"]! as! GraphQLID
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

public final class AddToPersonalFeedMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation AddToPersonalFeed($id: ID!) {
      addToPersonalFeed(shareId: $id) {
        __typename
        ...ShareFragment
      }
    }
    """

  public let operationName: String = "AddToPersonalFeed"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ShareFragment.fragmentDefinition)
    document.append("\n" + EpisodeAttachmentFragment.fragmentDefinition)
    return document
  }

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("addToPersonalFeed", arguments: ["shareId": GraphQLVariable("id")], type: .object(AddToPersonalFeed.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(addToPersonalFeed: AddToPersonalFeed? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "addToPersonalFeed": addToPersonalFeed.flatMap { (value: AddToPersonalFeed) -> ResultMap in value.resultMap }])
    }

    public var addToPersonalFeed: AddToPersonalFeed? {
      get {
        return (resultMap["addToPersonalFeed"] as? ResultMap).flatMap { AddToPersonalFeed(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "addToPersonalFeed")
      }
    }

    public struct AddToPersonalFeed: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Share"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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

public final class SettingsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Settings {
      pages {
        __typename
        id
        title
        content
      }
    }
    """

  public let operationName: String = "Settings"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("pages", type: .list(.object(Page.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(pages: [Page?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "pages": pages.flatMap { (value: [Page?]) -> [ResultMap?] in value.map { (value: Page?) -> ResultMap? in value.flatMap { (value: Page) -> ResultMap in value.resultMap } } }])
    }

    public var pages: [Page?]? {
      get {
        return (resultMap["pages"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Page?] in value.map { (value: ResultMap?) -> Page? in value.flatMap { (value: ResultMap) -> Page in Page(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [Page?]) -> [ResultMap?] in value.map { (value: Page?) -> ResultMap? in value.flatMap { (value: Page) -> ResultMap in value.resultMap } } }, forKey: "pages")
      }
    }

    public struct Page: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Page"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("content", type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, content: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Page", "id": id, "title": title, "content": content])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
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

      public var content: String? {
        get {
          return resultMap["content"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "content")
        }
      }
    }
  }
}

public final class ResolveQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Resolve($url: String!) {
      resolveShareUrl(url: $url) {
        __typename
        episode {
          __typename
          ...EpisodeAttachmentFragment
        }
        podcast {
          __typename
          id
          ...ComposerPodcastFragment
          latestEpisodes {
            __typename
            ...EpisodeAttachmentFragment
          }
        }
      }
    }
    """

  public let operationName: String = "Resolve"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + EpisodeAttachmentFragment.fragmentDefinition)
    document.append("\n" + ComposerPodcastFragment.fragmentDefinition)
    return document
  }

  public var url: String

  public init(url: String) {
    self.url = url
  }

  public var variables: GraphQLMap? {
    return ["url": url]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("resolveShareUrl", arguments: ["url": GraphQLVariable("url")], type: .object(ResolveShareUrl.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(resolveShareUrl: ResolveShareUrl? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "resolveShareUrl": resolveShareUrl.flatMap { (value: ResolveShareUrl) -> ResultMap in value.resultMap }])
    }

    public var resolveShareUrl: ResolveShareUrl? {
      get {
        return (resultMap["resolveShareUrl"] as? ResultMap).flatMap { ResolveShareUrl(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "resolveShareUrl")
      }
    }

    public struct ResolveShareUrl: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ResolvedShareUrl"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("episode", type: .object(Episode.selections)),
          GraphQLField("podcast", type: .object(Podcast.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(episode: Episode? = nil, podcast: Podcast? = nil) {
        self.init(unsafeResultMap: ["__typename": "ResolvedShareUrl", "episode": episode.flatMap { (value: Episode) -> ResultMap in value.resultMap }, "podcast": podcast.flatMap { (value: Podcast) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var episode: Episode? {
        get {
          return (resultMap["episode"] as? ResultMap).flatMap { Episode(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "episode")
        }
      }

      public var podcast: Podcast? {
        get {
          return (resultMap["podcast"] as? ResultMap).flatMap { Podcast(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "podcast")
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

      public struct Podcast: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Podcast"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLFragmentSpread(ComposerPodcastFragment.self),
            GraphQLField("latestEpisodes", type: .list(.object(LatestEpisode.selections))),
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

        /// Unique identifier for the resource
        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var latestEpisodes: [LatestEpisode?]? {
          get {
            return (resultMap["latestEpisodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LatestEpisode?] in value.map { (value: ResultMap?) -> LatestEpisode? in value.flatMap { (value: ResultMap) -> LatestEpisode in LatestEpisode(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [LatestEpisode?]) -> [ResultMap?] in value.map { (value: LatestEpisode?) -> ResultMap? in value.flatMap { (value: LatestEpisode) -> ResultMap in value.resultMap } } }, forKey: "latestEpisodes")
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

          public var composerPodcastFragment: ComposerPodcastFragment {
            get {
              return ComposerPodcastFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }

        public struct LatestEpisode: GraphQLSelectionSet {
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
    }
  }
}

public final class FindPodcastQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query FindPodcast($query: String!) {
      typeaheadPodcast(query: $query) {
        __typename
        ...ComposerPodcastFragment
      }
    }
    """

  public let operationName: String = "FindPodcast"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ComposerPodcastFragment.fragmentDefinition)
    return document
  }

  public var query: String

  public init(query: String) {
    self.query = query
  }

  public var variables: GraphQLMap? {
    return ["query": query]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("typeaheadPodcast", arguments: ["query": GraphQLVariable("query")], type: .list(.object(TypeaheadPodcast.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(typeaheadPodcast: [TypeaheadPodcast?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "typeaheadPodcast": typeaheadPodcast.flatMap { (value: [TypeaheadPodcast?]) -> [ResultMap?] in value.map { (value: TypeaheadPodcast?) -> ResultMap? in value.flatMap { (value: TypeaheadPodcast) -> ResultMap in value.resultMap } } }])
    }

    public var typeaheadPodcast: [TypeaheadPodcast?]? {
      get {
        return (resultMap["typeaheadPodcast"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [TypeaheadPodcast?] in value.map { (value: ResultMap?) -> TypeaheadPodcast? in value.flatMap { (value: ResultMap) -> TypeaheadPodcast in TypeaheadPodcast(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [TypeaheadPodcast?]) -> [ResultMap?] in value.map { (value: TypeaheadPodcast?) -> ResultMap? in value.flatMap { (value: TypeaheadPodcast) -> ResultMap in value.resultMap } } }, forKey: "typeaheadPodcast")
      }
    }

    public struct TypeaheadPodcast: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Podcast"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ComposerPodcastFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, publisher: String, artwork: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Podcast", "id": id, "title": title, "publisher": publisher, "artwork": artwork])
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

        public var composerPodcastFragment: ComposerPodcastFragment {
          get {
            return ComposerPodcastFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class LatestEpisodesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query LatestEpisodes($podcast: ID!) {
      node(id: $podcast) {
        __typename
        ... on Podcast {
          latestEpisodes {
            __typename
            ...EpisodeAttachmentFragment
          }
        }
      }
    }
    """

  public let operationName: String = "LatestEpisodes"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + EpisodeAttachmentFragment.fragmentDefinition)
    return document
  }

  public var podcast: GraphQLID

  public init(podcast: GraphQLID) {
    self.podcast = podcast
  }

  public var variables: GraphQLMap? {
    return ["podcast": podcast]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("node", arguments: ["id": GraphQLVariable("podcast")], type: .object(Node.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(node: Node? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
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
      public static let possibleTypes: [String] = ["Episode", "Podcast", "PodcastClient", "Share", "User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLTypeCase(
            variants: ["Podcast": AsPodcast.selections],
            default: [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            ]
          )
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeEpisode() -> Node {
        return Node(unsafeResultMap: ["__typename": "Episode"])
      }

      public static func makePodcastClient() -> Node {
        return Node(unsafeResultMap: ["__typename": "PodcastClient"])
      }

      public static func makeShare() -> Node {
        return Node(unsafeResultMap: ["__typename": "Share"])
      }

      public static func makeUser() -> Node {
        return Node(unsafeResultMap: ["__typename": "User"])
      }

      public static func makePodcast(latestEpisodes: [AsPodcast.LatestEpisode?]? = nil) -> Node {
        return Node(unsafeResultMap: ["__typename": "Podcast", "latestEpisodes": latestEpisodes.flatMap { (value: [AsPodcast.LatestEpisode?]) -> [ResultMap?] in value.map { (value: AsPodcast.LatestEpisode?) -> ResultMap? in value.flatMap { (value: AsPodcast.LatestEpisode) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var asPodcast: AsPodcast? {
        get {
          if !AsPodcast.possibleTypes.contains(__typename) { return nil }
          return AsPodcast(unsafeResultMap: resultMap)
        }
        set {
          guard let newValue = newValue else { return }
          resultMap = newValue.resultMap
        }
      }

      public struct AsPodcast: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Podcast"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("latestEpisodes", type: .list(.object(LatestEpisode.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(latestEpisodes: [LatestEpisode?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "Podcast", "latestEpisodes": latestEpisodes.flatMap { (value: [LatestEpisode?]) -> [ResultMap?] in value.map { (value: LatestEpisode?) -> ResultMap? in value.flatMap { (value: LatestEpisode) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var latestEpisodes: [LatestEpisode?]? {
          get {
            return (resultMap["latestEpisodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [LatestEpisode?] in value.map { (value: ResultMap?) -> LatestEpisode? in value.flatMap { (value: ResultMap) -> LatestEpisode in LatestEpisode(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [LatestEpisode?]) -> [ResultMap?] in value.map { (value: LatestEpisode?) -> ResultMap? in value.flatMap { (value: LatestEpisode) -> ResultMap in value.resultMap } } }, forKey: "latestEpisodes")
          }
        }

        public struct LatestEpisode: GraphQLSelectionSet {
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
    }
  }
}

public final class CreateShareMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateShare($message: String!, $episodeId: ID!, $shareOnTwitter: Boolean, $hideFromGlobalFeed: Boolean) {
      createShare(
        message: $message
        episodeId: $episodeId
        shareOnTwitter: $shareOnTwitter
        hideFromGlobalFeed: $hideFromGlobalFeed
      ) {
        __typename
        ...ShareFragment
      }
    }
    """

  public let operationName: String = "CreateShare"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ShareFragment.fragmentDefinition)
    document.append("\n" + EpisodeAttachmentFragment.fragmentDefinition)
    return document
  }

  public var message: String
  public var episodeId: GraphQLID
  public var shareOnTwitter: Bool?
  public var hideFromGlobalFeed: Bool?

  public init(message: String, episodeId: GraphQLID, shareOnTwitter: Bool? = nil, hideFromGlobalFeed: Bool? = nil) {
    self.message = message
    self.episodeId = episodeId
    self.shareOnTwitter = shareOnTwitter
    self.hideFromGlobalFeed = hideFromGlobalFeed
  }

  public var variables: GraphQLMap? {
    return ["message": message, "episodeId": episodeId, "shareOnTwitter": shareOnTwitter, "hideFromGlobalFeed": hideFromGlobalFeed]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createShare", arguments: ["message": GraphQLVariable("message"), "episodeId": GraphQLVariable("episodeId"), "shareOnTwitter": GraphQLVariable("shareOnTwitter"), "hideFromGlobalFeed": GraphQLVariable("hideFromGlobalFeed")], type: .object(CreateShare.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createShare: CreateShare? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createShare": createShare.flatMap { (value: CreateShare) -> ResultMap in value.resultMap }])
    }

    public var createShare: CreateShare? {
      get {
        return (resultMap["createShare"] as? ResultMap).flatMap { CreateShare(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createShare")
      }
    }

    public struct CreateShare: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Share"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
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

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ViewerFragment.fragmentDefinition)
    document.append("\n" + FollowFragment.fragmentDefinition)
    return document
  }

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
      createViewer(
        twitterId: $twitterId
        twitterToken: $twitterToken
        twitterTokenSecret: $twitterTokenSecret
      ) {
        __typename
        ...ViewerFragment
      }
    }
    """

  public let operationName: String = "CreateViewer"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ViewerFragment.fragmentDefinition)
    document.append("\n" + FollowFragment.fragmentDefinition)
    return document
  }

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

public final class PodcastClientsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query PodcastClients {
      podcastClient {
        __typename
        ...Client
      }
    }
    """

  public let operationName: String = "PodcastClients"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + Client.fragmentDefinition)
    return document
  }

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
          GraphQLFragmentSpread(Client.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, icon: String, displayName: String, subscribeUrl: String, subscribeUrlNeedsProtocol: Bool) {
        self.init(unsafeResultMap: ["__typename": "PodcastClient", "id": id, "icon": icon, "displayName": displayName, "subscribeUrl": subscribeUrl, "subscribeUrlNeedsProtocol": subscribeUrlNeedsProtocol])
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

        public var client: Client {
          get {
            return Client(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public struct EpisodeOverlayFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment EpisodeOverlayFragment on Episode {
      __typename
      description
      artwork(size: 100, scale: 2)
      datePublished
      durationSeconds
      url
      podcast {
        __typename
        feed
        url
        artwork(size: 100, scale: 2)
      }
    }
    """

  public static let possibleTypes: [String] = ["Episode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("artwork", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
      GraphQLField("datePublished", type: .nonNull(.scalar(String.self))),
      GraphQLField("durationSeconds", type: .scalar(Int.self)),
      GraphQLField("url", type: .scalar(String.self)),
      GraphQLField("podcast", type: .nonNull(.object(Podcast.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(description: String? = nil, artwork: String? = nil, datePublished: String, durationSeconds: Int? = nil, url: String? = nil, podcast: Podcast) {
    self.init(unsafeResultMap: ["__typename": "Episode", "description": description, "artwork": artwork, "datePublished": datePublished, "durationSeconds": durationSeconds, "url": url, "podcast": podcast.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
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

  public var artwork: String? {
    get {
      return resultMap["artwork"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "artwork")
    }
  }

  public var datePublished: String {
    get {
      return resultMap["datePublished"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "datePublished")
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

  public var url: String? {
    get {
      return resultMap["url"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "url")
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
        GraphQLField("feed", type: .nonNull(.scalar(String.self))),
        GraphQLField("url", type: .scalar(String.self)),
        GraphQLField("artwork", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(feed: String, url: String? = nil, artwork: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Podcast", "feed": feed, "url": url, "artwork": artwork])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var feed: String {
      get {
        return resultMap["feed"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "feed")
      }
    }

    public var url: String? {
      get {
        return resultMap["url"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "url")
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
  }
}

public struct ShareFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ShareFragment on Share {
      __typename
      id
      author {
        __typename
        id
        handle
        displayName
        profilePicture(size: 100, scale: 2)
      }
      message
      createdAt
      isInGlobalFeed: isInFeed(feedType: Global)
      isInPersonalFeed: isInFeed(feedType: Personal)
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
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("author", type: .nonNull(.object(Author.selections))),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("isInFeed", alias: "isInGlobalFeed", arguments: ["feedType": "Global"], type: .scalar(Bool.self)),
      GraphQLField("isInFeed", alias: "isInPersonalFeed", arguments: ["feedType": "Personal"], type: .scalar(Bool.self)),
      GraphQLField("episode", type: .nonNull(.object(Episode.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, author: Author, message: String? = nil, createdAt: String, isInGlobalFeed: Bool? = nil, isInPersonalFeed: Bool? = nil, episode: Episode) {
    self.init(unsafeResultMap: ["__typename": "Share", "id": id, "author": author.resultMap, "message": message, "createdAt": createdAt, "isInGlobalFeed": isInGlobalFeed, "isInPersonalFeed": isInPersonalFeed, "episode": episode.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Unique identifier for the resource
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
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

  public var isInGlobalFeed: Bool? {
    get {
      return resultMap["isInGlobalFeed"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isInGlobalFeed")
    }
  }

  public var isInPersonalFeed: Bool? {
    get {
      return resultMap["isInPersonalFeed"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isInPersonalFeed")
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
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("handle", type: .nonNull(.scalar(String.self))),
        GraphQLField("displayName", type: .scalar(String.self)),
        GraphQLField("profilePicture", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, handle: String, displayName: String? = nil, profilePicture: String? = nil) {
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

    /// Unique identifier for the resource
    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
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

public struct Client: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment Client on PodcastClient {
      __typename
      id
      icon
      displayName
      subscribeUrl
      subscribeUrlNeedsProtocol
    }
    """

  public static let possibleTypes: [String] = ["PodcastClient"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("icon", type: .nonNull(.scalar(String.self))),
      GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
      GraphQLField("subscribeUrl", type: .nonNull(.scalar(String.self))),
      GraphQLField("subscribeUrlNeedsProtocol", type: .nonNull(.scalar(Bool.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, icon: String, displayName: String, subscribeUrl: String, subscribeUrlNeedsProtocol: Bool) {
    self.init(unsafeResultMap: ["__typename": "PodcastClient", "id": id, "icon": icon, "displayName": displayName, "subscribeUrl": subscribeUrl, "subscribeUrlNeedsProtocol": subscribeUrlNeedsProtocol])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Unique identifier for the resource
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
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

  public var subscribeUrl: String {
    get {
      return resultMap["subscribeUrl"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "subscribeUrl")
    }
  }

  public var subscribeUrlNeedsProtocol: Bool {
    get {
      return resultMap["subscribeUrlNeedsProtocol"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "subscribeUrlNeedsProtocol")
    }
  }
}

public struct ComposerPodcastFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ComposerPodcastFragment on Podcast {
      __typename
      id
      title
      publisher
      artwork(size: 100, scale: 2)
    }
    """

  public static let possibleTypes: [String] = ["Podcast"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("publisher", type: .nonNull(.scalar(String.self))),
      GraphQLField("artwork", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, title: String, publisher: String, artwork: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Podcast", "id": id, "title": title, "publisher": publisher, "artwork": artwork])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Unique identifier for the resource
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
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

  public var publisher: String {
    get {
      return resultMap["publisher"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "publisher")
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
}

public struct EpisodeAttachmentFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment EpisodeAttachmentFragment on Episode {
      __typename
      id
      title
      artwork(size: 65, scale: 2)
      durationSeconds
      description
      datePublished
      podcast {
        __typename
        title
        description
        publisher
        artwork(size: 65, scale: 2)
      }
    }
    """

  public static let possibleTypes: [String] = ["Episode"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("artwork", arguments: ["size": 65, "scale": 2], type: .scalar(String.self)),
      GraphQLField("durationSeconds", type: .scalar(Int.self)),
      GraphQLField("description", type: .scalar(String.self)),
      GraphQLField("datePublished", type: .nonNull(.scalar(String.self))),
      GraphQLField("podcast", type: .nonNull(.object(Podcast.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, title: String, artwork: String? = nil, durationSeconds: Int? = nil, description: String? = nil, datePublished: String, podcast: Podcast) {
    self.init(unsafeResultMap: ["__typename": "Episode", "id": id, "title": title, "artwork": artwork, "durationSeconds": durationSeconds, "description": description, "datePublished": datePublished, "podcast": podcast.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Unique identifier for the resource
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
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

  public var datePublished: String {
    get {
      return resultMap["datePublished"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "datePublished")
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
        GraphQLField("artwork", arguments: ["size": 65, "scale": 2], type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(title: String, description: String? = nil, publisher: String, artwork: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Podcast", "title": title, "description": description, "publisher": publisher, "artwork": artwork])
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

    public var artwork: String? {
      get {
        return resultMap["artwork"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "artwork")
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
      messageLimit
      personalFeedLastChecked
      user {
        __typename
        id
        handle
        displayName
        profilePicture(size: 100, scale: 2)
        following(first: 4) {
          __typename
          totalCount
          edges {
            __typename
            node {
              __typename
              ...FollowFragment
            }
          }
        }
        followers(first: 4) {
          __typename
          totalCount
          edges {
            __typename
            node {
              __typename
              ...FollowFragment
            }
          }
        }
      }
    }
    """

  public static let possibleTypes: [String] = ["Viewer"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("token", type: .nonNull(.scalar(String.self))),
      GraphQLField("personalFeed", type: .nonNull(.scalar(String.self))),
      GraphQLField("messageLimit", type: .nonNull(.scalar(Int.self))),
      GraphQLField("personalFeedLastChecked", type: .scalar(String.self)),
      GraphQLField("user", type: .nonNull(.object(User.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(token: String, personalFeed: String, messageLimit: Int, personalFeedLastChecked: String? = nil, user: User) {
    self.init(unsafeResultMap: ["__typename": "Viewer", "token": token, "personalFeed": personalFeed, "messageLimit": messageLimit, "personalFeedLastChecked": personalFeedLastChecked, "user": user.resultMap])
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

  public var messageLimit: Int {
    get {
      return resultMap["messageLimit"]! as! Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "messageLimit")
    }
  }

  public var personalFeedLastChecked: String? {
    get {
      return resultMap["personalFeedLastChecked"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "personalFeedLastChecked")
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
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("handle", type: .nonNull(.scalar(String.self))),
        GraphQLField("displayName", type: .scalar(String.self)),
        GraphQLField("profilePicture", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
        GraphQLField("following", arguments: ["first": 4], type: .nonNull(.object(Following.selections))),
        GraphQLField("followers", arguments: ["first": 4], type: .nonNull(.object(Follower.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(id: GraphQLID, handle: String, displayName: String? = nil, profilePicture: String? = nil, following: Following, followers: Follower) {
      self.init(unsafeResultMap: ["__typename": "User", "id": id, "handle": handle, "displayName": displayName, "profilePicture": profilePicture, "following": following.resultMap, "followers": followers.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    /// Unique identifier for the resource
    public var id: GraphQLID {
      get {
        return resultMap["id"]! as! GraphQLID
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

    public var following: Following {
      get {
        return Following(unsafeResultMap: resultMap["following"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "following")
      }
    }

    public var followers: Follower {
      get {
        return Follower(unsafeResultMap: resultMap["followers"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "followers")
      }
    }

    public struct Following: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CountableUserConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalCount", type: .scalar(Int.self)),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(totalCount: Int? = nil, edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "CountableUserConnection", "totalCount": totalCount, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var totalCount: Int? {
        get {
          return resultMap["totalCount"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "totalCount")
        }
      }

      /// https://facebook.github.io/relay/graphql/connections.htm#sec-Edge-Types
      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CountableUserEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "CountableUserEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// https://facebook.github.io/relay/graphql/connections.htm#sec-Node
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(FollowFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, displayName: String? = nil, profilePicture: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "User", "id": id, "displayName": displayName, "profilePicture": profilePicture])
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

            public var followFragment: FollowFragment {
              get {
                return FollowFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }

    public struct Follower: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CountableUserConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("totalCount", type: .scalar(Int.self)),
          GraphQLField("edges", type: .list(.object(Edge.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(totalCount: Int? = nil, edges: [Edge?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "CountableUserConnection", "totalCount": totalCount, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var totalCount: Int? {
        get {
          return resultMap["totalCount"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "totalCount")
        }
      }

      /// https://facebook.github.io/relay/graphql/connections.htm#sec-Edge-Types
      public var edges: [Edge?]? {
        get {
          return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
        }
      }

      public struct Edge: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CountableUserEdge"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("node", type: .object(Node.selections)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(node: Node? = nil) {
          self.init(unsafeResultMap: ["__typename": "CountableUserEdge", "node": node.flatMap { (value: Node) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// https://facebook.github.io/relay/graphql/connections.htm#sec-Node
        public var node: Node? {
          get {
            return (resultMap["node"] as? ResultMap).flatMap { Node(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "node")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(FollowFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(id: GraphQLID, displayName: String? = nil, profilePicture: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "User", "id": id, "displayName": displayName, "profilePicture": profilePicture])
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

            public var followFragment: FollowFragment {
              get {
                return FollowFragment(unsafeResultMap: resultMap)
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

public struct FollowFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment FollowFragment on User {
      __typename
      id
      displayName
      profilePicture(size: 36, scale: 2)
    }
    """

  public static let possibleTypes: [String] = ["User"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("displayName", type: .scalar(String.self)),
      GraphQLField("profilePicture", arguments: ["size": 36, "scale": 2], type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, displayName: String? = nil, profilePicture: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "User", "id": id, "displayName": displayName, "profilePicture": profilePicture])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Unique identifier for the resource
  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
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
