char = require("char")
env = require("env").get()

local anim = {}
local x = false
local opacity = 1

-- gets the char at d time after dt fraction
function anim.get(d, dt)
    -- only update on 0.2s
    if d % 0.2 < 0.1 then
        return false
    end

    -- if the opacity hits 0, reset the digit
    if x[4] <= 0 then
        x = false
    end

    -- see if the char is set, else set it
    if !x then
        -- take a random char
        x = {
            env.chars[math.random(#env.chars)],
            env['secondary_color'][0],
            env['secondary_color'][1],
            env['secondary_color'][2],
            env['secondary_color'][3]
        }
        return x
    end

    -- alter the secondary color with primary
    if x[1] == 255 then
        x[1] = env['primary_color'][0]
        x[2] = env['primary_color'][1]
        x[3] = env['primary_color'][2]
        x[4] = env['primary_color'][3]
        return x
    end

    -- just decrease the opacity and return it
    x[4] = x[4] - 0.01
    return x
end

return anim
