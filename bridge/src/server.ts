import Fastify from 'fastify';
import formbody from '@fastify/formbody';
import {
  type ZodTypeProvider,
  serializerCompiler,
  validatorCompiler,
} from 'fastify-type-provider-zod';
import { env } from './env.js';
import api from './routes/index.js';
import { initWs } from './ws/wsClient.js';

export const app = Fastify({
  logger: {
    level: 'info',
    transport: {
      target: 'pino-pretty',
      options: { colorize: true },
    },
  },
}).withTypeProvider<ZodTypeProvider>();
export const logger = app.log;

app.setValidatorCompiler(validatorCompiler);
app.setSerializerCompiler(serializerCompiler);

// Allows the bridge to handle urlencoded and json requests
app.addHook('preValidation', (req, _, done) => {
  const [key] = Object.keys(req.body || {});

  if (!key?.includes('{')) {
    done();

    return;
  }

  // Breaks if a single quotation is included when parsing
  const cleanedKey = key.replaceAll(String.raw`\'`, "'");

  try {
    const parsed = JSON.parse(cleanedKey);
    req.body = parsed;
  } catch {
    app.log.warn({ body: req.body }, 'Failed to parse a stringified request body');
  }

  done();
});

app.register(formbody);
app.register(api, { prefix: '/api' });

app.listen({ port: env.PORT, host: '0.0.0.0' }).catch((e) => {
  app.log.error('An error occurred with Fastify', e);
  process.exit(1);
});

try {
  await initWs();
} catch {
  app.log.error('Failed to initialize Websocket connection');

  app.close();
  process.exit(1);
}
