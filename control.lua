-- local json = require("util_json")
-- local config = require("config")

-- -- local function write_event(filename, data)
-- --     local encoded = json.encode(data)
-- --     script.write_file(config.output_dir .. filename, encoded .. "\n", true)
-- -- end

-- local function write_event(filename, data)
--     local encoded = json.encode(data)
--     helpers.write_file(
--         config.output_dir .. filename,
--         encoded .. "\n",
--         true
--     )
-- end

-- -- Store death count
-- local function getAndStoreDeathCount(player_name, cause)
--     storage.playerDeathCount = storage.playerDeathCount or {}
--     storage.playerDeathCount[player_name] = storage.playerDeathCount[player_name] or {}

--     storage.playerDeathCount[player_name][cause] = storage.playerDeathCount[player_name][cause] or 0
--     storage.playerDeathCount[player_name][cause] = storage.playerDeathCount[player_name][cause] + 1

--     storage.playerDeathCount[player_name]["total"] = storage.playerDeathCount[player_name]["total"] or 0
--     storage.playerDeathCount[player_name]["total"] = storage.playerDeathCount[player_name]["total"] + 1

--     return storage.playerDeathCount[player_name][cause], storage.playerDeathCount[player_name]["total"]
-- end

-- -- Player login
-- script.on_event(
--     defines.events.on_player_joined_game, 
--     function(event)
--         local player = game.get_player(event.player_index)
--         local data = {
--             event = "player_join",
--             player = player.name,
--             tick = game.tick
--         }
--         write_event(config.files.login, data)
--     end
-- )



-- -- Player logout
-- script.on_event(
--     defines.events.on_player_left_game,
--     function(event)
--         local player = game.get_player(event.player_index)
--         -- local cause, total = getAndStoreDeathCount(player.name, causeText)
--         local data = {
--             event = "player_leave",
--             player = player.name,
--             -- playtime_ticks = player.online_time,
--             deaths_total = player.deaths or 0,
--             tick = game.tick
--         }
--         write_event(config.files.login, data)
--     end
-- )

-- -- Player die
-- -- script.on_event(defines.events.on_player_died, function(event)
-- --     local player = game.get_player(event.player_index)
-- --     player.deaths = (player.deaths or 0) + 1
-- --     local data = {
-- --         event = "player_death",
-- --         player = player.name,
-- --         deaths_total = player.deaths,
-- --         tick = game.tick
-- --     }
-- --     write_event(config.files.deaths, data)
-- -- end)

-- -- -- Research started
-- -- script.on_event(defines.events.on_research_started, function(event)
-- --     write_event(config.files.research, {
-- --         event = "research_started",
-- --         research = event.research.name,
-- --         tick = game.tick
-- --     })
-- -- end)

-- -- -- Research ended
-- -- script.on_event(defines.events.on_research_finished, function(event)
-- --     write_event(config.files.research, {
-- --         event = "research_finished",
-- --         research = event.research.name,
-- --         tick = game.tick
-- --     })
-- -- end)

-- -- -- Rocket launched
-- -- script.on_event(defines.events.on_rocket_launched, function(event)
-- --     write_event(config.files.rocket, {
-- --         event = "rocket_launched",
-- --         tick = game.tick,
-- --         total_playtime_hours = math.floor(game.tick / 60 / 60)
-- --     })
-- -- end)



-- local function initStorage()
--     storage.playerDeathCount = storage.playerDeathCount or {}
--     storage.rocketLaunched = storage.rocketLaunched or 0
-- end

-- -- Run this on startup
-- script.on_init(initStorage)

local Controller = require("controller")


script.on_init(Controller.on_init)
script.on_load(Controller.on_load)

script.on_event(defines.events.on_player_created, Controller.on_player_created)
script.on_event(defines.events.on_player_joined_game, Controller.on_player_joined_game)
script.on_event(defines.events.on_player_left_game, Controller.on_player_left_game)
script.on_event(defines.events.on_player_died, Controller.on_player_died)



commands.add_command("fc_sim_join", "Simulate a player joining (debug solo)", function(cmd)
    local target = nil

    if cmd.parameter and #cmd.parameter > 0 then
        target = game.get_player(cmd.parameter)
    end

    if not target and cmd.player_index then
        target = game.get_player(cmd.player_index)
    end

    if not target then
        target = game.get_player(1)
    end
    if not target or not target.valid then
        if game and game.print then game.print("[FactoriCord] fc_sim_join: no valid player") end
        return
    end

    Controller.simulate_player_join(target.index)
    if game and game.print then
        game.print("[FactoriCord] Simulated join for " .. target.name)
    end
end)

commands.add_command("fc_sim_leave", "Simulate a player leaving (debug solo)", function(cmd)
    local target = nil

    if cmd.parameter and #cmd.parameter > 0 then
        target = game.get_player(cmd.parameter)
    end

    if not target and cmd.player_index then
        target = game.get_player(cmd.player_index)
    end

    if not target then
        target = game.get_player(1)
    end
    if not target or not target.valid then
        if game and game.print then game.print("[FactoriCord] fc_sim_leave: no valid player") end
        return
    end

    Controller.simulate_player_left(target.index)
    if game and game.print then
        game.print("[FactoriCord] Simulated leave for " .. target.name)
    end
end)