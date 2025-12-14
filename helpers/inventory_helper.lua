---@class InventoryHelper
InventoryHelper = {}

modimport("classes/hotbar_item.lua")

---@return HotbarItem[]
function InventoryHelper.GetHotbarItems()
    local hotbar_items = {}

    for _, hotbar_item in pairs(PlayerInventory.itemslots) do
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
        table.insert(hotbar_item_names, StringHelper.GetPrettyName(hotbar_item.item.prefab))
    end

    return hotbar_item_names
end

-- FIXME: Literally just returns items in the inventory
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

---@param prefab string
---@return boolean
function InventoryHelper.HasItem(prefab)
    for _, hotbar_item in pairs(InventoryHelper.GetHotbarItems()) do
        if hotbar_item.prefab == prefab then
            return true
        end
    end

    if PlayerInventory.equipslots.hands and PlayerInventory.equipslots.hands.prefab == prefab then
        return true
    end

    return false
end
