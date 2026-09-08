-- User variable overrides for Caelestia Hyprland
-- These settings take precedence over ~/.config/hypr/variables.lua
-- and will survive upstream Caelestia dotfile updates.

return {
	-- Default Applications
	terminal = "kitty",
	browser = "zen-browser",
	editor = "antigravity-ide",
	obsidian = "obsidian",

	-- Hardware & Touchpad
	touchpadScrollFactor = 1.0,

	-- Window Appearance & Effects
	blurXray = true,
	cursorTheme = "Bibata-Modern-Classic",

	-- Keybinding Inversions / Customizations
	kbWindowFullscreen = "SUPER + ALT + F",
	kbWindowBorderedFullscreen = "SUPER + F",
	kbObsidian = "SUPER + O",
}
