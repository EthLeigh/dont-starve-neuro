ApiBridge = {}

---@param action_payload string
---@param is_successful boolean
---@param result_code integer
local function HandleIncomingAction(action_payload, is_successful, result_code)
	if action_payload == '[]' then
		return
	end

	---@type IncomingAction
	local action = GLOBAL.json.decode(action_payload)

	-- TODO: Handle actions here
	log_info(action.data.id, action.data.name)
end

-- TODO: Add handlers for forced actions, action results, registering actions, and unregistering actions

---@param message string
---@param silent boolean?
function ApiBridge.HandleSendContext(message, silent)
	GLOBAL.TheSim:QueryServer(
		Constants.SEND_CONTEXT_URL,
		function() end,
		"POST",
		GLOBAL.json.encode({
			message = message,
			silent = silent
		})
	)
end

function ApiBridge.GetIncomingActions()
    GLOBAL.TheSim:QueryServer(
		Constants.RETRIEVE_INCOMING_ACTIONS_URL,
		HandleIncomingAction,
		"GET"
	)
end
