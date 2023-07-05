local beautiful = require("beautiful")
local naughty = require("naughty")

---------------------------
-- NAUGHTY CONFIGURATION --
---------------------------
naughty.config.defaults.ontop = true
naughty.config.defaults.icon_size = beautiful.notification_icon_size
naughty.config.defaults.timeout = 10
naughty.config.defaults.hover_timeout = 300
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.margin = beautiful.notification_margin
naughty.config.defaults.border_width = beautiful.notification_border_width
naughty.config.defaults.position = "top_right"
naughty.config.defaults.shape = beautiful.notification_shape

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message,
    })
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box({ notification = n })
end)
