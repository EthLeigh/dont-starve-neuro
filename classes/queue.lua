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
        first = 0,
        last = -1,
        _data = {},
    }

    GLOBAL.setmetatable(queue, self)

    return queue
end

---@generic T
---@param value T
function Queue:Push(value)
    local last = self.last + 1

    self.last = last
    self._data[self.last] = value
end

---@generic T
---@return T|nil
function Queue:Pop()
    if self:GetSize() == 0 then
        return nil
    end

    local first = self.first
    ---@generic T
    ---@type T
    local value = self._data[first]

    self._data[first] = nil
    self.first = first + 1

    return value
end

---@return integer
function Queue:GetSize()
    return #self._data
end

function Queue:Clear()
    self.first = 0
    self.last = -1
    self._data = {}
end
