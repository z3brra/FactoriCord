local config = require("config")
local json = require("scripts.json")

-- @class Utils
local Utils = {}

---@param filename any
function Utils.init_event(filename)
    storage.events_data = storage.events_data or {}
    storage.events_data[filename] = storage.events_data[filename] or { events = {} }
end

---@param s any
---@return string
local function sanitize_filename(s)
    s = tostring(s or "unknown")
    return (s:gsub("[^%w%._%-]", "_"))
end

---@param name any
---@return string
local function strip_json_ext(name)
    return (tostring(name or "events"):gsub("%.json$", ""))
end

---@param filename_hint any
---@param data any
function Utils.write_event(filename_hint, data)
    storage._fc_seq = (storage._fc_seq or 0) + 1

    local base = strip_json_ext(filename_hint)
    local event = sanitize_filename(data and data.event or "event")
    local player = sanitize_filename(data and data.player or "unknown")
    local tick = tostring(game.tick)
    local seq = string.format("%06d", storage._fc_seq)

    local subdir = (config.events_subdir or base)
    local relpath = string.format("%s/%s_%s_%s_%s.json", subdir, event, player, tick, seq)
    local full = (config.output_dir or "") .. relpath

    helpers.write_file(
        full,
        json.encode(data),
        false
    )
end


local event_enable_cache = {}

--- @param event_name string
--- @return boolean
function Utils.is_event_enabled(event_name)
    if type(event_name) ~= "string" or event_name == "" then
        return false
    end

    local cached = event_enable_cache[event_name]
    if cached ~= nil then
        return cached
    end

    local setting_name = "jsonlog_" .. event_name
    local setting = settings.global[setting_name]
    local enabled = (setting and setting.value == true) or false

    event_enable_cache[event_name] = enabled
    return enabled
end

script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
    if e.setting:sub(1, 8) == "jsonlog_" then
        local event_name = e.setting:sub(9)
        event_enable_cache[event_name] = nil
    end
end)

return Utils