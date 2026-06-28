local env = {}

-- the configuration module: the single place to tune the look & feel
function env.get()
    return {
        -- debug mode shows FPS / runtime / grid info overlay
        DEBUG = false,

        ----------------------------------------------------------------
        -- sizing (scales the text to the monitor)
        ----------------------------------------------------------------
        -- how many character rows should fill the screen height.
        -- the font size is derived from this, so the text scales with the
        -- monitor's resolution / pixel density instead of being fixed.
        -- smaller number  => bigger glyphs.
        target_rows = 45,
        -- never render the font smaller than this many pixels
        min_font_size = 14,
        -- horizontal cell width relative to the widest glyph (1.0 = tight)
        char_spacing = 1.05,

        ----------------------------------------------------------------
        -- colors (LÖVE 11 uses 0..1 per channel)
        ----------------------------------------------------------------
        -- the bright leading glyph of a stream (near white with a green tint)
        head_color = {0.78, 1.0, 0.78},
        -- the falling trail color (classic Matrix green)
        trail_color = {0.0, 1.0, 0.27},

        ----------------------------------------------------------------
        -- rain behavior (each stream randomizes within these ranges)
        ----------------------------------------------------------------
        -- fall speed in rows per second
        min_speed = 7,
        max_speed = 24,
        -- visible trail length in rows
        min_trail = 6,
        max_trail = 30,
        -- empty rows left above a respawning stream so columns desync
        -- (this is what creates the gaps between drops)
        max_gap = 28,
        -- per-stream, per-frame chance to mutate a random glyph in the trail
        flicker_chance = 0.08,

        ----------------------------------------------------------------
        -- glyphs
        ----------------------------------------------------------------
        chars = {
            '0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
        }
    }
end

return env
