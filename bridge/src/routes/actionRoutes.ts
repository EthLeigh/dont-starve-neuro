import { type FastifyPluginAsyncZod } from 'fastify-type-provider-zod';
import { sendMessage } from '../ws/wsClient.js';
import {
  createActionResultMessage,
  createContextMessage,
  createForceActionMessage,
  createRegisterActionMessage,
  createUnregisterActionMessage,
} from '../utils/outgoingMessageUtils.js';
import z from 'zod';
import allActions, { retrieveCurrentGoal } from '../constants/actionConstants.js';
import {
  clearPendingIncomingAction,
  consumePendingIncomingAction,
  getPendingIncomingAction,
  hasSentPendingIncomingAction,
} from '../state/pendingIncomingAction.js';
import { logger } from '../server.js';

const actions: FastifyPluginAsyncZod = async (app) => {
  app.get('/retrieve-pending', async () => {
    if (hasSentPendingIncomingAction()) return;

    return consumePendingIncomingAction();
  });

  app.post(
    '/register-all',
    {
      schema: {
        body: z.strictObject({
          goalsEnabled: z.boolean().optional(),
        }),
      },
    },
    async (req) => {
      const { goalsEnabled } = req.body;

      const filteredActions = allActions.filter((action) => {
        if (action === retrieveCurrentGoal && !goalsEnabled) {
          return false;
        }

        return true;
      });

      const registerAllMessage = createRegisterActionMessage(filteredActions);

      logger.info(registerAllMessage, 'Registering all actions');

      await sendMessage(registerAllMessage);
    },
  );

  app.get('/unregister-all', async () => {
    const unregisterAllMessage = createUnregisterActionMessage(
      allActions.map((action) => action.name),
    );

    await sendMessage(unregisterAllMessage);
  });

  app.post(
    '/register',
    {
      schema: {
        body: z.strictObject({
          actionNames: z.array(z.string()),
        }),
      },
    },
    async (req) => {
      const { actionNames: actionNamesToRegister } = req.body;
      const actionsToRegister = allActions.filter((action) =>
        actionNamesToRegister.includes(action.name),
      );

      const registerMessage = createRegisterActionMessage(actionsToRegister);

      await sendMessage(registerMessage);
    },
  );

  app.post(
    '/unregister',
    {
      schema: {
        body: z.strictObject({
          actionNames: z.array(z.string()),
        }),
      },
    },
    async (req) => {
      const { actionNames: actionNamesToUnregister } = req.body;

      const unregisterMessage = createUnregisterActionMessage(actionNamesToUnregister);

      await sendMessage(unregisterMessage);
    },
  );

  app.post(
    '/context',
    {
      schema: {
        body: z.strictObject({
          message: z.string(),
          silent: z.boolean().optional(),
        }),
      },
    },
    async (req) => {
      const requestContextMessage = req.body;

      const contextMessage = createContextMessage(
        requestContextMessage.message,
        requestContextMessage.silent,
      );

      await sendMessage(contextMessage);
    },
  );

  app.post(
    '/force',
    {
      schema: {
        body: z.strictObject({
          query: z.string(),
          actionNames: z.array(z.string()),
          ephemeralContext: z.boolean().optional(),
          state: z.string().optional(),
        }),
      },
    },
    async (req) => {
      const requestForceAction = req.body;

      const forceMessage = createForceActionMessage(
        requestForceAction.query,
        requestForceAction.actionNames,
        requestForceAction.ephemeralContext,
        requestForceAction.state,
      );

      await sendMessage(forceMessage);
    },
  );

  app.post(
    '/result',
    {
      schema: {
        body: z.strictObject({
          success: z.boolean(),
          message: z.string().optional(),
        }),
      },
    },
    async (req) => {
      const actionResult = req.body;
      const pendingIncomingAction = getPendingIncomingAction();

      if (!pendingIncomingAction) {
        logger.error('Failed to send action result as there is no pending action');

        return;
      }

      clearPendingIncomingAction();

      const resultMessage = createActionResultMessage(
        pendingIncomingAction.data.id,
        actionResult.success,
        actionResult.message,
      );

      await sendMessage(resultMessage);
    },
  );
};

export default actions;
