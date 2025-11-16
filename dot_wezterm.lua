-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Prevent copying selection (https://github.com/wezterm/wezterm/discussions/3760)
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.Nop,
  },
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.Nop,
  },
}

-- Remap keys on MacOS (https://github.com/wezterm/wezterm/issues/1777)
function macCMDtoMeta()
	local keys = "abdefghijklmnopqrstuwxyz" -- no c,v
	local keymappings = {}

	for i = 1, #keys do
		local c = keys:sub(i, i)
		table.insert(keymappings, {
			key = c,
			mods = "CMD",
			action = act.SendKey({
				key = c,
				mods = "META",
			}),
		})
		table.insert(keymappings, {
			key = c,
			mods = "CMD|CTRL",
			action = act.SendKey({
				key = c,
				mods = "META|CTRL",
			}),
		})
	end
	return keymappings
end

local keys = {
  -- Tabs
  { key = "T", mods = "CTRL|SHIFT", action = act.SpawnTab "DefaultDomain" },
  { key = "W", mods = "CTRL|SHIFT", action = act.CloseCurrentTab { confirm = true } },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

  -- New window
  { key = "N", mods = "CTRL|SHIFT", action = act.SpawnWindow },

  -- Pane management
  { key = "D", mods = "CTRL|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "E", mods = "CTRL|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "Q", mods = "CTRL|SHIFT", action = act.CloseCurrentPane { confirm = true } },

  -- Move between panes
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Left" },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Right" },
  { key = "UpArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Up" },
  { key = "DownArrow", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Down" },

  -- Resize panes
  { key = "LeftArrow", mods = "CTRL|ALT|SHIFT", action = act.AdjustPaneSize { "Left", 3 } },
  { key = "RightArrow", mods = "CTRL|ALT|SHIFT", action = act.AdjustPaneSize { "Right", 3 } },
  { key = "UpArrow", mods = "CTRL|ALT|SHIFT", action = act.AdjustPaneSize { "Up", 3 } },
  { key = "DownArrow", mods = "CTRL|ALT|SHIFT", action = act.AdjustPaneSize { "Down", 3 } },

  -- Reload configuration
  { key = "R", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },

  -- Zoom
  { key = "Enter", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },

  -- Copy & paste (use CMD+C/V for native copy/paste)
  { key = "C", mods = "CTRL|SHIFT", action = act.CopyTo "Clipboard" },
  { key = "V", mods = "CTRL|SHIFT", action = act.PasteFrom "Clipboard" },

  -- Search
  { key = "F", mods = "CTRL|SHIFT", action = act.Search("CurrentSelectionOrEmptyString") },
}

-- Finally, return the configuration to wezterm:
config.keys = macCMDtoMeta()
return config
