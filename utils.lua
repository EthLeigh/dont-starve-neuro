Utils = Utils or {}

modimport("constants.lua")

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

Utils.GetActionForEntity = function(ent)
    if ent == nil or not ent:IsValid() then return nil end

    if ent.components.pickable and ent.components.pickable:CanBePicked() then
        return ACTIONS.PICK
    elseif ent.components.harvestable and ent.components.harvestable:CanBeHarvested() then
        return ACTIONS.HARVEST
    elseif ent.components.crop and ent.components.crop:IsReadyForHarvest() then
        return ACTIONS.HARVEST
    end

    return nil
end

Utils.HarvestEntity = function(player, ent)
    local action = Utils.GetActionForEntity(ent)

    if action == nil then
        print("NO ACTION AVAILABLE")

        return
    end

    local buffer_action = GLOBAL.BufferedAction(player, ent, action)

    player.components.locomotor:PushAction(buffer_action, true)
end
