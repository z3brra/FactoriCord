--- @class VictoryService
local VictoryService = {}

function VictoryService.init_global()
  storage._fc_victory_done = storage._fc_victory_done or false
  storage._fc_victory_source = storage._fc_victory_source
  storage._fc_victory_detected_by = storage._fc_victory_detected_by
  storage._fc_victory_first_seen_tick = storage._fc_victory_first_seen_tick
  storage._fc_last_finished = storage._fc_last_finished or false
end

--- Trigger victory once and call the callback to write the event
--- @param source string
--- @param detected_by string
--- @param e table
--- @param write_callback fun(e: table)
function VictoryService.trigger_once(source, detected_by, e, write_callback)
    if storage._fc_victory_done then return end
    storage._fc_victory_done = true
    storage._fc_victory_source = source
    storage._fc_victory_detected_by = detected_by
    storage._fc_victory_first_seen_tick = game.tick
    write_callback(e)
end

return VictoryService