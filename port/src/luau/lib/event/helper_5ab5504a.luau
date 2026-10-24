--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c5602593 = require("@lib/event/helper_c5602593")
local helper_d25c550f = require("@lib/event/helper_d25c550f")

--- Helper function.
local function helper_5ab5504a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	helper_d25c550f(arg0, 0, 0)
	var2 = helper_c5602593()
	if 0 < var2 then
		event.MesMake_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(
		0,
		"よく分かりましたね。\nすばらしい。<page>君なら私の期待にも\n答えてくれることでしょう。<page>約束でしたね。私も\n君と共に行きましょう。"
	)
	helper_b5a98ffa(0, -1, arg0, arg1, 0)
	event.SetMotion(arg0, "立ち")
	helper_95dae095()
	event.Finish()
	event.SetQuestEtc(1, 13, 1)
end

return helper_5ab5504a
