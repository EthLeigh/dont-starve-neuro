export const STARTUP_ACTION = 'startup';
export const CONTEXT_ACTION = 'context';
export const ACTIONS_REGISTER_ACTION = 'actions/register';
export const ACTIONS_UNREGISTER_ACTION = 'actions/unregister';
export const ACTIONS_FORCE_ACTION = 'actions/force';
export const ACTIONS_RESULT_ACTION = 'actions/result';
export const SHUTDOWN_READY_ACTION = 'shutdown/ready';

export const VALID_ACTION_COMMANDS = [
  STARTUP_ACTION,
  CONTEXT_ACTION,
  ACTIONS_REGISTER_ACTION,
  ACTIONS_UNREGISTER_ACTION,
  ACTIONS_FORCE_ACTION,
  ACTIONS_RESULT_ACTION,
  SHUTDOWN_READY_ACTION,
] as const;
