--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_8fd3f088(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "Hi! Are you Max's\ngirlfriend?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Your hair's a really unusual colour.\nLike Erik's, but different...<page>Yours is really pretty,\nlike a jewel."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_8fd3f088
