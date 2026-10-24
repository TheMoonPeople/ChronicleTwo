--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_e7b28db9(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "The Firbit people will only\ngrant favours to people who are\nmore skilled than themselves.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "I'm fairly confident when it\ncomes to fish.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"I've heard that some humans are holding\nan event where they make their fish compete\nagainst each other.<page>If you've got a fish, why don't you\ntry to come in first place?<page>If you can do that, then \nI'll know you're worthy of my help."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]She seems to be talking about the Fish\n   Race.  Why not try to win the Beginners'\n   Class?  Then maybe she'll help."
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 16, 1)
end

return helper_e7b28db9
