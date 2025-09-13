---@class InventoryHelper
InventoryHelper = {}

modimport("hotbar_item.lua")

---@return HotbarItem[]
function InventoryHelper.GetHotbarItems()
    local inventory = Player.components.inventory
    local hotbar_items = {}

    for _, hotbar_item in pairs(inventory.itemslots) do
        if hotbar_item then
            table.insert(hotbar_items, HotbarItem(hotbar_item))
        end
    end

    return hotbar_items
end

---@return table<integer, string>
function InventoryHelper.GetHotbarItemNames()
    local hotbar_items = InventoryHelper.GetHotbarItems()
    local hotbar_item_names = {}

    for _, hotbar_item in pairs(hotbar_items) do
        table.insert(hotbar_item_names, hotbar_item.name)
    end

    return hotbar_item_names
end

---@return HotbarItem[]
function InventoryHelper.GetFoodItems()
    local hotbar_items = InventoryHelper.GetHotbarItems()
    local food_items = {}

    for _, hotbar_item in pairs(hotbar_items) do
        if hotbar_item.item.components.edible ~= nil then
            table.insert(food_items, hotbar_item)
        end
    end

    return food_items
end
