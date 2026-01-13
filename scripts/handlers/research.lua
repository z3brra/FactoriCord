local config = require("config")
local Utils = require("scripts.utils")
local PlaytimeSensor = require("scripts.sensors.playtime_total")

--- @class Research
local Research = {}

function Research.on_research_finished(e)
    if not Utils.is_event_enabled("on_research_finished") then return end

    local research = e.research
    if not research or not research.valid then return end

    local playtime = PlaytimeSensor.get_playtime_total()

    local data = {
        event = "research_finished",
        research = research.name,
        tick = game.tick,
        level = research.level or 1,
        force = research.force and research.force.name or "unknown",
        playtime_seconds = playtime.seconds_total,
        playtime_formatted = playtime.short
    }

    Utils.write_event(config.files.research, data)
end

return Research
