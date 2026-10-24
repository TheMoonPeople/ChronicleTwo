--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

--- Helper function.
local function helper_14527650(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	event.SetMesPreset(0, 0)
	helper_d25c550f(arg0, 0, 0)
	event.MesMake_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.MesMake_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	var2 = 259
	argc = event.GetItemNum(258) or argc
	if argc <= 0 then
		var2 = 258
	else
		argc = event.GetItemNum(260) or argc
		if argc <= 0 then
			var2 = 260
		end
	end
	event.AddItem(var2)
	helper_e8257c69(var2, 1)
	helper_d61bc810(1)
	event.MesMake_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_95dae095()
	event.Finish()
	event.SetQuestEtc(1, 7, 1)
end

return helper_14527650
