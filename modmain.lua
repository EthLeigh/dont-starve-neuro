modimport("logging.lua")
modimport("crafting_helper.lua")
modimport("harvest_helper.lua")
modimport("movement_helper.lua")
modimport("inventory_helper.lua")
modimport("constants.lua")

---@type GLOBAL
GLOBAL = GLOBAL

---@type Player
Player = nil

---@type Locomotor
PlayerLocomotor = nil

---@type Builder
PlayerBuilder = nil

---@type Camera
Camera = nil

AddPlayerPostInit(function(inst)
    Player = inst
    PlayerLocomotor = Player.components.locomotor
    PlayerBuilder = Player.components.builder

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

    if (Player == nil) then
        log_error("The Player object is nil")

        return
    end

    -- Test inventory visibility
    local items = InventoryHelper.GetHotbarItems(Player)
    for _, item_name in pairs(items) do
        log_info("ITEM:", item_name)
    end

    -- Test harvesting
    -- local x, y, z = Player.Transform:GetWorldPosition()
    -- local nearby_harvestables = Utils.GetNearbyHarvestables(x, y, z)
    -- HarvestHelper.HarvestEntities(nearby_harvestables)

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
end)
