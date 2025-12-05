---@type table<string, any>
GoalState = {}

-- TODO: Allow for goal state, like total number of things harvested before completing
---@type table<string, function>
GoalChecks = {
    [Goals.CRAFT_AXE] = function()
        CreateListenerOnEntityForEvent(Goals.CRAFT_AXE, PlayerBuilder, "builditem", function(event_data)
            return event_data.item.prefab == "axe"
        end)
    end,
    [Goals.MAKE_CAMPFIRE] = function()
        CreateListenerOnEntityForEvent(Goals.MAKE_CAMPFIRE, PlayerBuilder, "buildstructure", function(event_data)
            return event_data.item.prefab == "campfire"
        end)
    end,
    [Goals.CRAFT_PICKAXE] = function()
        CreateListenerOnEntityForEvent(Goals.CRAFT_PICKAXE, PlayerBuilder, "builditem", function(event_data)
            return event_data.item.prefab == "pickaxe"
        end)
    end,
    [Goals.BUILD_SCIENCE_MACHINE] = function()
        CreateListenerOnEntityForEvent(Goals.BUILD_SCIENCE_MACHINE, PlayerBuilder, "builditem", function(event_data)
            return event_data.item.prefab == "scienceprototyper"
        end)
    end,
    [Goals.CRAFT_BACKPACK] = function()
        CreateListenerOnEntityForEvent(Goals.CRAFT_BACKPACK, PlayerBuilder, "builditem", function(event_data)
            return event_data.item.prefab == "backpack"
        end)
    end,
    [Goals.COOK_FOOD] = function()
        -- Custom event pushing in api_bridge_helper
        CreateListenerOnEntityForEvent(Goals.COOK_FOOD, PlayerInventory, "cookedfood", function()
            return true
        end)
    end,
    [Goals.SURVIVE_NIGHT] = function()
        CreateListenerOnEntityForEvent(Goals.SURVIVE_NIGHT, Clock, "daycomplete", function()
            return true
        end)
    end,
}

---Listens for an event on a **Player Component**
---@param component Component
---@param event_name string
---@param completion_check fun(...): boolean
function CreateListenerOnEntityForEvent(goal_name, component, event_name, completion_check)
    component.GoalCompletionListener = function(_, data)
        if GoalManager.CurrentGoal.Name ~= goal_name then return end

        complete = completion_check(data)

        if not complete then return end

        log_info("Completed goal:", goal_name)
        next_goal = GLOBAL.next(GoalChecks, goal_name)

        if not next_goal then
            log_warning("No more goals left!")

            GoalManager.CurrentGoal.CurrentGoalCheck = nil
            GoalManager.CurrentGoal.Name = nil

            return
        end

        GoalManager.StartGoal(next_goal, component, event_name)
    end

    GoalManager.CurrentGoal.Component = component
    GoalManager.CurrentGoal.EventName = event_name

    Player:ListenForEvent(event_name, component.GoalCompletionListener, component.inst)
end
