--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_03b4722e(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(0, "Falls du etwas brauchst,\nhelfe ich gern so gut ich kann.<page>Verlass dich auf mich.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, " ...")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Ich wei[UNI00df] nicht, ob du helfen\nkannst ...<page>Aber h[UNI00f6]r dir das an.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Ich arbeite seit 30 Jahren\nhart in diesem Haus.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Ich mache sonst nichts, aber\nmein Hobby ist Lesen.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Es gibt ein kostbares, seltenes\nBuch, das momentan versteigert wird.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Alle wollen es haben.\nIch denke, ein Gebot von etwa\n1000 Gilda m[UNI00fc]sste reichen.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Aber so viel Geld habe ich nicht,\nund wenn ich meinen Meister frage, wird\ner wom[UNI00f6]glich sauer und k[UNI00fc]ndigt mir."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Du bist meine einzige Hoffnung.<page>Aber das hei[UNI00df]t nicht, dass\nich dir nicht helfe, wenn\ndu mir nicht hilfst."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.SetMesPreset(0, 4)
	event.SetMesWindowMode(0, 4)
	event.MesMake_2(
		0,
		"[(!)]Egal was er sagt - Stewart\n   hilft dir wohl nur f[UNI00fc]r 1000 Gilda.\n   Tja, dann spar mal sch[UNI00f6]n!"
	)
	helper_9e7d1511(0, -1, 8, 0, 0)
	event.SetMesPreset(0, 0)
	event.Finish()
	event.SetQuestEtc(0, 6, 1)
end

return helper_03b4722e
