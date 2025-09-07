---@param ... any
function log_info(...)
    print("[DSN] " .. ...)
end

---@param message any
---@param level? integer
function log_error(message, level)
    error("[DSN] " .. message, level)
end
