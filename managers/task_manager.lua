modimport("classes/queue.lua")

---@class TaskManager
TaskManager = {}

TaskManager.TASK_TYPES = {
    HARVEST = 1,
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
end

---@param type integer
---@return function | nil
local function GetTaskTypeFunction(type)
    if type == TaskManager.TASK_TYPES.HARVEST then
        return function()
            -- TODO: Add filtering for specific harvestables
            local nearby_harvestables = EntityHelper.GetNearbyHarvestables()

            HarvestHelper.HarvestEntities(nearby_harvestables)
        end
    else
        return nil
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

        task_function()

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

-- TODO: Doesn't seem to immediately cancel the active task
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
