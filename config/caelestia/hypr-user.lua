-- User custom Hyprland configuration for Caelestia
-- This file is loaded at the end of ~/.config/hypr/hyprland.lua
-- and will survive upstream Caelestia dotfile updates.

local vars = require("variables")
local fn   = require("utils.functions")

-- Autostart extra background daemons
hl.exec_cmd("pgrep -u $USER -x udiskie >/dev/null || udiskie &")

-- Keybind redundancy: ensure custom apps like Obsidian are always bound
if vars.kbObsidian and vars.obsidian then
	hl.bind(vars.kbObsidian, hl.dsp.exec_cmd(vars.obsidian))
end

-- =============================================================================
-- Custom Keybindings
-- =============================================================================
-- Super + Space toggles music play / pause directly
hl.bind("SUPER + Space", hl.dsp.exec_cmd("caelestia shell mpris playPause"))
hl.bind("CTRL + SUPER + Space", hl.dsp.exec_cmd("caelestia shell mpris playPause"))

-- =============================================================================
-- Gesture Overrides
-- =============================================================================
-- 3 fingers:
--   Up / Down    -> Volume control
--   Left / Right -> Next / Previous track
-- 4 fingers:
--   Up / Down    -> Toggle music workspace (like Super + M)
--   Left / Right -> Workspaces (horizontal swipe)

-- 1. Unset upstream default gestures that conflict
hl.gesture({ fingers = 3, direction = "up", action = "unset" })
hl.gesture({ fingers = 3, direction = "down", action = "unset" })
hl.gesture({ fingers = 4, direction = "down", action = "unset" })

-- 2. Three-finger gestures: Volume and Tracks
local vol_up_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l "
	.. (vars.volumeMax / 100) .. " @DEFAULT_AUDIO_SINK@ " .. vars.volumeStep .. "%+"
local vol_down_cmd = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ "
	.. vars.volumeStep .. "%-"

hl.gesture({
	fingers   = 3,
	direction = "up",
	action    = function()
		hl.exec_cmd(vol_up_cmd)
	end,
})
hl.gesture({
	fingers   = 3,
	direction = "down",
	action    = function()
		hl.exec_cmd(vol_down_cmd)
	end,
})
hl.gesture({
	fingers   = 3,
	direction = "left",
	action    = function()
		hl.exec_cmd("caelestia shell mpris next")
	end,
})
hl.gesture({
	fingers   = 3,
	direction = "right",
	action    = function()
		hl.exec_cmd("caelestia shell mpris previous")
	end,
})

-- 3. Four-finger gestures: Toggle Music Workspace in both vertical directions
hl.gesture({
	fingers   = 4,
	direction = "up",
	action    = fn.toggle("music"),
})
hl.gesture({
	fingers   = 4,
	direction = "down",
	action    = fn.toggle("music"),
})
-- 4-finger horizontal swipe for workspaces remains active from base config
