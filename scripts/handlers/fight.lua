local config = require("config")
local player_data = require("scripts.player_data")
local Utils = require("scripts.utils")

--- @class Fight
local Fight = {}

function Fight.on_player_died(e)
    if not Utils.is_event_enabled("on_player_died") then return end

    local player = game.get_player(e.player_index)
    if not player or not player.valid then return end

    local dead_cause = "unknown"
    local cause_entity = e.cause

    if cause_entity then
        if cause_entity.valid and cause_entity.name then
            dead_cause = cause_entity.name
        end

        if cause_entity.type == "character" and cause_entity.player then
            if cause_entity.player.name == player.name then
                dead_cause = "suicide"
            else
                dead_cause = "player/" .. cause_entity.player.name
            end
        end
    end

    player_data.increment_death(e.player_index, dead_cause)

    local pdata = storage.players[player.name]

    local data = {
        event = "player_died",
        player = player.name,
        tick = game.tick,
        cause = dead_cause,
        total_deaths = pdata.total_deaths,
        session_deaths = pdata.session_deaths
    }

    Utils.write_event(config.files.deaths, data)
end

return Fight
