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
