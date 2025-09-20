import z from 'zod';
import { createOutgoingAction } from '../utils/outgoingMessageUtils.js';
import type { OutgoingAction } from '../types/outgoingMessageTypes.js';
import type { JSONSchema } from 'zod/v4/core';
import { schemaToJsonSchema } from '../utils/zodUtil.js';

const toJSONSchema = (schema: z.ZodObject): JSONSchema.JSONSchema => {
  const jsonSchema = schemaToJsonSchema(schema);

  // eslint-disable-next-line @typescript-eslint/no-unused-vars
  const { $schema, additionalProperties, ...filteredJsonSchema } = jsonSchema;

  return filteredJsonSchema;
};

export const moveToMarker = createOutgoingAction(
  'move_to_marker',
  'Moves the player to a saved location.',
  toJSONSchema(
    z.strictObject({
      markerName: z.string(),
    }),
  ),
);

export const eatFood = createOutgoingAction(
  'eat_food',
  'Eats the best food available in the inventory.',
);

const allActions: OutgoingAction[] = [moveToMarker, eatFood];

export default allActions;
