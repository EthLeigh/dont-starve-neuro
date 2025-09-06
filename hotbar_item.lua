HotbarItem = Class(function(self, item)
    self.item = item

    local stack_comp = item.components.stackable

    self.count = stack_comp and stack_comp:StackSize() or 1
    self.name = item.name
    self.id = tostring(item.prefab)
end)

function HotbarItem.__tostring(self)
    return self.name .. " - " .. self.count
end
