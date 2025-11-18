---@class Queue<T>
---@field first integer
---@field last integer
---@field _data table<integer, any>
Queue = {}
Queue.__index = Queue

---@generic T
---@return Queue<T>
function Queue:New()
    local queue = {
        _data = {},
    }

    GLOBAL.setmetatable(queue, self)

    return queue
end

---@generic T
---@param value T
function Queue:Push(value)
    table.insert(self._data, value)
end

---@generic T
---@return T|nil
function Queue:Pop()
    if self:GetSize() == 0 then
        log_warning("No elements left in queue")

        return nil
    end

    return table.remove(self._data, 1)
end

---@return integer
function Queue:GetSize()
    return #self._data
end

function Queue:Clear()
    self._data = {}
end
