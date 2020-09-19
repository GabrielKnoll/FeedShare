export default function (
  ctx: NexusContext,
): {
  userId?: string;
} {
  return {
    userId: (ctx.token as any)?.user ?? undefined,
  };
}
