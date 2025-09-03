modimport("harvest_helper.lua")
modimport("constants.lua")

Player = nil
Camera = nil

AddPlayerPostInit(function(inst)
    Player = inst

    local controller = inst.components.playercontroller
    local locomotor = inst.components.locomotor

    -- controller:Enable(false)

    -- Test pathfinding
    -- inst:DoPeriodicTask(0, function()
    --     local x, y, z = inst.Transform:GetWorldPosition()
    --     local dest = GLOBAL.Vector3(x + 15, y, z)

    --     locomotor:GoToPoint(dest, nil, true)
    -- end)
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

    local x, y, z = Player.Transform:GetWorldPosition()
    local nearby_harvestables = Utils.GetNearbyHarvestables(x, y, z)

    HarvestHelper.HarvestEntities(Player, nearby_harvestables)
end)