import { type IncomingMessageCommands } from '../types/common.js';
import type { IncomingMessage, IncomingMessageData } from '../types/incomingMessageTypes.js';

export const createIncomingAction = (
  command: IncomingMessageCommands,
  data: IncomingMessageData,
): IncomingMessage => ({
  command,
  data,
});
