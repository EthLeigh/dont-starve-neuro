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

---@param table table<any, any>
function log_entries(table)
    if not table then
        log_error("Unable to log entries on table, as it is nil.")

        return
    end

    log_info("Started logging entries for: ", table)

    for k, v in pairs(table) do
        log_info(k, v)
    end

    log_info("Stopped logging entries for: ", table)
end
