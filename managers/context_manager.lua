ContextManager = {}

ContextManager._debounce_starve = true

local sent_season_update = false

function ContextManager.HandlePlayerEnterDarkness()
    ApiBridge.HandleSendContext("Your character is in the dark, run to the nearest light source or " ..
        "make one. Your character will lose sanity in the dark and get attacked by shadow monsters.")
end

function ContextManager.HandlePlayerExitDarkness()
    ApiBridge.HandleSendContext("Your character is no longer in the dark.", true)
end

--- Handles the event for when the player starts starving. Called by the starving trigger.
---@param food_eaten string | nil
function ContextManager.HandlePlayerStarve(food_eaten)
    if food_eaten then
        ContextManager._debounce_starve = true

        ApiBridge.HandleSendContext("Your character started starving but ate food to stay fed.", true)
    else
        ContextManager._debounce_starve = false

        ApiBridge.HandleSendContext("Your character is starving and will take damage until you " ..
            "eat but there is no food in your character's inventory.")
    end
end

--- Handles the event for when the player starts starving
local function HandlePlayerStopStarve()
    if ContextManager._debounce_starve then
        ContextManager._debounce_starve = false

        return
    end

    ApiBridge.HandleSendContext("Your character is no longer starving.", true)
end

--- Handles the event for when the player begins to go insane
local function HandlePlayerGoInsane()
    ApiBridge.HandleSendContext("Your character is going insane from sanity loss.")
end

--- Handles the event for when the player becomes sane
local function HandlePlayerGoSane()
    ApiBridge.HandleSendContext("Your character is no longer insane.", true)
end

--- Handles the event for when the season changes (to winter/summer)
local function HandleSeasonChange()
    -- Since event is triggered automatically when entering a world, we ignore the first event
    if not sent_season_update then
        sent_season_update = true

        return
    end

    ApiBridge.HandleSendContext("The season is now " .. SeasonManager:GetSeasonString() .. ".")
end

--- Handles the event for when the rain starts
local function HandleRainStart()
    ApiBridge.HandleSendContext("It has started to rain.", true)
end

--- Handles the event for when the rain stops
local function HandleRainStop()
    ApiBridge.HandleSendContext("It has stopped raining.", true)
end

--- Handles the event for when the rain starts
local function HandleFreezingStart()
    ApiBridge.HandleSendContext("Your character is freezing.")
end

--- Handles the event for when the rain stops
local function HandleFreezingStop()
    ApiBridge.HandleSendContext("Your character has stopped freezing.", true)
end

---@param data table<string, any>
function ContextManager.OnEntityKilled(_, data)
    local victim = data.victim

    if not victim then
        return
    end

    ApiBridge.HandleSendContext("You have slain a " .. StringHelper.GetPrettyName(victim.prefab) .. ".", true)
end

--- Setup listeners for necessary events
function ContextManager.SetupContextEvents()
    PlayerHunger.inst:ListenForEvent("stopstarving", HandlePlayerStopStarve)

    PlayerSanity.inst:ListenForEvent("goinsane", HandlePlayerGoInsane)
    PlayerSanity.inst:ListenForEvent("gosane", HandlePlayerGoSane)

    SeasonManager.inst:ListenForEvent("seasonChange", HandleSeasonChange)
    SeasonManager.inst:ListenForEvent("rainstart", HandleRainStart)
    SeasonManager.inst:ListenForEvent("rainstop", HandleRainStop)

    PlayerTemperature.inst:ListenForEvent("startfreezing", HandleFreezingStart)
    PlayerTemperature.inst:ListenForEvent("stopfreezing", HandleFreezingStop)
end

function ContextManager.HandleFetchNearbyMessage()
    local entity_counts = EntityHelper.GetAllNearbyEntityCounts()

    local message_parts = {}
    for entity_prefab_name, entity_count in pairs(entity_counts) do
        local entity_name = StringHelper.GetPrettyName(entity_prefab_name)

        entity_name = StringHelper.ProperName(entity_count, entity_name)

        message_parts[#message_parts + 1] = string.format("%d %s (%s)", entity_count, entity_name, entity_prefab_name)
    end

    if #message_parts > 0 then
        table.sort(message_parts)

        return "These interactibles are nearby: " .. table.concat(message_parts, ", ") .. "."
    end

    return "There are no interactibles nearby."
end
