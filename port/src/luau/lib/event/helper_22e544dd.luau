--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_22e544dd(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Un pesce rispecchia il padrone.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Non parler[UNI00f2] mai col padrone \ndi un pesce tanto imbranato!")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"Stavo guardando, sai.\n[UNI00c8] stata una bella corsa.<page>Non avrei mai potuto allevare\nun pesce simile!<page>Ti prego, portami con te.\nTi prego, insegnami quel che sai!"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

return helper_22e544dd
