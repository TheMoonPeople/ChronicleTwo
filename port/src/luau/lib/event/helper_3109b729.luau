--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_3109b729(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.SetMesPreset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "Tel poisson, tel ma[UNI00ee]tre, para[UNI00ee]t-il.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "Pas question que je parle au \npropri[UNI00e9]taire d'un poisson si nul.")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"J'ai bien regard[UNI00e9], tu sais.\nC'[UNI00e9]tait une course superbe.<page>Je ne pense pas que j'aurais pu\ndresser un aussi bon poisson.<page>Tu peux m'emmener avec toi et\nm'apprendre tout ce que tu sais ?"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_95dae095()
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

return helper_3109b729
