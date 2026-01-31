modimport("logging.lua")
modimport("constants/game.lua")
modimport("constants/ignored_prefabs.lua")
modimport("constants/api_bridge.lua")
modimport("constants/api_actions.lua")
modimport("constants/persistent_strings.lua")
modimport("constants/goals.lua")
modimport("classes/task.lua")
modimport("managers/context_manager.lua")
modimport("managers/trigger_manager.lua")
modimport("managers/task_manager.lua")
modimport("managers/goal_manager.lua")
modimport("helpers/string_helper.lua")
modimport("helpers/goals_helper.lua")
modimport("helpers/combat_helper.lua")
modimport("helpers/crafting_helper.lua")
modimport("helpers/player_helper.lua")
modimport("helpers/harvest_helper.lua")
modimport("helpers/movement_helper.lua")
modimport("helpers/inventory_helper.lua")
modimport("helpers/environment_helper.lua")
modimport("helpers/entity_helper.lua")
modimport("helpers/marker_helper.lua")
modimport("helpers/eater_helper.lua")
modimport("helpers/api_bridge_helper.lua")
modimport("api_bridge.lua")

GLOBAL.CHEATS_ENABLED = true
GLOBAL.require("debugkeys")

CONFIG = {}

CONFIG.GOALS_ENABLED = GetModConfigData("goals_enabled")

---@type GLOBAL
GLOBAL = GLOBAL

---@type World
World = nil

---@type Clock
Clock = nil

---@type SeasonManager
SeasonManager = nil

---@type Player
Player = nil

---@type string
PlayerName = nil

---@type Inventory
PlayerInventory = nil

---@type Health
PlayerHealth = nil

---@type Hunger
PlayerHunger = nil

---@type Sanity
PlayerSanity = nil

---@type Locomotor
PlayerLocomotor = nil

---@type Builder
PlayerBuilder = nil

---@type Combat
PlayerCombat = nil

---@type Eater
PlayerEater = nil

---@type LightWatcher
PlayerLightWatcher = nil

---@type Temperature
PlayerTemperature = nil

---@type Camera
Camera = nil

local function FilterAndRegisterActions()
    local actions_to_register = Utils.UnpackValues(ApiActions)

    Utils.RemoveElementByValue(actions_to_register, ApiActions.CREATE_NEW_WORLD)
    Utils.RemoveElementByValue(actions_to_register, ApiActions.LOAD_WORLD)

    Utils.RemoveElementByValue(actions_to_register, ApiActions.RETRY)
    Utils.RemoveElementByValue(actions_to_register, ApiActions.EXIT_TO_MAIN_MENU)

    if not CONFIG.GOALS_ENABLED then
        Utils.RemoveElementByValue(actions_to_register, ApiActions.RETRIEVE_CURRENT_GOAL)
    end

    if not Clock:IsNight() then
        Utils.RemoveElementByValue(actions_to_register, ApiActions.GO_TO_LIGHT_SOURCE)
    end

    if not EaterHelper.GetBestFoodInInventory() then
        Utils.RemoveElementByValue(actions_to_register, ApiActions.EAT_FOOD)
        Utils.RemoveElementByValue(actions_to_register, ApiActions.COOK_FOOD)
    end

    if not MarkerHelper.HasMarkers() then
        MarkerHelper.HAS_REGISTERED_GET_ACTIONS = false

        Utils.RemoveElementByValue(actions_to_register, ApiActions.GET_MARKERS)
        Utils.RemoveElementByValue(actions_to_register, ApiActions.MOVE_TO_MARKER)
    else
        MarkerHelper.HAS_REGISTERED_GET_ACTIONS = true
    end

    ApiBridge.HandleSendRegister(actions_to_register)
end

AddClassPostConstruct("screens/mainscreen", function(self)
    ApiBridgeHelper.OutsideOfSim = true

    GLOBAL.TheSim:GetPersistentString(GameInitialized, function(success, data)
        if success and data == "true" then
            log_warning("Skipping sending startup message as it has (probably) already been sent")

            return
        end

        GLOBAL.TheSim:SetPersistentString(GameInitialized, "true")

        ApiBridge.HandleSendStartup()
    end)

    local actions_to_register = { ApiActions.CREATE_NEW_WORLD }
    if GLOBAL.SaveGameIndex:GetCurrentMode(1) ~= nil then
        table.insert(actions_to_register, ApiActions.LOAD_WORLD)
    end

    ApiBridge.HandleSendRegister(actions_to_register)

    local CHECK_INTERVAL = 2
    local original_OnUpdate = self.OnUpdate

    local time_accumulator = 0
    self.OnUpdate = function(update_self, dt)
        if original_OnUpdate then
            original_OnUpdate(update_self, dt)
        end

        time_accumulator = time_accumulator + dt

        if time_accumulator >= CHECK_INTERVAL then
            time_accumulator = 0

            ApiBridge.GetPending()
        end
    end
end)

local OriginalStartNextInstance = GLOBAL.StartNextInstance
---@param in_params table?
GLOBAL.StartNextInstance = function(in_params)
    ApiBridge.HandleSendUnregisterAll()

    OriginalStartNextInstance(in_params)
end

local OriginalRequestShutdown = GLOBAL.RequestShutdown
---@param callback function
GLOBAL.RequestShutdown = function(callback)
    GLOBAL.TheSim:SetPersistentString(GameInitialized, "false")

    OriginalRequestShutdown(callback)
end

AddPlayerPostInit(function(inst)
    Player = inst
    PlayerInventory = Player.components.inventory
    PlayerHealth = Player.components.health
    PlayerHunger = Player.components.hunger
    PlayerSanity = Player.components.sanity
    PlayerLocomotor = Player.components.locomotor
    PlayerBuilder = Player.components.builder
    PlayerCombat = Player.components.combat
    PlayerEater = Player.components.eater
    PlayerLightWatcher = Player.LightWatcher
    PlayerTemperature = Player.components.temperature

    player_original_on_save = Player.OnSave

    -- Handle stuff when player gets saved
    Player.OnSave = function(_, data)
        -- Commented out for testing/dev
        -- GoalManager.SaveCurrentGoal()

        if not player_original_on_save then
            log_error("Missing player save function! Failed to save data.")

            return
        end

        player_original_on_save(Player, data)
    end

    Player:ListenForEvent("death", function()
        ApiBridge.HandleSendRegister({ ApiActions.RETRY, ApiActions.EXIT_TO_MAIN_MENU })

        ApiBridge.HandleSendForce("What do you want to do?",
            { ApiActions.RETRY, ApiActions.EXIT_TO_MAIN_MENU },
            true, "Your character has died and the game is over.")
    end)
end)

AddSimPostInit(function()
    ApiBridgeHelper.OutsideOfSim = false

    Camera = GLOBAL.TheCamera
    Clock = GLOBAL:GetClock()
    World = GLOBAL:GetWorld()
    SeasonManager = World.components.seasonmanager

    PlayerName = Player.profile:GetValue("characterinthrone")

    Camera:SetControllable(false)
    Camera:SetHeadingTarget(270)
    Camera:Snap()

    -- If no time has passed in the first cycle, we assume it's a new world
    if (Clock.timeLeftInEra == Clock.totalEraTime and Clock.numcycles == 0) then
        ApiBridge.HandleSendContext('A tall man said to you, "Say pal, you don\'t look so good. ' ..
            'You better find something to eat before night comes!", and then he dissapeared.')

        PlayerHudShowDefault = Player.HUD.Show
        Player.HUD.Show = function(...)
            -- Register actions when the player's hud is shown
            FilterAndRegisterActions()

            -- Do whatever default stuff the game does
            PlayerHudShowDefault(...)
        end
    else
        FilterAndRegisterActions()
    end

    GlobalPlayer = GLOBAL:GetPlayer()

    if Player == nil and GlobalPlayer == nil then
        log_error("The Player object is nil")

        return
    elseif GlobalPlayer ~= nil then
        Player = GlobalPlayer
    end

    TriggerManager.SetupTriggerEvents()
    ContextManager.SetupContextEvents()

    if CONFIG.GOALS_ENABLED then
        GoalManager.LoadAndStart()
    end

    Player:DoPeriodicTask(1, function()
        ApiBridge.GetPending()
    end)

    Player:ListenForEvent("killed", ContextManager.OnEntityKilled)
end)
