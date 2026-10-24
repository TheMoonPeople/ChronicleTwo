--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38443164 = require("@lib/event/helper_38443164")
local helper_95dae095 = require("@lib/event/helper_95dae095")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_d25c550f = require("@lib/event/helper_d25c550f")
local helper_d7d2c87b = require("@lib/event/helper_d7d2c87b")

--- Helper function.
local function helper_aa4f047e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesPreset(0, 0)
		at = 1
		helper_d25c550f(arg0, 0, 0)
		var2 = event.GetMenuEtc_2(0) or var2
		var3 = event.GetCnt(19) or var3
		print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
		if vm.i32(var2 - var3) < 10 then
			event.MesMake_2(0, "まだ体調はすぐれないわ。")
			at = 2
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.MesMake_2(
				0,
				"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
			)
			at = 3
			helper_b5a98ffa(0, -1, arg0, arg1, 0)
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
		at = 4
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
		)
		at = 5
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.MesMake_2(
			0,
			"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
		)
		at = 6
		helper_b5a98ffa(0, -1, arg0, arg1, 0)
		event.SetMotion(arg0, "立ち")
		at = 7
		helper_95dae095()
		event.Finish()
		event.SetQuestEtc(1, 17, 1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at == 1 then
			end
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_38443164(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_d7d2c87b()
			end
			return 0
		end
		return nil
	end)
end

return helper_aa4f047e
