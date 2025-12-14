---@class TriggerManager
TriggerManager = {}

TriggerManager.CurrentAttackerName = nil

--- Handles the event for when the player's health decreases. Will send a context message about the current enemy attacking.
---@param damage_cause string
local function HandlePlayerHurt(damage_cause)
    local threats = EntityHelper.GetNearbyHostileEntities()

    ---@type Entity|nil
    local current_threat = nil

    for _, threat in pairs(threats) do
        if threat.prefab == damage_cause then
            current_threat = threat
            break
        end
    end

    if current_threat == nil then
        return
    end

    Player:DoTaskInTime(0.5, function()
        MovementHelper.FleeFromEntity(current_threat)
    end)

    if (damage_cause == TriggerManager.CurrentAttackerName) then
        return
    end

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
