local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.default_domain = 'WSL:Ubuntu'

config.color_scheme = 'Ayu Mirage'
config.font = wezterm.font('UDEV Gothic 35NF')
config.use_ime = true
config.macos_forward_to_ime_modifier_mask = 'SHIFT|CTRL'

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false

return config
