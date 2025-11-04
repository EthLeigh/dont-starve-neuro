GoalManager = {}

---@type string
GoalManager.CurrentGoalCheckName = nil

---@type function
GoalManager.CurrentGoalCheck = nil

function GoalManager.LoadAndStart()
    GLOBAL.TheSim:GetPersistentString(GoalStringKey, function(success, goal_check_name)
        local first_goal_check_name, first_goal_check = GLOBAL.next(GoalChecks, nil)

        GoalManager.CurrentGoalCheckName = goal_check_name

        if success and GoalChecks[goal_check_name] then
            log_info("A saved goal was found, starting with:", goal_check_name)

            GoalManager.CurrentGoalCheck = GoalChecks[goal_check_name]
        else
            log_info("No saved goal was found, starting with:", first_goal_check_name)

            GoalManager.CurrentGoalCheckName = first_goal_check_name
            GoalManager.CurrentGoalCheck = first_goal_check
        end

        GoalManager.CurrentGoalCheck()
    end)
end

---@param goal_check_name string
function GoalManager.StartGoalCheck(goal_check_name)
    GoalManager.CurrentGoalCheckName = goal_check_name
    GoalManager.CurrentGoalCheck = GoalChecks[goal_check_name]

    GoalManager.CurrentGoalCheck()
end

function GoalManager.SaveCurrentGoalCheck()
    GLOBAL.TheSim:SetPersistentString(GoalStringKey, GoalManager.CurrentGoalCheckName)
end
