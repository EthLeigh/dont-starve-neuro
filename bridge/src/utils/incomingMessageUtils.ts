import type { IncomingAction, IncomingActionData } from '../types/incomingMessageTypes.js';

export const createIncomingAction = (
  command: string,
  data: IncomingActionData,
): IncomingAction => ({
  command,
  data,
});
