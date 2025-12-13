---@class CraftingHelper
CraftingHelper = {}

---@return table<string, Recipe>
function CraftingHelper.GetAvailableBuildables()
    ---@type table<string, Recipe>
    local valid_recipes = {}

    for recipe_name, recipe in pairs(GLOBAL:GetAllRecipes()) do
        if PlayerBuilder:CanBuild(recipe_name) and PlayerBuilder:KnowsRecipe(recipe_name) then
            valid_recipes[recipe_name] = recipe
        end
    end

    return valid_recipes
end

---@return table<string, Recipe>
function CraftingHelper.GetAvailablePrototypes()
    ---@type table<string, Recipe>
    local valid_prototypes = {}

    for prototype_recipe_name, prototype_recipe in pairs(GLOBAL:GetAllRecipes()) do
        if PlayerBuilder:CanBuild(prototype_recipe_name) and not PlayerBuilder:KnowsRecipe(prototype_recipe_name) then
            log_info("PROTOTYPE:", prototype_recipe_name, prototype_recipe.name, prototype_recipe.prefab)
            valid_prototypes[prototype_recipe_name] = prototype_recipe
        end
    end

    return valid_prototypes
end

---@param recipe_name string
---@return boolean "If the craft was successful or not"
function CraftingHelper.BuildFromRecipeName(recipe_name)
    local craft_success, _ = PlayerBuilder:DoBuild(recipe_name)

    return craft_success
end
