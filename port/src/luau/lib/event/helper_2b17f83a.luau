--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_7408556b = require("@lib/event/helper_7408556b")
local helper_d49338a5 = require("@lib/event/helper_d49338a5")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")

--- Helper function.
local function helper_2b17f83a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local money: s32 = 0
	local var4: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 6 then
			if at <= 5 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 7 then
			return
		end
		if at <= 10 then
			if at <= 8 then
				var4 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 9 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_f3577a67(30)
			end
			return
		end
		if at <= 13 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 14 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 15 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 16 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 17 then
			helper_d49338a5()
		end
	end
	event.SetMesPreset(0, 0)
	helper_06ed6d94(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetCnt(9) or var2
	money = event.GetMoney() or money
	if var2 == 0 then
		if money < 1000 then
			event.MesMake_2(
				0,
				"坊ちゃん、そんな額では、\nオークションにすら\n出られませんよ。<page>１０００ギルダです。\nしっかりして下さい。"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(2)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.MesMake_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetCnt(9, 1)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 1 then
		if money < 1500 then
			event.MesMake_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>１５００ギルダ、\n急いでください。"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(5)
			end
		else
			event.MesMake_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetCnt(9, 2)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	if var2 == 2 then
		if money < 2000 then
			event.MesMake_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>２０００ギルダ、\n急いでください。"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(8)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		var4 = helper_7408556b(0, -1, 5, 256, 208, 2, 1)
		if vm.skipping() then
			return skip(9)
		end
		event.SetMesShippo(0, 1)
		event.SetMesEtc(0, 0, 0)
		if var4 ~= 0 then
			event.MesMake_2(
				0,
				"そうですか・・・やはり２０００ギルダは\n大金ですから、惜しくなってしまうのですね。\nこんなに裕福な坊ちゃんと言えども・・・<page>わかりました。あきらめます！\nでも、オークションはまだ続いています。\n私は待っていますよ、いつまでも・・・"
			)
			helper_dbd14b96(0, -1, arg0, arg1, 0)
			if vm.skipping() then
				return skip(10)
			end
			event.SetMotion(arg0, "立ち")
			event.Finish()
			return
		end
		event.MesMake_2(
			0,
			"あぁ、坊ちゃん、\nありがとうございます。<page>では、急いで\nオークショニアの所へ\n行って来ます！"
		)
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(11)
		end
		event.AddMoney(-2000)
		event.SetCnt(9, 3)
		event.SetFadeOut(30)
		helper_f3577a67(30)
		if vm.skipping() then
			return skip(12)
		end
		event.SetAi(1, arg0)
		event.CharaActive(0, arg0)
		event.DeleteVillager(arg0)
		event.SetFadeIn(30)
		event.Finish()
		return
	end
	event.MesMake_2(0, "坊ちゃん、\nありがとうございました。\n無事、落札できました。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(13)
	end
	event.MesMake_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(14)
	end
	event.MesMake_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(15)
	end
	event.AddMoney(600)
	event.MesMake_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(16)
	end
	event.MesMake_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(17)
	end
	event.SetMotion(arg0, "立ち")
	helper_d49338a5()
	if vm.skipping() then
		return skip(18)
	end
	event.Finish()
	event.SetQuestEtc(1, 6, 1)
end

return helper_2b17f83a
