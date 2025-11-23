modimport("classes/queue.lua")

---@class TaskManager
TaskManager = {}

TaskManager.TASK_TYPES = {
    HARVEST = 1,
    ATTACK_NEARBY = 2,
}

---@type Queue<Task>
TaskManager._task_queue = Queue:New()

---@type PeriodicTask
TaskManager._task_loop = nil
TaskManager._task_loop_iteration = 0

local function ClearLoop()
    TaskManager._task_loop_iteration = 0
    TaskManager._task_loop:Cancel()
    TaskManager._task_loop = nil
end

local function ClearTasks()
    ClearLoop()
    TaskManager._task_queue:Clear()
    TaskManager._task_loop:Cancel()
end

---@param type integer
---@return fun(): boolean
local function GetTaskTypeFunction(type)
    if type == TaskManager.TASK_TYPES.HARVEST then
        return function()
            -- TODO: Add filtering for specific harvestables
            local nearby_harvestables = EntityHelper.GetNearbyHarvestables()

            local _, nearby_harvestable = GLOBAL.next(nearby_harvestables, nil)

            if not nearby_harvestable then
                log_warning("No harvestables found nearby.")

                return false
            end

            HarvestHelper.HarvestEntity(nearby_harvestable)

            return true
        end
    elseif type == TaskManager.TASK_TYPES.ATTACK_NEARBY then
        return function()
            local nearby_hostiles = EntityHelper.GetNearbyHostileEntities()
            local nearby_animals = EntityHelper.GetNearbyAnimals()

            local ent_to_attack = nil
            if #nearby_hostiles > 0 then
                _, ent_to_attack = GLOBAL.next(nearby_hostiles, nil)
            elseif #nearby_animals > 0 then
                _, ent_to_attack = GLOBAL.next(nearby_animals, nil)
            else
                return false
            end

            CombatHelper.AttackEntity(ent_to_attack)

            return true
        end
    else
        return function() return false end
    end
end

---@param task Task
local function StartTask(task)
    local task_function = GetTaskTypeFunction(task.type)

    if not task_function then
        log_error("Task type not found when starting a new task")

        return
    end

    TaskManager._task_loop = Player:DoPeriodicTask(1, function()
        TaskManager._task_loop_iteration = TaskManager._task_loop_iteration + 1

        local task_execution_success = task_function()

        if not task_execution_success then
            TaskManager._task_loop:Cancel()

            return
        end

        if task.success_check_fn(TaskManager._task_loop_iteration) then
            ClearLoop()
            local next_task = TaskManager._task_queue:Pop()

            if not next_task then
                return
            end

            StartTask(next_task)
        end
    end)
end

local function StopTasks()
    if TaskManager._task_loop then
        ClearTasks()
    end
end

--- This will clear the previous list of tasks
---@param tasks Task[]
function TaskManager.StartTasks(tasks)
    StopTasks()

    for _, task in pairs(tasks) do
        TaskManager._task_queue:Push(task)
    end

    local first_task = TaskManager._task_queue:Pop()

    if not first_task then
        log_error("No tasks were sent to execute")

        return
    end

    StartTask(first_task)
end

function TaskManager.StopTasks()
    StopTasks()
end
