modimport("logging.lua")
modimport("constants/game.lua")
modimport("constants/api_bridge.lua")
modimport("constants/persistent_strings.lua")
modimport("helpers/string_helper.lua")
modimport("helpers/environment_helper.lua")
modimport("helpers/entity_helper.lua")
modimport("helpers/api_bridge_helper.lua")
modimport("api_bridge.lua")

GLOBAL.CHEATS_ENABLED = true
GLOBAL.require("debugkeys")

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

---@type LightWatcher
PlayerLightWatcher = nil

---@type Camera
Camera = nil

AddClassPostConstruct("screens/mainscreen", function()
    GLOBAL.TheSim:GetPersistentString(GameInitialized, function(success, data)
        if success and data == "true" then
            log_warning("Skipping sending startup message as it has (probably) already been sent")

            return
        end

        GLOBAL.TheSim:SetPersistentString(GameInitialized, "true")

        ApiBridge.HandleSendStartup()
    end)
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
    PlayerLightWatcher = Player.LightWatcher
end)

AddSimPostInit(function()
    Camera = GLOBAL.TheCamera
    Clock = GLOBAL:GetClock()
    World = GLOBAL:GetWorld()
    SeasonManager = World.components.seasonmanager

    PlayerName = Player.profile:GetValue("characterinthrone")

    Player:DoPeriodicTask(1, function()
        ApiBridge.GetPending()
    end)
end)
