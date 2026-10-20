--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12ac1c2b = require("@lib/event/helper_12ac1c2b")
local helper_29ffefe6 = require("@lib/event/helper_29ffefe6")
local helper_fb6fbabc = require("@lib/event/helper_fb6fbabc")

--- Helper function.
local function helper_3f08ff50(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_fb6fbabc(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_fb6fbabc(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_fb6fbabc(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_12ac1c2b()
		end
	end
	event.SetMesPreset(0, 0)
	helper_29ffefe6(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetMenuEtc_2(0) or var2
	var3 = event.GetCnt(19) or var3
	print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
	if vm.i32(var2 - var3) < 10 then
		event.MesMake_2(0, "まだ体調はすぐれないわ。")
		helper_fb6fbabc(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
		)
		helper_fb6fbabc(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
	)
	helper_fb6fbabc(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_12ac1c2b()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 17, 1)
end

return helper_3f08ff50
