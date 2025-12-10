# Don't Starve Neuro (WIP)

Neuro-sama API integration for Don't Starve.

[View open/planned Actions/Context Messages/Automatic Actions here](https://github.com/users/EthLeigh/projects/1).

Ensure that this repository's files are under `dont_starve/mods/dont_starve_neuro/` (Don't Starve's game directory).
The mod should now appear under the **Mods** button in the main menu and can be enabled normally.

To start the API Bridge, `cd` into `dont_starve_neuro/bridge/`, and make sure you have created an `.env` file based on the `.env.example`.

> [!IMPORTANT]
> If you do change the `PORT` variable in the `.env`, make sure that the `constants/api_bridge.lua` file is updated to match.

Then run:

```bash
# Install the dependencies first...
npm install

# Build the release version...
npm run build

# Start it.
npm start
```

Alternatively, you can also just run it in without building:

```bash
npm run dev
```

## Configuration

> Ensure the mod is loading correctly and can be viewed under the Mods section of the Main Menu!

When under the Mods section, and hovering over the "Don't Starve Neuro" mod,
click **Configure Mod** to adjust the settings.

Currently, you can:

- Toggle Goal related functionality

## Development

To run a development build, ensure you have a `.env` file created under `bridge/`, and run this:

> The startup will fail if there is not a Websocket connection setup prior!

```bash
# Install dependencies (if not done already)...
npm install

# Start it in watch/development mode.
npm run dev
```

---

To view your changes to the game files/test them, you can simply exit and enter a world and the mod will be reloaded.
There is no need to restart the game.

**Optional**: You can copy Don't Starve's source code (under the game files and `data/scripts/`) into `external/ds/`,
this is for some more context over game functions/classes/enums/etc. You can otherwise skip this step as I have
setup types for _most_ used game scripts, or you could reference the game scripts if you need to add something new.

## Available Actions

- Eat food - `eat_food`: Eats the best available food in the inventory
- Harvest nearby - `harvest_nearby`: Gets all nearby harvestable entities and starts a task (not blocking) to collect them until another actions is called. Available search filters are: "tree", "bush", "rock", "shrub", "grass", "flower". **Sends an action result immediately if harvestables are found or not.**
- Save marker - `save_marker`: Saves a position under a name.
- Move to marker - `move_to_marker`: Moves the player to a saved position.
- Get markers - `get_markers`: Returns all saved markers by name.
- Get environment information - `get_environment_info`: Returns all information about the player's surroundings. It specifically sends the ground type (grass, sand, etc.), temperature, if it's raining, if it's freezing, and the current season.
- Get player info - `get_player_info`: Returns all information about the player. It specifically sends the character name (Wilson, Willow, etc.), health percent, hunger percent, sanity percent, if they are starving, and if they are sane.
- Get inventory - `get_inventory`: Returns all items in the inventory by name **(currently does not include total item counts)**.
- Get available crafts - `get_available_crafts`: Returns all available and valid crafting recipes by name, this does not include items required for that recipe, or if the resulting craft is a building or item.
- Craft - `craft`: Attempts to craft a recipe by name. Recipe names can be retrieved with `get_available_crafts`.
- Get perks and quirks - `get_perks_and_quirks`: Returns the current character's perks and quirks (character-specific buffs and debuffs, alongside random information).
- Go to light source - `go_to_light_source`: Runs to the nearest light source. This action is only registered at night.
- Retrieve current goal - `retrieve_current_goal`: Sends the current goal and it's completion description.
- Attack nearby - `attack_nearby`: Attacks all nearby entities until another action is called.
- Cook food - `cook_food`: Cooks the best available food in the inventory using a Campfire or Fire Pit.
- Explore - `explore`: Explores in a random direction until another action is called. **Currently quite janky and will pick a new direction every 5 seconds**.
- Interact - `interact`: Interacts with a nearby entity/interactible.

## Context Messages

- Enter Darkness: "Your character is in the dark, run to the nearest light source or make one. Your character will lose sanity and get attacked by shadow monsters."
- Exit Darkness/Enter Light: "Your character is no longer in the dark."
- Starving (automatically eat available food): "Your character started starving but ate food to stay fed."
- Starving (no food available): "Your character is starving and will take damage until you eat but there is no food in your character's inventory."
- Stopped Starving: "Your character is no longer starving."
- Going insane: "Your character is going insane from sanity loss."
- Becoming sane: "Your character is no longer insane."
- Season change: "The season is now `SEASON_NAME`."
- Rain start: "It has started to rain."
- Rain stop: "It stopped raining."
- Freezing start: "Your character is freezing."
- Freezing stop: "Your character has stopped freezing."
- Monster attack: "You are being attacked by a `ENTITY_NAME`. There are `TOTAL_MONSTER_COUNT` monsters around you."
- Entity slain: "You have slain a `ENTITY_NAME`."
- Retrieve nearby: "These interactibles are nearby: `ENTITY_COUNT` `ENTITY_NAME` (`ENTITY_PREFAB_NAME`), `ENTITY_COUNT` `ENTITY_NAME` (`ENTITY_PREFAB_NAME`), ..."

## Automatic Actions

- Eat food when starving
- Run away when attacked
