import type { IncomingAction } from '../types/incomingMessageTypes.js';

let sentToGame = false;
let pendingIncomingAction: IncomingAction | undefined = undefined;

export const hasSentPendingIncomingAction = (): boolean => sentToGame;

export const consumePendingIncomingAction = (): IncomingAction | undefined => {
  const incomingAction = pendingIncomingAction;

  pendingIncomingAction = undefined;
  sentToGame = true;

  return incomingAction;
};

export const handleNewIncomingAction = (newIncomingAction: IncomingAction): void => {
  pendingIncomingAction = newIncomingAction;
  sentToGame = false;
};
