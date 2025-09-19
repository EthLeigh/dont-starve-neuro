ApiBridge = {}

local function HandleIncomingActions(result, is_successful, result_code)
    -- TODO: Handle the real actions incoming here
    log_info("RECEIVED ACTION REQUEST", is_successful, result_code, result)
end

function ApiBridge.GetIncomingActions()
    GLOBAL.TheSim:QueryServer(
		Constants.GET_INCOMING_ACTIONS_URL,
		function(result, is_successful, result_code) HandleIncomingActions(result, is_successful, result_code) end,
		"GET"
	)
end
