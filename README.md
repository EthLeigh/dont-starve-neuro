# Don't Starve Neuro (WIP)

Neuro-sama API integration for Don't Starve

<!-- TODO: Add a section on how to setup and use -->

# Development

<!-- TODO: Add instructions for the API bridge -->

Copy Don't Starve's source code (under the game files and `data/scripts`) into `external/ds/`,
this is for some more context over game functions/classes/enums/etc.

# Available Actions

- Eat food - `eat_food`: Eats the best available food in the inventory
- Harvest nearby - `harvest_nearby`: Gets all nearby harvestable entities and starts a task (not blocking) to collect them. **Sends an action result immediately if harvestables are found or not.**
- Save marker - `save_marker`: Saves a position under a name.
- Move to marker - `move_to_marker`: Moves the player to a saved position.
- Get environment information - `get_environment_info`: Returns all information about the player's surroundings. It specifically sends the ground type (grass, sand, etc.), temperature, if it's raining, if it's freezing, and the current season.
- Get player info - `get_player_info`: Returns all information about the player. It specifically sends the character name (Wilson, Willow, etc.), health percent, hunger percent, sanity percent, if they are starving, and if they are sane.
- Get inventory - `get_inventory`: Returns all items in the inventory by name **(currently does not include total item counts)**.
- Get available crafts - `get_available_crafts`: Returns all available and valid crafting recipes by name, this does not include items required for that recipe, or if the resulting craft is a building or item.
- Craft - `craft`: Attempts to craft a recipe by name. Recipe names can be fetched with `get_available_crafts`.
- Character say - `character_say`: Makes the character say custom dialog.

## Planned Actions

- Go to light source - `go_to_light_source`: Runs to the nearest light source or crafts one (maybe not craft).
- Get all markers - `get_all_markers`: Returns all saved markers.
- Attack nearby - `attack_nearby`: Attacks the nearest entity, but prioritizes enemies.
- Get perks and quirks - `get_perks_and_quirks`: Returns the current character's perks and quirks. For example: You are playing as Willow. She has an infinite lighter, is immune to fire damage, but lights fires when low on sanity.
- Get goal - `get_goal`: Returns a general goal for Neuro to follow and will internally keep track of her progress. The goals will increment in (hardcoded) steps. For example: "Make a campfire" -> "Collect farmable food" -> etc.
  _This will hopefully alleviate Neuro not knowing how to play, or getting lost/not playing._

# Context Messages

None implemented currently.

## Planned Context Messages

- Enemy attacking: "You are being attacked by an `ENEMY_NAME`."
- Nearby hostile/strong enemy: "There is a dangerous/hostile `ENEMY_NAME` close to you."
- Starving: "You are starving."
- Insanity: "Your character is going insane from sanity loss."
- Darkness: "You are in the dark, run to the nearest light source or make one."
- Season change: "It is now `SEASON_NAME`."
- Rain change: "It is now **raining/not raining**."
- Freezing change: "It is now **freezing/not freezing**."
