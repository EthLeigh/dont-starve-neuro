StringHelper = {}

---@param prefab string
---@return string
function StringHelper.GetPrettyName(prefab)
    return GLOBAL.STRINGS.NAMES[string.upper(prefab)] or prefab
end

---@param name string
---@return string
function StringHelper.GetPrettyCharacterName(name)
    return GLOBAL.STRINGS.CHARACTER_NAMES[string.upper(name)] or name
end

---@param name string
---@return string
function StringHelper.GetCharacterDescription(name)
    return GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS[string.upper(name)]
end
