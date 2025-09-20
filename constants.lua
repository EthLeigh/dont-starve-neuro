---@class Constants
---@field SEARCH_RADIUS integer
Constants = {}

--- Maximum viewing distance for searching/vision
Constants.SEARCH_RADIUS = 20

--- Distance to flee away from enemies/hostile entities
Constants.FLEE_DISTANCE = 30

Constants.BRIDGE_BASE_URL = "http://localhost:9003/api"
Constants.RETRIEVE_INCOMING_ACTIONS_URL = Constants.BRIDGE_BASE_URL .. "/actions/retrieve-incoming"
Constants.SEND_CONTEXT_URL = Constants.BRIDGE_BASE_URL .. "/actions/send-context"
