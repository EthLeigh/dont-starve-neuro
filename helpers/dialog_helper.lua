---@class DialogHelper
DialogHelper = {}

--- Makes the player's character say a message
---@param message string
function DialogHelper.Speak(message)
    local player_talker = Player.components.talker

    if not player_talker then
        log_error("No talker component found on the Player")

        return
    end

    player_talker:Say(message, string.len(message) / 4) -- 250 ms per letter
end
