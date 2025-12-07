import 'dotenv/config';
import { z } from 'zod';

const Env = z.object({
  PORT: z.coerce.number().int().positive().default(9003),
  NODE_ENV: z.enum(['dev', 'release']).default('dev'),
  NEURO_SDK_WS_URL: z.url().default('ws://localhost:8000'),
});

export const env = Env.parse(process.env);
