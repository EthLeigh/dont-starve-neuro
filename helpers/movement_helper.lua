---@class MovementHelper
MovementHelper = {}

---@param pos Vector3
function MovementHelper.MoveToPosition(pos)
    PlayerLocomotor:GoToPoint(pos, nil, true)
end

---@param x number
---@param z number
function MovementHelper.MoveToPoint(x, z)
    local pos = GLOBAL.Vector3(x, 0, z)

    PlayerLocomotor:GoToPoint(pos, nil, true)
end

---@param ent Entity
function MovementHelper.MoveToEntity(ent)
    local x, _, z = ent.Transform:GetWorldPosition()

    MovementHelper.MoveToPoint(x, z)
end

---@param ent Entity
function MovementHelper.FleeFromEntity(ent)
    local px, _, pz = Player.Transform:GetWorldPosition()
    local ex, _, ez = ent.Transform:GetWorldPosition()

    local dx = px - ex
    local dz = pz - ez

    local dist = GLOBAL.math.sqrt(dx * dx + dz * dz) + 0.00001
    local inv_x, inv_z = dx / dist, dz / dist

    MovementHelper.MoveToPoint(
        inv_x * GameConstants.FLEE_DISTANCE,
        inv_z * GameConstants.FLEE_DISTANCE
    )
end
