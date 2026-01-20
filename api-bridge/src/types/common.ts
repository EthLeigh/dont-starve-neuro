import z from 'zod';

export const IncomingMessageCommandsSchema = z.union([
  z.literal('action'),
  z.literal('actions/reregister_all'),
  z.literal('shutdown/graceful'),
  z.literal('shutdown/immediate'),
]);
export type IncomingMessageCommands = z.infer<typeof IncomingMessageCommandsSchema>;
