export type IncomingAction = {
  command: string;
  data: {
    id: string;
    name: string;
    data: string | undefined;
  };
};
