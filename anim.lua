env = require("env").get()

local function anim()
    local self = {
        -- public fields go in the instance table
        x = {}
    }

    -- gets the char at d time after dt fraction
    function self.get(d, dt)
        -- only update on 0.2s
        if d % 0.2 < 0.1 then
            return false
        end

        -- if the opacity hits 0, reset the digit
        if self.x[4] <= 0 then
            self.x = {}
        end

        -- see if the char is set, else set it
        if self.x == {} then
            -- take a random char
            self.x = {
                env.chars[math.random(#env.chars)],
                env['secondary_color'][0],
                env['secondary_color'][1],
                env['secondary_color'][2],
                env['secondary_color'][3]
            }
            return self.x
        end

        -- alter the secondary color with primary
        if self.x[2] == 255 then
            self.x[2] = env['primary_color'][1]
            self.x[3] = env['primary_color'][2]
            self.x[4] = env['primary_color'][3]
            self.x[5] = env['primary_color'][4]
            return x
        end

        -- just decrease the opacity and return it
        self.x[5] = self.x[5] - 0.01
        return self.x
    end

    function self.get_color()
        return self.x[2], self.x[3], self.x[4], self.x[5]
    end

    function self.get_digit()
        return self.x[1]
    end

    -- return the instance
    return self
end

return anim
