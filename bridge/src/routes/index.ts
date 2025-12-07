import type { FastifyPluginAsync } from 'fastify';
import actionRoutes from './actionRoutes.js';
import { createStartupMessage } from '../utils/outgoingMessageUtils.js';
import { sendMessage } from '../ws/wsClient.js';

const api: FastifyPluginAsync = async (app) => {
  app.register(actionRoutes, { prefix: '/actions' });

  app.get('/send-startup', async () => {
    const contextMessage = createStartupMessage();

    await sendMessage(contextMessage);
  });
};

export default api;
