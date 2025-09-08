modimport("logging.lua")
modimport("helpers/combat_helper.lua")
modimport("helpers/dialog_helper.lua")
modimport("helpers/crafting_helper.lua")
modimport("helpers/harvest_helper.lua")
modimport("helpers/movement_helper.lua")
modimport("helpers/inventory_helper.lua")
modimport("helpers/entity_helper.lua")
modimport("constants.lua")

---@type GLOBAL
GLOBAL = GLOBAL

---@type Player
Player = nil

---@type Locomotor
PlayerLocomotor = nil

---@type Builder
PlayerBuilder = nil

---@type Combat
PlayerCombat = nil

---@type Camera
Camera = nil

AddPlayerPostInit(function(inst)
    Player = inst
    PlayerLocomotor = Player.components.locomotor
    PlayerBuilder = Player.components.builder
    PlayerCombat = Player.components.combat

    -- Player.components.playercontroller:Enable(false)

    -- Test pathfinding
    -- Player:DoPeriodicTask(0, function()
    --     local x, y, z = Player.Transform:GetWorldPosition()

    --     MovementHelper.MoveToPoint(x + 15, y, z)
    -- end)
end)

AddSimPostInit(function()
    Camera = GLOBAL.TheCamera

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
    local items = InventoryHelper.GetHotbarItems(Player)
    for _, item_name in pairs(items) do
        log_info("ITEM:", item_name)
    end

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
end)
