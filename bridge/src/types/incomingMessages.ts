export type IncomingActionData = {
  id: string;
  name: string;
  data: string | undefined;
};

export type IncomingAction = {
  command: string;
  data: IncomingActionData;
};
