import type { FastifyPluginAsync } from 'fastify';
import actionRoutes from './actionRoutes.js';
import { createStartupMessage } from '../utils/outgoingMessageUtils.js';
import { sendMessage } from '../ws/wsClient.js';
import { getGameStarted, setGameStarted } from '../state/gameStartupSent.js';
import { logger } from '../server.js';

const api: FastifyPluginAsync = async (app) => {
  app.register(actionRoutes, { prefix: '/actions' });

  app.get('/send-startup', async () => {
    if (getGameStarted()) {
      logger.warn('Unable to send startup message as it has already been sent');

      return;
    }

    const contextMessage = createStartupMessage();

    setGameStarted(true);
    await sendMessage(contextMessage);
  });
};

export default api;
