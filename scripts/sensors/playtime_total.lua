local Time = require("scripts.sensors.time")

local PlaytimeSensor = {}

--- Return map total playtime
--- @return table
function PlaytimeSensor.get_playtime_total()
    return Time.from_ticks(game.ticks_played)
end

return PlaytimeSensor