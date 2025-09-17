import { z } from 'zod';

export const schemaToJsonSchema = (schema: z.ZodTypeAny): object =>
  z.toJSONSchema(schema, { target: 'draft-7' });
