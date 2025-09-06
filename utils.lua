Utils = {}

modimport("constants.lua")
modimport("action_queue.lua")

---@param x number
---@param y number
---@param z number
---@return Entity[]
function Utils.GetNearbyHarvestables(x, y, z)
    return GLOBAL.TheSim:FindEntities(
        x,
        y,
        z,
        Constants.SEARCH_RADIUS,
        nil,
        {"FX", "NOCLICK", "DECOR", "INLIMBO", "player"}
    )
end

---@param x number
---@param y number
---@param z number
---@return table<string, Entity>
function Utils.GetNearbyUniqueHarvestables(x, y, z)
    local nearby_ents = Utils.GetNearbyHarvestables(x, y, z)
    local nearby_unique_ents = {}

    for _, ent in ipairs(nearby_ents) do
        if (nearby_unique_ents[ent.prefab] == nil) then
            nearby_unique_ents[ent.prefab] = ent
        end
    end

    return nearby_unique_ents
end

---@param ent Entity
---@return table | nil
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

---@param ent Entity
Utils.GetBufferedActionForEntity = function(ent)
    local action = Utils.GetActionForEntity(ent)

    if action == nil then return end

    return GLOBAL.BufferedAction(Player, ent, action)
end
