local awful = require("awful")
local wibox = require("wibox")
local helpers = require("helpers")
local rubato = require("modules").rubato
local beautiful = require("beautiful")
local xresources = beautiful.xresources
local dpi = xresources.apply_dpi
local client = client

local mod = require("bindings.mod")

return function(s)
    local taglist = awful.widget.taglist({
        layout = wibox.layout.fixed.horizontal,
        screen = s,
        filter = awful.widget.taglist.filter.all,

        buttons = {
            awful.button({
                modifiers = {},
                button = 1,
                on_press = function(t)
                    t:view_only()
                end,
            }),
            awful.button({
                modifiers = { mod.super },
                button = 1,
                on_press = function(t)
                    if client.focus then
                        client.focus:move_to_tag(t)
                    end
                end,
            }),
            awful.button({
                modifiers = {},
                button = 3,
                on_press = awful.tag.viewtoggle,
            }),
            awful.button({
                modifiers = { mod.super },
                button = 3,
                on_press = function(t)
                    if client.focus then
                        client.focus:toggle_tag(t)
                    end
                end,
            }),
            awful.button({
                modifiers = {},
                button = 4,
                on_press = function(t)
                    awful.tag.viewprev(t.screen)
                end,
            }),
            awful.button({
                modifiers = {},
                button = 5,
                on_press = function(t)
                    awful.tag.viewnext(t.screen)
                end,
            }),
        },
        widget_template = {
            {
                id = "background_role",
                widget = wibox.container.background,
                forced_width = dpi(40),
            },
            top = dpi(7),
            bottom = dpi(7),
            widget = wibox.container.margin,

            create_callback = function(self, c3, _)
                self.anim = rubato.timed({
                    duration = 1 / 3,
                    subscribed = function(pos)
                        if pos < 8 then
                            pos = 8
                        end

                        if pos > 32 then
                            pos = 32
                        end

                        self:get_children_by_id("background_role")[1].forced_width = pos
                    end,
                })

                if c3.selected then
                    self.anim.target = dpi(32)
                elseif #c3:clients() == 0 then
                    self.anim.target = dpi(12)
                else
                    self.anim.target = dpi(16)
                end

                --- Tag preview
                --[[
                self:connect_signal("mouse::enter", function()
                    if #c3:clients() > 0 then
                        awesome.emit_signal("bling::tag_preview::update", c3)
                        awesome.emit_signal("bling::tag_preview::visibility", s, true)
                    end
                end)

                self:connect_signal("mouse::leave", function()
                    awesome.emit_signal("bling::tag_preview::visibility", s, false)
                end)
                --]]
            end,
            update_callback = function(self, c3, _)
                if c3.selected then
                    self.anim.target = dpi(32)
                elseif #c3:clients() == 0 then
                    self.anim.target = dpi(12)
                else
                    self.anim.target = dpi(16)
                end
            end,
        },
    })
    return taglist
end
