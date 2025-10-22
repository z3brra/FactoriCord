local config = require("config")
local player_data = require("scripts.player-data")
local Utils = require("scripts.utils")

local Time = require("scripts.sensors.time")

-- @class Controller
local Controller = {}

function Controller.init_global()
    storage.players = storage.players or {}
    storage.events_data = storage.events_data or {}
end

function Controller.on_init()
    Controller.init_global()

    for _, player in pairs(game.players) do
        player_data.init(player.index)
    end
end

function Controller.on_player_created(e)
    player_data.init(e.player_index)
end


local function _handle_player_join(player_index)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    player_data.on_join(player_index)

    local data = {
        event = "player_join",
        player = player.name,
        tick = game.tick
    }
    Utils.write_event(config.files.login, data)
end

function Controller.on_player_joined_game(e)
    _handle_player_join(e.player_index)
end

local function _handle_player_left(player_index)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    local session_info = player_data.on_leave and player_data.on_leave(player_index) or nil
    local time_info = session_info and session_info.session_time or {}


    Utils.write_event(config.files.login, {
        event = "player_left",
        player = player.name,
        tick   = game.tick,

        session_deaths        = session_info and session_info.session_deaths or 0,
        total_deaths          = session_info and session_info.total_deaths   or 0,

        session_length_ticks  = time_info.ticks or 0,
        session_length_seconds = time_info.seconds_total or 0,
        session_length_formatted = time_info.short or "00:00:00",
        session_days = time_info.days or 0,
    })
end

function Controller.on_player_left_game(e)
    if not game.is_multiplayer() then return end
    _handle_player_left(e.player_index)
end

function Controller.simulate_player_left(player_index)
    _handle_player_left(player_index)
end

function Controller.simulate_player_join(player_index)
    _handle_player_join(player_index)
end

function Controller.on_player_died(e)
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


return Controller