---@class PlayerHelper
PlayerHelper = {}

--- Returns in percentage
---@return number
function PlayerHelper.GetHealth()
    return PlayerHealth:GetPercent()
end

---@return boolean
function PlayerHelper.IsHurt()
    return PlayerHealth:IsHurt()
end

--- Returns in percentage
---@return number
function PlayerHelper.GetHunger()
    return PlayerHunger:GetPercent()
end

---@return boolean
function PlayerHelper.IsHurtingFromStarvation()
    return PlayerHunger:IsStarving()
end

---@return boolean
function PlayerHelper.IsHungry()
    return PlayerHunger:GetPercent() < 0.5
end

--- Returns in percentage
---@return number
function PlayerHelper.GetSanity()
    return PlayerSanity:GetPercent()
end

---@return boolean
function PlayerHelper.IsSane()
    return PlayerSanity:IsSane()
end

---@return boolean
function PlayerHelper.LosingSanity()
    return PlayerSanity:GetRate() < 0
end
