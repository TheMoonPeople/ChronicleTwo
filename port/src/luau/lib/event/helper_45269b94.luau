--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

--- Helper function.
local function helper_45269b94(arg0: s32, arg1: s32)
	event.SetMesPreset(0, 0)
	helper_d25c550f(arg0, 0, 0)
	event.MesMake_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "私はその間に旅の支度を\nしておくからさ。")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	event.AddItem(300, 20)
	helper_e8257c69(300, 20)
	helper_d61bc810(1)
	event.MesMake_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.Finish()
	event.SetQuestEtc(0, 8, 1)
	event.SetCnt(12, 0)
end

return helper_45269b94
