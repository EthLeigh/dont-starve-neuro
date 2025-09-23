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
                message = "Found the marker and your character is now heading towards it"

                MovementHelper.MoveToPoint(x, z)
            end,
            function()
                success = false
                message = "Failed to find the specified marker"
            end
        )
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

        ApiBridge.HandleSendResult(success, message)
    elseif name == ApiActions.GET_INVENTORY then
        local inventory_item_names = InventoryHelper.GetHotbarItemNames()

        message = "Your inventory items are: " .. table.concat(inventory_item_names, ", ") .. "."

        ApiBridge.HandleSendResult(success, message)
    elseif name == ApiActions.GET_AVAILABLE_CRAFTS then
        local available_craftables = CraftingHelper.GetAvailableBuildables()
        local available_craftable_names = {}

        for craftable_name, _ in pairs(available_craftables) do
            table.insert(available_craftable_names, craftable_name)
        end

        message = "Your available craftable items/buildings are: " ..
            table.concat(available_craftable_names, ", ") .. "."

        ApiBridge.HandleSendResult(success, message)
    else
        success = false
        message = "An unexpected error has occurred as that action was not found"
    end

    ApiBridge.HandleSendResult(success, message)
end
