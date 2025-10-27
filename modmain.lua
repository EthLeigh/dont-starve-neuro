modimport("logging.lua")
modimport("classes/task.lua")
modimport("managers/context_manager.lua")
modimport("managers/trigger_manager.lua")
modimport("managers/task_manager.lua")
modimport("helpers/combat_helper.lua")
modimport("helpers/dialog_helper.lua")
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
modimport("constants/game.lua")
modimport("constants/api_bridge.lua")
modimport("constants/api_actions.lua")
modimport("api_bridge.lua")

---@type GLOBAL
GLOBAL = GLOBAL

---@type World
World = nil

---@type SeasonManager
SeasonManager = nil

---@type Player
Player = nil

---@type string
PlayerName = nil

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

AddClassPostConstruct("screens/mainscreen", function()
    ApiBridge.HandleSendStartup()
end)

AddPlayerPostInit(function(inst)
    Player = inst
    PlayerHealth = Player.components.health
    PlayerHunger = Player.components.hunger
    PlayerSanity = Player.components.sanity
    PlayerLocomotor = Player.components.locomotor
    PlayerBuilder = Player.components.builder
    PlayerCombat = Player.components.combat
    PlayerEater = Player.components.eater
    PlayerLightWatcher = Player.LightWatcher
    PlayerTemperature = Player.components.temperature

    -- Player.components.playercontroller:Enable(false)

    -- Test pathfinding
    -- Player:DoPeriodicTask(0, function()
    --     local x, y, z = Player.Transform:GetWorldPosition()

    --     MovementHelper.MoveToPoint(x + 15, y, z)
    -- end)
end)

AddSimPostInit(function()
    Camera = GLOBAL.TheCamera
    World = GLOBAL:GetWorld()
    SeasonManager = World.components.seasonmanager

    PlayerName = Player.profile:GetValue("characterinthrone")

    Camera:SetControllable(false)
    Camera:SetHeadingTarget(270)
    Camera:Snap()

    GlobalPlayer = GLOBAL.GetPlayer()

    if Player == nil and GlobalPlayer == nil then
        log_error("The Player object is nil")

        return
    elseif GlobalPlayer ~= nil then
        Player = GlobalPlayer
    end

    -- Test inventory visibility
    -- local items = InventoryHelper.GetHotbarItems(Player)
    -- for _, item_name in pairs(items) do
    --     log_info("ITEM:", item_name)
    -- end

    -- Test harvesting
    -- local nearby_harvestables = EntityHelper.GetNearbyHarvestables()
    -- HarvestHelper.HarvestEntities(nearby_harvestables)

    -- Test animal detection and combat
    -- Player:DoPeriodicTask(1, function()
    --     local nearby_animals = EntityHelper.GetNearbyAnimals()

    --     for _, animal in pairs(nearby_animals) do
    --         if CombatHelper.CanAttackEntity(animal) then
    --             CombatHelper.AttackEntity(animal)
    --             break;
    --         end
    --     end
    -- end)

    -- Test crafting
    -- Player:DoTaskInTime(0, function()
    --     local buildables = CraftingHelper.GetAvailableBuildables()

    --     for _, buildable in pairs(buildables) do
    --         log_info(buildable.name)

    --         if buildable.name == "axe" then
    --             CraftingHelper.BuildFromRecipeName(buildable.name)
    --         end
    --     end
    -- end)

    -- Test custom dialog
    -- Player:DoTaskInTime(5, function()
    --     DialogHelper.Speak("Oh my god, here we are!")
    -- end)

    -- Test player helper
    -- Player:DoPeriodicTask(5, function()
    --     log_info("--- PLAYER DETAILS ---")

    --     log_info("Health:", PlayerHelper.GetHealth())
    --     log_info("Hunger:", PlayerHelper.GetHunger())
    --     log_info("Sanity:", PlayerHelper.GetSanity())

    --     log_info("Hurt:", PlayerHelper.IsHurt())
    --     log_info("Hungry:", PlayerHelper.IsHungry())
    --     log_info("Sane:", PlayerHelper.IsSane())

    --     log_info("Hurting from starvation:", PlayerHelper.IsHurtingFromStarvation())
    --     log_info("Sanity going down:", PlayerHelper.LosingSanity())

    --     log_info("---                ---")
    -- end)

    -- Testing environment helper
    -- log_info(EnvironmentHelper.GetGroundName())
    -- log_info(EnvironmentHelper.GetSeason())
    -- log_info(EnvironmentHelper.GetPrecipType())
    -- log_info(EnvironmentHelper.GetTemperature())
    -- log_info(EnvironmentHelper.IsFreezing())

    -- Test marker helper
    -- local x, _, z = Player.Transform:GetWorldPosition()
    -- MarkerHelper.SetMarker("home", x, z)

    -- Player:DoTaskInTime(1, function()
    --     MarkerHelper.GetMarker("home", function (markerX, markerZ)
    --         log_info("MY HOME POSITION:", markerX, markerZ)
    --     end)
    -- end)

    -- Test TaskManager
    -- TaskManager.StartTasks({
    --     Task:new(TaskManager.TASK_TYPES.HARVEST, function(current_iteration, args)
    --         log_info("DOING FIRST LOOP")
    --         if current_iteration > 5 then
    --             log_info("FINISHED FIRST TASK, MOVING TO THE NEXT")

    --             return true
    --         end

    --         return false
    --     end),
    --     Task:new(TaskManager.TASK_TYPES.HARVEST, function()
    --         log_info("HOLY SHIT DOING THE SECOND ONE")

    --         return true
    --     end),
    -- })

    TriggerManager.SetupTriggerEvents()
    ContextManager.SetupContextEvents()

    Player:DoPeriodicTask(1, function()
        ApiBridge.GetPending()
    end)

    -- Testing only (need to send valid actions only not all)
    ApiBridge.HandleSendRegisterAll()
end)
