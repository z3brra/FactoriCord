local Time = require("scripts.sensors.time")

local SessionSensor = {}

--- Calculate the player session duration
--- @param start_tick integer
---@param end_tick integer
---@return table
function SessionSensor.calculate_session_time(start_tick, end_tick)
    return Time.delta(start_tick, end_tick)
end

return SessionSensor