# Migration `20200926012914-unique-share`

This migration has been generated by Daniel Büchele at 9/26/2020, 2:29:14 AM.
You can check out the [state of the schema](./schema.prisma) after the migration.

## Database Steps

```sql
CREATE UNIQUE INDEX "Share.episodeId_podcastId_authorId_unique" ON "public"."Share"("episodeId", "podcastId", "authorId")
```

## Changes

```diff
diff --git schema.prisma schema.prisma
migration 20200926010530-string-ampid..20200926012914-unique-share
--- datamodel.dml
+++ datamodel.dml
@@ -4,9 +4,9 @@
 }
 datasource db {
   provider = "postgres"
-  url = "***"
+  url = "***"
 }
 model User {
   id     String  @default(uuid()) @id
@@ -23,8 +23,9 @@
   podcast   Podcast  @relation(fields: [podcastId], references: [id])
   podcastId String
   message   String?
   createdAt DateTime @default(now())
+  @@unique([episodeId, podcastId, authorId])
 }
 model Episode {
   id              String   @default(uuid()) @id
```

