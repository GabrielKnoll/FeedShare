import env from 'env-var';
const {parsed} = require('dotenv').config({path: __dirname + '/../../../.env'});

const ci = env.get('CI').asBool();

const e = {
  DATABASE_URL: env.get('DATABASE_URL').required(!ci).asString(),
  JWT_SECRET: env.get('JWT_SECRET').required(!ci).asString(),
  PORT: env.get('PORT').required(!ci).asIntPositive(),
  TWITTER_COMSUMER_KEY: env
    .get('TWITTER_COMSUMER_KEY')
    .required(!ci)
    .asString(),
  TWITTER_CONSUMER_SECRET: env
    .get('TWITTER_CONSUMER_SECRET')
    .required(!ci)
    .asString(),
  SPOTIFY_CLIENT_ID: env.get('SPOTIFY_CLIENT_ID').required(!ci).asString(),
  SPOTIFY_CLIENT_SECRET: env
    .get('SPOTIFY_CLIENT_SECRET')
    .required(!ci)
    .asString(),
  APOLLO_KEY: env.get('APOLLO_KEY').asString(),
  APOLLO_GRAPH_VARIANT: env
    .get('APOLLO_GRAPH_VARIANT')
    .asEnum(['dev', 'current']),
  APOLLO_SCHEMA_REPORTING: env.get('APOLLO_SCHEMA_REPORTING').asBool(),
  TIMBER_SOUCE_ID: env.get('TIMBER_SOUCE_ID').required(!ci).asString(),
  TIMBER_TOKEN: env.get('TIMBER_TOKEN').required(!ci).asString(),
};

const set = new Set(Object.keys(parsed));
Object.keys(e).forEach((key) => set.delete(key));
if (set.size > 0 && !ci) {
  throw new Error(`${[...set].join(', ')} not declared in ${__filename}`);
}

export default e;
