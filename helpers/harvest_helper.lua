---@class HarvestHelper
HarvestHelper = {}

modimport("utils.lua")

---@param filters string[]
---@return table<string, string>
function HarvestHelper.MapActionFiltersToPrefabs(filters)
    local filter_prefabs = {}
    for _, action_filter in ipairs(filters) do
        -- TODO: Make sure the filter prefabs are correct

        if table.contains(filter_prefabs, action_filter) then
            -- Ignore duplicates
        elseif action_filter == "tree" then
            table.insert(filter_prefabs, action_filter, "evergreen")
        elseif action_filter == "bush" then
            table.insert(filter_prefabs, action_filter, "bush")
        elseif action_filter == "rock" then
            table.insert(filter_prefabs, action_filter, "stone")
        elseif action_filter == "shrub" then
            table.insert(filter_prefabs, action_filter, "shrub")
        elseif action_filter == "grass" then
            table.insert(filter_prefabs, action_filter, "dry_grass")
        elseif action_filter == "flower" then
            table.insert(filter_prefabs, action_filter, "flower")
        else
            log_warning("Unknown harvestable type filter:", action_filter)
        end
    end

    return filter_prefabs
end

---@param ent Entity
function HarvestHelper.HarvestEntity(ent)
    local action = Utils.GetActionForEntity(ent)

    if action == nil then
        log_info("No action enum was found for entity:", ent.prefab)

        return
    end

    local buffer_action = GLOBAL.BufferedAction(Player, ent, action)

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
