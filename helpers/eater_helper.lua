---@class EaterHelper
EaterHelper = {}

---@param food ItemSlot
function EaterHelper.EatFood(food)
    PlayerEater:Eat(food)
end

---@return HotbarItem | nil
function EaterHelper.GetBestFoodInInventory()
    local food_items = InventoryHelper.GetFoodItems()

    ---@type HotbarItem[]
    local safe_food_items = {}

    for _, food_item in pairs(food_items) do
        local food_edible = food_item.edible

        if food_edible and food_edible:GetHealth() >= 0 and food_edible:GetHunger() > 0 and food_edible:GetSanity() >= 0 then
            table.insert(safe_food_items, food_item)
        end
    end

    local good_food_item = nil

    for _, food_item in pairs(safe_food_items) do
        local food_edible = food_item.edible

        if not good_food_item or (food_edible and good_food_item:GetHunger() < food_edible:GetHunger()) then
            good_food_item = food_item
        end
    end

    return good_food_item
end

---@return boolean "Successfully ate the most optimal food in the inventory"
function EaterHelper.EatBestFoodInInventory()
    local best_food_item = EaterHelper.GetBestFoodInInventory()

    if not best_food_item then
        log_info("No food items found in the hotbar to eat")

        return false
    end

    EaterHelper.EatFood(best_food_item.item)

    return true
end
