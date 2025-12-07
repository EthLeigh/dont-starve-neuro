import type {
  ActionResultMessage,
  ContextMessage,
  ForceActionMessage,
  OutgoingAction,
  RegisterActionMessage,
  ShutdownReadyMessage,
  StartupMessage,
  UnregisterActionMessage,
} from '../types/outgoingMessageTypes.js';
import { GAME_NAME } from '../constants/constants.js';
import type { JSONSchema } from 'zod/v4/core';
import {
  CONTEXT_ACTION,
  ACTIONS_FORCE_ACTION,
  ACTIONS_REGISTER_ACTION,
  ACTIONS_RESULT_ACTION,
  STARTUP_ACTION,
  ACTIONS_UNREGISTER_ACTION,
  SHUTDOWN_READY_ACTION,
} from '../constants/outgoingMessageActions.js';

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
  command: STARTUP_ACTION,
  game: GAME_NAME,
});

export const createContextMessage = (
  message: string,
  silent: boolean | undefined,
): ContextMessage => ({
  command: CONTEXT_ACTION,
  game: GAME_NAME,
  data: {
    message,
    silent: silent || false,
  },
});

export const createRegisterActionMessage = (
  actions: readonly OutgoingAction[],
): RegisterActionMessage => ({
  command: ACTIONS_REGISTER_ACTION,
  game: GAME_NAME,
  data: {
    actions,
  },
});

export const createUnregisterActionMessage = (actionNames: string[]): UnregisterActionMessage => ({
  command: ACTIONS_UNREGISTER_ACTION,
  game: GAME_NAME,
  data: {
    action_names: actionNames,
  },
});

export const createForceActionMessage = (
  query: string,
  actionNames: string[],
  ephemeralContext: boolean | undefined,
  state: string | undefined,
): ForceActionMessage => ({
  command: ACTIONS_FORCE_ACTION,
  game: GAME_NAME,
  data: {
    query,
    action_names: actionNames,
    ephemeral_context: ephemeralContext,
    state,
  },
});

export const createActionResultMessage = (
  id: string,
  success: boolean,
  message: string | undefined,
): ActionResultMessage => ({
  command: ACTIONS_RESULT_ACTION,
  game: GAME_NAME,
  data: {
    id,
    success,
    message,
  },
});

export const createShutdownReadyMessage = (): ShutdownReadyMessage => ({
  command: SHUTDOWN_READY_ACTION,
  game: GAME_NAME,
});
