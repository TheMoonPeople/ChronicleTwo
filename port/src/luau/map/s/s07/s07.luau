--!strict
-- map/s/s07/s07.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3a9ba306 = require("@lib/event/helper_3a9ba306")
local helper_449e3f4b = require("@lib/event/helper_449e3f4b")
local helper_46e8aa48 = require("@lib/event/helper_46e8aa48")
local helper_8ddec556 = require("@lib/event/helper_8ddec556")
local helper_c746120b = require("@lib/event/helper_c746120b")
local helper_df4094fb = require("@lib/event/helper_df4094fb")

--- Helper function.
local function helper_27d5c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 8
		var2 = 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		helper_449e3f4b(var1, var2)
		var1 = var1 + 1
		var2 = var2 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(0) or var0
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = 8
	event.InitLocalCnt()
	var2 = 1
	while var2 <= 25 do
		var3 = event.GetChapter() or var3
		if var2 == 1 then
			var4 = event.GetCnt(1) or var4
			if var3 ~= 8 or var4 ~= 1 then
				var2 = var2 + 1
				continue
			end
		end
		if var3 < 5 then
			if var2 == 2 or var2 == 13 then
				var2 = var2 + 1
				continue
			end
		end
		var5 = event.GetNpcStatus(var2) or var5
		if var5 == 0 then
			var2 = var2 + 1
			continue
		end
		if bit32.band(var5, 4) ~= 0 then
			var2 = var2 + 1
			continue
		end
		var6 = event.GetNpcTrainEtc(0, var2) or var6
		if var0 ~= var6 then
			var2 = var2 + 1
			continue
		end
		event.LoadCharaNpc(1, 5, var2, var1)
		helper_449e3f4b(var1, var2)
		event.SetLocalCnt(var1, var2)
		event.SetCharaNo(var1, var2)
		if bit32.band(var5, 1) ~= 0 then
			event.CharaActive(0, var1)
		else
			event.CharaActive(var1)
		end
		var1 = vm.i32(var1 + 1)
		var2 = var2 + 1
	end
	flag = event.GetFlag(254) or flag
	if flag ~= 0 and var0 == 3 then
		event.LoadChara(5, "event/train/tp02_01a.gltf", "info", var1)
		event.SetCharaPos(var1, 0.0, 56.0, -200.0)
		event.SetCharaRot(var1, 0.0, 0.0, 0.0)
		event.SetMotion(var1, "立ち", 4)
		event.SetLocalCnt(var1, 34)
		event.SetCharaNo(var1, 34)
		event.CharaActive(var1)
	end
end

--- Helper function.
local function helper_28838()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = 8
	while var0 < 20 do
		event.DeleteChara(var0)
		event.DeleteVillager(var0)
		var0 = var0 + 1
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Helper function.
local function helper_1a284()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
		if at <= 9 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	if var0 == 2 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
		return
	end
	if var0 == 3 then
		event.MapJump(-1, "s04")
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var0 == 4 then
		event.MapJump(-1, "s09")
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var0 == 5 then
		event.MapJump(-1, "s10")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	if var0 == 6 then
		event.MapJump(-1, "s11")
		if vm.wait() then
			return skip(6)
		end
		return
	end
	if var0 == 7 then
		event.MapJump(-1, "s12")
		if vm.wait() then
			return skip(7)
		end
		return
	end
	if var0 == 8 then
		event.MapJump(-1, "s31")
		if vm.wait() then
			return skip(8)
		end
		return
	end
	if var0 == 9 then
		event.MapJump(-1, "s34")
		if vm.wait() then
			return skip(9)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(10)
	end
end

--- Helper function.
local function helper_2518c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c746120b(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_c746120b(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_25290()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2518c(15)
		end
		if at <= 2 then
			helper_2518c(1)
		end
		if at <= 3 then
			helper_2518c(6)
		end
		if at <= 4 then
			helper_2518c(0)
		end
		if at <= 5 then
			helper_2518c(4)
		end
		if at <= 6 then
			helper_2518c(31)
		end
		if at <= 7 then
			helper_2518c(35)
		end
		if at <= 8 then
			helper_2518c(36)
		end
		if at <= 9 then
			helper_2518c(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	language_code = event.GetLanguage() or language_code
	if language_code ~= 0 then
		event.MesMake_2(0, "Welcome.")
	else
		event.MesMake_2(0, "いらっしゃい。")
		if var0 == 18 then
			event.MesMake_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if var0 == 4 then
			event.MesMake_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if var0 == 34 then
			event.MesMake_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if var0 == 1012 then
			flag = event.GetFlag(45) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.SetFlag(45, 1)
			end
		end
		if var0 == 1015 then
			flag_2 = event.GetFlag(46) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.SetFlag(46, 1)
			end
		end
		if var0 == 1018 then
			flag_3 = event.GetFlag(47) or flag_3
			if flag_3 == 0 then
				event.MesMake_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.SetFlag(47, 1)
			else
				event.MesMake_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if var1 ~= -1 then
		helper_8ddec556(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_2518c(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_2518c(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_2518c(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_2518c(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_2518c(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_2518c(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_2518c(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_2518c(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_2518c(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.Initialize()
	print("##IN_START_EVENT################################\n")
	helper_27d5c()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(1, 3)
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "キ(O)ター[l1]ー[r1]ー[l2]ー[r2]ー")
	helper_46e8aa48(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1a284()
		end
	end
	print("--------------------------event200-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		helper_28838()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_1a284()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1a284()
		end
	end
	print("--------------------------event201-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		helper_28838()
		if vm.skipping() then
			return skip(1)
		end
		event.StopBgm(0)
		helper_1a284()
		if vm.skipping() then
			return skip(2)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = var0 - 1
		helper_27d5c()
	end
	print("--------------------------event202-------------------------\n")
	event.SetFadeOut(0)
	helper_28838()
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 1 then
		event.SetCnt(0, 0)
		event.SetCharaPos(0, 0.0, 36.0, -100.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.MapJump(-1, "s08")
	else
		var0 = vm.i32(var0 - 1)
		event.SetCnt(0, var0)
		helper_27d5c()
		event.SetCharaPos(0, 0.0, 36.0, -235.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 203.
script[203] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var0 = vm.i32(var0 + 1)
		helper_27d5c()
	end
	print("--------------------------event203-------------------------\n")
	var0 = event.GetCnt(0) or var0
	if var0 ~= 3 then
		event.SetFadeOut(0)
		helper_28838()
		if vm.skipping() then
			return skip(1)
		end
		var0 = vm.i32(var0 + 1)
		event.SetCnt(0, var0)
		helper_27d5c()
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 205.
script[205] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 206.
script[206] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 207.
script[207] = function()
	print("--------------------------event207-------------------------\n")
end

--- Program 208.
script[208] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event208-------------------------\n")
	var0 = event.GetCnt(0) or var0
	if var0 == 3 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3a9ba306(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		helper_25290()
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_3a9ba306(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
