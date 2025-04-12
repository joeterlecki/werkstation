local wezterm = require 'wezterm'

local mux = wezterm.mux
wezterm.on('gui-startup', function()
  local _, first_pane, window = mux.spawn_window {}
  local _, second_pane, _ = window:spawn_tab {}
  local _, third_pane, _ = window:spawn_tab {}

  first_pane:send_text "toolbox enter\n"
end)

local config = {}

config.font = wezterm.font 'CaskaydiaMono Nerd Font Mono'
config.font_size = 15.0
config.color_scheme = 'Vesper'
config.window_close_confirmation = 'NeverPrompt'
config.enable_tab_bar = false

return config
