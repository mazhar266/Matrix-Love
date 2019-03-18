-- called once the game opened
function love.load()
    x, y = 0, 0
    incr = 1
end

-- called everytime it needs to update frame
function love.update(dt)
    x = x + (incr * 2)
    y = y + (incr * 2)

    if x < 1 then
        incr = 1
    end
    
    if x > 300 then
        incr = -1
    end
end

-- draw wherever I want here
function love.draw()
    love.graphics.setColor(0, 255, 0, 1)
    love.graphics.print('Hello World!', x, y)
    -- draw the FPS
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()), 700, 580)
end
