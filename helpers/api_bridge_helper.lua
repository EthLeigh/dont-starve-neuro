---@class ApiBridgeHelper
ApiBridgeHelper = {}

---@param name string
---@param data table<string, any>
function ApiBridgeHelper.HandleActionExecution(name, data)
    local success = true
    local message

    TaskManager.StopTasks()

    if name == ApiActions.EAT_FOOD then
        local eaten_food_name = EaterHelper.EatBestFoodInInventory()

        if not eaten_food_name then
            success = false
            message = "There is no food to eat in the inventory."
        else
            message = "Ate " .. eaten_food_name .. "."
        end
    elseif name == ApiActions.MOVE_TO_MARKER then
        MarkerHelper.GetMarkers(
            function(markers)
                if #markers == 0 then
                    message = "There are no saved markers."

                    return
                end

                local marker = markers[data["marker_name"]]

                if not marker then
                    success = false
                    message = "Failed to find the saved marker."

                    return
                end

                message = "Loaded the marker's location and started heading toward it."

                MovementHelper.MoveToPoint(marker.x, marker.z)
            end,
            function()
                success = false
                message = "Failed to find the specified marker."
            end
        )
    elseif name == ApiActions.SAVE_MARKER then
        MarkerHelper.SetMarker(data["marker_name"])

        message = "Successfully saved current location as '" .. data["marker_name"] .. "'."
    elseif name == ApiActions.SAVE_MARKER then
        MarkerHelper.GetMarkers(
            function(markers)
                message = "Here are your saved markers: " .. table.concat(markers, ", ") .. "."
            end,
            function()
                success = false
                message = "Failed to find saved markers."
            end
        )
    elseif name == ApiActions.HARVEST_NEARBY then
        local entity_prefab_filters = HarvestHelper.MapActionFiltersToPrefabs(data and data.filters or {})
        local harvest_task = Task:new(TaskManager.TASK_TYPES.HARVEST, function()
            return true
        end, { prefab_filters = entity_prefab_filters })

        message = "Started harvesting nearby things until another action is called."

        TaskManager.StartTasks({ harvest_task })
    elseif name == ApiActions.GET_ENVIRONMENT_INFO then
        message = "The floor is " .. EnvironmentHelper.GetGroundName()
        message = message .. ", it is " .. (EnvironmentHelper.IsRaining() and "raining" or "not raining")
        message = message .. ", the season is " .. EnvironmentHelper.GetSeason()
        message = message .. " and it is " .. (EnvironmentHelper.IsFreezing() and "freezing." or "not freezing.")
    elseif name == ApiActions.GET_AVAILABLE_CRAFTS then
        local available_craftables = CraftingHelper.GetAvailableBuildables()

        local available_craftable_names = {}
        for craftable_name, _ in pairs(available_craftables) do
            table.insert(available_craftable_names, craftable_name)
        end

        if Utils.GetTableLength(available_craftable_names) == 0 then
            message = "There are no available craftables."
        else
            message = "Your available craftable items/buildings are: " ..
                table.concat(available_craftable_names, ", ") .. "."
        end

        local nearby_science_prototyper = EntityHelper.GetNearbySciencePrototyper()
        local available_prototypes = CraftingHelper.GetAvailablePrototypes()

        if not nearby_science_prototyper then
            message = message .. " No science prototyper was found nearby."
        elseif Utils.GetTableLength(available_prototypes) == 0 then
            message = message .. " No prototype recipes are available."
        else
            local available_prototype_names = {}
            for prototype_name, _ in pairs(available_prototypes) do
                table.insert(available_prototype_names, prototype_name)
            end

            message = message ..
                " Available prototype recipes: " .. table.concat(available_prototype_names, ", ") .. "."
        end
    elseif name == ApiActions.GET_PLAYER_INFO then
        message = "The current character is " .. PlayerHelper.GetName()
        message = message .. ", health is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetHealth() * 100)) .. "%"
        message = message .. ", hunger is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetHunger() * 100)) .. "%"
        message = message .. ", sanity is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetSanity() * 100)) .. "%"
        message = message .. ", they are " .. (PlayerHelper.IsHungry() and "hungry" or "not hungry")
        message = message .. ", and are " .. (PlayerHelper.IsSane() and "sane." or "insane.")
    elseif name == ApiActions.PROTOTYPE then
        local recipe_name = data["recipe_name"]
        local available_prototypes = CraftingHelper.GetAvailablePrototypes()
        local recipe_exists = false

        for prototype_name, _ in pairs(available_prototypes) do
            if prototype_name == recipe_name then
                recipe_exists = true

                break
            end
        end

        if recipe_exists then
            success = CraftingHelper.BuildFromRecipeName(recipe_name)

            if not success then
                message = "Failed to prototype." -- Just in case
            else
                message = "Successfully prototyped and created the " .. recipe_name .. "."
            end
        else
            success = false
            message = "That is not a valid prototype recipe."
        end
        message = "The current character is " .. PlayerHelper.GetName()
        message = message .. ", health is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetHealth() * 100)) .. "%"
        message = message .. ", hunger is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetHunger() * 100)) .. "%"
        message = message .. ", sanity is " .. tostring(GLOBAL.math.ceil(PlayerHelper.GetSanity() * 100)) .. "%"
        message = message .. ", they are " .. (PlayerHelper.IsHungry() and "hungry" or "not hungry")
        message = message .. ", and are " .. (PlayerHelper.IsSane() and "sane." or "insane.")
    elseif name == ApiActions.CRAFT then
        local recipe_name = data["recipe_name"]
        local available_craftables = CraftingHelper.GetAvailableBuildables()
        local recipe_exists = false

        for craftable_name, _ in pairs(available_craftables) do
            if craftable_name == recipe_name then
                recipe_exists = true

                break
            end
        end

        if recipe_exists then
            success = CraftingHelper.BuildFromRecipeName(recipe_name)

            if not success then
                message = "Failed to craft." -- Just in case
            else
                message = "Successfully crafted the " .. recipe_name .. "."
            end
        else
            success = false
            message = "That is not a valid craft recipe."
        end
    elseif name == ApiActions.GET_PERKS_AND_QUIRKS then
        local character_desc = StringHelper.GetCharacterDescription(PlayerName)
        character_desc = character_desc:gsub("*", ""):gsub("%s*\n%s*(%a)", function(c)
            return ", " .. c:gsub(" ", ""):lower()
        end) .. "."

        message = "You are playing as " ..
            StringHelper.GetPrettyCharacterName(PlayerName) .. ". Their traits are: " .. character_desc
        success = true
    elseif name == ApiActions.GO_TO_LIGHT_SOURCE then
        local light_sources = EntityHelper.GetNearbyLightSources()

        if #light_sources == 0 then
            success = false
            message = "Failed to find a nearby light source"
        else
            local light_source = light_sources[1]
            local x, _, z = light_source.Transform:GetWorldPosition()
            local light_radius = light_source.components.firefx.current_radius

            -- Offset to avoid collision and endless running
            MovementHelper.MoveToPoint(x, z + (light_radius / 2))

            success = true
            message = "Successfully moved toward nearest light source"
        end
    elseif name == ApiActions.RETRIEVE_CURRENT_GOAL then
        message = GoalManager.GetAsMessage()
    elseif name == ApiActions.ATTACK_NEARBY then
        local attack_nearby_task = Task:new(TaskManager.TASK_TYPES.ATTACK_NEARBY, function()
            return false
        end)

        message = "Started attacking nearby entities until another action is called."

        TaskManager.StartTasks({ attack_nearby_task })
    elseif name == ApiActions.COOK_FOOD then
        local nearby_cookers = EntityHelper.GetNearbyEntities({ "campfire", "firepit" })

        if #nearby_cookers == 0 then
            success = false
            message = "No cookable entities were found nearby (Campfires, or Fire Pits)."
        else
            local _, nearby_cooker = GLOBAL.next(nearby_cookers, nil)
            local hotbar_item_to_cook = EaterHelper.GetBestFoodInInventory()

            if hotbar_item_to_cook == nil then
                success = false
                message = "No food was found in your character's inventory."
            else
                local food_to_cook = hotbar_item_to_cook.item
                local act = GLOBAL.BufferedAction(Player, nearby_cooker, GLOBAL.ACTIONS.COOK, food_to_cook)

                Player.components.locomotor:PushAction(act, true)

                PlayerInventory.inst:PushEvent("cookedfood")

                message = "Cooked the " .. StringHelper.GetPrettyName(food_to_cook.prefab) .. "."
            end
        end
    elseif name == ApiActions.EXPLORE then
        local explore_task = Task:new(TaskManager.TASK_TYPES.EXPLORE, function()
            return false
        end)

        message = "Exploring until another action is called."

        TaskManager.StartTasks({ explore_task }, 5)
    elseif name == ApiActions.INTERACT then
        ---@type string
        local entity_name_to_interact = data.name
        local nearby_entities = EntityHelper.GetNearbyEntities()

        local entity_to_interact = nil
        for _, entity in pairs(nearby_entities) do
            if entity.prefab == entity_name_to_interact then
                entity_to_interact = entity

                break
            end
        end

        -- Will return nil if the ent is nil
        local action_name, buffered_action = Utils.GetBufferedActionForEntity(entity_to_interact)

        if entity_to_interact and buffered_action then
            local action_item = nil
            local hotbar_items = InventoryHelper.GetHotbarItems()
            for _, hotbar_item in pairs(hotbar_items) do
                if (action_name == "mine" and hotbar_item.prefab == "pickaxe") or
                    (action_name == "chop" and hotbar_item.prefab == "axe") then
                    action_item = hotbar_item.item
                end
            end

            if action_item then
                PlayerInventory:Equip(action_item)
            end

            local entities_to_harvest = 0
            if entity_to_interact.components.lootdropper then
                local OriginalSpawnLootPrefab = entity_to_interact.components.lootdropper.SpawnLootPrefab
                entity_to_interact.components.lootdropper.SpawnLootPrefab = function(self, lootprefab, pt)
                    OriginalSpawnLootPrefab(self, lootprefab, pt)

                    entities_to_harvest = entities_to_harvest + 1
                end
            end

            local function handle_workable()
                PlayerLocomotor:PushAction(buffered_action, true)

                if not entity_to_interact or not entity_to_interact.components.workable then
                    return
                end

                if entity_to_interact.components.workable.workleft > 1 then
                    Player:DoTaskInTime(1, function() handle_workable() end)
                else
                    local cleanup_harvest_task = Task:new(TaskManager.TASK_TYPES.HARVEST, function(current_iteration)
                        log_info(current_iteration, entities_to_harvest, current_iteration <= entities_to_harvest)
                        return current_iteration > entities_to_harvest
                    end, nil)

                    TaskManager.StartTasks({ cleanup_harvest_task })
                end
            end

            handle_workable()

            message = "Performing the " .. action_name .. " action on the " .. entity_name_to_interact .. "."
        elseif not entity_to_interact then
            success = false
            message = "That entity/interactible was not found."
        elseif not buffered_action then
            success = false
            message = "That entity/interactible is not supported and cannot be interacted with."
        else
            success = false
            message = "An unexpected error occurred."
        end
    else
        success = false
        message = "An unexpected error has occurred as that action was not found."
    end

    -- Handle game over forced action
    if name == ApiActions.RETRY then
        GLOBAL.TheFrontEnd:Fade(false, 2, function()
            GLOBAL.StartNextInstance({
                reset_action = GLOBAL.RESET_ACTION.LOAD_SLOT,
                save_slot = GLOBAL.SaveGameIndex
                    :GetCurrentSaveSlot()
            })
        end)

        message = "Creating new world..."
        success = true
    elseif name == ApiActions.EXIT_TO_MAIN_MENU then
        GLOBAL.TheFrontEnd:Fade(false, 2, function()
            GLOBAL.StartNextInstance()
        end)

        message = "Exiting to main menu..."
        success = true
    end

    ApiBridge.HandleSendResult(success, message)

    -- 2 second delay to allow for the result to be sent and handled first
    Player:DoTaskInTime(2, function()
        local nearby_context = ContextManager.HandleFetchNearbyMessage()

        ApiBridge.HandleSendContext(nearby_context, true)

        local inventory_item_names = InventoryHelper.GetHotbarItemNames()

        local inventory_context = nil
        if Utils.GetTableLength(inventory_item_names) > 0 then
            inventory_context = "Your inventory items are: " .. table.concat(inventory_item_names, ", ") .. "."
        else
            inventory_context = "Your character has no items in their inventory."
        end

        ApiBridge.HandleSendContext(inventory_context, true)
    end)
end
