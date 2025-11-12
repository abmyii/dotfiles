-- Pull in the wezterm API
local wezterm = require 'wezterm'
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Spawn a bash shell in login mode
config.default_prog = { '/bin/bash' }

-- Prevent copying selection (https://github.com/wezterm/wezterm/discussions/3760)
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = wezterm.action.OpenLinkAtMouseCursor,
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

-- Finally, return the configuration to wezterm:
return config
