Utils = {}

modimport("classes/action_queue.lua")

---@param ent Entity | nil
---@return string | nil action_name, table | nil action_enum, string | nil response_message
function Utils.GetActionForEntity(ent)
    if ent == nil or ent.components == nil then return end

    if ent.prefab == "resurrectionstone" then
        return "activate", GLOBAL.ACTIONS.ACTIVATE, "Instead of dying your character will respawn at the stone."
    elseif ent.components.trap and ent.components.trap.issprung then
        return "check trap", GLOBAL.ACTIONS.CHECKTRAP,
            "Got " .. table.concat(ent.components.trap.lootprefabs, ", ") .. " from the trap."
    elseif ent.components.inventoryitem and ent.components.inventoryitem.canbepickedup then
        return "pickup", GLOBAL.ACTIONS.PICKUP
    elseif ent.components.pickable and ent.components.pickable:CanBePicked() and ent.components.pickable.caninteractwith then
        return "pick", GLOBAL.ACTIONS.PICK
    elseif ent.components.harvestable and ent.components.harvestable:CanBeHarvested() then
        return "harvest", GLOBAL.ACTIONS.HARVEST
    elseif ent.components.crop and ent.components.crop:IsReadyForHarvest() then
        return "harvest", GLOBAL.ACTIONS.HARVEST
    elseif (ent.prefab == "rock1" or ent.prefab == "rock2" or ent.prefab == "rock_flintless") then
        if InventoryHelper.HasItem("pickaxe") then
            return "mine", GLOBAL.ACTIONS.MINE
        else
            return nil, nil, "A pickaxe is required to mine the " .. ent.prefab .. "."
        end
    elseif (ent.prefab == "evergreen" or ent.prefab == "evergreen_normal" or ent.prefab == "evergreen_short" or
            ent.prefab == "evergreen_tall" or ent.prefab == "evergreen_sparse" or ent.prefab == "evergreen_sparse_normal"
            or ent.prefab == "evergreen_sparse_short" or ent.prefab == "evergreen_sparse_tall" or ent.prefab == "evergreen_burnt"
            or ent.prefab == "evergreen_stump") then
        if InventoryHelper.HasItem("axe") then
            return "chop", GLOBAL.ACTIONS.CHOP
        else
            return nil, nil, "An axe is required to chop the " .. ent.prefab .. "."
        end
    elseif ent.components.inspectable and not ent.components.harvestable and not ent.components.lootdropper and not ent.components.pickable and not ent.components.inventoryitem then
        -- TODO: Add a context message for the character response
        return "examine", GLOBAL.ACTIONS.LOOKAT
    end
end

---@param ent Entity|nil
---@return string|nil, BufferedAction|nil, string|nil
function Utils.GetBufferedActionForEntity(ent)
    if ent == nil then return end

    local action_name, action, response_message = Utils.GetActionForEntity(ent)

    if action == nil then return nil, nil, response_message end

    return action_name, GLOBAL.BufferedAction(Player, ent, action), response_message
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

---@generic V
---@param list table<any, V>
---@return V[]
function Utils.UnpackValues(list)
    local values = {}

    for _, v in pairs(list) do
        table.insert(values, v)
    end

    return values
end

---@param list table<any, any>
---@return integer
function Utils.GetTableLength(list)
    local count = 0
    for _ in pairs(list) do
        count = count + 1
    end

    return count
end
