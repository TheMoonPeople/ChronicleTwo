--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")

--- Helper function.
local function helper_84e1c96f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_d25c550f(arg0, 0, 0)
	var2 = event.GetCnt(12) or var2
	if var2 == 0 then
		event.MesMake_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 1)
	end
	if var2 == 1 then
		event.MesMake_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	if var2 == 2 then
		event.MesMake_2(0, "中止だって！？\nそいつは残念だな。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetCnt(12, 3)
	end
	if var2 == 3 then
		event.MesMake_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_84e1c96f
