Utils = Utils or {}

modimport("constants.lua")
modimport("action_queue.lua")

Utils.GetNearbyHarvestables = function(x, y, z)
    return GLOBAL.TheSim:FindEntities(
        x,
        y,
        z,
        Constants.SEARCH_RADIUS,
        nil,
        {"FX", "NOCLICK", "DECOR", "INLIMBO", "player"}
    )
end

Utils.GetNearbyUniqueHarvestables = function(x, y, z)
    local nearby_ents = Utils.GetNearbyHarvestables(x, y, z)
    local nearby_unique_ents = {}

    for _, obj in ipairs(nearby_ents) do
        if (nearby_unique_ents[tostring(obj.prefab)] == nil) then
            nearby_unique_ents[tostring(obj.prefab)] = obj
        end
    end

    return nearby_unique_ents
end

Utils.GetActionForEntity = function(ent)
    if ent == nil then return nil end

    if ent.components.pickable and ent.components.pickable:CanBePicked() then
        return GLOBAL.ACTIONS.PICK
    elseif ent.components.harvestable and ent.components.harvestable:CanBeHarvested() then
        return GLOBAL.ACTIONS.HARVEST
    elseif ent.components.crop and ent.components.crop:IsReadyForHarvest() then
        return GLOBAL.ACTIONS.HARVEST
    elseif ent.components.inspectable then
        return GLOBAL.ACTIONS.INSPECT
    end

    return nil
end

Utils.GetBufferedActionForEntity = function(player, ent)
    local action = Utils.GetActionForEntity(ent)

    if (action == nil) then return nil end

    return GLOBAL.BufferedAction(player, ent, action)
end
