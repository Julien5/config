local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Try OpenGL or Software to rule out GPU rendering glitches
config.front_end = "OpenGL" -- If this still fails, try "Software"

config.font_dirs = { '/usr/local/share/fonts/bitmaps', '/usr/share/fonts/X11/misc' }
config.font = wezterm.font('TamzenForPowerline')
-- config.font = wezterm.font('Fixed')
config.font_size = 14.0

-- Adjust spacing to match GTK/VTE (xfce4-terminal) defaults:
config.line_height = 1.1   -- Adds vertical padding between lines
config.cell_width = 1.05   -- Adds horizontal padding between characters

config.enable_tab_bar = false
config.disable_default_key_bindings = true
config.keys = {
    -- Pass Ctrl+Tab to the application (tmux)
    {
      key = "Tab",
      mods = "CTRL",
      action = wezterm.action.SendKey {
        key = "Tab",
        mods = "CTRL",
      },
    },

    -- Pass Ctrl+PageUp
    {
      key = "PageUp",
      mods = "CTRL",
      action = wezterm.action.SendKey {
        key = "PageUp",
        mods = "CTRL",
      },
    },

    -- Pass Ctrl+PageDown
    {
      key = "PageDown",
      mods = "CTRL",
      action = wezterm.action.SendKey {
        key = "PageDown",
        mods = "CTRL",
      },
    },

	{
      key = "V",
      mods = "CTRL|SHIFT",
      action = wezterm.action.PasteFrom("Clipboard"),
    },

	{
      key = "C",
      mods = "CTRL|SHIFT",
      action = wezterm.action.CopyTo("ClipboardAndPrimarySelection"),
    },
  }

return config