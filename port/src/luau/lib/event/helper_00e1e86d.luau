--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_6982de90 = require("@lib/event/helper_6982de90")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")

--- Helper function.
local function helper_00e1e86d(arg0: s32, arg1: s32)
	local flag: s32 = 0
	event.SetMesPreset(0, 0)
	helper_d25c550f(arg0, 0, 0)
	flag = event.GetFlag(41) or flag
	if flag == 0 then
		event.MesMake_2(0, "魚は飼い主に似ると言います。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_6982de90()
	event.Finish()
	event.SetQuestEtc(1, 16, 1)
end

return helper_00e1e86d
