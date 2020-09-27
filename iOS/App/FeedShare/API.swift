// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class FeedStreamQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query FeedStream {
      shares(first: 20) {
        __typename
        edges {
          __typename
          cursor
          node {
            __typename
            ...ShareFragment
          }
        }
      }
    }
    """

  public let operationName: String = "FeedStream"

  public var queryDocument: String { return operationDefinition.appending("\n" + ShareFragment.fragmentDefinition).appending("\n" + AttachmentFragment.fragmentDefinition) }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("shares", arguments: ["first": 20], type: .nonNull(.object(Share.selections))),
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
          GraphQLField("edges", type: .list(.nonNull(.object(Edge.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(edges: [Edge]? = nil) {
        self.init(unsafeResultMap: ["__typename": "ShareConnection", "edges": edges.flatMap { (value: [Edge]) -> [ResultMap] in value.map { (value: Edge) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var edges: [Edge]? {
        get {
          return (resultMap["edges"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Edge] in value.map { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Edge]) -> [ResultMap] in value.map { (value: Edge) -> ResultMap in value.resultMap } }, forKey: "edges")
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
  }
}

public struct AttachmentFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AttachmentFragment on Attachment {
      __typename
      title
      artwork(size: 100)
      ... on Episode {
        durationSeconds
        description
        podcast {
          __typename
          title
        }
      }
      ... on Podcast {
        description
      }
    }
    """

  public static let possibleTypes: [String] = ["Episode", "Podcast"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLTypeCase(
        variants: ["Episode": AsEpisode.selections, "Podcast": AsPodcast.selections],
        default: [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("artwork", arguments: ["size": 100], type: .scalar(String.self)),
        ]
      )
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public static func makeEpisode(title: String, artwork: String? = nil, durationSeconds: Int? = nil, description: String? = nil, podcast: AsEpisode.Podcast) -> AttachmentFragment {
    return AttachmentFragment(unsafeResultMap: ["__typename": "Episode", "title": title, "artwork": artwork, "durationSeconds": durationSeconds, "description": description, "podcast": podcast.resultMap])
  }

  public static func makePodcast(title: String, artwork: String? = nil, description: String? = nil) -> AttachmentFragment {
    return AttachmentFragment(unsafeResultMap: ["__typename": "Podcast", "title": title, "artwork": artwork, "description": description])
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
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("artwork", arguments: ["size": 100], type: .scalar(String.self)),
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
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(title: String) {
        self.init(unsafeResultMap: ["__typename": "Podcast", "title": title])
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
        GraphQLField("title", type: .nonNull(.scalar(String.self))),
        GraphQLField("artwork", arguments: ["size": 100], type: .scalar(String.self)),
        GraphQLField("description", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(title: String, artwork: String? = nil, description: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Podcast", "title": title, "artwork": artwork, "description": description])
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

    public var description: String? {
      get {
        return resultMap["description"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "description")
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
      }
      message
      attachment {
        __typename
        ...AttachmentFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["Share"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("author", type: .nonNull(.object(Author.selections))),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("attachment", type: .object(Attachment.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(author: Author, message: String? = nil, attachment: Attachment? = nil) {
    self.init(unsafeResultMap: ["__typename": "Share", "author": author.resultMap, "message": message, "attachment": attachment.flatMap { (value: Attachment) -> ResultMap in value.resultMap }])
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

  public var attachment: Attachment? {
    get {
      return (resultMap["attachment"] as? ResultMap).flatMap { Attachment(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "attachment")
    }
  }

  public struct Author: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["User"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("handle", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(handle: String) {
      self.init(unsafeResultMap: ["__typename": "User", "handle": handle])
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
  }

  public struct Attachment: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Episode", "Podcast"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AttachmentFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public static func makePodcast(title: String, artwork: String? = nil, description: String? = nil) -> Attachment {
      return Attachment(unsafeResultMap: ["__typename": "Podcast", "title": title, "artwork": artwork, "description": description])
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

      public var attachmentFragment: AttachmentFragment {
        get {
          return AttachmentFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}
