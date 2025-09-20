import { logger } from '../server.js';
import type { IncomingAction } from '../types/incomingMessageTypes.js';

let sentToGame = false;
let pendingIncomingAction: IncomingAction | undefined = undefined;

export const hasSentPendingIncomingAction = (): boolean => sentToGame;

export const getPendingIncomingAction = (): IncomingAction | undefined => pendingIncomingAction;

export const consumePendingIncomingAction = (): IncomingAction | undefined => {
  sentToGame = true;

  return pendingIncomingAction;
};

export const clearPendingIncomingAction = (): void => {
  pendingIncomingAction = undefined;
};

export const handleNewIncomingAction = (newIncomingAction: IncomingAction): void => {
  if (!sentToGame && pendingIncomingAction) {
    logger.warn(
      `A new action is overwriting an unsent action, the unsent action will be discarded: ${pendingIncomingAction.data.name}`,
    );
  }

  pendingIncomingAction = newIncomingAction;
  sentToGame = false;
};
