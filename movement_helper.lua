MovementHelper = MovementHelper or {}

MovementHelper.MoveToPosition = function(player, pos)
    player.components.locomotor:GoToPoint(pos, nil, true)
end

MovementHelper.MoveToPoint = function(player, x, y, z)
    local pos = GLOBAL.Vector3(x, y, z)

    player.components.locomotor:GoToPoint(pos, nil, true)
end

MovementHelper.MoveToEntity = function(player, ent)
    local pos = ent.Transform:GetWorldPosition()

    player.components.locomotor:GoToPoint(pos, nil, true)
end
