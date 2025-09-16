import 'dotenv/config';
import { z } from 'zod';

const Env = z.object({
  PORT: z.coerce.number().int().positive().default(9003),
  NODE_ENV: z.enum(['dev', 'test', 'release']).default('dev'),
});

export const env = Env.parse(process.env);
