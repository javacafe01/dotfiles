{ isWayland, theme }:

with theme.colors;

''
  local wezterm = require('wezterm')

  local scheme = wezterm.get_builtin_color_schemes()['Tomorrow Night']
  scheme.background = '#${base00}'

  function font_with_fallback(name, params)
      local names = {name, "emoji"}
      return wezterm.font_with_fallback(names, params)
  end

  local font_name = "monospace"

  return {
      front_end = "WebGpu",

      -- No updates, bleeding edge only
      check_for_updates = false,

      -- Font Stuff
      font = font_with_fallback(font_name),
      font_rules = {
          {italic = true, font = font_with_fallback(font_name, {italic = true})},
          {
              italic = true,
              intensity = "Bold",
              font = font_with_fallback(font_name, {bold = true, italic = true})
          },
          {
              intensity = "Bold",
              font = font_with_fallback(font_name, {bold = true})
          },
          {intensity = "Half", font = font_with_fallback(font_name .. " Light")}
      },
      font_size = 20.0,
      line_height = 1.0,

      -- Cursor style
      default_cursor_style = "SteadyUnderline",

      -- X Good
      enable_wayland = ${isWayland},

      -- Keys
      disable_default_key_bindings = true,

      keys = {
          {
              mods = "CTRL|SHIFT",
              key = [[\]],
              action = wezterm.action {
                  SplitHorizontal = {domain = "CurrentPaneDomain"}
              }
          }, {
              mods = "CTRL",
              key = [[\]],
              action = wezterm.action {
                  SplitVertical = {domain = "CurrentPaneDomain"}
              }
          }, -- browser-like bindings for tabbing
          {
              key = "t",
              mods = "CTRL",
              action = wezterm.action {SpawnTab = "CurrentPaneDomain"}
          }, {
              key = "w",
              mods = "CTRL",
              action = wezterm.action {CloseCurrentTab = {confirm = false}}
          },
          {
              mods = "CTRL",
              key = "Tab",
              action = wezterm.action {ActivateTabRelative = 1}
          }, {
              mods = "CTRL|SHIFT",
              key = "Tab",
              action = wezterm.action {ActivateTabRelative = -1}
          }, -- standard copy/paste bindings
          {key = "x", mods = "CTRL", action = "ActivateCopyMode"}, {
              key = "v",
              mods = "CTRL|SHIFT",
              action = wezterm.action {PasteFrom = "Clipboard"}
          }, {
              key = "c",
              mods = "CTRL|SHIFT",
              action = wezterm.action {CopyTo = "ClipboardAndPrimarySelection"}
          }, { 
              key = 'L', 
              mods = 'CTRL', 
              action = wezterm.action.ShowDebugOverlay 
          }
      },

      -- Pretty Colors
      bold_brightens_ansi_colors = false,
     
      color_schemes = {
        ['mine'] = scheme,
      },

      color_scheme = 'mine',
      
      -- Get rid of close prompt
      window_close_confirmation = "NeverPrompt",

      -- Padding
      window_padding = {left = '30pt', right = '30pt', top = '30pt', bottom = '30pt'},

      -- No opacity
      inactive_pane_hsb = {saturation = 1.0, brightness = 1.0},

      enable_tab_bar = true,
      use_fancy_tab_bar = false,
      hide_tab_bar_if_only_one_tab = true,
      show_tab_index_in_tab_bar = false
  }''
