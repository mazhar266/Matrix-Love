char = require("char")
env = require("env").get()

local anim = {}
local x = false

-- gets the char at d time after dt fraction
function anim.get(d, dt)
    -- see if the char is set, else set it
    if !x then
        -- take a random char
        x = env.chars[math.random(#env.chars)]
        return x,
            env['primary_color'][0],
            env['primary_color'][1],
            env['primary_color'][2]
    end
end

return anim
