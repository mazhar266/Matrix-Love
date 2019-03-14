-- called once the game opened
function love.load()
    x, y = 0, 0
    incr = 1
end

-- called everytime it needs to update frame
function love.update(dt)
    x = x + incr
    y = y + incr

    if x < 1 then
        incr = 1
    end
    
    if x > 300 then
        incr = -1
    end
end

-- draw wherever I want here
function love.draw()
    love.graphics.print('Hello World!', x, y)
end
