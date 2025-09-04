modimport("harvest_helper.lua")
modimport("movement_helper.lua")
modimport("inventory_helper.lua")
modimport("constants.lua")

Player = nil
Camera = nil

AddPlayerPostInit(function(inst)
    Player = inst

    -- inst.components.playercontroller:Enable(false)

    -- Test pathfinding
    Player:DoPeriodicTask(0, function()
        local x, y, z = Player.Transform:GetWorldPosition()

        MovementHelper.MoveToPoint(Player, x + 15, y, z)
    end)
end)

AddSimPostInit(function()
    Camera = GLOBAL.TheCamera

    Camera:SetControllable(false)
    Camera:SetHeadingTarget(270)
    Camera:Snap()

    if (Player == nil) then
        error("[DSN] The Player object is nil")

        return
    end

    local items = InventoryHelper.GetHotbarItems(Player)

    for _, item_name in pairs(items) do
        print("ITEM:", item_name)
    end

    -- local x, y, z = Player.Transform:GetWorldPosition()
    -- local nearby_harvestables = Utils.GetNearbyHarvestables(x, y, z)

    -- HarvestHelper.HarvestEntities(Player, nearby_harvestables)
end)
