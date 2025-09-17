import Fastify from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';
import { env } from './env.js';
import api from './routes/index.js';
import { initWs } from './ws/wsClient.js';
import { RequestActionQueue } from './queue/requestActionQueue.js';

await initWs();
export const requestActionQueue = new RequestActionQueue();

const app = Fastify({ logger: true }).withTypeProvider<ZodTypeProvider>();

app.register(api, { prefix: '/api' });

app.listen({ port: env.PORT, host: '0.0.0.0' }).catch((e) => {
  app.log.error(e);
  process.exit(1);
});

console.info(`Now hosting on on localhost:${env.PORT}`);
