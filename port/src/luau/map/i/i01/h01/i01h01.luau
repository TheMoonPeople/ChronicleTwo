--!strict
-- map/i/i01/h01/i01h01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1115c833 = require("@lib/event/helper_1115c833")
local helper_3ef870cf = require("@lib/event/helper_3ef870cf")
local helper_40810097 = require("@lib/event/helper_40810097")
local helper_40f32ea5 = require("@lib/event/helper_40f32ea5")
local helper_4b0a5650 = require("@lib/event/helper_4b0a5650")
local helper_6e84ae27 = require("@lib/event/helper_6e84ae27")
local helper_b9ea6aa8 = require("@lib/event/helper_b9ea6aa8")
local helper_c3d4d89a = require("@lib/event/helper_c3d4d89a")
local helper_e289b4cf = require("@lib/event/helper_e289b4cf")

--- Helper function.
local function helper_ff28()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	argc = event.GetItemNum(386) or argc
	if 0 < argc then
		event.FuncPointShow("", "item2", 0)
		event.EohSyncObj(0, "memo")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_104ec()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	helper_ff28()
	event.CharaActive(1, 24)
	event.FuncPointShow("", "fc_event_e108c", 0)
	var0 = event.GetSavedataEtc(0) or var0
	flag = event.GetFlag(7) or flag
	if var0 == 3 and flag == 0 then
		print("LOAD_STEAVE------------------\n")
		event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.CharaActive(1, 25)
		event.LoadChara(4, "event/e100/e105/back01.gltf", "info", 26)
		event.CharaActive(0, 26)
		flag_2 = event.GetFlag(107) or flag_2
		if flag == 0 and flag_2 == 1 then
			print("e107 ikou--------------------\n")
			event.CharaActive(0, 24)
			event.CharaActive(1, 25)
			event.SetCharaPos(25, -116.62, -12.11, -221.76)
			event.SetCharaRot(25, 0.0, 0.16, 0.0)
			event.FuncPointShow("", "fc_event_e108c", 1)
		else
			event.SetCharaPos(25, 62.85, 11.43, -176.07)
			event.SetCharaRot(25, 0.0, -0.72, 0.0)
		end
		flag_3 = event.GetFlag(20) or flag_3
		if flag_3 ~= 0 then
			event.CharaActive(1, 26)
			event.SetReference(25, "back", 26)
		end
	end
end

--- Helper function.
local function helper_87bc(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b9ea6aa8(arg0)
	end
	local _ = helper_e289b4cf(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_40f32ea5(arg0, 0, var6)
	if vm.skipping() then
		return skip(1)
	end
	helper_b9ea6aa8(arg0)
end

--- Helper function.
local function helper_cdf4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3ef870cf(1, 4)
			var2 = -1
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_3ef870cf(1, 4)
	var2 = -1
	if arg1 <= 0 then
		return
	end
	if arg1 == 1 then
		var2 = 10
		event.SetMesItem(1, 1, arg0)
	end
	if 1 < arg1 then
		var2 = 11
		event.SetMesItem(1, 1, arg0)
		event.SetMesValue(1, 2, arg1)
	end
	if var2 == -1 then
		return
	end
	argc = event.GetSysSndId() or argc
	event.SndSePlay(argc, 18)
	helper_87bc(1, var2, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_754(arg0: s32)
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40810097(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	argc = event.CheckGetItemLimit() or argc
	argc_2 = event.CheckItemOver() or argc_2
	if argc >= 1 or argc_2 >= 1 then
		if arg0 == 1 then
			event.SetFadeOut(10)
			helper_40810097(10)
			if vm.skipping() then
				return skip(2)
			end
		end
		argc_3 = event.GetNowLoopNo() or argc_3
		if argc_3 == 1 then
			event.GotoMenu(16)
			if vm.wait() then
				return skip(3)
			end
		end
		if argc_3 == 2 then
			event.GotoMenu(17)
			if vm.wait() then
				return skip(4)
			end
		end
		if arg0 == 1 then
			event.SetFadeIn(10)
		end
	end
end

--- Helper function.
local function helper_c34(arg0: f32, arg1: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 > arg1 then
		return arg0
	else
		return arg1
	end
end

--- Helper function.
local function helper_a50(arg0: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(-1.0 * arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 then
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

--- Helper function.
local function helper_900c(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var27 = var10
			var28 = var15
			angle = vm.f32(var28 - var27)
			var30 = var13
			var31 = var16
			angle_2 = vm.f32(var31 - var30)
			var33 = 0.0
			var34 = vm.f32(helper_c34(helper_a50(angle), helper_a50(angle_2)) * 8.0)
			var35 = helper_c3d4d89a(0.0, angle, var33, var34)
			var35 = vm.f32(var35 + var27)
			var36 = helper_c3d4d89a(0.0, angle_2, var33, var34)
			var36 = vm.f32(var36 + var30)
			var33 = vm.f32(var33 + 1.0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_c34(helper_a50(angle), helper_a50(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_c3d4d89a(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_c3d4d89a(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(2)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a540(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_900c(player_chara, arg0, arg1)
		end
		return rot_y
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_900c(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(2)
	end
	return rot_y
end

--- Helper function.
local function helper_a800(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var4 = helper_a540(arg0, arg2, arg3)
		end
		if at <= 2 then
			helper_4b0a5650(0, arg1, arg0, player_chara, 0)
		end
		if at <= 3 then
			helper_6e84ae27(arg0, var4, arg2, arg3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var4 = helper_a540(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_4b0a5650(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
	helper_6e84ae27(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_e6e4(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_40810097(9)
			end
			if at <= 2 then
				helper_3ef870cf(0, 1)
				helper_a540(arg0, 0, 0)
			end
			if at <= 3 then
				helper_4b0a5650(0, -1, arg0, player_chara, 0)
			end
			if at <= 4 then
				var5 = helper_1115c833(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 5 then
				helper_4b0a5650(0, -1, arg0, player_chara, 0)
			end
			if at <= 6 then
				helper_40810097(30)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 10 then
			return
		end
		if at <= 11 then
			return
		end
		if at <= 12 then
			return
		end
		if at <= 13 then
			return
		end
		if at <= 14 then
			return
		end
		if at <= 15 then
			return
		end
		if at <= 16 then
			return
		end
		if at <= 17 then
			return
		end
		if at <= 18 then
			helper_a800(arg0, -1, 0, 0)
		end
		if at <= 19 then
			helper_a800(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち", 0)
	helper_40810097(9)
	if vm.skipping() then
		return skip(2)
	end
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_3ef870cf(0, 1)
		helper_a540(arg0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "スティーブの調子はどうじゃ？")
		helper_4b0a5650(0, -1, arg0, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "ねんりょう補給\nコアのパワーアップ")
		var5 = helper_1115c833(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "よし、これで\n修理完了じゃ！")
			helper_4b0a5650(0, -1, arg0, player_chara, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_40810097(30)
			if vm.skipping() then
				return skip(7)
			end
			event.GotoMenu(6, 23)
			if vm.wait() then
				return skip(8)
			end
			event.SetFadeIn(25)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(107) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"こんなことであきらめるのか？\nなにごともネバーギブアップじゃ。"
		)
		helper_a800(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(20) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(10)
		end
		event.LoadScript("i01h01/i01h01c.stb", 500)
		return
	end
	var3 = event.GetItemNum(165) or var3
	if var3 > 0 then
		event.SetFlag(20, 1)
		if vm.wait() then
			return skip(11)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	argc = event.GetItemNum(224) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	var3 = event.GetInventionId(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		if vm.wait() then
			return skip(12)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.GetFlag(19) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"ここをでて、目の前にあるかぼちゃの\nかんばんの店がアイテム屋じゃ。<page>鉄クズ２０個、銅のかたまり２個、\nそれとぶあつい皮じゃぞ。\n早く買ってくるのじゃ。"
		)
		helper_a800(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(13)
		end
		event.SetAi(1, 24)
		return
	end
	var3 = event.GetInventionId(165) or var3
	if var3 ~= -1 then
		if vm.wait() then
			return skip(14)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	var3 = event.CheckInventItem(165) or var3
	if var3 == 1 then
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01b.stb", 520)
		return
	end
	flag = event.GetFlag(17) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(16)
		end
		event.LoadScript("i01h01/i01h01b.stb", 510)
		return
	end
	flag = event.GetFlag(105) or flag
	if flag == 0 then
		event.MesMake_2(0, "ユリス、バイトをサボるんじゃないぞ。\nわかったな！")
		helper_a800(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(17)
		end
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "まずは自分の力で、\nやってみるのじゃ。")
	helper_a800(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(0, "どうしても解らなければ、\nヒントをだしてやる。")
	helper_a800(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(0, "さあ、行け！")
	helper_a800(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_fbd4()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("[talk_chara]", var1, "\n")
			print("[talk_chara_id]", var1, "\n")
			helper_e6e4(var0, var1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetEventData_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_e6e4(var0, var1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == -1 then
		flag = event.GetFlag(6) or flag
		flag_2 = event.GetFlag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			if vm.wait() then
				return skip(3)
			end
			event.LoadScript("i01h01/i01h01c.stb", 520)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	print("i01h01--------start event----------\n")
	helper_104ec()
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c.stb", 151)
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(18) or flag
	if flag == 1 then
		flag = event.GetFlag(17) or flag
		if flag == 0 then
			event.PlayBgm(0)
			event.SetFlag(17, 1)
		end
	end
	flag_2 = event.GetFlag(105) or flag_2
	flag_3 = event.GetFlag(109) or flag_3
	flag = event.GetFlag(56) or flag
	if flag_2 ~= 0 and flag_3 == 0 and flag == 0 then
		event.BgmLoadCancel()
	end
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(2)
	end
	event.GotoOutside(-1, "m01")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ff28()
	event.FuncPointShow("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.LoadScript("i01h01/i01h01b.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("スティーブ読み込んだ-------------\n")
			print("いべんとe108b--------------\n")
		end
	end
	helper_ff28()
	event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
	event.CharaActive(1, 25)
	event.CharaActive(0, 24)
	event.SetCharaPos(25, -120.88, -13.05, -215.36)
	event.SetCharaRot(25, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	print("スティーブ読み込んだ-------------\n")
	event.LoadScript("i01h01/i01h01c.stb", 510)
	print("いべんとe108b--------------\n")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ff28()
	event.LoadScript("i01h01/i01h01c.stb", 520)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 590.
script[590] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cdf4(386, 1)
		end
		if at <= 2 then
			helper_754(1)
		end
		helper_ff28()
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_40810097(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_cdf4(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(386)
	helper_754(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_ff28()
end

--- Program 610.
script[610] = function()
	print("event_610-------\n")
	helper_ff28()
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fbd4()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_fbd4()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 11051.
script[11051] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11052.
script[11052] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_104ec()
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b.stb", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11053.
script[11053] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_104ec()
	event.SetFlag(20, 0)
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b.stb", 11053)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11060.
script[11060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_104ec()
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11083.
script[11083] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.ExtTyped(1078, "ii", 2, 1)
	event.SetFlag(25, 1)
	event.SetFlag(108, 0)
	event.SetFlag(103, 1)
	event.SetFlag(107, 1)
	event.SetFlag(7, 0)
	event.SetFlag(6, 1)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c.stb", 520)
	if vm.wait() then
		return skip(2)
	end
end

return script
