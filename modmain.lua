local constants = require("constants")

local Player = nil
local Camera = nil

function GetNearbyUniqueHarvestables(x, y, z)
    local nearby_ents = GLOBAL.TheSim:FindEntities(x, y, z, constants.SEARCH_RADIUS, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "player"})
    local nearby_unique_ents = {}

    for _, obj in ipairs(nearby_ents) do
        if (nearby_unique_ents[tostring(obj.prefab)] == nil) then
            nearby_unique_ents[tostring(obj.prefab)] = obj;
        end
    end

    return nearby_unique_ents
end

AddPlayerPostInit(function(inst)
    Player = inst

    local controller = inst.components.playercontroller
    local locomotor = inst.components.locomotor

    -- controller:Enable(false)

    inst:DoPeriodicTask(0, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local dest = GLOBAL.Vector3(x + 15, y, z)

        locomotor:GoToPoint(dest, nil, true)
    end)
end)

AddSimPostInit(function()
    Camera = GLOBAL.TheCamera

    Camera:SetControllable(false)
    Camera:SetHeadingTarget(270)
    Camera:Snap()
end)