--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_cde8a121(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "Oh, stai\naiutando Polly?<page>Grandioso.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Che me ne faccio\ndi 20 pagnotte?<page>Beh, dar[UNI00f2] un\nfonduta-party oggi!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			'Per fare un parallelo con le tue famose\n"invenzioni", [UNI00e8] una combo culinaria di<page>formaggio, pane e vino!'
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"[UNI00c8] buono. Ne mangiano a tonnellate,\nper questo mi serve tanto pane.<page>Ma veramente non volevo che\nmi venisse consegnato qui."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"Scusa Max, potresti portarmele\na casa, per favore?<page>Sai dov'[UNI00e8], vero?\nVicino al campo di zucche."
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "Sai dov'[UNI00e8], vero?\nVicino al campo di zucche.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.MesMake_2(0, "Niente pi[UNI00f9] party?!\nChe peccato!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "In tal caso, il pane non mi serve.\nLo riporteresti a Polly per me?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "Scusa, riporteresti il\npane a Polly per me?")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_cde8a121
