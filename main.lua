column = require("column")
env = require("env").get()

-- debug mode shows the FPS and grid info
DEBUG = env['DEBUG']

-- (re)build the grid for the current viewport: choose a font sized to the
-- monitor, then derive the cell size and column count from that font.
local function build()
    -- viewport in the graphics coordinate system (drawing uses these same
    -- units, so layout and rendering stay pixel-aligned at any DPI)
    screen_width  = love.graphics.getWidth()
    screen_height = love.graphics.getHeight()

    -- size the font so ~target_rows rows fill the height. because this is
    -- relative to the actual screen height (in device pixels when highdpi is
    -- on), the glyphs scale with the monitor's resolution and pixel density
    -- instead of being a fixed, tiny 12px.
    local font_size = math.max(
        env['min_font_size'],
        math.floor(screen_height / env['target_rows'])
    )
    font = love.graphics.newFont(font_size)
    love.graphics.setFont(font)

    -- cell height comes straight from the font; cell width is the widest
    -- glyph (× spacing) so the grid stays aligned with any font
    char_height = font:getHeight()
    char_width = 0
    for _, c in ipairs(env['chars']) do
        char_width = math.max(char_width, font:getWidth(c))
    end
    char_width = math.ceil(char_width * env['char_spacing'])

    cols = math.ceil(screen_width / char_width)
    rows = math.ceil(screen_height / char_height)

    -- one independent falling stream per column
    columns = {}
    for i = 1, cols do
        columns[i] = column(rows, env)
    end
end

-- called once when the game opens
function love.load()
    -- seed the RNG so every run looks different
    love.math.setRandomSeed(os.time())
    for _ = 1, 8 do love.math.random() end

    love.graphics.setBackgroundColor(0, 0, 0)

    -- running time is 0s at the beginning, no frames drawn yet
    running_time = 0
    total_frames = 0

    build()
end

-- rebuild if the window/monitor size ever changes
function love.resize()
    build()
end

-- press 'q' to stop and exit the animation
function love.keypressed(key)
    if key == 'q' then
        love.event.quit()
    end
end

-- called every time it needs to update a frame
function love.update(dt)
    running_time = running_time + dt
    total_frames = total_frames + 1

    for i = 1, cols do
        columns[i].update(dt)
    end
end

-- draw the debug overlay (bottom-right)
local function draw_debug()
    local lines = {
        'FPS: ' .. love.timer.getFPS(),
        string.format('Runtime: %.1fs', running_time),
        'Frames: ' .. total_frames,
        'Grid: ' .. cols .. ' x ' .. rows,
        'Font: ' .. font:getHeight() .. 'px'
    }

    local pad = math.floor(char_height * 0.5)
    local line_h = font:getHeight()
    local box_w = 0
    for _, l in ipairs(lines) do
        box_w = math.max(box_w, font:getWidth(l))
    end
    box_w = box_w + pad * 2
    local box_h = line_h * #lines + pad * 2
    local x = screen_width - box_w - pad
    local y = screen_height - box_h - pad

    love.graphics.setColor(0, 0, 0, 0.7)
    love.graphics.rectangle('fill', x, y, box_w, box_h)
    love.graphics.setColor(0, 1, 0, 1)
    for i, l in ipairs(lines) do
        love.graphics.print(l, x + pad, y + pad + (i - 1) * line_h)
    end
end

-- render the rain
function love.draw()
    for i = 1, cols do
        columns[i].draw((i - 1) * char_width, char_width, char_height, font)
    end

    if DEBUG then
        draw_debug()
    end
end
