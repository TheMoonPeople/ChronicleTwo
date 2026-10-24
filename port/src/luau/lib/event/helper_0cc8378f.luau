--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d251141b = require("@lib/event/helper_d251141b")

--- Helper function.
local function helper_0cc8378f(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Grumble, grumble...")
	helper_d251141b(arg0)
	event.MesMake_2(0, "...1212,<page>No, no, I'm sure it was 1122.<page>Or maybe it was 1010.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Grumble, grumble...")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]If he doesn't even notice you \n   trying to say, \"Hello.\" He must \n   have some pretty serious problems.<page>[(!)]Why don't you try back later?\n   Maybe you could lend him a hand or\n   an ear or something."
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
end

return helper_0cc8378f
