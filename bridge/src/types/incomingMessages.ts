import z from 'zod';

export const IncomingActionDataSchema = z.strictObject({
  id: z.string(),
  name: z.string(),
  data: z.string().optional(),
});

export const IncomingActionSchema = z.strictObject({
  command: z.string(),
  data: IncomingActionDataSchema,
});

export type IncomingAction = z.infer<typeof IncomingActionSchema>;
export type IncomingActionData = z.infer<typeof IncomingActionDataSchema>;
