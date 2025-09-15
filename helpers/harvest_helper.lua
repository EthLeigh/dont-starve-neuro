---@class HarvestHelper
HarvestHelper = {}

modimport("utils.lua")

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
    local buf_action_queue = BufferedActionQueue()

    for _, ent in pairs(ents) do
        local buffered_action = Utils.GetBufferedActionForEntity(ent)

        if (buffered_action ~= nil) then
           buf_action_queue:enqueue(buffered_action)
        else
            -- log_info("Unable to create a buffered action for entity:", ent.prefab)
        end
    end

    buf_action_queue:run_next()
end
