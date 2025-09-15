---@class Queue<T>
---@field first integer
---@field last integer
---@field _data table<integer, any>
Queue = {}
Queue.__index = Queue

---@return Queue
function Queue:New()
    if self == Queue then
        log_error("Cannot instantiate a Queue directly; subclass it")
    end

    local queue = {
        first = 0,
        last = -1,
        _data = {},
    }

    GLOBAL.setmetatable(queue, self)

    return queue
end

---@generic T
---@param self Queue
---@param value T
function Queue:Push(value)
    local last = self.last + 1

    self.last = last
    self._data[self.last] = value
end

---@generic T
---@param self Queue
---@return T|nil
function Queue:Pop()
    if self:GetSize() == 0 then
        return nil
    end

    local first = self.first
    local value = self._data[first]

    self._data[first] = nil
    self.first = first + 1

    return value
end

---@param self Queue
---@return integer
function Queue:GetSize()
    local size = 0

    for _, _ in pairs(self._data) do
        size = size + 1
    end

    return size
end

---@param self Queue
function Queue:Clear()
    self.first = 0
    self.last = -1
    self._data = {}
end
