export default function (
  token: NexusContext['token'],
): {
  userId?: string;
} {
  return {
    userId: (token as any)?.user ?? undefined,
  };
}
