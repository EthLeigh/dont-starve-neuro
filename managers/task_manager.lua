modimport("classes/queue.lua")

---@class TaskManager
TaskManager = {}

TaskManager.TASK_TYPES = {
    HARVEST = 1,
    ATTACK_NEARBY = 2,
    EXPLORE = 3,
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
---@param args table<string | integer, any>?
---@return fun(): boolean "Returns whether the task was successful or not"
local function GetTaskTypeFunction(type, args)
    if type == TaskManager.TASK_TYPES.HARVEST then
        return function()
            local nearby_harvestables = EntityHelper.GetNearbyHarvestables()

            local filtered_nearby_harvestables = {}
            if args ~= nil and args.prefab_filters ~= nil and Utils.GetTableLength(args.prefab_filters) > 0 then
                for _, entity in pairs(nearby_harvestables) do
                    if table.contains(args.prefab_filters, entity.prefab) then
                        log_info(entity.prefab)
                        table.insert(filtered_nearby_harvestables, entity)
                    end
                end
            else
                filtered_nearby_harvestables = nearby_harvestables
            end

            local _, nearby_harvestable = GLOBAL.next(filtered_nearby_harvestables, nil)

            if not nearby_harvestable then
                log_warning("No harvestables found nearby.")

                return false
            end

            HarvestHelper.HarvestEntity(nearby_harvestable)

            return true
        end
    elseif type == TaskManager.TASK_TYPES.ATTACK_NEARBY then
        return function()
            local direction = GLOBAL.math.random(-4, 4) * 0.25
            local angle = direction * GLOBAL.math.pi

            local p_x, _, p_z = Player.Transform:GetWorldPosition()
            local x_dir, z_dir = GLOBAL.math.cos(angle), GLOBAL.math.sin(angle)

            MovementHelper.MoveToPoint(p_x * x_dir * GameConstants.EXPLORE_DISTANCE,
                p_z * z_dir * GameConstants.EXPLORE_DISTANCE)

            return true
        end
    elseif type == TaskManager.TASK_TYPES.EXPLORE then
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
---@param task_cooldown integer?
local function StartTask(task, task_cooldown)
    local task_function = GetTaskTypeFunction(task.type, task.args)

    if not task_function then
        log_error("Task type not found when starting a new task")

        return
    end

    TaskManager._task_loop = Player:DoPeriodicTask(task_cooldown or 1, function()
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

            StartTask(next_task, task_cooldown)
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
---@param task_cooldown integer?
function TaskManager.StartTasks(tasks, task_cooldown)
    StopTasks()

    for _, task in pairs(tasks) do
        TaskManager._task_queue:Push(task)
    end

    local first_task = TaskManager._task_queue:Pop()

    if not first_task then
        log_error("No tasks were sent to execute.")

        return
    end

    StartTask(first_task, task_cooldown)
end

function TaskManager.StopTasks()
    StopTasks()
end
