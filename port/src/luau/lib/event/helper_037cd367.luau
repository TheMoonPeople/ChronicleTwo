--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_3fcbcef1 = require("@lib/event/helper_3fcbcef1")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_037cd367(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_3fcbcef1(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.MesMake_2(
		0,
		"Du kennst die Antwort doch:\nN-I-E-M-A-L-S!<page>Warum sollte ich f[UNI00fc]r andere\nLeute arbeiten?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Es springt nichts f[UNI00fc]r mich\nheraus und es ist gef[UNI00e4]hrlich.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Aber weil du's bist, denk ich\nmal dr[UNI00fc]ber nach.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "Andererseits bin ich ein H[UNI00e4]ndler-\nsohn - wir verschenken nichts.")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Du wei[UNI00df]t ja, dass ich\nM[UNI00fc]nzen sammle.<page>Sie sind Symbole des Handels.\nIch h[UNI00e4]tte so gern alle."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"Aber ich komme einfach nicht\nan die Dunkle M[UNI00fc]nze\nund die Panzer-M[UNI00fc]nze ran.<page>Wenn du mir hilfst, helfe\nich dir vielleicht auch."
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.SetQuestEtc(0, 2, 1)
end

return helper_037cd367
