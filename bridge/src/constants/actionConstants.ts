import z from 'zod';
import { createOutgoingAction } from '../utils/outgoingMessageUtils.js';
import type { OutgoingAction } from '../types/outgoingMessageTypes.js';

export const moveToMarker = createOutgoingAction(
  'move_to_marker',
  "Moves the player to a saved location by it's name.",
  z.strictObject({
    marker_name: z.string().nonoptional(),
  }),
);

export const saveMarker = createOutgoingAction(
  'save_marker',
  'Saves the current location by name to come back to later.',
  z.strictObject({
    marker_name: z.string().nonoptional(),
  }),
);

export const getMarkers = createOutgoingAction(
  'get_markers',
  'Retrieves all of the available markers that have been saved.',
);

export const eatFood = createOutgoingAction(
  'eat_food',
  'Eats the best food available in the inventory.',
);

export const harvestNearby = createOutgoingAction(
  'harvest_nearby',
  'Harvests nearby entities/interactibles until another action is called. ' +
    'Available search filters are: "evergreen", "bush", "rock", "sapling", "grass", "flower".',
  z.strictObject({
    filters: z.array(z.string().nonoptional()).optional(),
  }),
);

export const getEnvironmentInfo = createOutgoingAction(
  'get_environment_info',
  "Retrieves information about the current floor type, season, precipitation, and if it's freezing.",
);

export const getPlayerInfo = createOutgoingAction(
  'get_player_info',
  "Retrieves information about the current character's name, health, hunger, sanity, if they're starving and if the character is sane.",
);

export const getAvailableCrafts = createOutgoingAction(
  'get_available_crafts',
  'Retrieves all valid crafting and prototype recipes that can be crafted/learned. Prototype recipes require a nearby science prototyper',
);

export const craft = createOutgoingAction(
  'craft',
  'Crafts an item based on a recipe name.',
  z.strictObject({
    recipe_name: z.string().nonoptional(),
  }),
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

export const interact = createOutgoingAction(
  'interact',
  'Interacts with a nearby entity/interactible.',
  z.strictObject({
    name: z.string().nonoptional(),
  }),
);

export const prototype = createOutgoingAction(
  'prototype',
  'Prototypes (and crafts) a valid recipe. Requires your character to be near a science prototyper.',
  z.strictObject({
    recipe_name: z.string().nonoptional(),
  }),
);

// Game over only
export const retry = createOutgoingAction('retry', 'Creates a new save.');
export const exitToMainMenu = createOutgoingAction('exit_to_main_menu', 'Exits to the main menu.');

const allActions: readonly OutgoingAction[] = [
  moveToMarker,
  saveMarker,
  getMarkers,
  eatFood,
  harvestNearby,
  getEnvironmentInfo,
  getPlayerInfo,
  getAvailableCrafts,
  craft,
  goToLightSource,
  retrieveCurrentGoal,
  attackNearby,
  cookFood,
  explore,
  interact,
  prototype,
  retry,
  exitToMainMenu,
];

export default allActions;
