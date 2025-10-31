GoalManager = {}

---@type string
GoalManager.CurrentGoalCheckName = nil

---@type function
GoalManager.CurrentGoalCheck = nil

function GoalManager.LoadAndStart()
    GLOBAL.TheSim:GetPersistentString(GoalStringKey, function(success, goal_check_name)
        local _, firstGoalCheck = next(GoalChecks)

        GoalManager.CurrentGoalCheckName = goal_check_name
        log_info("Begun with a new GOAL:", goal_check_name, "or", firstGoalCheck)
        GoalManager.CurrentGoalCheck = success and GoalChecks[goal_check_name] or firstGoalCheck
        GoalManager.CurrentGoalCheck = GoalManager.CurrentGoalCheck ~= nil and GoalManager.CurrentGoalCheck or
            firstGoalCheck

        -- log_info(#GoalChecks, GoalChecks["craft_axe"], type(GoalChecks["craft_axe"]))
        log_info("Starting new goal...", GoalManager.CurrentGoalCheck, type(GoalManager.CurrentGoalCheck))
        GoalManager.CurrentGoalCheck()
        log_info("Started new goal!")
    end)
end

---@param goal_check_name string
function GoalManager.StartGoalCheck(goal_check_name)
    log_info("Started a new GOAL:", goal_check_name)

    GoalManager.CurrentGoalCheckName = goal_check_name
    GoalManager.CurrentGoalCheck = GoalChecks[goal_check_name]

    GoalManager.CurrentGoalCheck()
end

function GoalManager.SaveCurrentGoalCheck()
    GLOBAL.TheSim:SetPersistentString(GoalStringKey, GoalManager.CurrentGoalCheckName)
end
