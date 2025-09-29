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
            message = "That is not a valid craft recipe"
        end
    elseif name == ApiActions.CHARACTER_SAY then
        DialogHelper.Speak(data["dialog"])
    else
        success = false
        message = "An unexpected error has occurred as that action was not found"
    end

    ApiBridge.HandleSendResult(success, message)
end
