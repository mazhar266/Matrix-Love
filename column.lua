-- A single vertical Matrix "rain" stream that owns one column of the grid.
--
-- Unlike a per-cell fade (which produces a marching wave / pattern), a stream
-- is a discrete drop: a bright head glyph followed by a green trail that fades
-- to black, falling at its own random speed. When the whole trail leaves the
-- bottom the stream respawns above the top after a random gap, so the columns
-- never stay in sync -- that desync is what reads as real Matrix rain.
local function column(rows, env)
    -- closure-based factory, matching the project's "class" convention
    local self = {}

    -- a fresh random glyph
    local function rand_char()
        return env.chars[love.math.random(#env.chars)]
    end

    -- random float in [a, b)
    local function frand(a, b)
        return a + (b - a) * love.math.random()
    end

    -- (re)spawn this stream with freshly randomized parameters
    function self.reset(initial)
        self.speed  = frand(env.min_speed, env.max_speed)
        self.length = love.math.random(env.min_trail, env.max_trail)

        if initial then
            -- on the very first frame, scatter heads across (and above) the
            -- screen so the rain starts already in motion instead of empty
            self.head = frand(-self.length, rows)
        else
            -- respawn above the top, after a random gap, so drops don't all
            -- restart together
            self.head = -love.math.random(0, env.max_gap)
        end

        -- every row gets its own glyph; trail glyphs are revealed as the head
        -- passes and mutate over time
        self.glyphs = {}
        for r = 1, rows do
            self.glyphs[r] = rand_char()
        end
    end

    -- advance the stream by dt seconds
    function self.update(dt)
        local prev_row = math.floor(self.head)
        self.head = self.head + self.speed * dt
        local row = math.floor(self.head)

        -- whenever the head steps onto a new row, stamp a fresh glyph there
        if row ~= prev_row and row >= 1 and row <= rows then
            self.glyphs[row] = rand_char()
        end

        -- occasional flicker somewhere in the trail (the classic shimmer)
        if love.math.random() < env.flicker_chance then
            self.glyphs[love.math.random(rows)] = rand_char()
        end

        -- once the entire trail has fallen past the bottom, start over
        if self.head - self.length > rows then
            self.reset(false)
        end
    end

    -- draw the stream; x is the column's left pixel edge
    function self.draw(x, char_width, char_height, font)
        local head = math.floor(self.head)
        for offset = 0, self.length - 1 do
            local r = head - offset
            if r >= 1 and r <= rows then
                local cr, cg, cb
                if offset == 0 then
                    -- bright leading glyph
                    cr, cg, cb = env.head_color[1], env.head_color[2], env.head_color[3]
                else
                    -- fade from bright (just behind the head) to dark (tail);
                    -- squared falloff hugs the head like the real effect
                    local b = (self.length - offset) / self.length
                    b = b * b
                    cr = env.trail_color[1] * b
                    cg = env.trail_color[2] * b
                    cb = env.trail_color[3] * b
                end
                love.graphics.setColor(cr, cg, cb, 1)

                -- center the glyph in its cell so any (even proportional) font
                -- stays grid-aligned
                local glyph = self.glyphs[r]
                local gw = font:getWidth(glyph)
                love.graphics.print(
                    glyph,
                    x + (char_width - gw) * 0.5,
                    (r - 1) * char_height
                )
            end
        end
    end

    -- spawn populated for the first frame
    self.reset(true)

    -- return the instance
    return self
end

return column
