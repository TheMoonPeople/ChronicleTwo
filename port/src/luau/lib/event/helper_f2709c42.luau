--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_5a511e14 = require("@lib/event/helper_5a511e14")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_f2709c42(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "Hey Max, have you come looking for me?<page>I've been waiting.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Thanks to the castle walls,\nthis town is pretty safe.<page>It's time for us to go outside.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "It's good that you're always\ntinkering about with machines,\nbut I wonder how strong you are?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Fighting's all about\nspeed and footwork.<page>If you're any slower than me,\nit's no good.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Why don't we give you a test.\nRun to the boat at the lake and back.<page>My record is 2 minutes 1 second.\nIf you're any slower than that,\nit's no good."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetQuestEtc(0, 9, 1)
	event.MesMake_2(0, "How about it, you want to try?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	helper_5a511e14(arg0, arg1)
end

return helper_f2709c42
