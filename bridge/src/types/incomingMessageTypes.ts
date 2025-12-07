import z from 'zod';
import { IncomingMessageCommandsSchema } from './common.js';

export const IncomingMessageDataSchema = z.strictObject({
  id: z.string(),
  name: z.string(),
  data: z.string().optional(),
});

export const IncomingMessageSchema = z.strictObject({
  command: IncomingMessageCommandsSchema,
  data: IncomingMessageDataSchema,
});

export type IncomingMessage = z.infer<typeof IncomingMessageSchema>;
export type IncomingMessageData = z.infer<typeof IncomingMessageDataSchema>;
