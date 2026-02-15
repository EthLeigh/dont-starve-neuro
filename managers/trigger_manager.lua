---@class TriggerManager
TriggerManager = {}

TriggerManager.CurrentAttackerName = nil
TriggerManager._sent_for_darkness = false
TriggerManager.drop_item_action_registered = false
TriggerManager.food_actions_registered = false
TriggerManager.craft_action_registered = false

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

local function HandleInventoryItemChange(inventory_check)
    local food_exists = EaterHelper.GetBestFoodInInventory() ~= nil

    if food_exists ~= TriggerManager.food_actions_registered then
        if food_exists then
            ApiBridge.HandleSendRegister({ ApiActions.EAT_FOOD, ApiActions.COOK_FOOD })
        else
            ApiBridge.HandleSendUnregister({ ApiActions.EAT_FOOD, ApiActions.COOK_FOOD })
        end

        TriggerManager.food_actions_registered = food_exists
    end

    if inventory_check then
        Player:DoTaskInTime(0.1, function()
            local has_item = InventoryHelper.HasItems()

            if has_item ~= TriggerManager.drop_item_action_registered then
                if has_item then
                    ApiBridge.HandleSendRegister({ ApiActions.DROP_ITEM })
                else
                    ApiBridge.HandleSendUnregister({ ApiActions.DROP_ITEM })
                end

                TriggerManager.drop_item_action_registered = has_item
            end

            local available_craftables = CraftingHelper.GetAvailableBuildables()
            local can_craft = Utils.GetTableLength(available_craftables) > 0

            if can_craft ~= TriggerManager.craft_action_registered then
                if can_craft then
                    ApiBridge.HandleSendRegister({ ApiActions.CRAFT })
                else
                    ApiBridge.HandleSendUnregister({ ApiActions.CRAFT })
                end

                TriggerManager.craft_action_registered = can_craft
            end
        end)
    end
end

--- Checks if the player is in/leaving darkness and sends context
local function HandleCheckPlayerEnterDarkness()
    if PlayerLightWatcher:GetLightValue() >= 0.4 and TriggerManager._sent_for_darkness then
        TriggerManager._sent_for_darkness = false
        ContextManager.HandlePlayerExitDarkness()
    elseif PlayerLightWatcher:GetLightValue() < 0.1 then
        if not TriggerManager._sent_for_darkness then
            TriggerManager._sent_for_darkness = true
            ContextManager.HandlePlayerEnterDarkness()
        end

        if PlayerSanity:GetRate() >= 0 then
            return
        end

        local light_sources = EntityHelper.GetNearbyLightSources()

        if Utils.GetTableLength(light_sources) == 0 then
            return
        end

        local nearby_light_source = nil
        for _, light_source in pairs(light_sources) do
            if light_source.components.firefx then
                nearby_light_source = light_source

                break
            end
        end

        if not nearby_light_source then
            log_warning("Failed to find nearby ACTIVE light sources")

            return
        end

        ---@type FireFX
        local nearby_fire = nearby_light_source.components.firefx

        if nearby_fire.level >= 3 and nearby_fire.percent > 0.5 then
            log_info("Light source has enough fuel, ignoring refuel. Level: " ..
                nearby_fire.level .. ", Percent: " .. nearby_fire.percent)

            return
        end

        local fuel = InventoryHelper.GetFuel()

        if not fuel then
            log_warning("No fuel found in inventory to give to light source")

            return
        end

        local fuel_item = PlayerInventory:RemoveItem(fuel.item)

        if (nearby_light_source.components.fueled and nearby_light_source.components.fueled:TakeFuelItem(fuel_item))
            or (nearby_light_source.parent and nearby_light_source.parent.components.fueled
                and nearby_light_source.parent.components.fueled:TakeFuelItem(fuel_item)) then
            ApiBridge.HandleSendContext("Used " ..
                fuel.name .. " to fuel the " .. nearby_light_source.prefab .. ".", true)
        else
            log_error("Failed to refuel the " .. nearby_light_source.prefab)

            PlayerInventory:GiveItem(fuel_item)
        end
    end
end

--- Setup listeners for necessary events
function TriggerManager.SetupTriggerEvents()
    Player:DoPeriodicTask(3, HandleCheckPlayerEnterDarkness)

    PlayerHealth.inst:ListenForEvent("healthdelta", function(_, data)
        if data.oldpercent < data.newpercent then
            return
        end

        HandlePlayerHurt(data.cause)
    end)

    PlayerHunger.inst:ListenForEvent("startstarving", HandlePlayerStarve)

    Clock.inst:ListenForEvent("daytime", HandleDayStart)
    Clock.inst:ListenForEvent("nighttime", HandleNightStart)

    PlayerInventory.inst:ListenForEvent("itemlose", function() HandleInventoryItemChange(true) end)
    PlayerInventory.inst:ListenForEvent("itemget", function() HandleInventoryItemChange(false) end)
    PlayerInventory.inst:ListenForEvent("gotnewitem", function() HandleInventoryItemChange(true) end)
end
