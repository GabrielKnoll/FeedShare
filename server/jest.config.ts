import type {Config} from '@jest/types';

// Sync object
const config: Config.InitialOptions = {
  preset: 'ts-jest',
  transform: {
    '^.+\\.(ts|tsx)?$': 'ts-jest',
    '^.+\\.(js|jsx)$': 'babel-jest',
  },
  testPathIgnorePatterns: ['/dist/'],
  setupFiles: ['dotenv/config'],
};
export default config;
