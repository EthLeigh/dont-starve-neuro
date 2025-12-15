--- Allows Neuro to remember important locations
---@class MarkerHelper
MarkerHelper = {}

local SAVE_NAME = "dns_markers"

--- Saves a position as a persistent string for later use
---@param name string
function MarkerHelper.SetMarker(name)
    local x, _, z = Player.Transform:GetWorldPosition()

    MarkerHelper.GetMarkers(function(markers)
        markers[name] = { x = x, z = z }

        local encoded_markers = GLOBAL.json.encode(markers)

        GLOBAL.TheSim:SetPersistentString(SAVE_NAME, encoded_markers)
    end, function()
        log_error("Failed to set marker:", name)
    end)
end

--- Loads a saved position as a persistent string by it's name
---@param on_done fun(markers: table<string, table<"x" | "z", number>>)
---@param on_error function
function MarkerHelper.GetMarkers(on_done, on_error)
    GLOBAL.TheSim:GetPersistentString(SAVE_NAME, function(success, data)
        if not success then
            log_error("Failed to retrieve markers from persistent string")

            return on_error()
        end

        local markers = GLOBAL.json.decode(data or "{}")

        on_done(markers)
    end)
end

local function SetupSave()
    GLOBAL.TheSim:GetPersistentString(SAVE_NAME, function(success)
        if success then
            return
        end

        GLOBAL.TheSim:SetPersistentString(SAVE_NAME, "{}")
    end)
end

SetupSave()
