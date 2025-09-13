---@class MovementHelper
MovementHelper = {}

---@param pos Vector3
function MovementHelper.MoveToPosition(pos)
    PlayerLocomotor:GoToPoint(pos, nil, true)
end

---@param x number
---@param y number
---@param z number
function MovementHelper.MoveToPoint(x, y, z)
    local pos = GLOBAL.Vector3(x, y, z)

    PlayerLocomotor:GoToPoint(pos, nil, true)
end

---@param ent Entity
function MovementHelper.MoveToEntity(ent)
    local x, y, z = ent.Transform:GetWorldPosition()

    MovementHelper.MoveToPoint(x, y, z)
end

---@param ent Entity
function MovementHelper.FleeFromEntity(ent)
    local px, py, pz = Player.Transform:GetWorldPosition()
    local ex, ey, ez = ent.Transform:GetWorldPosition()

    local dx = px - ex
    local dy = py - ey
    local dz = pz - ez

    local dist = GLOBAL.math.sqrt(dx * dx + dy * dy + dz * dz) + 0.00001
    local inv_x, inv_y, inv_z = dx / dist, dy / dist, dz / dist

    log_info("MOVING")

    MovementHelper.MoveToPoint(inv_x * Constants.FLEE_DISTANCE, inv_y * Constants.FLEE_DISTANCE, inv_z * Constants.FLEE_DISTANCE)
end
