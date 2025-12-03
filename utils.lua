Utils = {}

modimport("classes/action_queue.lua")

---@param ent Entity | nil
---@return string | nil, table | nil
function Utils.GetActionForEntity(ent)
    if ent == nil then return end

    if ent.components.inventoryitem and ent.components.inventoryitem.canbepickedup then
        return "pickup", GLOBAL.ACTIONS.PICKUP
    elseif ent.components.pickable and ent.components.pickable:CanBePicked() then
        return "pick", GLOBAL.ACTIONS.PICK
    elseif ent.components.harvestable and ent.components.harvestable:CanBeHarvested() then
        return "harvest", GLOBAL.ACTIONS.HARVEST
    elseif ent.components.crop and ent.components.crop:IsReadyForHarvest() then
        return "harvest", GLOBAL.ACTIONS.HARVEST
    elseif ent.components.inspectable then
        -- TODO: Add a context message for the character response
        return "examine", GLOBAL.ACTIONS.LOOKAT
    end
end

---@param ent Entity | nil
---@return string | nil, BufferedAction | nil
function Utils.GetBufferedActionForEntity(ent)
    if ent == nil then return end

    local action_name, action = Utils.GetActionForEntity(ent)

    if action == nil then return end

    return action_name, GLOBAL.BufferedAction(Player, ent, action)
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
