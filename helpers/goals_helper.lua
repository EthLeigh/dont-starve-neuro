---@type table<string, any>
GoalState = {}

-- TODO: Allow for goal state, like total number of things harvested before completing
---@type table<string, function>
GoalChecks = {
    craft_axe = function()
        log_info("STARTING LISTENER FOR craft_axe")

        CreateListenerOnEntityForEvent("craft_axe", PlayerBuilder, "builditem", function(item)
            return item.prefab.name == "axe"
        end)
    end,
    make_campfire = function()
        CreateListenerOnEntityForEvent("make_campfire", PlayerBuilder, "buildstructure", function(item)
            return item.prefab.name == "campfire"
        end)
    end,
}

---Listens for an event on a **Player Component**
---@param component Component
---@param event_name string
---@param completion_check fun(...): boolean
function CreateListenerOnEntityForEvent(goal_check_name, component, event_name, completion_check)
    component.inst:ListenForEvent(event_name, function(...)
        complete = completion_check(...)

        log_info("LISTENING FOR craft_axe, complete:", complete)

        if not complete then
            return
        end

        GoalManager.StartGoalCheck(goal_check_name)
    end)
end
