---@class PlayerHelper
PlayerHelper = {}

function PlayerHelper.GetHealth()
    return PlayerHealth:GetPercent()
end

function PlayerHelper.IsHurt()
    return PlayerHealth:IsHurt()
end

function PlayerHelper.GetHunger()
    return PlayerHunger:GetPercent()
end

function PlayerHelper.IsHurtingFromStarvation()
    return PlayerHunger:IsStarving()
end

function PlayerHelper.IsHungry()
    return PlayerHunger:GetPercent() < 0.5
end

function PlayerHelper.GetSanity()
    return PlayerSanity:GetPercent()
end

function PlayerHelper.IsSane()
    return PlayerSanity:IsSane()
end

function PlayerHelper.LosingSanity()
    return PlayerSanity:GetRate() < 0
end
