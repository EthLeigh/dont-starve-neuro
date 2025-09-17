import type { FastifyPluginAsync } from 'fastify';
import { sendMessage } from '../ws/wsClient.js';
import { createContextMessage } from '../utils/outgoingMessages.js';
import z from 'zod';
import { schemaToJsonSchema } from '../utils/zod.js';

const SendContextRequestSchema = z.object({
  message: z.string(),
  silent: z.boolean().default(false),
});
type SendContextRequest = z.infer<typeof SendContextRequestSchema>;

const actions: FastifyPluginAsync = async (app) => {
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
};

export default actions;
