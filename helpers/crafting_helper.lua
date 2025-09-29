---@class CraftingHelper
CraftingHelper = {}

---@return table<string, Recipe>
function CraftingHelper.GetAvailableBuildables()
    ---@type table<string, Recipe>
    local valid_recipes = {}

    for recipe_name, recipe in pairs(GLOBAL.GetAllRecipes()) do
        if PlayerBuilder:CanBuild(recipe_name) and PlayerBuilder:KnowsRecipe(recipe_name) then
            valid_recipes[recipe_name] = recipe
        end
    end

    return valid_recipes
end

--- Can only be run in a `Player:DoTaskInTime` in `AddSimPostInit`
---@param recipe_name string
---@return boolean "If the craft was successful or not"
function CraftingHelper.BuildFromRecipeName(recipe_name)
    return PlayerBuilder:DoBuild(recipe_name)[0]
end
