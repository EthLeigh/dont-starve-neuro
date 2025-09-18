import type { IncomingAction, IncomingActionData } from '../types/incomingMessages.js';

export const createIncomingAction = (
  command: string,
  data: IncomingActionData,
): IncomingAction => ({
  command,
  data,
});
