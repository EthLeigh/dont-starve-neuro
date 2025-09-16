import type { FastifyPluginAsync } from 'fastify';

const actions: FastifyPluginAsync = async (app) => {
  app.post('/send-context', async () => ({ ok: true }));
};

export default actions;
