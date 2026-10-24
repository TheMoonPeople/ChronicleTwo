--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_0c1bb972(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "You want me to do you a favour?<page>First, hear me out.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"I only listen to people that I respect.<page>And the only people I respect are people\nthat have caught a bigger fish than me."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"The biggest fish I ever caught\nwas a 60cm Nonky.<page>Are you impressed?\nIf you feel like a challenge,\nI'll take you on anytime!"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]It seems like the only way to get\n   him on your side is to catch a Nonky\n   of more than 60cm. You can do it!"
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.MesMake_2(0, "[(!)]Anyway, try doing some fishing\n   in the Palm Brinks lake.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 15, 1)
end

return helper_0c1bb972
