/**
 * This file was generated by Nexus Schema
 * Do not make changes to this file directly
 */


import { Context as ctx } from "./../src/context"
import { FieldAuthorizeResolver } from "nexus/dist/plugins/fieldAuthorizePlugin"
import { core, connectionPluginCore } from "nexus"
declare global {
  interface NexusGenCustomInputMethods<TypeName extends string> {
    /**
     * The `JSONObject` scalar type represents JSON objects as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).
     */
    json<FieldName extends string>(fieldName: FieldName, opts?: core.CommonInputFieldConfig<TypeName, FieldName>): void // "JSONObject";
    /**
     * A date-time string at UTC, such as 2007-12-03T10:15:30Z, compliant with the `date-time` format outlined in section 5.6 of the RFC 3339 profile of the ISO 8601 standard for representation of dates and times using the Gregorian calendar.
     */
    date<FieldName extends string>(fieldName: FieldName, opts?: core.CommonInputFieldConfig<TypeName, FieldName>): void // "DateTime";
  }
}
declare global {
  interface NexusGenCustomOutputMethods<TypeName extends string> {
    /**
     * The `JSONObject` scalar type represents JSON objects as specified by [ECMA-404](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf).
     */
    json<FieldName extends string>(fieldName: FieldName, ...opts: core.ScalarOutSpread<TypeName, FieldName>): void // "JSONObject";
    /**
     * A date-time string at UTC, such as 2007-12-03T10:15:30Z, compliant with the `date-time` format outlined in section 5.6 of the RFC 3339 profile of the ISO 8601 standard for representation of dates and times using the Gregorian calendar.
     */
    date<FieldName extends string>(fieldName: FieldName, ...opts: core.ScalarOutSpread<TypeName, FieldName>): void // "DateTime";
    /**
     * Adds a Relay-style connection to the type, with numerous options for configuration
     *
     * @see https://nexusjs.org/docs/plugins/connection
     */
    connectionField<FieldName extends string>(
      fieldName: FieldName,
      config: connectionPluginCore.ConnectionFieldConfig<TypeName, FieldName>
    ): void
    /**
     * Adds a Relay-style connection to the type, with numerous options for configuration
     *
     * @see https://nexusjs.org/docs/plugins/connection
     */
    countableConnection<FieldName extends string>(
      fieldName: FieldName,
      config: connectionPluginCore.ConnectionFieldConfig<TypeName, FieldName> & { totalCount: core.FieldResolver<core.FieldTypeName<TypeName, FieldName>, "totalCount"> }
    ): void
  }
}
declare global {
  interface NexusGenCustomOutputProperties<TypeName extends string> {
    model: NexusPrisma<TypeName, 'model'>
    crud: any
  }
}

declare global {
  interface NexusGen extends NexusGenTypes {}
}

export interface NexusGenInputs {
}

export interface NexusGenEnums {
  FeedType: "Global" | "Personal" | "User"
}

export interface NexusGenScalars {
  String: string
  Int: number
  Float: number
  Boolean: boolean
  ID: string
  DateTime: any
  JSONObject: any
}

export interface NexusGenObjects {
  CountableUserConnection: { // root type
    edges?: Array<NexusGenRootTypes['CountableUserEdge'] | null> | null; // [CountableUserEdge]
    pageInfo: NexusGenRootTypes['PageInfo']; // PageInfo!
  }
  CountableUserEdge: { // root type
    cursor: string; // String!
    node?: NexusGenRootTypes['User'] | null; // User
  }
  Episode: { // root type
    datePublished: NexusGenScalars['DateTime']; // DateTime!
    durationSeconds?: number | null; // Int
    title: string; // String!
    url?: string | null; // String
  }
  Mutation: {};
  Page: { // root type
    content?: string | null; // String
    id: string; // ID!
    title: string; // String!
  }
  PageInfo: { // root type
    endCursor?: string | null; // String
    hasNextPage: boolean; // Boolean!
    hasPreviousPage: boolean; // Boolean!
    startCursor?: string | null; // String
  }
  Podcast: { // root type
    publisher: string; // String!
    title: string; // String!
  }
  PodcastClient: { // root type
    displayName: string; // String!
    icon: string; // String!
    subscribeUrl: string; // String!
    subscribeUrlNeedsProtocol: boolean; // Boolean!
  }
  Query: {};
  ResolvedShareUrl: { // root type
    episode?: NexusGenRootTypes['Episode'] | null; // Episode
    podcast?: NexusGenRootTypes['Podcast'] | null; // Podcast
  }
  SearchResult: { // root type
    feedId?: string | null; // ID
    title: string; // String!
  }
  Share: { // root type
    createdAt: NexusGenScalars['DateTime']; // DateTime!
    message?: string | null; // String
  }
  ShareConnection: { // root type
    edges?: Array<NexusGenRootTypes['ShareEdge'] | null> | null; // [ShareEdge]
    pageInfo: NexusGenRootTypes['PageInfo']; // PageInfo!
  }
  ShareEdge: { // root type
    cursor: string; // String!
    node?: NexusGenRootTypes['Share'] | null; // Share
  }
  Subscription: {};
  User: { // root type
    displayName?: string | null; // String
    handle: string; // String!
  }
  Viewer: { // root type
    user: NexusGenRootTypes['User']; // User!
  }
}

export interface NexusGenInterfaces {
  Node: NexusGenRootTypes['Episode'] | NexusGenRootTypes['Podcast'] | NexusGenRootTypes['PodcastClient'] | NexusGenRootTypes['Share'] | NexusGenRootTypes['User'];
}

export interface NexusGenUnions {
}

export type NexusGenRootTypes = NexusGenInterfaces & NexusGenObjects

export type NexusGenAllTypes = NexusGenRootTypes & NexusGenScalars & NexusGenEnums

export interface NexusGenFieldTypes {
  CountableUserConnection: { // field return type
    edges: Array<NexusGenRootTypes['CountableUserEdge'] | null> | null; // [CountableUserEdge]
    pageInfo: NexusGenRootTypes['PageInfo']; // PageInfo!
    totalCount: number | null; // Int
  }
  CountableUserEdge: { // field return type
    cursor: string; // String!
    node: NexusGenRootTypes['User'] | null; // User
  }
  Episode: { // field return type
    artwork: string | null; // String
    datePublished: NexusGenScalars['DateTime']; // DateTime!
    description: string | null; // String
    durationSeconds: number | null; // Int
    id: string; // ID!
    podcast: NexusGenRootTypes['Podcast']; // Podcast!
    title: string; // String!
    url: string | null; // String
  }
  Mutation: { // field return type
    addToPersonalFeed: NexusGenRootTypes['Share'] | null; // Share
    createShare: NexusGenRootTypes['Share'] | null; // Share
    createViewer: NexusGenRootTypes['Viewer'] | null; // Viewer
  }
  Page: { // field return type
    content: string | null; // String
    id: string; // ID!
    title: string; // String!
  }
  PageInfo: { // field return type
    endCursor: string | null; // String
    hasNextPage: boolean; // Boolean!
    hasPreviousPage: boolean; // Boolean!
    startCursor: string | null; // String
  }
  Podcast: { // field return type
    artwork: string | null; // String
    description: string | null; // String
    feed: string; // String!
    id: string; // ID!
    latestEpisodes: Array<NexusGenRootTypes['Episode'] | null> | null; // [Episode]
    publisher: string; // String!
    title: string; // String!
    url: string | null; // String
  }
  PodcastClient: { // field return type
    displayName: string; // String!
    icon: string; // String!
    id: string; // ID!
    subscribeUrl: string; // String!
    subscribeUrlNeedsProtocol: boolean; // Boolean!
  }
  Query: { // field return type
    findPodcast: Array<NexusGenRootTypes['Podcast'] | null> | null; // [Podcast]
    node: NexusGenRootTypes['Node'] | null; // Node
    pages: Array<NexusGenRootTypes['Page'] | null> | null; // [Page]
    podcastClient: Array<NexusGenRootTypes['PodcastClient'] | null> | null; // [PodcastClient]
    resolveShareUrl: NexusGenRootTypes['ResolvedShareUrl'] | null; // ResolvedShareUrl
    shares: NexusGenRootTypes['ShareConnection']; // ShareConnection!
    typeaheadPodcast: Array<NexusGenRootTypes['Podcast'] | null> | null; // [Podcast]
    viewer: NexusGenRootTypes['Viewer'] | null; // Viewer
  }
  ResolvedShareUrl: { // field return type
    episode: NexusGenRootTypes['Episode'] | null; // Episode
    podcast: NexusGenRootTypes['Podcast'] | null; // Podcast
  }
  SearchResult: { // field return type
    feedId: string | null; // ID
    title: string; // String!
  }
  Share: { // field return type
    author: NexusGenRootTypes['User']; // User!
    createdAt: NexusGenScalars['DateTime']; // DateTime!
    episode: NexusGenRootTypes['Episode']; // Episode!
    id: string; // ID!
    isInFeed: boolean | null; // Boolean
    message: string | null; // String
  }
  ShareConnection: { // field return type
    edges: Array<NexusGenRootTypes['ShareEdge'] | null> | null; // [ShareEdge]
    pageInfo: NexusGenRootTypes['PageInfo']; // PageInfo!
  }
  ShareEdge: { // field return type
    cursor: string; // String!
    node: NexusGenRootTypes['Share'] | null; // Share
  }
  Subscription: { // field return type
    truths: boolean | null; // Boolean
  }
  User: { // field return type
    displayName: string | null; // String
    followers: NexusGenRootTypes['CountableUserConnection']; // CountableUserConnection!
    following: NexusGenRootTypes['CountableUserConnection']; // CountableUserConnection!
    handle: string; // String!
    id: string; // ID!
    profilePicture: string | null; // String
  }
  Viewer: { // field return type
    messageLimit: number; // Int!
    personalFeed: string; // String!
    personalFeedLastChecked: NexusGenScalars['DateTime'] | null; // DateTime
    token: string; // String!
    user: NexusGenRootTypes['User']; // User!
  }
  Node: { // field return type
    id: string; // ID!
  }
}

export interface NexusGenFieldTypeNames {
  CountableUserConnection: { // field return type name
    edges: 'CountableUserEdge'
    pageInfo: 'PageInfo'
    totalCount: 'Int'
  }
  CountableUserEdge: { // field return type name
    cursor: 'String'
    node: 'User'
  }
  Episode: { // field return type name
    artwork: 'String'
    datePublished: 'DateTime'
    description: 'String'
    durationSeconds: 'Int'
    id: 'ID'
    podcast: 'Podcast'
    title: 'String'
    url: 'String'
  }
  Mutation: { // field return type name
    addToPersonalFeed: 'Share'
    createShare: 'Share'
    createViewer: 'Viewer'
  }
  Page: { // field return type name
    content: 'String'
    id: 'ID'
    title: 'String'
  }
  PageInfo: { // field return type name
    endCursor: 'String'
    hasNextPage: 'Boolean'
    hasPreviousPage: 'Boolean'
    startCursor: 'String'
  }
  Podcast: { // field return type name
    artwork: 'String'
    description: 'String'
    feed: 'String'
    id: 'ID'
    latestEpisodes: 'Episode'
    publisher: 'String'
    title: 'String'
    url: 'String'
  }
  PodcastClient: { // field return type name
    displayName: 'String'
    icon: 'String'
    id: 'ID'
    subscribeUrl: 'String'
    subscribeUrlNeedsProtocol: 'Boolean'
  }
  Query: { // field return type name
    findPodcast: 'Podcast'
    node: 'Node'
    pages: 'Page'
    podcastClient: 'PodcastClient'
    resolveShareUrl: 'ResolvedShareUrl'
    shares: 'ShareConnection'
    typeaheadPodcast: 'Podcast'
    viewer: 'Viewer'
  }
  ResolvedShareUrl: { // field return type name
    episode: 'Episode'
    podcast: 'Podcast'
  }
  SearchResult: { // field return type name
    feedId: 'ID'
    title: 'String'
  }
  Share: { // field return type name
    author: 'User'
    createdAt: 'DateTime'
    episode: 'Episode'
    id: 'ID'
    isInFeed: 'Boolean'
    message: 'String'
  }
  ShareConnection: { // field return type name
    edges: 'ShareEdge'
    pageInfo: 'PageInfo'
  }
  ShareEdge: { // field return type name
    cursor: 'String'
    node: 'Share'
  }
  Subscription: { // field return type name
    truths: 'Boolean'
  }
  User: { // field return type name
    displayName: 'String'
    followers: 'CountableUserConnection'
    following: 'CountableUserConnection'
    handle: 'String'
    id: 'ID'
    profilePicture: 'String'
  }
  Viewer: { // field return type name
    messageLimit: 'Int'
    personalFeed: 'String'
    personalFeedLastChecked: 'DateTime'
    token: 'String'
    user: 'User'
  }
  Node: { // field return type name
    id: 'ID'
  }
}

export interface NexusGenArgTypes {
  Episode: {
    artwork: { // args
      scale: number; // Int!
      size: number; // Int!
    }
  }
  Mutation: {
    addToPersonalFeed: { // args
      shareId: string; // ID!
    }
    createShare: { // args
      episodeId: string; // ID!
      hideFromGlobalFeed?: boolean | null; // Boolean
      message: string; // String!
      shareOnTwitter?: boolean | null; // Boolean
    }
    createViewer: { // args
      twitterId: string; // String!
      twitterToken: string; // String!
      twitterTokenSecret: string; // String!
    }
  }
  Podcast: {
    artwork: { // args
      scale: number; // Int!
      size: number; // Int!
    }
    latestEpisodes: { // args
      length: number | null; // Int
    }
  }
  Query: {
    findPodcast: { // args
      query: string; // String!
    }
    node: { // args
      id: string; // ID!
    }
    resolveShareUrl: { // args
      url: string; // String!
    }
    shares: { // args
      after?: string | null; // String
      before?: string | null; // String
      feedType: NexusGenEnums['FeedType']; // FeedType!
      first?: number | null; // Int
      last?: number | null; // Int
    }
    typeaheadPodcast: { // args
      query: string; // String!
    }
  }
  Share: {
    isInFeed: { // args
      feedType: NexusGenEnums['FeedType']; // FeedType!
    }
  }
  User: {
    followers: { // args
      after?: string | null; // String
      before?: string | null; // String
      first?: number | null; // Int
      last?: number | null; // Int
    }
    following: { // args
      after?: string | null; // String
      before?: string | null; // String
      first?: number | null; // Int
      last?: number | null; // Int
    }
    profilePicture: { // args
      scale: number; // Int!
      size: number; // Int!
    }
  }
}

export interface NexusGenAbstractTypeMembers {
  Node: "Episode" | "Podcast" | "PodcastClient" | "Share" | "User"
}

export interface NexusGenTypeInterfaces {
  Episode: "Node"
  Podcast: "Node"
  PodcastClient: "Node"
  Share: "Node"
  User: "Node"
}

export type NexusGenObjectNames = keyof NexusGenObjects;

export type NexusGenInputNames = never;

export type NexusGenEnumNames = keyof NexusGenEnums;

export type NexusGenInterfaceNames = keyof NexusGenInterfaces;

export type NexusGenScalarNames = keyof NexusGenScalars;

export type NexusGenUnionNames = never;

export type NexusGenObjectsUsingAbstractStrategyIsTypeOf = never;

export type NexusGenAbstractsUsingStrategyResolveType = "Node";

export type NexusGenFeaturesConfig = {
  abstractTypeStrategies: {
    isTypeOf: false
    resolveType: true
    __typename: false
  }
}

export interface NexusGenTypes {
  context: ctx;
  inputTypes: NexusGenInputs;
  rootTypes: NexusGenRootTypes;
  inputTypeShapes: NexusGenInputs & NexusGenEnums & NexusGenScalars;
  argTypes: NexusGenArgTypes;
  fieldTypes: NexusGenFieldTypes;
  fieldTypeNames: NexusGenFieldTypeNames;
  allTypes: NexusGenAllTypes;
  typeInterfaces: NexusGenTypeInterfaces;
  objectNames: NexusGenObjectNames;
  inputNames: NexusGenInputNames;
  enumNames: NexusGenEnumNames;
  interfaceNames: NexusGenInterfaceNames;
  scalarNames: NexusGenScalarNames;
  unionNames: NexusGenUnionNames;
  allInputTypes: NexusGenTypes['inputNames'] | NexusGenTypes['enumNames'] | NexusGenTypes['scalarNames'];
  allOutputTypes: NexusGenTypes['objectNames'] | NexusGenTypes['enumNames'] | NexusGenTypes['unionNames'] | NexusGenTypes['interfaceNames'] | NexusGenTypes['scalarNames'];
  allNamedTypes: NexusGenTypes['allInputTypes'] | NexusGenTypes['allOutputTypes']
  abstractTypes: NexusGenTypes['interfaceNames'] | NexusGenTypes['unionNames'];
  abstractTypeMembers: NexusGenAbstractTypeMembers;
  objectsUsingAbstractStrategyIsTypeOf: NexusGenObjectsUsingAbstractStrategyIsTypeOf;
  abstractsUsingStrategyResolveType: NexusGenAbstractsUsingStrategyResolveType;
  features: NexusGenFeaturesConfig;
}


declare global {
  interface NexusGenPluginTypeConfig<TypeName extends string> {
  }
  interface NexusGenPluginFieldConfig<TypeName extends string, FieldName extends string> {
    /**
     * Authorization for an individual field. Returning "true"
     * or "Promise<true>" means the field can be accessed.
     * Returning "false" or "Promise<false>" will respond
     * with a "Not Authorized" error for the field.
     * Returning or throwing an error will also prevent the
     * resolver from executing.
     */
    authorize?: FieldAuthorizeResolver<TypeName, FieldName>
    
    
  }
  interface NexusGenPluginInputFieldConfig<TypeName extends string, FieldName extends string> {
  }
  interface NexusGenPluginSchemaConfig {
  }
  interface NexusGenPluginArgConfig {
  }
}