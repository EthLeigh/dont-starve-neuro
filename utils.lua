local Utils = {}

local Constants = modimport("constants.lua")

Utils.GetNearbyUniqueHarvestables = function(x, y, z)
    local nearby_ents = GLOBAL.TheSim:FindEntities(x, y, z, Constants.SEARCH_RADIUS, nil, {"FX", "NOCLICK", "DECOR", "INLIMBO", "player"})
    local nearby_unique_ents = {}

    for _, obj in ipairs(nearby_ents) do
        if (nearby_unique_ents[tostring(obj.prefab)] == nil) then
            nearby_unique_ents[tostring(obj.prefab)] = obj;
        end
    end

    return nearby_unique_ents
end

return Utils
