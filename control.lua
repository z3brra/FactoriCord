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