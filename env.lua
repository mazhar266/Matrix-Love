local env = {}

function env.get()
    return {
        delay = 0.037,
        secondary_delay = 0.5,
        primary_color = {0, 255, 0, 1},
        secondary_color = {255, 255, 255, 1},
        chars = {
            '0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
        }
    }
end

return env
