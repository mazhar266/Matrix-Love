anim = require("anim")
env = require("env").get()

-- debug mode shows the FPS
DEBUG = env['DEBUG']

-- called once the game opened
function love.load()
    -- running time is 0s at the beginning
    running_time = 0
    -- keep the frames as 0
    total_frames = 0
    -- first make an empty screen of chars
    screens = {}
    -- inspect the viewport and init the constants
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    -- size of a digit
    char_width = 10
    char_height = 12

    -- let previous random number be zero
    previous_rand = 0

    -- now make random chars
    for i = 0, screen_width / char_width, 1
    do
        -- define the empty table / list
        screens[i] = {}

        -- make the random value constant for a column
        rand = previous_rand
        -- avoid the previous rand value
        while rand == previous_rand
        do
            rand = math.random(math.floor(screen_height / char_height))
        end
        -- save the value as previous rand value
        previous_rand = rand

        for j = 0, screen_height / char_height, 1
        do
            -- add a new anim obj
            screens[i][j] = anim()
            -- initialize according to the desired value
            screens[i][j].init(
                (2*(screen_height / char_height) - (j + rand)) * env['delay'],
                env['delay']
            )
        end
        
    end
end

-- called everytime it needs to update frame
function love.update(dt)
    -- update the time the game is running
    -- old_running_time = running_time
    running_time = running_time + dt
    -- update the frame count
    total_frames = total_frames + 1

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
            love.graphics.setColor(screens[i][j].get_color())
            -- now print the digit
            love.graphics.print(screens[i][j].get_digit(), i * char_width, j * char_height)
        end
    end
    
    -- draw the FPS and other debug info
    if DEBUG then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle(
            "fill",
            screen_width - 115,
            screen_height - 65,
            500, -- just keep it larger than the message
            500  -- just keep it larger than the message too
        )
        love.graphics.setColor(0, 255, 0, 1)
        -- print the framerate
        love.graphics.print(
            'Current FPS: ' .. tostring(love.timer.getFPS()),
            screen_width - 110,
            screen_height - 20
        )
        -- print the total time in second
        love.graphics.print(
            'Runtime: ' .. string.format("%0.1f", running_time) .. 's',
            screen_width - 110,
            screen_height - 40
        )
        -- print the total frames rendered
        love.graphics.print(
            'Frames: ' .. tostring(total_frames),
            screen_width - 110,
            screen_height - 60
        )
    end
end
