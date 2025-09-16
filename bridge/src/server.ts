import Fastify from 'fastify';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';
import { env } from './env.js';
import api from './routes/index.js';

const app = Fastify({ logger: true }).withTypeProvider<ZodTypeProvider>();

app.register(api, { prefix: '/api' });

app.listen({ port: env.PORT, host: '0.0.0.0' }).catch((e) => {
  app.log.error(e);
  process.exit(1);
});
