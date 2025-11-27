GoalManager = {}

---@type table<string, any>
GoalManager.CurrentGoal = {}

---@type string
GoalManager.CurrentGoal.Name = nil

---@type function
GoalManager.CurrentGoal.Check = nil

---@type Component
GoalManager.CurrentGoal.Component = nil

---@type string
GoalManager.CurrentGoal.EventName = nil

function GoalManager.LoadAndStart()
    GLOBAL.TheSim:GetPersistentString(GoalStringKey, function(success, goal_name)
        local first_goal_name, first_goal_check = GLOBAL.next(GoalChecks, nil)

        GoalManager.CurrentGoal.Name = goal_name

        if success and GoalChecks[goal_name] then
            log_info("A saved goal was found, starting with:", goal_name)

            GoalManager.CurrentGoal.Check = GoalChecks[goal_name]
        else
            log_info("No saved goal was found, starting with:", first_goal_name)

            GoalManager.CurrentGoal.Name = first_goal_name
            GoalManager.CurrentGoal.Check = first_goal_check
        end

        GoalManager.CurrentGoal.Check()

        ApiBridge.HandleSendContext(GoalManager.GetAsMessage())
    end)
end

---@param goal_name string
---@param goal_check_component Component
---@param goal_event_name string
function GoalManager.StartGoal(goal_name, goal_check_component, goal_event_name)
    Player:RemoveEventCallback(GoalManager.CurrentGoal.EventName,
        GoalManager.CurrentGoal.Component.GoalCompletionListener)

    GoalManager.CurrentGoal.Component = goal_check_component
    GoalManager.CurrentGoal.EventName = goal_event_name
    GoalManager.CurrentGoal.Name = goal_name
    GoalManager.CurrentGoal.Check = GoalChecks[goal_name]

    GoalManager.CurrentGoal.Check()

    ApiBridge.HandleSendContext(GoalManager.GetAsMessage())
end

function GoalManager.SaveCurrentGoal()
    GLOBAL.TheSim:SetPersistentString(GoalStringKey, GoalManager.CurrentGoal.Name)
end

function GoalManager.GetAsMessage()
    return "Your current goal is '" .. (GoalManager.CurrentGoal.Name or "None") ..
        "', and the completion description is: " ..
        (GoalCompletionDescriptions[GoalManager.CurrentGoal.Name] or "Unavailable.")
end
