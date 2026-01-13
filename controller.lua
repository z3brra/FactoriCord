local player_data = require("scripts.player_data")
local Players = require("scripts.handlers.players")
local Fight = require("scripts.handlers.fight")
local Research = require("scripts.handlers.research")
local Rocket = require("scripts.handlers.rocket")
local Victory = require("scripts.handlers.victory")
local VictoryService = require("scripts.services.victory_service")

--- @class Controller
local Controller = {}

function Controller.init_global()
    storage.players = storage.players or {}
    storage.events_data = storage.events_data or {}
    VictoryService.init_global()
end

function Controller.on_init()
    Controller.init_global()
    for _, player in pairs(game.players) do
        player_data.init(player.index)
    end
end

function Controller.on_load()
--     Controller.init_global()
end

function Controller.on_configuration_changed(cfg)
    Controller.init_global()
end

Controller.on_player_created = Players.on_player_created
Controller.on_player_joined_game = Players.on_player_joined_game
Controller.on_player_left_game = Players.on_player_left_game

Controller.on_player_died = Fight.on_player_died

Controller.on_research_finished = Research.on_research_finished

Controller.on_rocket_launched = Rocket.on_rocket_launched

Controller.on_pre_scenario_finished = Victory.on_pre_scenario_finished
Controller.on_tick = Victory.on_tick

return Controller
