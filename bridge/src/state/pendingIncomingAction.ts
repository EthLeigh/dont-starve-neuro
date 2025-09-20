import type { IncomingAction } from '../types/incomingMessages.js';

let pendingIncomingAction: IncomingAction | undefined = undefined;

export const consumePendingIncomingAction = (): IncomingAction | undefined => {
  const incomingAction = pendingIncomingAction;
  pendingIncomingAction = undefined;

  return incomingAction;
};

export const handleNewIncomingAction = (newIncomingAction: IncomingAction): void => {
  pendingIncomingAction = newIncomingAction;
};
