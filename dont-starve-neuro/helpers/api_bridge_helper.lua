---@class ApiBridgeHelper
ApiBridgeHelper = {}

---@param name string
---@param data table<string, any>
function ApiBridgeHelper.HandleActionExecution(name, data)
    local success = true
    local message

    -- TODO: Add action handlers here

    ApiBridge.HandleSendResult(success, message)
end
