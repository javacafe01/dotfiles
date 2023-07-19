local _M = {}

local awful = require("awful")
local hotkeys_popup = require("awful.hotkeys_popup")
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi
local wibox = require("wibox")
local menubar = require("menubar")
local helpers = require("helpers")
local awesome = awesome

local get_taglist = require("widgets.wibar.modules.taglist")

_M.volume_bar = wibox.widget({
    max_value = 100,
    value = 70,
    forced_width = dpi(100),
    bar_shape = helpers.shape.rrect(dpi(6)),
    shape = helpers.shape.rrect(dpi(6)),
    color = beautiful.bg_focus,
    background_color = helpers.math.lighten(beautiful.bg_normal, -3),
    widget = wibox.widget.progressbar,
})

-- helpers.widget.add_hover_cursor(_M.battery_bar, "hand2")

awesome.connect_signal("signal::volume", function(volume, muted)
    _M.volume_bar.value = volume

    if muted then
        _M.volume_bar.color = helpers.math.lighten(beautiful.bg_focus, -15)
    else
        _M.volume_bar.color = beautiful.bg_focus
    end
end)

_M.menu = awful.widget.button({
    image = beautiful.theme_assets.awesome_icon(beautiful.wibar_height, beautiful.bg_focus, beautiful.bg_normal),
    clip_shape = helpers.shape.rrect(dpi(6)),
    forced_height = beautiful.wibar_height,
    forced_width = beautiful.wibar_height,
    resize = true,
    buttons = { awful.button({}, 1, nil, function()
        menubar.show()
    end) },
})

_M.keyboardlayout = awful.widget.keyboardlayout()
_M.textclock = wibox.widget.textclock()

function _M.create_promptbox()
    return awful.widget.prompt()
end

function _M.create_layoutbox(s)
    return awful.widget.layoutbox({
        screen = s,
        buttons = {
            awful.button({
                modifiers = {},
                button = 1,
                on_press = function()
                    awful.layout.inc(1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 3,
                on_press = function()
                    awful.layout.inc(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 4,
                on_press = function()
                    awful.layout.inc(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 5,
                on_press = function()
                    awful.layout.inc(1)
                end,
            }),
        },
    })
end

function _M.create_taglist(s)
    return get_taglist(s)
end

function _M.create_tasklist(s)
    return awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        layout = { spacing = 1, layout = wibox.layout.fixed.horizontal },
        buttons = {
            awful.button({
                modifiers = {},
                button = 1,
                on_press = function(c)
                    c:activate({
                        context = "tasklist",
                        action = "toggle_minimization",
                    })
                end,
            }),
            awful.button({
                modifiers = {},
                button = 3,
                on_press = function()
                    awful.menu.client_list({ theme = { width = 250 } })
                end,
            }),
            awful.button({
                modifiers = {},
                button = 4,
                on_press = function()
                    awful.client.focus.byidx(-1)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 5,
                on_press = function()
                    awful.client.focus.byidx(1)
                end,
            }),
        },
        widget_template = {
            {
                wibox.widget.base.make_widget(),
                forced_height = dpi(2),
                id = "background_role",
                widget = wibox.container.background,
            },
            {
                awful.widget.clienticon,
                top = dpi(7),
                left = dpi(10),
                right = dpi(8),
                bottom = dpi(9),
                widget = wibox.container.margin,
            },
            nil,
            layout = wibox.layout.align.vertical,
        },
    })
end

function _M.create_wibox(s)
    return awful.wibar({
        screen = s,
        position = "top",
        height = beautiful.wibar_height,
        widget = {
            layout = wibox.layout.align.horizontal,
            expand = "none",
            -- left widgets
            {
                layout = wibox.layout.fixed.horizontal,
                {
                    {
                        {
                            _M.menu,
                            margins = dpi(5),
                            widget = wibox.container.margin,
                        },
                        shape = helpers.shape.rrect(dpi(6)),
                        bg = helpers.math.lighten(beautiful.bg_normal, 10),
                        widget = wibox.container.background,
                    },
                    margins = dpi(6),
                    widget = wibox.container.margin,
                },
                s.tasklist,
                s.promptbox,
            },
            -- middle widgets
            { s.taglist, margins = dpi(6), widget = wibox.container.margin },
            -- right widgets
            {
                layout = wibox.layout.fixed.horizontal,
                spacing = dpi(5),
                {
                    {
                        {
                            widget = wibox.widget.systray,
                            base_size = beautiful.systray_icon_size,
                        },
                        valign = "center",
                        widget = wibox.container.place,
                    },
                    margins = dpi(0),
                    widget = wibox.container.margin,
                },
                { _M.volume_bar, margins = dpi(12), widget = wibox.container.margin },
                { _M.textclock, right = dpi(8), widget = wibox.container.margin },
                {
                    {
                        s.layoutbox,
                        margins = dpi(10),
                        widget = wibox.container.margin,
                    },
                    bg = helpers.math.lighten(beautiful.bg_normal, 10),
                    widget = wibox.container.background,
                },
            },
        },
    })
end

return _M
