import type { JSONSchema } from 'zod/v4/core';
import type {
  ActionResultMessage,
  ContextMessage,
  ForceActionMessage,
  OutgoingAction,
  RegisterActionMessage,
  StartupMessage,
  UnregisterActionMessage,
} from '../types/outgoingMessages.js';
import { GAME_NAME } from '../utils/constants.js';

export const createOutgoingAction = (
  name: string,
  description: string,
  schema: JSONSchema.JSONSchema | undefined = undefined,
): OutgoingAction => ({
  name,
  description,
  schema,
});

export const createStartupMessage = (): StartupMessage => ({
  command: 'startup',
  game: GAME_NAME,
});

export const createContextMessage = (
  message: string,
  silent: boolean | undefined,
): ContextMessage => ({
  command: 'context',
  game: GAME_NAME,
  data: {
    message,
    silent: silent || false,
  },
});

export const createRegisterActionMessage = (actions: OutgoingAction[]): RegisterActionMessage => ({
  command: 'actions/register',
  game: GAME_NAME,
  data: {
    actions,
  },
});

export const createUnregisterActionMessage = (actionNames: string[]): UnregisterActionMessage => ({
  command: 'actions/unregister',
  game: GAME_NAME,
  data: {
    action_names: actionNames,
  },
});

export const createForceActionMessage = (
  query: string,
  actionNames: string[],
  ephemeralContext: boolean,
  state: string | undefined,
): ForceActionMessage => ({
  command: 'actions/force',
  game: GAME_NAME,
  data: {
    state,
    query,
    ephemeral_context: ephemeralContext,
    action_names: actionNames,
  },
});

export const createActionResultMessage = (
  id: string,
  success: boolean,
  message: string | undefined,
): ActionResultMessage => ({
  command: 'action/result',
  game: GAME_NAME,
  data: {
    id,
    success,
    message,
  },
});
