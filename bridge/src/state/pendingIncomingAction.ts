import { logger } from '../server.js';
import type { IncomingMessage } from '../types/incomingMessageTypes.js';

let sentToGame = false;
let pendingIncomingMessage: IncomingMessage | undefined = undefined;

export const hasSentPendingIncomingAction = (): boolean => sentToGame;

export const getPendingIncomingMessage = (): IncomingMessage | undefined => pendingIncomingMessage;

export const consumePendingIncomingMessage = (): IncomingMessage | undefined => {
  sentToGame = true;

  return pendingIncomingMessage;
};

export const clearPendingIncomingMessage = (): void => {
  pendingIncomingMessage = undefined;
};

export const handleNewIncomingMessage = (newIncomingMessage: IncomingMessage): void => {
  if (!sentToGame && pendingIncomingMessage) {
    logger.warn(
      `A new message is overwriting an unsent message, the unsent message will be discarded: ${pendingIncomingMessage.data.name}`,
    );
  }

  pendingIncomingMessage = newIncomingMessage;
  sentToGame = false;
};
