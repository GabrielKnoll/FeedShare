import {FieldAuthorizeResolver} from '@nexus/schema/dist/plugins/fieldAuthorizePlugin';

type AuthProp = {
  authorize: FieldAuthorizeResolver<any, any>;
};

const authProp: AuthProp = {
  authorize: (_, __, {userId}) => Boolean(userId),
};

export default authProp;
