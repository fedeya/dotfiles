local wezterm = require("wezterm")

local theme = wezterm.plugin.require("https://github.com/neapsix/wezterm").main

local act = wezterm.action

local config = wezterm.config_builder()

-- config.font = wezterm.font("JetBrainsMono Nerd Font")

config.font = wezterm.font_with_fallback({
	{
		family = "JetBrainsMono Nerd Font",
		-- harfbuzz_features = {
		-- 	"calt=1", -- Ligaduras contextuales
		-- 	"ss01=1", -- Estilo alternativo para algunos caracteres
		-- 	"ss02=1", -- Estilo alternativo para cero con slash
		-- 	"ss03=1", -- Estilo alternativo para ampersand
		-- 	"ss04=1", -- Estilo alternativo para dollar sign
		-- 	"ss05=1", -- Estilo alternativo para @
		-- 	"ss06=1", -- Estilo alternativo para puntuación
		-- },
		-- harfbuzz_features = { "calt=1", "clig=1", "liga=1" },
	},
	"JetBrains Mono",
})

config.anti_alias_custom_block_glyphs = true
config.freetype_load_target = "Light" -- Mejor renderizado en pantallas modernas
config.freetype_render_target = "HorizontalLcd"

config.cursor_blink_rate = 250

config.font_size = 18.0

config.window_frame = theme.window_frame()

config.color_scheme = "rose-pine"

config.initial_rows = 65
config.initial_cols = 181

config.colors = theme.colors()

config.window_decorations = "RESIZE|MACOS_FORCE_ENABLE_SHADOW"

config.hide_tab_bar_if_only_one_tab = true

-- config.window_background_opacity = 0.95
config.window_background_opacity = 1

config.use_fancy_tab_bar = false

config.animation_fps = 60
config.enable_scroll_bar = false
config.max_fps = 120

config.webgpu_power_preference = "HighPerformance"
config.front_end = "WebGpu"

config.keys = {
	{
		key = "j",
		mods = "CMD",
		action = act.SendKey({
			key = "n",
			mods = "CTRL",
		}),
	},

	{
		key = "k",
		mods = "CMD",
		action = act.SendKey({
			key = "p",
			mods = "CTRL",
		}),
	},
}

return config
