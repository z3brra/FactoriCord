local Time = {}

Time.TICKS_PER_SECOND = 60
Time.TICKS_PER_MINUTE = 60 * Time.TICKS_PER_SECOND
Time.TICKS_PER_HOUR = 60 * Time.TICKS_PER_MINUTE
Time.TICKS_PER_DAY = 24 * Time.TICKS_PER_HOUR

--- Convert tick int into readble table
--- @param ticks integer
--- @return table
function Time.from_ticks(ticks)
    local seconds_total = math.floor(ticks / Time.TICKS_PER_SECOND)
    local minutes_total = math.floor(seconds_total / 60)
    local hours_total = math.floor(minutes_total / 60)
    local days_total = math.floor(hours_total / 24)

    local seconds = seconds_total % 60
    local minutes = minutes_total % 60
    local hours = hours_total % 24

    return {
        ticks = ticks,
        seconds_total = seconds_total,
        days = days_total,
        hours = hours,
        minutes = minutes,
        seconds = seconds,
        formatted = string.format("%02dd %02dh %02dm %02ds", days_total, hours, minutes, seconds),
        short = string.format("%02d:%02d:%02d", hours, minutes, seconds)
    }
end

--- Calculate duration between 2 ticks
--- @param start_tick integer
--- @param end_tick integer
--- @return table
function Time.delta(start_tick, end_tick)
    return Time.from_ticks((end_tick or game.tick) - (start_tick or 0))
end

--- Format ticks into readable time HH:MM:SS
--- @param ticks integer
--- @return string
function Time.format(ticks)
    local time = Time.from_ticks(ticks)
    return time.short
end


return Time