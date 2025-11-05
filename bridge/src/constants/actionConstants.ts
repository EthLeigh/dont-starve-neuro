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
  "Moves the player to a saved marker location by it's name.",
  toJSONSchema(
    z.strictObject({
      marker_name: z.string(),
    }),
  ),
);

export const saveMarker = createOutgoingAction(
  'save_marker',
  'Saves the current location by name as a marker to come back to later.',
  toJSONSchema(
    z.strictObject({
      marker_name: z.string(),
    }),
  ),
);

export const eatFood = createOutgoingAction(
  'eat_food',
  'Eats the best food available in the inventory.',
);

export const harvestNearby = createOutgoingAction(
  'harvest_nearby',
  'Harvests nearby collectables until another action is called.',
);

export const getEnvironmentInfo = createOutgoingAction(
  'get_environment_info',
  "Retrieves information about the current floor type, season, precipitation, and if it's freezing.",
);

export const getPlayerInfo = createOutgoingAction(
  'get_player_info',
  "Retrieves information about the current character's name, health, hunger, sanity, if they're starving and if the character is sane.",
);

export const getInventory = createOutgoingAction(
  'get_inventory',
  'Retrieves all the items in the inventory and returns their names.',
);

export const getAvailableCrafts = createOutgoingAction(
  'get_available_crafts',
  'Retrieves all the available and valid crafting recipes that can be crafted.',
);

export const craft = createOutgoingAction(
  'craft',
  'Crafts an item based on a recipe name (recipes can be retrieved through the get_available_crafts action).',
  toJSONSchema(
    z.strictObject({
      recipe_name: z.string(),
    }),
  ),
);

export const characterSay = createOutgoingAction(
  'character_say',
  'Makes your character say something.',
  toJSONSchema(
    z.strictObject({
      dialog: z.string(),
    }),
  ),
);

export const getPerksAndQuirks = createOutgoingAction(
  'get_perks_and_quirks',
  "Returns the current character's perks and quirks.",
);

export const goToLightSource = createOutgoingAction(
  'go_to_light_source',
  'Runs to the nearest light source.',
);

export const retrieveCurrentGoal = createOutgoingAction(
  'retrieve_current_goal',
  "Sends the current goal and it's completion description.",
);

const allActions: readonly OutgoingAction[] = [
  moveToMarker,
  saveMarker,
  eatFood,
  harvestNearby,
  getEnvironmentInfo,
  getPlayerInfo,
  getInventory,
  getAvailableCrafts,
  craft,
  characterSay,
  getPerksAndQuirks,
  goToLightSource,
  retrieveCurrentGoal,
];

export default allActions;
