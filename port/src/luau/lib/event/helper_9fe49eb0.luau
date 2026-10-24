--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_9fe49eb0(arg0: s32, arg1: any)
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Made any good discoveries?<page>You know, while you're making discoveries\nabout machines and devices,\nI'm making discoveries about cooking.<page>Every day, I'm researching how to make\ndelicious foods that no one's ever\ntasted before."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_9fe49eb0
