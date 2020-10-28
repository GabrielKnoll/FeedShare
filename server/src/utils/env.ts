import env from 'env-var';
const {parsed} = require('dotenv').config({path: __dirname + '/../../../.env'});

const e = {
  DATABASE_URL: env.get('DATABASE_URL').required().asString(),
  JWT_SECRET: env.get('JWT_SECRET').required().asString(),
  PORT: env.get('PORT').required().asIntPositive(),
  TWITTER_COMSUMER_KEY: env.get('TWITTER_COMSUMER_KEY').required().asString(),
  TWITTER_CONSUMER_SECRET: env
    .get('TWITTER_CONSUMER_SECRET')
    .required()
    .asString(),
};

const set = new Set(Object.keys(parsed));
Object.keys(e).forEach((key) => {
  if (!set.has(key)) {
    throw new Error(`${key} not defined in .env`);
  }
  set.delete(key);
});
if (set.size > 0) {
  throw new Error(`${[...set].join(', ')} not declared in ${__filename}`);
}

export default e;
