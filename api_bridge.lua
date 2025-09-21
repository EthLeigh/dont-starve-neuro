ApiBridge = {}

---@param action_payload string
---@param is_successful boolean
---@param result_code integer
local function HandlePendingAction(action_payload, is_successful, result_code)
	if action_payload == '[]' or action_payload == '' then
		return
	end

	---@type IncomingAction
	local action = GLOBAL.json.decode(action_payload)
	local action_data

	if action.data.data ~= nil and action.data.data ~= '' and string.len(action.data.data) > 2  then
		action_data = GLOBAL.json.decode(action.data.data)
	end

	ApiBridgeHelper.HandleActionExecution(action.data.name, action_data)
end

-- TODO: Add handlers for forced actions, action results, registering actions, and unregistering actions

---@param message string
---@param silent boolean?
function ApiBridge.HandleSendContext(message, silent)
	GLOBAL.TheSim:QueryServer(
		BridgeConstants.CONTEXT_URL,
		function() end,
		"POST",
		GLOBAL.json.encode({
			message = message,
			silent = silent
		})
	)
end

---@param success boolean
---@param message string?
function ApiBridge.HandleSendActionResult(success, message)
	GLOBAL.TheSim:QueryServer(
		BridgeConstants.RESULT_URL,
		function() end,
		"POST",
		GLOBAL.json.encode({
			success = success,
			message = message
		})
	)
end

function ApiBridge.HandleSendStartup()
	GLOBAL.TheSim:QueryServer(
		BridgeConstants.STARTUP_URL,
		function() end,
		"GET"
	)
end

function ApiBridge.HandleSendRegisterAll()
	GLOBAL.TheSim:QueryServer(
		BridgeConstants.REGISTER_ALL_URL,
		function() end,
		"GET"
	)
end

---@param action_names string[]
function ApiBridge.HandleSendRegisterActions(action_names)
	GLOBAL.TheSim:QueryServer(
		BridgeConstants.REGISTER_URL,
		function() end,
		"POST",
		GLOBAL.json.encode({
			actions = action_names
		})
	)
end

function ApiBridge.GetPendingActions()
    GLOBAL.TheSim:QueryServer(
		BridgeConstants.RETRIEVE_PENDING_ACTIONS_URL,
		HandlePendingAction,
		"GET"
	)
end
