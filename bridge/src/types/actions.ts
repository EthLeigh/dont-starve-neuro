import type { GAME_NAME } from '../utils/constants.js';

export type Action = {
  command: string;
  game: typeof GAME_NAME;
  data: ActionData | undefined;
};

export type ActionData = {
  [key: string]: string | number | object;
};
