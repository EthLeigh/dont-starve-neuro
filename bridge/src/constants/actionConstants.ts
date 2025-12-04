import z from 'zod';
import { createOutgoingAction } from '../utils/outgoingMessageUtils.js';
import type { OutgoingAction } from '../types/outgoingMessageTypes.js';
import { schemaToJsonSchema } from '../utils/zodUtil.js';

export const moveToMarker = createOutgoingAction(
  'move_to_marker',
  "Moves the player to a saved location by it's name.",
  schemaToJsonSchema(
    z.strictObject({
      marker_name: z.string().nonoptional(),
    }),
  ),
);

export const saveMarker = createOutgoingAction(
  'save_marker',
  'Saves the current location by name to come back to later.',
  schemaToJsonSchema(
    z.strictObject({
      marker_name: z.string().nonoptional(),
    }),
  ),
);

export const eatFood = createOutgoingAction(
  'eat_food',
  'Eats the best food available in the inventory.',
);

export const harvestNearby = createOutgoingAction(
  'harvest_nearby',
  'Harvests nearby entities/interactibles until another action is called.',
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
  'Retrieves all items in the inventory and returns their names.',
);

export const getAvailableCrafts = createOutgoingAction(
  'get_available_crafts',
  'Retrieves all available and valid crafting recipes that can be crafted.',
);

export const craft = createOutgoingAction(
  'craft',
  'Crafts an item based on a recipe name (recipes can be retrieved through the get_available_crafts action).',
  schemaToJsonSchema(
    z.strictObject({
      recipe_name: z.string().nonoptional(),
    }),
  ),
);

export const characterSay = createOutgoingAction(
  'character_say',
  'Makes your character say something.',
  schemaToJsonSchema(
    z.strictObject({
      dialog: z.string().nonoptional(),
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

export const attackNearby = createOutgoingAction(
  'attack_nearby',
  'Attacks all nearby entities continuously until another action is called.',
);

export const cookFood = createOutgoingAction(
  'cook_food',
  'Cooks the best available food in the inventory at a nearby campfire.',
);

export const explore = createOutgoingAction(
  'explore',
  'Explores in a random direction until another action is called.',
);

export const retrieveNearby = createOutgoingAction(
  'retrieve_nearby',
  'Retrieves all the nearby objects/entities/enemies and how many there are.',
);

export const interact = createOutgoingAction(
  'interact',
  'Interacts with a nearby entity/interactible.',
  schemaToJsonSchema(
    z.strictObject({
      name: z.string().nonoptional(),
    }),
  ),
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
  attackNearby,
  cookFood,
  explore,
  retrieveNearby,
  interact,
];

export default allActions;
