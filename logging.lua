---@param ... any
function log_info(...)
    print("[DSN] [INFO]", ...)
end

---@param ... any
function log_warning(...)
    print("[DSN] [WARNING]", ...)
end

---@param ... any
function log_error(...)
    print("[DSN] [ERROR]", ...)
end

---@param table table<string, any>
function log_entries(table)
    log_info("Started logging entries for: ", table)

    for k, v in pairs(table) do
        log_info(k, v)
    end

    log_info("Stopped logging entries for: ", table)
end
