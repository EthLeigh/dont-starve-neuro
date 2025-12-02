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
        MarkerHelper.GetMarker(
            data["marker_name"],
            function(x, z)
                message = "Loaded the marker's location and started heading towards it."

                MovementHelper.MoveToPoint(x, z)
            end,
            function()
                success = false
                message = "Failed to find the specified marker."
            end
        )
    elseif name == ApiActions.SAVE_MARKER then
        MarkerHelper.SetMarker(data["marker_name"])

        message = "Successfully saved current location as '" .. data["marker_name"] .. "'."
    elseif name == ApiActions.HARVEST_NEARBY then
        local harvest_task = Task:new(TaskManager.TASK_TYPES.HARVEST, function()
            return true
        end)

        message = "Started harvesting nearby things until another action is called."

        TaskManager.StartTasks({ harvest_task })
    elseif name == ApiActions.GET_ENVIRONMENT_INFO then
        message = "The floor is " .. EnvironmentHelper.GetGroundName()
        message = message .. ", it is " .. (EnvironmentHelper.IsRaining() and "raining" or "not raining")
        message = message .. ", the season is " .. EnvironmentHelper.GetSeason()
        message = message .. " and it is " .. (EnvironmentHelper.IsFreezing() and "freezing." or "not freezing.")
    elseif name == ApiActions.GET_INVENTORY then
        local inventory_item_names = InventoryHelper.GetHotbarItemNames()

        message = "Your inventory items are: " .. table.concat(inventory_item_names, ", ") .. "."
    elseif name == ApiActions.GET_AVAILABLE_CRAFTS then
        local available_craftables = CraftingHelper.GetAvailableBuildables()
        local available_craftable_names = {}

        for craftable_name, _ in pairs(available_craftables) do
            table.insert(available_craftable_names, craftable_name)
        end

        if #available_craftable_names == 0 then
            message = "There are no available craftables."
        else
            message = "Your available craftable items/buildings are: " ..
                table.concat(available_craftable_names, ", ") .. "."
        end
    elseif name == ApiActions.GET_PLAYER_INFO then
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
    elseif name == ApiActions.CHARACTER_SAY then
        DialogHelper.Speak(data["dialog"])
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

                message = "Cooked the " .. StringHelper.GetPrettyName(food_to_cook.prefab) .. "."
            end
        end
    elseif name == ApiActions.EXPLORE then
        local explore_task = Task:new(TaskManager.TASK_TYPES.EXPLORE, function()
            return false
        end)

        message = "Exploring until another action is called."

        TaskManager.StartTasks({ explore_task }, 5)
    elseif name == ApiActions.RETRIEVE_NEARBY then
        local entity_counts = EntityHelper.GetAllNearbyEntityCounts()

        local message_parts = {}
        for entity_prefab_name, entity_count in pairs(entity_counts) do
            local entity_name = StringHelper.GetPrettyName(entity_prefab_name)

            entity_name = StringHelper.ProperName(entity_count, entity_name)

            message_parts[#message_parts + 1] = string.format("%d %s (%s)", entity_count, entity_name, entity_prefab_name)
        end

        if #message_parts > 0 then
            table.sort(message_parts)
            message = "These interactibles are nearby: " .. table.concat(message_parts, ", ") .. "."
        else
            message = "There are no interactibles nearby."
        end
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
            PlayerLocomotor:PushAction(buffered_action, true)

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

    ApiBridge.HandleSendResult(success, message)
end
