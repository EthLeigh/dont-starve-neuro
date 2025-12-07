import type { JSONSchema } from 'zod/v4/core';
import type { GAME_NAME } from '../constants/constants.js';
import type {
  ACTIONS_FORCE_ACTION,
  ACTIONS_REGISTER_ACTION,
  ACTIONS_RESULT_ACTION,
  ACTIONS_UNREGISTER_ACTION,
  CONTEXT_ACTION,
  STARTUP_ACTION,
} from '../constants/outgoingMessageActions.js';

export type OutgoingAction = {
  name: string;
  description: string;
  schema: JSONSchema.JSONSchema | undefined;
};

export type StartupMessage = {
  command: typeof STARTUP_ACTION;
  game: typeof GAME_NAME;
};

export type ContextMessage = {
  command: typeof CONTEXT_ACTION;
  game: typeof GAME_NAME;
  data: {
    message: string;
    silent: boolean;
  };
};

export type RegisterActionMessage = {
  command: typeof ACTIONS_REGISTER_ACTION;
  game: typeof GAME_NAME;
  data: {
    actions: readonly OutgoingAction[];
  };
};

export type UnregisterActionMessage = {
  command: typeof ACTIONS_UNREGISTER_ACTION;
  game: typeof GAME_NAME;
  data: {
    action_names: string[];
  };
};

export type ForceActionMessage = {
  command: typeof ACTIONS_FORCE_ACTION;
  game: typeof GAME_NAME;
  data: {
    state: string | undefined;
    query: string;
    ephemeral_context: boolean | undefined;
    action_names: string[];
  };
};

export type ActionResultMessage = {
  command: typeof ACTIONS_RESULT_ACTION;
  game: typeof GAME_NAME;
  data: {
    id: string;
    success: boolean;
    message: string | undefined;
  };
};
