local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local menubar = require("menubar")
local gears = require("gears")
local rubato = require("modules").rubato
local helpers = require("helpers")

require("signals.naughty.playerctl")

---------------------------
-- NAUGHTY CONFIGURATION --
---------------------------
naughty.config.defaults.ontop = true
naughty.config.defaults.timeout = 10
naughty.config.defaults.title = "System Notification"
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = dpi(10)
naughty.config.presets.low.timeout = 10
naughty.config.presets.critical.timeout = 0

naughty.connect_signal("request::icon", function(n, context, hints)
    if context ~= "app_icon" then
        return
    end

    local path = menubar.utils.lookup_icon(hints.app_icon) or menubar.utils.lookup_icon(hints.app_icon:lower())

    if path then
        n.icon = path
    end
end)

naughty.connect_signal("request::display_error", function(message, startup)
    naughty.notification({
        urgency = "critical",
        title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
        message = message,
    })
end)

naughty.connect_signal("request::display", function(n)
    -- action widget
    local action_widget = {
        {
            {
                id = "text_role",
                align = "center",
                valign = "center",
                font = beautiful.font,
                widget = wibox.widget.textbox,
            },
            left = dpi(6),
            right = dpi(6),
            widget = wibox.container.margin,
        },
        bg = helpers.math.lighten(beautiful.bg_normal, 5),
        forced_height = dpi(30),
        shape = helpers.shape.rrect(dpi(2)),
        widget = wibox.container.background,
    }

    -- actions
    local actions = wibox.widget({
        notification = n,
        base_layout = wibox.widget({
            spacing = dpi(8),
            layout = wibox.layout.flex.horizontal,
        }),
        widget_template = action_widget,
        style = { underline_normal = false, underline_selected = true },
        widget = naughty.list.actions,
    })

    -- image
    local image_n = wibox.widget({
        {
            {
                opacity = 0.9,
                image = n.icon or gears.filesystem.get_configuration_dir() .. "assets/" .. "distro_logo.png",
                resize = true,
                halign = "center",
                valign = "center",
                clip_shape = helpers.shape.rrect(dpi(50)),
                widget = wibox.widget.imagebox,
            },
            strategy = "exact",
            height = dpi(60),
            width = dpi(60),
            widget = wibox.container.constraint,
        },
        id = "arc",
        widget = wibox.container.arcchart,
        max_value = 100,
        min_value = 0,
        value = 100,
        rounded_edge = true,
        thickness = dpi(4),
        start_angle = 4.71238898,
        bg = helpers.math.lighten(beautiful.bg_normal, 10),
        colors = { beautiful.accent_blue },
        forced_width = dpi(65),
        forced_height = dpi(65),
    })

    local anim = rubato.timed({
        duration = 5,
        subscribed = function(pos)
            image_n:get_children_by_id("arc")[1].value = pos

            if pos >= 100 then
                n:destroy()
            end
        end,
    })

    -- title
    local title_n = wibox.widget({
        {
            {
                markup = n.title,
                font = beautiful.font_name .. "Bold 11",
                align = "left",
                valign = "center",
                widget = wibox.widget.textbox,
            },
            forced_width = dpi(240),
            widget = wibox.container.scroll.horizontal,
            step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
            speed = 50,
        },
        margins = { right = 15 },
        widget = wibox.container.margin,
    })

    local message_n = wibox.widget({
        {
            {
                markup = helpers.text.colorize_text(
                    "<span weight='normal'>" .. n.message .. "</span>",
                    beautiful.fg_normal .. "BF"
                ),
                font = beautiful.font_name .. "9",
                align = "left",
                valign = "center",
                wrap = "char",
                widget = wibox.widget.textbox,
            },
            forced_width = dpi(240),
            layout = wibox.layout.fixed.horizontal,
        },
        margins = { right = 15 },
        widget = wibox.container.margin,
    })

    -- app name
    local aname = ""
    if n.app_name ~= "" then
        aname = n.app_name
    else
        aname = "naughty"
    end
    local app_name_n = wibox.widget({
        markup = helpers.text.colorize_text(aname, beautiful.fg_normal .. "BF"),
        font = beautiful.font,
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox,
    })

    local time_n = wibox.widget({
        {
            markup = helpers.text.colorize_text("now", beautiful.fg_normal .. "BF"),
            font = beautiful.font,
            align = "right",
            valign = "center",
            widget = wibox.widget.textbox,
        },
        margins = { right = 20 },
        widget = wibox.container.margin,
    })

    local close = wibox.widget({
        markup = helpers.text.colorize_text("󰝥", beautiful.fg_urgent),
        font = beautiful.font_name .. "10",
        align = "ceneter",
        valign = "center",
        widget = wibox.widget.textbox,
    })

    close:buttons(gears.table.join(awful.button({}, 1, function()
        n:destroy(naughty.notification_closed_reason.dismissed_by_user)
    end)))

    -- extra info
    local notif_info = wibox.widget({
        app_name_n,
        {
            widget = wibox.widget.separator,
            shape = gears.shape.circle,
            forced_height = dpi(4),
            forced_width = dpi(4),
            color = beautiful.fg_normal .. "BF",
        },
        time_n,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(7),
    })

    local widget = naughty.layout.box({
        notification = n,
        bg = beautiful.bg_normal .. "00",
        shape = helpers.shape.rrect(0),
        widget_template = {
            {
                {
                    {
                        {
                            {
                                notif_info,
                                nil,
                                close,
                                layout = wibox.layout.align.horizontal,
                                expand = "none",
                            },
                            margins = { left = dpi(15), right = dpi(15), top = dpi(10), bottom = dpi(10) },
                            widget = wibox.container.margin,
                        },
                        widget = wibox.container.background,
                        bg = helpers.math.lighten(beautiful.bg_focus, -15),
                    },
                    layout = wibox.layout.fixed.vertical,
                },
                {
                    -- body
                    {
                        {
                            title_n,
                            message_n,
                            layout = wibox.layout.fixed.vertical,
                            spacing = dpi(3),
                        },
                        nil,
                        image_n,
                        layout = wibox.layout.align.horizontal,
                        expand = "none",
                    },
                    margins = { left = dpi(15), top = dpi(10), right = dpi(10) },
                    widget = wibox.container.margin,
                },
                {
                    actions,
                    margins = dpi(10),
                    widget = wibox.container.margin,
                },
                layout = wibox.layout.fixed.vertical,
                spacing = dpi(10),
            },
            widget = wibox.container.background,
            shape = helpers.shape.rrect(dpi(8)),
            border_width = dpi(1),
            border_color = helpers.math.lighten(beautiful.bg_normal, -5),
            bg = beautiful.bg_normal,
        },
    })

    widget.buttons = {}
    anim.target = 100
end)
