ContextManager = {}

ContextManager._sentForDarkness = false

--- Checks if the player is in/leaving darkness and sends context
local function HandleCheckPlayerEnterDarkness()
    if PlayerLightWatcher:IsInLight() and ContextManager._sentForDarkness then
        ContextManager._sentForDarkness = false
        ApiBridge.HandleSendContext("Your character is no longer in the dark.", true)
    elseif not PlayerLightWatcher:IsInLight() and not ContextManager._sentForDarkness then
        ContextManager._sentForDarkness = true
        ApiBridge.HandleSendContext("Your character is in the dark, run to the nearest light source or " ..
            "make one. Your character will lose sanity in the dark and get attacked by shadow monsters.")
    end
end

--- Handles the event for when the player starts starving. Called by the starving trigger.
---@param food_eaten string | nil
function ContextManager.HandlePlayerStarve(food_eaten)
    if food_eaten then
        -- TODO: Still triggers the 'no longer starving' message
        ApiBridge.HandleSendContext("Your character started starving but ate food to stay fed.", true)
    else
        ApiBridge.HandleSendContext("Your character is starving and will take damage until you " ..
            "eat but there is no food in your character's inventory.")
    end
end

--- Handles the event for when the player starts starving
local function HandlePlayerStopStarve()
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

--- Setup listeners for necessary events
function ContextManager.SetupContextEvents()
    Player:DoPeriodicTask(3, HandleCheckPlayerEnterDarkness)

    PlayerHunger.inst:ListenForEvent("stopstarving", HandlePlayerStopStarve)

    PlayerSanity.inst:ListenForEvent("goinsane", HandlePlayerGoInsane)
    PlayerSanity.inst:ListenForEvent("gosane", HandlePlayerGoSane)
end
