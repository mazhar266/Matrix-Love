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
        },
        times = 0
    }

    -- gets the char at d time after dt fraction
    function self.get(d, dt)
        -- only update on 0.2s
        -- if d % env['delay'] < 0.1 then
        --     return false
        -- end

        -- increase the time
        self.times = self.times + 1

        -- if the opacity hits 0, reset the digit
        if self.x[5] <= 0 or self.x[5] == nil then
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
        -- TODO keep the white digit longer like 0.2 ~ 0.5s
        if self.x[2] == env['secondary_color'][1] then
            --d % env['secondary_delay'] < 0.01 then
            self.x[2] = env['primary_color'][1]
            self.x[3] = env['primary_color'][2]
            self.x[4] = env['primary_color'][3]
            self.x[5] = env['primary_color'][4] - dt
            return self.x
        end

        -- just decrease the opacity and return it
        if self.x[2] ~= env['secondary_color'][1] then
            -- minus the dt to make the animation smoother
            self.x[5] = self.x[5] - dt
        end
        
        return self.x
    end

    function self.get_color()
        return self.x[2], self.x[3], self.x[4], self.x[5]
    end

    function self.get_digit()
        return self.x[1]
    end

    function self.init(d)
        if self.times == 0 then
            for i = 0, math.floor(d / env['delay']), 1
            do
                -- reach that time period
                self.get(d, env['delay'])
            end
        end
    end

    -- return the instance
    return self
end

return anim
