---@class ApiBridgeHelper
ApiBridgeHelper = {}

---@param _name string
---@param _data table<string, any>
function ApiBridgeHelper.HandleActionExecution(_name, _data)
    local success = true
    local message

    -- TODO: Add action handlers here
    message = "Placeholder"

    ApiBridge.HandleSendResult(success, message)
end
