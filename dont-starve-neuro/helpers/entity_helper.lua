---@class EntityHelper
EntityHelper = {}

EntityHelper.GENERIC_AVOID_TAGS = { "FX", "NOCLICK", "DECOR", "INLIMBO" }

---@return Entity[]
function EntityHelper.GetNearbyAnimals()
    local x, _, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        nil,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure", "monster" },
        { "animal", "prey" }
    )
end

---@return Entity[]
function EntityHelper.GetNearbyMonsters()
    local x, _, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        { "monster" },
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure" }
    )
end

---@return Entity[]
function EntityHelper.GetNearbyHostileEntities()
    local x, _, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        { "HASCOMBATCOMPONENT", "hostile" },
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure" }
    )
end

---@param tags string[]?
---@return table<integer, Entity>
function EntityHelper.GetNearbyHarvestables(tags)
    local x, _, z = Player.Transform:GetWorldPosition()
    local nearby_harvestables = GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        tags,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "structure", "monster", "prey", "animal", "NOFORAGE" }
    )

    local filtered_harvestables = {}
    for _, harvestable in pairs(nearby_harvestables) do
        if Utils.GetActionForEntity(harvestable) ~= nil then
            table.insert(filtered_harvestables, harvestable)
        end
    end

    return filtered_harvestables
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

---@return Entity[]
function EntityHelper.GetNearbyLightSources()
    local x, _, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        { "lightsource" }
    )
end

---@param tags string[]?
---@return table<string, Entity>
function EntityHelper.GetNearbyEntities(tags)
    local x, _, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, 0, z,
        GameConstants.SEARCH_RADIUS,
        nil,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "shadowcreature", "shadowhand" },
        tags
    )
end
