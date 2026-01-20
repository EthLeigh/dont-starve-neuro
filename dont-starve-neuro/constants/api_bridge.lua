---@class BridgeConstants
BridgeConstants = {}

-- TODO: Replace this with proper configs
BridgeConstants.BRIDGE_PORT = 9003
BridgeConstants.BRIDGE_BASE_URL = "http://localhost:" .. BridgeConstants.BRIDGE_PORT .. "/api"

BridgeConstants.STARTUP_URL = BridgeConstants.BRIDGE_BASE_URL .. "/send-startup"
BridgeConstants.REGISTER_ALL_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/register-all"
BridgeConstants.UNREGISTER_ALL_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/unregister-all"
BridgeConstants.REGISTER_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/register"
BridgeConstants.UNREGISTER_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/unregister"
BridgeConstants.RETRIEVE_PENDING_ACTIONS_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/retrieve-pending"
BridgeConstants.CONTEXT_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/context"
BridgeConstants.RESULT_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/result"
BridgeConstants.FORCE_URL = BridgeConstants.BRIDGE_BASE_URL .. "/actions/force"
