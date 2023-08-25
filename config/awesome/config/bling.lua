local awful = require("awful")
local bling = require("modules.bling")
local beautiful = require("beautiful")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local apps = require("config.apps")
local helpers = require("helpers")

local M = {}

M.discord_scratch = bling.module.scratchpad({
    command = "webcord", -- How to spawn the scratchpad
    rule = { instance = "webcord" }, -- The rule that the scratchpad will be searched by
    sticky = true, -- Whether the scratchpad should be sticky
    autoclose = true, -- Whether it should hide itself when losing focus
    floating = true, -- Whether it should be floating (MUST BE TRUE FOR ANIMATIONS)
    geometry = { x = awful.screen.focused().geometry.width / 2, y = 90, height = 900, width = 1200 }, -- The geometry in a floating state
    reapply = true, -- Whether all those properties should be reapplied on every new opening of the scratchpad (MUST BE TRUE FOR ANIMATIONS)
    dont_focus_before_close = false, -- When set to true, the scratchpad will be closed by the toggle function regardless of whether its focused or not. When set to false, the toggle function will first bring the scratchpad into focus and only close it on a second call
})

local app_launcher_args = {
    terminal = apps.terminal,
    sort_alphabetically = true,

    border_width = beautiful.border_width,
    border_color = beautiful.border_color_normal,
    shape = helpers.shape.rrect(beautiful.border_radius),

    prompt_color = beautiful.accent_blue,

    app_selected_color = beautiful.accent_blue,
    apps_margin = dpi(0),
    apps_per_row = 3, -- Set how many apps should appear in each row
    apps_per_column = 3,
    app_width = dpi(200),
    app_height = dpi(200),
    apps_spacing = dpi(1),
}

M.app_launcher = bling.widget.app_launcher(app_launcher_args)

return M
