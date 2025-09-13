---@class HotbarItem
---@field item ItemSlot
---@field edible ItemEdibleComponent
---@field count integer
---@field name string
---@field id string
---@param item ItemSlot
---@return HotbarItem
HotbarItem = Class(function(self, item)
    self.item = item

    local stack_comp = item.components.stackable

    self.edible = item.components.edible
    self.count = stack_comp and stack_comp:StackSize() or 1
    self.name = item.name
    self.id = tostring(item.prefab)

    return self
end)

function HotbarItem:__tostring()
    return self.name .. " - " .. self.count
end
