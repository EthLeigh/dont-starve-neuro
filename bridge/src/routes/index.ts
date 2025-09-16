import type { FastifyPluginAsync } from 'fastify';
import actions from './actions.js';

const api: FastifyPluginAsync = async (app) => {
  app.register(actions, { prefix: '/actions' });
};

export default api;
