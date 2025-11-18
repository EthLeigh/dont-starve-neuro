---@class Queue<BufferedAction>
---@field player Player
---@field queue table<integer, BufferedAction>
---@field running boolean
BufferedActionQueue = {}
BufferedActionQueue.__index = BufferedActionQueue

---@return Queue<BufferedAction>
function BufferedActionQueue:New()
    local act_queue = {
        running = false
    }

    GLOBAL.setmetatable(act_queue, Queue)

    return act_queue
end

function BufferedActionQueue:RunNext()
    if self.running or #self.queue == 0 then
        return
    end

    self.running = true

    local buffered_action = table.remove(self.queue, 1)

    local function FinishAction()
        self.running = false
        self:RunNext()
    end

    buffered_action:AddSuccessAction(FinishAction)
    buffered_action:AddFailAction(FinishAction)

    Player.components.locomotor:PushAction(buffered_action, true)
end
