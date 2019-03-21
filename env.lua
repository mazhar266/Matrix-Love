local env = {}

-- the configuration module
function env.get()
    return {
        -- debug mode on or off
        DEBUG = true,
        -- the animation delay
        delay = 0.037,
        -- the secondary / white color delay
        secondary_delay = 0.5,
        -- the actual digit color = green
        primary_color = {0, 255, 0, 1},
        -- the first time digit loading color = white
        secondary_color = {255, 255, 255, 1},
        -- digits
        chars = {
            '0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
        }
    }
end

return env
