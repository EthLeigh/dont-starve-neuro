import type { FastifyPluginAsync } from 'fastify';
import { sendMessage } from '../ws/wsClient.js';
import {
  createActionResultMessage,
  createContextMessage,
  createForceActionMessage,
  createRegisterActionMessage,
} from '../utils/outgoingMessages.js';
import z from 'zod';
import { schemaToJsonSchema } from '../utils/zod.js';
import allActions from '../constants/actions.js';

const SendContextRequestSchema = z.object({
  message: z.string(),
  silent: z.boolean().default(false),
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
  id: z.string(),
  success: z.boolean(),
  message: z.string().optional(),
});
type ResultRequest = z.infer<typeof ResultRequestSchema>;

const actions: FastifyPluginAsync = async (app) => {
  app.get('/register-all', async () => {
    const contextMessage = createRegisterActionMessage(allActions);

    await sendMessage(contextMessage);
  });

  app.post(
    '/send-context',
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
      const requestForceAction = req.body as ResultRequest;

      const contextMessage = createActionResultMessage(
        requestForceAction.id,
        requestForceAction.success,
        requestForceAction.message,
      );

      await sendMessage(contextMessage);
    },
  );
};

export default actions;
