import {FieldAuthorizeResolver} from '@nexus/schema';

type AuthProp = {
  authorize: FieldAuthorizeResolver<any, any>;
};

const authProp: AuthProp = {
  authorize: (_, __, {userId}) => {
    console.log(userId);
    return Boolean(userId);
  },
};

export default authProp;
