env = require("env").get()

local function anim()
    local self = {
        -- public fields go in the instance table
        x = {
            env.chars[math.random(#env.chars)],
            env['primary_color'][1],
            env['primary_color'][2],
            env['primary_color'][3],
            env['primary_color'][4]
        }
    }

    -- gets the char at d time after dt fraction
    function self.get(d, dt)
        -- only update on 0.2s
        -- if d % env['delay'] < 0.1 then
        --     return false
        -- end

        -- if the opacity hits 0, reset the digit
        if self.x[5] <= 0 or self.x[5] == nil then
            self.x = {}
        end

        -- see if the char is set, else set it
        if self.x[5] == nil then
            -- take a random char
            self.x = {
                env.chars[math.random(#env.chars)],
                env['secondary_color'][1],
                env['secondary_color'][2],
                env['secondary_color'][3],
                env['secondary_color'][4]
            }
            return self.x
        end

        -- alter the secondary color with primary
        -- comparing numbers makes it speedy
        if self.x[2] == env['secondary_color'][1] and d % env['secondary_delay'] < 0.01 then
            self.x[2] = env['primary_color'][1]
            self.x[3] = env['primary_color'][2]
            self.x[4] = env['primary_color'][3]
            self.x[5] = env['primary_color'][4]
            return self.x
        end

        -- just decrease the opacity and return it
        if self.x[2] ~= env['secondary_color'][1] then
            self.x[5] = self.x[5] - 0.005
        end
        
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
