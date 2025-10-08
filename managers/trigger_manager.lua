---@class TriggerManager
TriggerManager = {}

--- Handles the event for when the player's health changes
---@param health_change_cause string
local function HandlePlayerHurt(health_change_cause)
    local threats = EntityHelper.GetNearbyHostileEntities()
    local current_threat = nil

    for _, threat in pairs(threats) do
        if threat.prefab == health_change_cause then
            current_threat = threat
            break
        end
    end

    if current_threat == nil then
        log_warning("Unable to find the entity damaging the player!")

        return
    end

    MovementHelper.FleeFromEntity(current_threat)

    -- TODO: Add context message for getting attacked
end

--- Handles the event for when the player starts starving
local function HandlePlayerStarve()
    local food_eaten = EaterHelper.EatBestFoodInInventory()

    ContextManager.HandlePlayerStarve(food_eaten)
end

--- Setup listeners for necessary events
function TriggerManager.SetupTriggerEvents()
    PlayerHealth.inst:ListenForEvent("healthdelta", function(_, data)
        if data.oldpercent < data.newpercent then
            return
        end

        HandlePlayerHurt(data.cause)
    end)

    PlayerHunger.inst:ListenForEvent("startstarving", HandlePlayerStarve)
end
