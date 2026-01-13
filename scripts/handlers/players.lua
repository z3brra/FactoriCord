local config = require("config")
local player_data = require("scripts.player_data")
local Utils = require("scripts.utils")

--- @class Players
local Players = {}

function Players.on_player_created(e)
    player_data.init(e.player_index)
end

function Players.on_player_joined_game(e)
    if not Utils.is_event_enabled("on_player_joined_game") then return end

    local player = game.get_player(e.player_index)
    if not player or not player.valid then return end

    player_data.on_join(e.player_index)

    local data = {
        event = "player_join",
        player = player.name,
        tick = game.tick,
    }
    Utils.write_event(config.files.login, data)
end

function Players.on_player_left_game(e)
    if not game.is_multiplayer() then return end
    if not Utils.is_event_enabled("on_player_left_game") then return end

    local player = game.get_player(e.player_index)
    if not player or not player.valid then return end

    local session_info = player_data.on_leave and player_data.on_leave(e.player_index) or nil
    local time_info = session_info and session_info.session_time or {}

    local data = {
        event = "player_left",
        player = player.name,
        tick = game.tick,

        session_deaths = session_info and session_info.session_deaths or 0,
        total_deaths = session_info and session_info.total_deaths or 0,

        session_length_ticks = time_info.ticks or 0,
        session_length_seconds = time_info.seconds_total or 0,
        session_length_formatted = time_info.short or "00:00:00",
        session_days = time_info.days or 0,
    }
    Utils.write_event(config.files.login, data)
end

return Players