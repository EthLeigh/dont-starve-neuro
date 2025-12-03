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
    return GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS[name]
end

---@param count integer
---@param name string
---@return string
function StringHelper.ProperName(count, name)
    local function ToSingular(word)
        if word:match("ies$") then
            return word:gsub("ies$", "y")
        elseif word:match("(sses)$") or word:match("(shes)$") or word:match("(ches)$") then
            return word:gsub("es$", "")
        end

        return word
    end

    local function ToPlural(word)
        if word:match("s$") then
            return word
        elseif word:match("[sx]$") or word:match("sh$") or word:match("ch$") then
            return word .. "es"
        elseif word:match("[^aeiou]y$") then
            return word:gsub("y$", "ies")
        end

        return word .. "s"
    end

    local singular = ToSingular(name)
    local plural = ToPlural(singular)

    if count == 1 then
        return singular
    end

    return plural
end
