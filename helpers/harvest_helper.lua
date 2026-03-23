---@class HarvestHelper
HarvestHelper = {}

modimport("utils.lua")

---@param filters string[]
---@return table<string, string>
function HarvestHelper.MapActionFiltersToPrefabs(filters)
    if type(filters) == "string" then
        filters = { filters }
    end

    local filter_prefabs = {}
    for _, action_filter in ipairs(filters) do
        if action_filter == "tree" or action_filter == "evergreen" then
            filter_prefabs[action_filter] = "evergreen"
        elseif action_filter == "bush" then
            filter_prefabs[action_filter] = "bush"
        elseif action_filter == "rock" then
            filter_prefabs[action_filter] = "rock1"
        elseif action_filter == "shrub" or action_filter == "sapling" then
            filter_prefabs[action_filter] = "sapling"
        elseif action_filter == "grass" then
            filter_prefabs[action_filter] = "grass"
        elseif action_filter == "flower" then
            filter_prefabs[action_filter] = "flower"
        elseif action_filter == "flint" then
            filter_prefabs[action_filter] = "flint"
        elseif action_filter == "carrot" then
            filter_prefabs[action_filter] = "carrot_planted"
        elseif action_filter == "log" then
            filter_prefabs[action_filter] = "log"
        elseif action_filter == "rocks" then
            filter_prefabs[action_filter] = "rocks"
        else
            log_warning("Unknown harvestable type filter:", action_filter)
        end
    end

    return filter_prefabs
end

---@param ent Entity
function HarvestHelper.HarvestEntity(ent)
    local action_name, buffer_action = Utils.GetBufferedActionForEntity(ent)

    if not buffer_action then return end

    local action_item = nil
    local hotbar_items = InventoryHelper.GetHotbarItems()
    for _, hotbar_item in pairs(hotbar_items) do
        if (action_name == "mine" and hotbar_item.prefab == "pickaxe") or
            (action_name == "chop" and hotbar_item.prefab == "axe") then
            action_item = hotbar_item.item
        end
    end

    if action_item ~= nil and PlayerInventory.equipslots.hands ~= action_item then
        PlayerInventory:Equip(action_item)
    end

    PlayerLocomotor:PushAction(buffer_action, true)
end

---@param ents Entity[]
function HarvestHelper.HarvestEntities(ents)
    local buf_action_queue = BufferedActionQueue:New()

    for _, ent in pairs(ents) do
        local _, buffered_action = Utils.GetBufferedActionForEntity(ent)

        if (buffered_action ~= nil) then
            buf_action_queue:Push(buffered_action)
        else
            log_error("Unable to create a buffered action for entity", ent.prefab)
        end
    end

    buf_action_queue:RunNext()
end
