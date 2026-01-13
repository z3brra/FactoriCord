local config = require("config")
local Utils = require("scripts.utils")
local PlaytimeSensor = require("scripts.sensors.playtime_total")
local VictoryService = require("scripts.services.victory_service")

--- @class Victory
local Victory = {}

local function write_victory(e)
    if not Utils.is_event_enabled("on_factoricord_victory") then return end

    local playtime = PlaytimeSensor.get_playtime_total()

    local data = {
        event = "victory",
        tick = game.tick,

        victory_source = storage._fc_victory_source or "unknown",
        victory_detected_by = storage._fc_victory_detected_by or "unknown",
        victory_first_seen_tick = storage._fc_victory_first_seen_tick or game.tick,

        game_finished_screen = game.finished,
        game_finished_but_continuing = game.finished_but_continuing,

        scenario_player_won = (e and e.player_won) or nil,

        playtime_seconds = playtime.seconds_total,
        playtime_formatted = playtime.short,
        playtime_days = playtime.days or 0,
    }

    Utils.write_event(config.files.victory, data)
end

function Victory.on_pre_scenario_finished(e)
    if not Utils.is_event_enabled("on_pre_scenario_finished") then return end
    local won = (e and (e.player_won == true or e.won == true))
    if not won then return end

    VictoryService.trigger_once("scenario_finished", "on_pre_scenario_finished", e, write_victory)
end

function Victory.on_tick(e)
    if not Utils.is_event_enabled("on_tick") then return end
    if (game.tick % 60) ~= 0 then return end

    local now_finished = game.finished
    local was_finished = storage._fc_last_finished or false

    if now_finished and not was_finished then
        VictoryService.trigger_once("victory_screen", "game.finished", e, write_victory)
    end

    storage._fc_last_finished = now_finished
end

return Victory