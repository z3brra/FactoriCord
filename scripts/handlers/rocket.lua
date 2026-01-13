local config = require("config")
local Utils = require("scripts.utils")
local PlaytimeSensor = require("scripts.sensors.playtime_total")

--- @class Rocket
local Rocket = {}

function Rocket.on_rocket_launched(e)
    if not Utils.is_event_enabled("on_rocket_launched") then return end

    local silo = e.rocket_silo
    if silo and not silo.valid then silo = nil end

    local playtime = PlaytimeSensor.get_playtime_total()

    local data = {
        event = "rocket_launched",
        tick = game.tick,

        playtime_seconds = playtime.seconds_total,
        playtime_formatted = playtime.short,
        playtime_days = playtime.days or 0,

        surface = (silo and silo.surface and silo.surface.name) or "unknown",
        position = (silo and silo.position) and {
            x = math.floor(silo.position.x),
            y = math.floor(silo.position.y)
        } or nil
    }

    Utils.write_event(config.files.rocket, data)
end

return Rocket
