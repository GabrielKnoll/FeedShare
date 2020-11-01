import {Timber} from '@timberio/node';
import env from './env';

export default class ErrorReporter {
  private timberClient: Timber;

  constructor() {
    this.timberClient = new Timber(env.TIMBER_TOKEN, env.TIMBER_SOUCE_ID);
  }
  didEncounterErrors(errors: Error[]): Promise<any> {
    errors.map(console.error);
    return Promise.all(
      errors.map((error: Error) => this.timberClient.error(error.message)),
    );
  }
}
