local Controller = require("controller")
local Utils = require("scripts.utils")

local function discover_event_handlers()
    local handlers = {}

    for key, callable in pairs(Controller) do
        if type(callable) == "function" and key:sub(1, 3) == "on_" then
            local defines_event_name = defines.events[key]

            if defines_event_name then
                handlers[#handlers+1] = {
                    name = key,
                    callable = callable,
                    event_id = defines_event_name
                }
            else
                log("[FactoriCord] Warning: No defines.events entry for Controller function '" .. key .. "'")
            end
        end
    end

    return handlers
end

local dynamic_handlers = discover_event_handlers()

local function register_events()
    for _, handler in pairs(dynamic_handlers) do
        if Utils.is_event_enabled(handler.name) then
            script.on_event(handler.event_id, handler.callable)
            log("[FactoriCord] Enabled event : " .. handler.name)
        else
            script.on_event(handler.event_id, nil)
            log("[FactoriCord] Disabled event : " .. handler.name)
        end
    end
end

script.on_init(function()
    if Controller.on_init then
        Controller.on_init()
    end
    register_events()
end)

script.on_load(function()
    if Controller.on_load then
        Controller.on_load()
    end
    register_events()
end)

script.on_event(defines.events.on_runtime_mod_setting_changed, function(e)
    if e.setting:sub(1, 8) == "jsonlog_" then
        register_events()
    end
end)



--- Debug commands to simulate player join/leave in local mode
-- local function resolve_target(cmd)
--     local target = nil

--     if cmd.parameter and #cmd.parameter > 0 then
--         target = game.get_player(cmd.parameter)
--     end

--     if not target and cmd.player_index then
--         target = game.get_player(cmd.player_index)
--     end

--     if not target then
--         target = game.get_player(1)
--     end
--     return target
-- end

-- commands.add_command("fc_sim_join", "Simulate a player joining (debug solo)", function(cmd)
--     local player = resolve_target(cmd)
--     if not player or not player.valid then
--         if game and game.print then game.print("[FactoriCord] fc_sim_join: no valid player") end
--         return
--     end

--     Controller.simulate_player_join(player.index)
--     if game and game.print then
--         game.print("[FactoriCord] Simulated join for " .. player.name)
--     end
-- end)

-- commands.add_command("fc_sim_leave", "Simulate a player leaving (debug solo)", function(cmd)
--     local player = resolve_target(cmd)
--     if not player or not player.valid then
--         if game and game.print then game.print("[FactoriCord] fc_sim_leave: no valid player") end
--         return
--     end

--     Controller.simulate_player_left(player.index)
--     if game and game.print then
--         game.print("[FactoriCord] Simulated leave for " .. player.name)
--     end
-- end)

-- commands.add_command("fc_win", "Simulate victory", function(cmd)
--     game.set_game_state{
--         game_finished = true,
--         player_won = true,
--         can_continue = true
--     }
-- end)