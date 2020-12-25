declare namespace NodeJS {
  export interface Process {
    env: {
      readonly NODE_ENV: 'development' | 'production' | 'test';
      readonly DATABASE_URL: string;
      readonly JWT_SECRET: string;
      readonly PORT: string;
      readonly TWITTER_COMSUMER_KEY: string;
      readonly TWITTER_CONSUMER_SECRET: string;
      readonly PODCAST_INDEX_KEY: string;
      readonly PODCAST_INDEX_SECRET: string;
      readonly NEW_RELIC_LICENSE_KEY: string;
      readonly IMGIX_TOKEN: string;
      readonly ONESIGNAL_APP_ID: string;
      readonly ONESIGNAL_API_KEY: string;
    };
  }
}
