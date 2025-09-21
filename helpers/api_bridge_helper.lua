---@class ApiBridgeHelper
ApiBridgeHelper = {}

---@param name string
---@param data table<string, any>
function ApiBridgeHelper.HandleActionExecution(name, data)
    if name == ApiActions.EAT_FOOD then
        local success = EaterHelper.EatBestFoodInInventory()
        local message

        if not success then
            message = "There is no food to eat in the inventory."
        end

        ApiBridge.HandleSendActionResult(success, message)
    elseif name == ApiActions.MOVE_TO_MARKER then
        MarkerHelper.GetMarker(data["marker_name"], function (x, z)
            MovementHelper.MoveToPoint(x, z)
        end)
    end
end
