-- Converted from hyprland-animations.conf
-- Required from hyprland.lua via: require("hyprland-animations")

hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.5, 0 }, { 0.99, 0.99 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.5, 0 }, { 0.68, 1.5 } } })
hl.curve("slide", { type = "bezier", points = { { 0.25, 0.1 }, { 0.25, 1.0 } } })
hl.curve("expo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 4, bezier = "slide" })

hl.animation({ leaf = "border", enabled = true, speed = 25, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "linear", style = "loop" })

hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "smoothIn" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 5, bezier = "smoothIn" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 5, bezier = "smoothOut" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 4, bezier = "smoothOut", style = "slidefadevert" })

hl.config({
	decoration = {
		rounding = 14,

		blur = {
			enabled = true,
			size = 8,
			passes = 3,
			new_optimizations = true,
			xray = false,
			noise = 0.01,
			contrast = 0.89,
			brightness = 0.82,
		},

		shadow = {
			enabled = true,
			range = 24,
			render_power = 3,
			color = "rgba(06061488)",
			color_inactive = "rgba(00000066)",
		},
	},

	general = {
		gaps_in = 5,
		gaps_out = 12,
		border_size = 2,
		resize_on_border = true,
		allow_tearing = false,

		col = {
			active_border = {
				colors = { "rgba(FF007Cee)", "rgba(FFFF00ee)", "rgba(00FF00ee)", "rgba(00FFFFee)" },
				angle = 45,
			},
			inactive_border = { colors = { "rgba(2a0a1aaa)", "rgba(0a2a2aaa)" }, angle = 45 },
		},

		layout = "dwindle",
	},
	animations = { enabled = true },

})
