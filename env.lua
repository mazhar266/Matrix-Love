local env = {}

function env.get()
    return {
        primary_color = {0, 255, 0, 1},
        secondary_color = {255, 255, 255, 1},
        chars = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}
    }
end

return env
