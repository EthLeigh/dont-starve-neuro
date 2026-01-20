---@class Task
---@field type integer
---@field args table<string, any>
---@field success_check_fn fun(current_iteration: integer, args: table<string, any>?): boolean
Task = {}
Task.__index = Task

---@param type integer
---@param success_check_fn fun(current_iteration: integer, args: table<string, any>?): boolean
---@param args table<string | integer, any>?
---@return Task
function Task:new(type, success_check_fn, args)
    local task = GLOBAL.setmetatable({}, self)

    task.type = type
    task.success_check_fn = success_check_fn
    task.args = args or {}

    return task
end
