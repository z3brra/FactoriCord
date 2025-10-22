local config = require("config")
local json = require("scripts.json")

-- @class Utils
local Utils = {}

function Utils.init_event(filename)
    storage.events_data = storage.events_data or {}
    storage.events_data[filename] = storage.events_data[filename] or { events = {} }
end

local function sanitize_filename(s)
    s = tostring(s or "unknown")
    return (s:gsub("[^%w%._%-]", "_"))
end

local function strip_json_ext(name)
    return (tostring(name or "events"):gsub("%.json$", ""))
end

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

return Utils