---@class EaterHelper
EaterHelper = {}

---@param food ItemSlot
function EaterHelper.EatFood(food)
    PlayerEater:Eat(food)
end

---@return HotbarItem[]
local function GetFoodItemsInInventory()
    local food_items = InventoryHelper.GetFoodItems()

    ---@type HotbarItem[]
    local safe_food_items = {}

    for _, food_item in ipairs(food_items) do
        local food_edible = food_item.edible

        if food_edible and food_item.is_perishable and food_edible:GetHealth() >= 0 and food_edible:GetHunger() > 0 and food_edible:GetSanity() >= 0 then
            table.insert(safe_food_items, food_item)
        end
    end

    return safe_food_items
end

---@return HotbarItem | nil
function EaterHelper.GetBestFoodInInventory()
    local safe_food_items = GetFoodItemsInInventory()

    ---@type HotbarItem | nil
    local good_food_item = nil

    for _, food_item in ipairs(safe_food_items) do
        local food_edible = food_item.edible
        local good_food_edible = good_food_item ~= nil and good_food_item.edible or nil

        if not good_food_item or (good_food_edible and food_edible and good_food_edible:GetHunger() < food_edible:GetHunger()) then
            good_food_item = food_item
        end
    end

    return good_food_item
end

---@return HotbarItem | nil
function EaterHelper.GetBestNonCookedFoodInInventory()
    local safe_food_items = GetFoodItemsInInventory()

    ---@type HotbarItem | nil
    local good_food_item = nil

    for _, food_item in ipairs(safe_food_items) do
        local food_edible = food_item.edible
        local food_cookable = food_item.cookable
        local good_food_edible = good_food_item ~= nil and good_food_item.edible or nil

        if not good_food_item or (good_food_edible and food_edible and food_cookable ~= nil and good_food_edible:GetHunger() < food_edible:GetHunger()) then
            good_food_item = food_item
        end
    end

    return good_food_item
end

---@return string | nil "The name of the food that was eaten or nil if none was found"
function EaterHelper.EatBestFoodInInventory()
    local best_food_item = EaterHelper.GetBestFoodInInventory()

    if not best_food_item then
        log_info("No food items found in the hotbar to eat.")

        return nil
    end

    EaterHelper.EatFood(best_food_item.item)

    return best_food_item.name
end
