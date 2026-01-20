---@class EnvironmentHelper
EnvironmentHelper = {}

modimport("utils.lua")

---@return string
function EnvironmentHelper.GetGroundName()
    local x, y, z = Player.Transform:GetWorldPosition()
    local tile = GLOBAL:GetMap():GetTileAtPoint(x, y, z)

    return Utils.GetEnumKey(GLOBAL.GROUND, tile)
end

---@return string
function EnvironmentHelper.GetSeason()
    local world = GLOBAL:GetWorld()
    local seasonManager = world.components.seasonmanager

    return seasonManager:GetSeasonString()
end

---@return boolean
function EnvironmentHelper.IsRaining()
    local world = GLOBAL:GetWorld()
    local seasonManager = world.components.seasonmanager

    return seasonManager.precip or false
end

---@return number
function EnvironmentHelper.GetTemperature()
    local temperature = Player.components.temperature

    return temperature:GetCurrent()
end

---@return boolean
function EnvironmentHelper.IsFreezing()
    local temperature = Player.components.temperature

    return temperature:IsFreezing()
end
