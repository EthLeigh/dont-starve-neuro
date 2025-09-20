import { z } from 'zod';
import type { JSONSchema } from 'zod/v4/core';

export const schemaToJsonSchema = (schema: z.ZodTypeAny): JSONSchema.JSONSchema =>
  z.toJSONSchema(schema, { target: 'draft-7' });
