---@class InventoryHelper
InventoryHelper = {}

modimport("hotbar_item.lua")

---@param player Player
---@return HotbarItem[]
function InventoryHelper.GetHotbarItems(player)
    local inventory = player.components.inventory
    local hotbar_items = {}

    for _, hotbar_item in pairs(inventory.itemslots) do
        if hotbar_item then
            table.insert(hotbar_items, HotbarItem(hotbar_item))
        end
    end

    return hotbar_items
end

---@param player Player
---@return table<integer, string>
function InventoryHelper.GetHotbarItemNames(player)
    local hotbar_items = InventoryHelper.GetHotbarItems(player)
    local hotbar_item_names = {}

    for _, hotbar_item in pairs(hotbar_items) do
        table.insert(hotbar_item_names, hotbar_item.name)
    end

    return hotbar_item_names
end
