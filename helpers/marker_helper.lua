--- Allows Neuro to remember important locations
---@class MarkerHelper
MarkerHelper = {}

local SAVE_NAME_SUFFIX = "_marker"

--- Saves a position as a persistent string for later use
---@param name string
function MarkerHelper.SetMarker(name)
    local x, _, z = Player.Transform:GetWorldPosition()
    local waypoint_name = name .. SAVE_NAME_SUFFIX
    local formatted_position = x .. ";" .. z

    GLOBAL.TheSim:SetPersistentString(waypoint_name, formatted_position)
end

--- Loads a saved position as a persistent string by it's name
---@param name string
---@param on_done fun(x: number, z: number)
---@param on_error function
function MarkerHelper.GetMarker(name, on_done, on_error)
    local waypoint_name = name .. SAVE_NAME_SUFFIX

    GLOBAL.TheSim:GetPersistentString(waypoint_name, function(success, data)
        if not success then
            log_error("Failed to retrieve marker (" .. waypoint_name .. ") from persistent string")

            return on_error()
        end

        local raw_position = {}

        for pos_value in string.gmatch(data, "([^;]+)") do
            table.insert(raw_position, pos_value)
        end

        x = raw_position[1] and GLOBAL.tonumber(raw_position[1]) or nil
        z = raw_position[2] and GLOBAL.tonumber(raw_position[2]) or nil

        if x == nil or z == nil then
            log_error("Failed to parse marker position")

            return
        end

        on_done(x, z)
    end)
end
