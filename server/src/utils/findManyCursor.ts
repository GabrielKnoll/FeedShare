/**
 * Credits go to @queicherius who provided the original example:
 * https://github.com/prisma/photonjs/issues/321#issuecomment-568290134
 * The code below is a direct copy/paste and then adapation of it.
 */

export type ConnectionCursor = string;

export interface ConnectionArguments {
  after?: ConnectionCursor | null;
  before?: ConnectionCursor | null;
  last: number;
}

export interface PageInfo {
  startCursor?: ConnectionCursor;
  endCursor?: ConnectionCursor;
  hasPreviousPage: boolean;
  hasNextPage: boolean;
}

export interface Edge<T> {
  node: T;
  cursor: ConnectionCursor;
}

export interface Connection<T> {
  edges: Array<Edge<T>>;
  pageInfo: PageInfo;
}

/**
 * Supports the Relay Cursor Connection Specification
 *
 * @see https://facebook.github.io/relay/graphql/connections.htm
 */
export async function findManyCursor<Model extends {id: string}>(
  findMany: (args: {
    take?: number;
    skip?: number;
    cursor?: {
      id?: string;
    };
  }) => Promise<Model[]>,
  args: ConnectionArguments = {} as ConnectionArguments,
): Promise<Connection<Model>> {
  if (args?.last < 0) {
    throw new Error('last is less than 0');
  }

  let skip, cursor;
  const take = args.last + 1;

  if (args.before) {
    skip = 1;
    cursor = {id: args.before};
  }

  let nodes = await findMany({take, skip, cursor});
  const hasExtraNode = nodes.length === take;

  // Remove the extra node from the results
  if (hasExtraNode) {
    nodes.pop();
  }

  // cut off list before the cursor
  if (args.after) {
    let found = false;
    nodes = nodes.filter((n) => {
      found = found || n.id === args.after;
      return !found;
    });
  }

  // Get the start and end cursors
  const endCursor = nodes.length > 0 ? nodes[0].id : undefined;
  const startCursor = nodes.length > 0 ? nodes[nodes.length - 1].id : undefined;
  const hasPreviousPage = hasExtraNode;
  const hasNextPage = (skip ?? 0) > 0;

  return {
    pageInfo: {
      startCursor,
      endCursor,
      hasNextPage,
      hasPreviousPage,
    },
    edges: nodes.map((node) => ({cursor: node.id, node})),
  };
}
