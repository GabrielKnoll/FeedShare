import {PrismaClient} from '@prisma/client';
import pushNotifications from './pushNotifications';

const instance = new PrismaClient();

instance.$use(pushNotifications);
export default instance;
