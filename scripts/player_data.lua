local Time = require("scripts.sensors.time")

local player_data = {}

--- @param player_index integer
function player_data.init(player_index)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    local name = player.name
    storage.players = storage.players or {}

    if not storage.players[name] then
        storage.players[name] = {
            total_deaths = 0,
            session_deaths = 0,
            sessions = {}
        }
    end
end


--- @param player_index integer
function player_data.on_join(player_index)
    player_data.init(player_index)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    local name = player.name
    local pdata = storage.players[name]

    pdata.session_deaths = 0
    pdata.session_start_tick = game.tick
end


--- @param player_index integer
--- @return table|nil
function player_data.on_leave(player_index)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    local name = player.name
    local pdata = storage.players[name]
    if not pdata then return end

    local start_tick = pdata.session_start_tick or game.tick
    local time_info = Time.delta(start_tick, game.tick)

    table.insert(pdata.sessions, {
        start_tick = start_tick,
        end_tick = game.tick,
        duration_ticks = time_info.ticks,
        duration_seconds = time_info.seconds_total,
        session_deaths = pdata.session_deaths
    })

    return {
        session_time  = time_info,
        session_deaths  = pdata.session_deaths,
        total_deaths    = pdata.total_deaths
    }
end


--- @param player_index integer
--- @param cause string|nil
function player_data.increment_death(player_index, cause)
    local player = game.get_player(player_index)
    if not player or not player.valid then return end

    local name = player.name
    player_data.init(player_index)

    local pdata = storage.players[name]
    pdata.total_deaths = (pdata.total_deaths or 0) + 1
    pdata.session_deaths = (pdata.session_deaths or 0) + 1

    table.insert(pdata.sessions, {
        tick = game.tick,
        cause = cause or "unknown"
    })
end

return player_data
