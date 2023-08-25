local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local client = client

-- Remove border when only one window
local function set_border(c)
    local s = awful.screen.focused()
    if c.class ~= "steam" then
        if
            c.maximized
            or (#s.tiled_clients == 1 and not c.floating)
            or (s.selected_tag and s.selected_tag.layout.name == "max")
        then
            c.border_width = 0
            awful.titlebar.hide(c)
            -- c.shape = helpers.shape.rrect(0)
        else
            c.border_width = beautiful.border_width
            awful.titlebar.show(c)
            -- c.shape = helpers.shape.rrect(beautiful.client_border_radius)
        end
    end
end

client.connect_signal("request::border", set_border)
client.connect_signal("property::maximized", set_border)
