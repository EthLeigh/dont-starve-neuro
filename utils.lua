Utils = {}

modimport("classes/action_queue.lua")

---@param ent Entity | nil
---@return table | nil
function Utils.GetActionForEntity(ent)
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

---@param ent Entity | nil
function Utils.GetBufferedActionForEntity(ent)
    local action = Utils.GetActionForEntity(ent)

    if action == nil then return end

    return GLOBAL.BufferedAction(Player, ent, action)
end

function Utils.GetEnumKey(enum, value)
    for k, v in pairs(enum) do
        if v == value then
            return k
        end
    end
end

---@generic K
---@param list table<any, K>
---@param value K
function Utils.RemoveElementByValue(list, value)
    for list_index, list_value in ipairs(list) do
        if list_value == value then
            table.remove(list, list_index)

            return true
        end
    end

    return false
end
