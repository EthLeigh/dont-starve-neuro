import type { ActionData, Action } from '../types/actions.js';

export const createAction = (command: string, data: ActionData | undefined): Action => {
  return {
    command,
    game: "Don't Starve",
    data,
  } as Action;
};
