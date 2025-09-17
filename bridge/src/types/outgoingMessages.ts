import type { GAME_NAME } from '../utils/constants.js';
import type { Action } from './actions.js';

export type StartupMessage = {
  command: 'startup';
  game: typeof GAME_NAME;
};

export type ContextMessage = {
  command: 'context';
  game: typeof GAME_NAME;
  data: {
    message: string;
    silent: boolean;
  };
};

export type RegisterActionMessage = {
  command: 'actions/register';
  game: typeof GAME_NAME;
  data: {
    actions: Action[];
  };
};

export type UnregisterActionMessage = {
  command: 'actions/unregister';
  game: typeof GAME_NAME;
  data: {
    action_names: string[];
  };
};

export type ForceActionMessage = {
  command: 'actions/force';
  game: typeof GAME_NAME;
  data: {
    state: string | undefined;
    query: string;
    ephemeral_context: boolean | undefined;
    action_names: string[];
  };
};

export type ActionResultMessage = {
  command: 'action/result';
  game: typeof GAME_NAME;
  data: {
    id: string;
    success: boolean;
    message: string | undefined;
  };
};
