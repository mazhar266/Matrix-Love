-- debug mode shows the FPS
DEBUG = true

-- called once the game opened
function love.load()
    -- first make an empty screen of chars
    screens = {}
    -- inspect the viewport and init the constants
    screen_width = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()
    char_width = 10
    char_height = 12
    -- now make random chars
    for i = 0, screen_width / char_width, 1
    do
        screens[i] = {}
        for j = 0, screen_height / char_height, 1
        do
            screens[i][j] = 1
        end
        
    end
end

-- called everytime it needs to update frame
function love.update(dt)
    -- TODO
end

-- draw wherever I want here
function love.draw()
    -- set the green color
    love.graphics.setColor(0, 255, 0, 1)

    -- render the screens list
    for i = 0, #screens, 1
    do
        for j = 0, #screens[i], 1
        do
            love.graphics.print(screens[i][j], i * char_width, j * char_height)
        end
    end
    
    -- draw the FPS
    if DEBUG then
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle("fill", 695, 575, 500, 500 )
        love.graphics.setColor(0, 255, 0, 1)
        love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 700, 580)
    end
end
