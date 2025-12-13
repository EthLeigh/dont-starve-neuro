---@class HotbarItem
---@field item ItemSlot
---@field edible ItemEdibleComponent
---@field cookable ItemCookableComponent?
---@field is_perishable boolean
---@field count integer
---@field name string
---@field prefab string
---@param item ItemSlot
---@return HotbarItem
HotbarItem = Class(function(self, item)
    self.item = item

    local stack_comp = item.components.stackable

    self.edible = item.components.edible
    self.cookable = item.components.cookable
    self.is_perishable = item.components.perishable ~= nil
    self.count = stack_comp and stack_comp:StackSize() or 1
    self.name = StringHelper.GetPrettyName(item.prefab)
    self.prefab = tostring(item.prefab)

    return self
end)

function HotbarItem:__tostring()
    return self.name .. " - " .. self.count
end
