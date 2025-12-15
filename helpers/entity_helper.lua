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

---@return table<string, Entity>
function EntityHelper.GetNearbyLightSources()
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        { "lightsource" }
    )
end

---@param tags string[]?
---@return table<string, Entity>
function EntityHelper.GetNearbyEntities(tags)
    local x, y, z = Player.Transform:GetWorldPosition()

    return GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SEARCH_RADIUS,
        nil,
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "shadowcreature", "shadowhand" },
        tags
    )
end

---@return table<string, integer>
function EntityHelper.GetAllNearbyEntityCounts()
    local entities = EntityHelper.GetNearbyEntities()
    local inventory_items = InventoryHelper.GetHotbarItems()
    local entity_counts = {}

    local inventory_item_names = {}
    for _, inventory_item in pairs(inventory_items) do
        table.insert(inventory_item_names, inventory_item.item.prefab)
    end

    for _, entity in pairs(entities) do
        local prefab = entity.prefab

        if table.contains(inventory_item_names, prefab) then
            Utils.RemoveElementByValue(inventory_item_names, prefab)
        elseif prefab ~= nil then
            entity_counts[prefab] = (entity_counts[prefab] or 0) + 1
        end
    end

    return entity_counts
end

---@return Entity|nil
function EntityHelper.GetNearbySciencePrototyper()
    local x, y, z = Player.Transform:GetWorldPosition()

    local nearby_structures = GLOBAL.TheSim:FindEntities(
        x, y, z,
        GameConstants.SCIENCE_PROTOTYPER_SEARCH_RADIUS,
        { "structure" },
        { GLOBAL.unpack(EntityHelper.GENERIC_AVOID_TAGS), "player", "shadowcreature", "shadowhand", "shadowskittish" }
    )
    local science_prototyper = nil

    for _, structure in pairs(nearby_structures) do
        log_info(structure.prefab)
        if structure.prefab == "researchlab" then
            science_prototyper = structure
        end
    end

    return science_prototyper
end
