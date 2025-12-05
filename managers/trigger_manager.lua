---@class TriggerManager
TriggerManager = {}

TriggerManager.CurrentAttacker = nil

--- Handles the event for when the player's health changes. Will send a context message about the current enemy attacking.
---@param health_change_cause string
local function HandlePlayerHurt(health_change_cause)
    local threats = EntityHelper.GetNearbyHostileEntities()

    ---@type Entity|nil
    local current_threat = nil

    for _, threat in pairs(threats) do
        if threat.prefab == health_change_cause then
            current_threat = threat
            break
        end
    end

    if current_threat == nil then
        return
    end

    MovementHelper.FleeFromEntity(current_threat)

    if (current_threat == TriggerManager.CurrentAttacker) then
        return
    end

    TriggerManager.CurrentAttacker = current_threat

    ApiBridge.HandleSendContext("You are being attacked by a " ..
        StringHelper.GetPrettyName(current_threat.prefab) ..
        ". There are " .. #EntityHelper.GetNearbyMonsters() .. " monsters around you.")
end

--- Handles the event for when the player starts starving
local function HandlePlayerStarve()
    local food_eaten = EaterHelper.EatBestFoodInInventory()

    ContextManager.HandlePlayerStarve(food_eaten)
end

local function HandleDayStart()
    ApiBridge.HandleSendUnregister({ ApiActions.GO_TO_LIGHT_SOURCE })
end

local function HandleNightStart()
    ApiBridge.HandleSendRegister({ ApiActions.GO_TO_LIGHT_SOURCE })
end

local function HandleInventoryItemChange()
    if EaterHelper.GetBestFoodInInventory() then
        ApiBridge.HandleSendRegister({ ApiActions.EAT_FOOD, ApiActions.COOK_FOOD })
    else
        ApiBridge.HandleSendUnregister({ ApiActions.EAT_FOOD, ApiActions.COOK_FOOD })
    end
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

    Clock.inst:ListenForEvent("daytime", HandleDayStart)
    Clock.inst:ListenForEvent("nighttime", HandleNightStart)

    PlayerInventory.inst:ListenForEvent("itemlose", HandleInventoryItemChange)
    PlayerInventory.inst:ListenForEvent("itemget", HandleInventoryItemChange)
end
