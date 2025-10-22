local Time = require("scripts.sensors.time")

local SessionSensor = {}

--- Calculate the player session duration
--- @param start_tic integer
---@param end_tick integer
---@return table
function SessionSensor.calculate_session_time(start_tic, end_tick)
    return Time.delta(start_tic, end_tick)
end

return SessionSensor