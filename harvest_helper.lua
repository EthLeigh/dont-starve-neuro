HarvestHelper = HarvestHelper or {}

modimport("utils.lua")

HarvestHelper.HarvestEntity = function(player, ent)
    local action = Utils.GetActionForEntity(ent)

    if action == nil then
        print("[DSN] No action enum was found for entity:", ent.prefab)

        return
    end

    local buffer_action = GLOBAL.BufferedAction(player, ent, action)

    player.components.locomotor:PushAction(buffer_action, true)
end

HarvestHelper.HarvestEntities = function(player, ents)
    local buf_action_queue = BufferedActionQueue(player)

    for _, ent in pairs(ents) do
        local buffered_action = Utils.GetBufferedActionForEntity(player, ent)

        if (buffered_action ~= nil) then
           buf_action_queue:enqueue(buffered_action)
        else
            print("[DSN] Unable to create a buffered action for entity:", ent.prefab)
        end
    end

    buf_action_queue:run_next()
end
