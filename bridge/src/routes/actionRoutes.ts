import type { FastifyPluginAsync } from 'fastify';
import { sendMessage } from '../ws/wsClient.js';
import {
  createActionResultMessage,
  createContextMessage,
  createForceActionMessage,
  createRegisterActionMessage,
} from '../utils/outgoingMessageUtils.js';
import z from 'zod';
import { schemaToJsonSchema } from '../utils/zodUtil.js';
import allActions from '../constants/actionConstants.js';
import {
  clearPendingIncomingAction,
  consumePendingIncomingAction,
  getPendingIncomingAction,
  hasSentPendingIncomingAction,
} from '../state/pendingIncomingAction.js';
import { logger } from '../server.js';

const SendContextRequestSchema = z.object({
  message: z.string(),
  silent: z.boolean().optional(),
});
type SendContextRequest = z.infer<typeof SendContextRequestSchema>;

const ForceRequestSchema = z.object({
  query: z.string(),
  actionNames: z.array(z.string()),
  ephemeralContext: z.boolean().default(true),
  state: z.string().optional(),
});
type ForceRequest = z.infer<typeof ForceRequestSchema>;

const ResultRequestSchema = z.object({
  success: z.boolean(),
  message: z.string().optional(),
});
type ResultRequest = z.infer<typeof ResultRequestSchema>;

const actions: FastifyPluginAsync = async (app) => {
  app.get('/retrieve-incoming', async () => {
    if (hasSentPendingIncomingAction()) return;

    consumePendingIncomingAction();
  });

  app.get('/register-all', async () => {
    const contextMessage = createRegisterActionMessage(allActions);

    await sendMessage(contextMessage);
  });

  app.post(
    '/context',
    {
      schema: {
        body: schemaToJsonSchema(SendContextRequestSchema),
      },
    },
    async (req) => {
      const requestContextMessage = req.body as SendContextRequest;

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
        body: schemaToJsonSchema(ForceRequestSchema),
      },
    },
    async (req) => {
      const requestForceAction = req.body as ForceRequest;

      const contextMessage = createForceActionMessage(
        requestForceAction.query,
        requestForceAction.actionNames,
        requestForceAction.ephemeralContext,
        requestForceAction.state,
      );

      await sendMessage(contextMessage);
    },
  );

  app.post(
    '/result',
    {
      schema: {
        body: schemaToJsonSchema(ResultRequestSchema),
      },
    },
    async (req) => {
      const actionResult = req.body as ResultRequest;
      const pendingIncomingAction = getPendingIncomingAction();

      if (!pendingIncomingAction) {
        logger.error('Failed to send action result as there is no pending action');

        return;
      }

      clearPendingIncomingAction();

      const contextMessage = createActionResultMessage(
        pendingIncomingAction.data.id,
        actionResult.success,
        actionResult.message,
      );

      await sendMessage(contextMessage);
    },
  );
};

export default actions;
