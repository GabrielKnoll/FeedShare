import * as OneSignal from 'onesignal-node';
import env from '../utils/env';

const client = new OneSignal.Client(
  env.ONESIGNAL_APP_ID,
  env.ONESIGNAL_API_KEY,
);

export function sendPush(
  receiverIds: string[],
  content: {
    title: string;
    subtitle?: string;
    body: string;
    image?: string | null;
  },
  withBadge?: boolean,
) {
  return client.createNotification({
    included_segments: ['empty'],
    headings: {
      en: content.title,
    },
    subtitle: content.subtitle
      ? {
          en: content.subtitle,
        }
      : undefined,
    contents: {
      en: content.body,
    },
    include_external_user_ids: receiverIds,
    ios_badgeType: withBadge ? 'Increase' : undefined,
    ios_badgeCount: withBadge ? 1 : undefined,
    ios_attachments: content.image
      ? {
          id1: content.image,
        }
      : undefined,
  });
}
