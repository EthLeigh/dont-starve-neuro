---@class EntityHelper
EntityHelper = {}

---@return Entity[]
function EntityHelper.GetNearbyAnimals()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        Constants.SEARCH_RADIUS,
        nil,
        {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "structure", "monster"},
        {"animal", "prey"}
    )
end

---@return Entity[]
function EntityHelper.GetNearbyMonsters()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        Constants.SEARCH_RADIUS,
        {"monster"},
        {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "structure"}
    )
end

---@return Entity[]
function EntityHelper.GetNearbyHarvestables()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        Constants.SEARCH_RADIUS,
        nil,
        {"FX", "NOCLICK", "DECOR", "INLIMBO", "player", "structure", "monster", "prey", "animal"}
    )
end

---@return table<string, Entity>
function EntityHelper.GetNearbyUniqueHarvestables()
    local nearby_ents = EntityHelper.GetNearbyHarvestables()
    local nearby_unique_ents = {}

    for _, ent in ipairs(nearby_ents) do
        if (nearby_unique_ents[ent.prefab] == nil) then
            nearby_unique_ents[ent.prefab] = ent
        end
    end

    return nearby_unique_ents
end
