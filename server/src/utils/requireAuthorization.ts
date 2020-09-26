import parseToken from './parseToken';
import {FieldAuthorizeResolver} from 'nexus/components/schema';

type AuthProp = {
  authorize: FieldAuthorizeResolver<any, any>;
};

const authProp: AuthProp = {
  authorize: (_, __, {token}) => Boolean(parseToken(token).userId),
};

export default authProp;
