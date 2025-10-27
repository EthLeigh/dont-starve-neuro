---@class EntityHelper
EntityHelper = {}

EntityHelper.GENERIC_AVOID_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

---@return Entity[]
function EntityHelper.GetNearbyAnimals()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        nil,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure", "monster" },
        { "animal", "prey" }
    )
end

---@return Entity[]
function EntityHelper.GetNearbyMonsters()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        { "monster" },
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure" }
    )
end

---@return Entity[]
function EntityHelper.GetNearbyHostileEntities()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        { "HASCOMBATCOMPONENT" },
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure" }
    )
end

-- TODO: Currently includes non-harvestable entities like trees, etc.
---@return Entity[]
function EntityHelper.GetNearbyHarvestables()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        nil,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure", "monster", "prey", "animal", "NOFORAGE" }
    )
end

---@return table<string, Entity[]>
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

---@return table<string, Entity[]>
function EntityHelper.GetNearbyLightSources()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        { "lightsource" }
    )
end
