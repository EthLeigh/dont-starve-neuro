InventoryHelper = InventoryHelper or {}

InventoryHelper.GetHotbarItems = function(player)
    local inventory = player.components.inventory
    local hotbar_items = {}

    for _, hotbar_item in pairs(inventory.itemslots) do
        if hotbar_item then
            table.insert(hotbar_items, hotbar_item)
        end
    end

    return hotbar_items
end

InventoryHelper.GetHotbarItemNames = function(player)
    local hotbar_items = InventoryHelper.GetHotbarItems(player)
    local item_names = {}

    for _, hotbar_item in pairs(hotbar_items) do
        table.insert(item_names, tostring(hotbar_item.prefab))
    end

    return item_names
end
