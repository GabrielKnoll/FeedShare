import env from 'env-var';
const {parsed = {}} = require('dotenv').config({
  path: __dirname + '/../../../.env',
});

const ci = env.get('CI').asBool();

const e = {
  NODE_ENV: env.get('NODE_ENV').asString(),
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
  APOLLO_SCHEMA_REPORTING: env
    .get('APOLLO_SCHEMA_REPORTING')
    .asEnum(['true', 'false']),
  PODCAST_INDEX_KEY: env.get('PODCAST_INDEX_KEY').required(!ci).asString(),
  PODCAST_INDEX_SECRET: env
    .get('PODCAST_INDEX_SECRET')
    .required(!ci)
    .asString(),
  NEW_RELIC_LICENSE_KEY: env
    .get('NEW_RELIC_LICENSE_KEY')
    .required(!ci)
    .asString(),
};

const set = new Set(Object.keys(parsed));
Object.keys(e).forEach((key) => set.delete(key));
if (set.size > 0 && !ci) {
  throw new Error(`${[...set].join(', ')} not declared in ${__filename}`);
}

export default e;
