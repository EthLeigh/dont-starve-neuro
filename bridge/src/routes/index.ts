import type { FastifyPluginAsync } from 'fastify';
import actions from './actions.js';
import { createStartupMessage } from '../utils/outgoingMessages.js';
import { sendMessage } from '../ws/wsClient.js';

const api: FastifyPluginAsync = async (app) => {
  app.register(actions, { prefix: '/actions' });

  app.get('/send-startup', async () => {
    const contextMessage = createStartupMessage();

    await sendMessage(contextMessage);
  });
};

export default api;
