import Fastify from 'fastify';
import formbody from '@fastify/formbody';
import type { ZodTypeProvider } from 'fastify-type-provider-zod';
import { env } from './env.js';
import api from './routes/index.js';
import { initWs } from './ws/wsClient.js';

await initWs();

const app = Fastify({ logger: true }).withTypeProvider<ZodTypeProvider>();

// Allows the bridge to handle urlencoded and json requests
app.addHook('preValidation', (req, _, done) => {
  const [key] = Object.keys(req.body || {});

  if (!key?.includes('{')) {
    done();

    return;
  }

  try {
    const parsed = JSON.parse(key);
    req.body = parsed;
  } catch (e) {
    console.warn('Failed to parse a stringified request body', e);
  }

  done();
});

app.register(formbody);
app.register(api, { prefix: '/api' });

app.listen({ port: env.PORT, host: '0.0.0.0' }).catch((e) => {
  app.log.error(e);
  process.exit(1);
});

console.info(`Now hosting on on localhost:${env.PORT}`);
