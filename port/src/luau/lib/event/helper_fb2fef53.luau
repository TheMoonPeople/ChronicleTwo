--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_fb2fef53(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "S[UNI00ec], venire con te non mi dispiace,\nma ci sar[UNI00e0] una luna l[UNI00e0]?")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Davvero? Magari lo dici cos[UNI00ec] per\ndire. Gli Umani sono bugiardi!")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Veramente, ho cambiato idea.\nAspetter[UNI00f2] qui che la luna sorga.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(0, "[(!)]Sar[UNI00e0] per qualcosa accaduto\n   in passato, ma Rufio non\n   crede agli Umani.")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.MesMake_2(
		0,
		"[(!)]Devi far s[UNI00ec] che Rufio ti creda.\n   Se gli dessi una foto della\n   luna, forse lo farebbe."
	)
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 14, 1)
end

return helper_fb2fef53
