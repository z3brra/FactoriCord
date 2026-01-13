local events = {
    "on_player_joined_game",
    "on_player_left_game",
    "on_player_died",
    "on_research_finished",

    "on_rocket_launched",

    "on_pre_scenario_finished",

    "on_tick",

    "on_factoricord_victory",
}

for _, event in pairs(events) do
    local default = true

    if event == "on_tick" then
        default = false
    end

    data:extend({
        {
            type = "bool-setting",
            name = "jsonlog_" .. event,
            setting_type = "runtime-global",
            default_value = default,
            order = event
        }
    })
end
