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
