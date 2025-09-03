BufferedActionQueue = Class(function(self, player)
    self.player = player
    self.queue = {}
    self.running = false
end)

function BufferedActionQueue:enqueue(buff_act) table.insert(self.queue, buff_act) end

function BufferedActionQueue:run_next()
    if self.running or #self.queue == 0 then return end
    self.running = true

    local buff_act = table.remove(self.queue, 1)

    buff_act:AddSuccessAction(function()
        self.running = false
        self:run_next()
    end)

    buff_act:AddFailAction(function()
        self.running = false
        self:run_next()
    end)

    self.player.components.locomotor:PushAction(buff_act, true)
end
