import env from 'env-var';

const ci = env.get('CI').asBool();

const e = {
  NODE_ENV: env
    .get('NODE_ENV')
    .required(!ci)
    .asEnum(['development', 'production', 'test']),
  PORT: env.get('PORT').required(!ci).asIntPositive(),
  DATABASE_URL: env.get('DATABASE_URL').required(!ci).asString(),
  JWT_SECRET: env.get('JWT_SECRET').required(!ci).asString(),
  TWITTER_CONSUMER_KEY: env
    .get('TWITTER_CONSUMER_KEY')
    .required(!ci)
    .asString(),
  TWITTER_CONSUMER_SECRET: env
    .get('TWITTER_CONSUMER_SECRET')
    .required(!ci)
    .asString(),
  PODCAST_INDEX_KEY: env.get('PODCAST_INDEX_KEY').required(!ci).asString(),
  PODCAST_INDEX_SECRET: env
    .get('PODCAST_INDEX_SECRET')
    .required(!ci)
    .asString(),
  IMAGEKIT_PUBLIC_KEY: env.get('IMAGEKIT_PUBLIC_KEY').required(!ci).asString(),
  IMAGEKIT_PRIVATE_KEY: env
    .get('IMAGEKIT_PRIVATE_KEY')
    .required(!ci)
    .asString(),
  IMAGEKIT_ID: env.get('IMAGEKIT_ID').required(!ci).asString(),
  ONESIGNAL_APP_ID: env.get('ONESIGNAL_APP_ID').required(!ci).asString(),
  ONESIGNAL_API_KEY: env.get('ONESIGNAL_API_KEY').required(!ci).asString(),
  DATO_CMS_KEY: env.get('DATO_CMS_KEY').required(!ci).asString(),
  BASE_URL: env.get('BASE_URL').required(!ci).asString(),
};

export default e;
