# Don't Starve Neuro Co-op (WIP)

> [!IMPORTANT]
> If you are looking for the **completed singleplayer** integration it is under the `single` branch, and the releases are marked with `single-*`.

Co-op Neuro-sama SDK integration for Don't Starve.

## Setup

Ensure that this repository's files are under `dont_starve/mods/dont-starve-neuro/` (Don't Starve's game directory).
The mod should now appear under the **Mods** button in the main menu and can be enabled normally.

To start the API Bridge, `cd` into `api-bridge/`, and make sure you have created an `.env` file based on the `.env.example`.

> [!IMPORTANT]
> If you do change the `PORT` variable in the `.env`, make sure that the `dont-starve-neuro/constants/api_bridge.lua` file is updated to match.

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

## Usage

> [!IMPORTANT]
> Make sure you have a [similar API to the one described here](https://github.com/VedalAI/neuro-sdk/) running with a Websocket connection (not the Bridge API).

### Configuration

> Ensure the mod is loading correctly and can be viewed under the Mods section of the Main Menu!

When under the Mods section, and hovering over the "Don't Starve Neuro" mod,
click **Configure Mod** to adjust the settings.

---

Once everything is configured and ready...

Start up the Bridge, and then open the game. The startup command only sends _once_ on game startup.

Create a new save and keep everything default. If any DLCs are installed/available, ignore them and only select **DS** (may change later).

Once the world is created, the mod will communicate with the Bridge to register actions, which will send it over to the Neuro API.

## Development

To run a development build, ensure you have a `.env` file created under `api-bridge/`, and run this:

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

**Optional**: You can open Don't Starve's source code (under the game files and `dont_starve/data/scripts/`),
this is for some more context over game functions/classes/enums/etc. You can otherwise skip this step as I have
setup types for _most_ used game scripts, or you could reference the game scripts if you need to add something new.

## Contact / Support

Message me on Discord if you need any help, [`ethleigh`](https://discordapp.com/users/ethleigh/).

## Available Actions

Work in progress...

## Context Messages

Work in progress...

## Automatic Actions

Work in progress...
