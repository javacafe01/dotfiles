local gears = require("gears")

local helpers = {}

-- Create rounded rectangle shape (in one line)
helpers.rrect = function(radius)
    return function(cr, width, height)
        gears.shape.rounded_rect(cr, width, height, radius)
    end
end

-- Create partially rounded rect
helpers.prrect = function(radius, tl, tr, br, bl)
    return function(cr, width, height)
        gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
    end
end

helpers.x = function(width, height, thickness)
    return function(cr)
        gears.shape
            .transform(gears.shape.cross)
            :rotate_at(width / 2, height / 2, math.pi / 4)(cr, width, height, thickness)
    end
end

helpers.dot = function(width, height)
    return function(cr)
        gears.shape.circle(cr, width, height)
    end
end

return helpers
