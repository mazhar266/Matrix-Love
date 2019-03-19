anim = require("anim")

-- debug mode shows the FPS
DEBUG = true

-- called once the game opened
function love.load()
    -- running time is 0s at the beginning
    running_time = 0
    -- first make an empty screen of chars
    screens = {}
    -- inspect the viewport and init the constants
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    -- size of a digit
    char_width = 10
    char_height = 12

    -- now make random chars
    for i = 0, screen_width / char_width, 1
    do
        screens[i] = {}
        for j = 0, screen_height / char_height, 1
        do
            screens[i][j] = anim()
        end
        
    end
end

-- called everytime it needs to update frame
function love.update(dt)
    -- update the time the game is running
    -- old_running_time = running_time
    running_time = running_time + dt

    -- now make random chars
    -- if math.floor(old_running_time) < math.floor(running_time) then
        for i = 0, screen_width / char_width, 1
        do
            for j = 0, screen_height / char_height, 1
            do
                screens[i][j].get(running_time, dt)
            end
            
        end
    -- end
end

-- draw wherever I want here
function love.draw()
    -- render the screens list
    for i = 0, #screens, 1
    do
        for j = 0, #screens[i], 1
        do
            -- set the decided color
            -- print(screens[i][j].get_color())
            love.graphics.setColor(screens[i][j].get_color())
            love.graphics.print(screens[i][j].get_digit(), i * char_width, j * char_height)
        end
    end
    
    -- draw the FPS
    if DEBUG then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle(
            "fill",
            screen_width - 105,
            screen_height - 45,
            500, -- just keep it larger than the message
            500  -- just keep it larger than the message too
        )
        love.graphics.setColor(0, 255, 0, 1)
        love.graphics.print(
            'Current FPS: ' .. tostring(love.timer.getFPS()),
            screen_width - 100,
            screen_height - 20
        )
        love.graphics.print(
            'Runtime: ' .. string.format("%0.1f", running_time) .. 's',
            screen_width - 100,
            screen_height - 40
        )
    end
end
