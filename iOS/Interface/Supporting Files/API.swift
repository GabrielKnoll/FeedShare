// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

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

  public var queryDocument: String { return operationDefinition.appending("\n" + EpisodeAttachmentFragment.fragmentDefinition).appending("\n" + ComposerPodcastFragment.fragmentDefinition) }

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
      findPodcast(query: $query) {
        __typename
        ...ComposerPodcastFragment
      }
    }
    """

  public let operationName: String = "FindPodcast"

  public var queryDocument: String { return operationDefinition.appending("\n" + ComposerPodcastFragment.fragmentDefinition) }

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
        GraphQLField("findPodcast", arguments: ["query": GraphQLVariable("query")], type: .list(.object(FindPodcast.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(findPodcast: [FindPodcast?]? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "findPodcast": findPodcast.flatMap { (value: [FindPodcast?]) -> [ResultMap?] in value.map { (value: FindPodcast?) -> ResultMap? in value.flatMap { (value: FindPodcast) -> ResultMap in value.resultMap } } }])
    }

    public var findPodcast: [FindPodcast?]? {
      get {
        return (resultMap["findPodcast"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [FindPodcast?] in value.map { (value: ResultMap?) -> FindPodcast? in value.flatMap { (value: ResultMap) -> FindPodcast in FindPodcast(unsafeResultMap: value) } } }
      }
      set {
        resultMap.updateValue(newValue.flatMap { (value: [FindPodcast?]) -> [ResultMap?] in value.map { (value: FindPodcast?) -> ResultMap? in value.flatMap { (value: FindPodcast) -> ResultMap in value.resultMap } } }, forKey: "findPodcast")
      }
    }

    public struct FindPodcast: GraphQLSelectionSet {
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

  public var queryDocument: String { return operationDefinition.appending("\n" + EpisodeAttachmentFragment.fragmentDefinition) }

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
    mutation CreateShare($message: String!, $episodeId: ID!) {
      createShare(message: $message, episodeId: $episodeId) {
        __typename
        ...ShareFragment
      }
    }
    """

  public let operationName: String = "CreateShare"

  public var queryDocument: String { return operationDefinition.appending("\n" + ShareFragment.fragmentDefinition).appending("\n" + EpisodeAttachmentFragment.fragmentDefinition) }

  public var message: String
  public var episodeId: GraphQLID

  public init(message: String, episodeId: GraphQLID) {
    self.message = message
    self.episodeId = episodeId
  }

  public var variables: GraphQLMap? {
    return ["message": message, "episodeId": episodeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createShare", arguments: ["message": GraphQLVariable("message"), "episodeId": GraphQLVariable("episodeId")], type: .object(CreateShare.selections)),
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

  public var queryDocument: String { return operationDefinition.appending("\n" + Client.fragmentDefinition) }

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

      public init(id: GraphQLID, icon: String, displayName: String) {
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

public struct ComposerPodcastFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ComposerPodcastFragment on Podcast {
      __typename
      id
      title
      publisher
      artwork(size: 70, scale: 2)
    }
    """

  public static let possibleTypes: [String] = ["Podcast"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("publisher", type: .nonNull(.scalar(String.self))),
      GraphQLField("artwork", arguments: ["size": 70, "scale": 2], type: .scalar(String.self)),
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

public struct Client: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment Client on PodcastClient {
      __typename
      id
      icon
      displayName
    }
    """

  public static let possibleTypes: [String] = ["PodcastClient"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("icon", type: .nonNull(.scalar(String.self))),
      GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: GraphQLID, icon: String, displayName: String) {
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
        profilePicture(size: 100, scale: 2)
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
        GraphQLField("profilePicture", arguments: ["size": 100, "scale": 2], type: .scalar(String.self)),
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
        profilePicture(size: 100, scale: 2)
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
}
