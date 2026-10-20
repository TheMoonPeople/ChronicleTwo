--!strict
-- map/s/s56/s56.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1281c23c = require("@lib/event/helper_1281c23c")
local helper_34e58157 = require("@lib/event/helper_34e58157")
local helper_3a88f4ff = require("@lib/event/helper_3a88f4ff")
local helper_430489d5 = require("@lib/event/helper_430489d5")
local helper_46b52105 = require("@lib/event/helper_46b52105")
local helper_512cd149 = require("@lib/event/helper_512cd149")
local helper_52115bbf = require("@lib/event/helper_52115bbf")
local helper_816cbf1e = require("@lib/event/helper_816cbf1e")
local helper_ab850a0e = require("@lib/event/helper_ab850a0e")
local helper_b01df685 = require("@lib/event/helper_b01df685")
local helper_cfb096c9 = require("@lib/event/helper_cfb096c9")
local helper_d779bb0d = require("@lib/event/helper_d779bb0d")
local helper_e49eb19b = require("@lib/event/helper_e49eb19b")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetBgmNo() or var0
	if var0 ~= 17 then
		event.StopBgm(0)
		helper_d779bb0d(6)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(17)
	end
	event.PlayBgm(0)
	event.LoadSound(3682)
	flag = event.GetFlag(348) or flag
	if flag == 1 then
		event.FuncPointShow("", "e348", 0)
		event.EohSyncObj(0, "p07_d03b01")
		event.EohSetShow(0, 0)
	end
	flag_2 = event.GetFlag(352) or flag_2
	if flag_2 == 1 then
		event.FuncPointShow("", "event", 0)
	end
end

--- Helper function.
local function helper_16800()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d779bb0d(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 1858.52, -189.52, 1308.84)
	event.ObjsSetRot(0, 0.0, -2.22, 0.0)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.CmrsSetPos(1910.24, -159.5, 1350.91)
	event.CmrsSetRef(1816.64, -159.5, 1274.78)
	event.ObjsMove(0, 1816.64, -189.5, 1274.78, 60)
	event.SetFadeIn(30)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(2)
	end
	event.EohSetFootSoundId(0, -1)
	event.ResetCamera(0)
	event.Finish()
end

--- Helper function.
local function helper_837c(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_46b52105(arg0, arg1, arg2, arg3, arg4)
			_, arg5 = helper_34e58157(arg0, 1, arg5)
		end
		helper_ab850a0e(arg0)
		return arg5
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_46b52105(arg0, arg1, arg2, arg3, arg4)
	_, arg5 = helper_34e58157(arg0, 1, arg5)
	if vm.skipping() then
		return skip(2)
	end
	helper_ab850a0e(arg0)
	return arg5
end

--- Helper function.
local function helper_160d0()
	local argc: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_cfb096c9(0, -1, 8, 0, 0)
		end
		if at <= 2 then
			helper_cfb096c9(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			var1 = helper_837c(0, -1, 5, 256, 208, var1)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 0)
	argc = event.GetItemNum(371) or argc
	if argc <= 0 then
		event.MesMake_2(
			0,
			"ここから過去に戻れば、クレストを助けられるはず！\nでも、過去に戻るにはどうしたら良いんだろう・・・"
		)
		helper_cfb096c9(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesPreset(0, 4)
		event.SetMesWindowMode(0, 4)
		event.MesMake_2(
			0,
			"[(!)]過去に戻る方法なんてあるんでしょうか？\n   何か特別な道具でもあれば別ですけど・・・"
		)
		helper_cfb096c9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"[(!)]そう言えば、ステラ寺院には世にも珍しい品物を扱う\n   道具屋があるそうです。そこでなら、もしかしたら、\n   何か手に入るかも知れませんね。"
		)
		helper_cfb096c9(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	else
		event.MesMake_2(
			0,
			"ここから過去に戻れば、クレストを助けられるはず！\n（(#)ボタンでメニューを開く）"
		)
		var1 = helper_837c(0, -1, 5, 256, 208, var1)
		if vm.skipping() then
			return skip(4)
		end
		if var1 == 1 then
			event.SetMesShippo(0, 1)
			return 1
		end
	end
	event.SetMesPreset(0, 0)
	event.SetMesShippo(0, 1)
	return 0
end

--- Helper function.
local function helper_12f20()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		print("GET_ACTIVE_CHR_NO-------", active_chr_no, "\n")
		global0 = 0
		global1 = 8
		global0 = 8
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	print("GET_ACTIVE_CHR_NO-------", active_chr_no, "\n")
	if active_chr_no == 0 then
		global0 = 0
		global1 = 8
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 1, "info", global1, 17)
		event.LoadEquip(5, 1, 0, "info", global1, 18)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 12)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
	end
	if active_chr_no == 1 then
		global0 = 8
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 1, "info", global0, 17)
		event.LoadEquip(5, 0, 0, "info", global0, 18)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 12)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e300/e352/e352_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 12)
		event.CharaActive(0, 17)
		event.CharaActive(0, 18)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e300/e352/e352_monica1.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadChara(5, "event/e300/e352/e352_lin.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(4, 9)
	event.ObjsInit(2, 9)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e300/e352/e352_tokei_h.gltf", "info", 19)
	event.CharaActive(0, 19)
	event.LoadChara(5, "event/e300/e352/e352_monica_tokei.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.LoadChara(5, "event/e300/e352/e352_sdokei.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.LoadChara(5, "event/e300/e352/e352_mabu.gltf", "info", 21)
	event.CharaActive(0, 21)
	event.LoadChara(5, "event/e300/e352/e352_hikari.gltf", "info", 22)
	event.CharaActive(0, 22)
	event.SetCharaType(22, 4)
	event.LoadMes(0, 5, "event/e300/e352/e352.txt")
end

--- Helper function.
local function helper_129cc()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.CharaActive(1, global0)
		event.CharaActive(0, global1)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global1)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(12)
		event.DeleteChara(17)
		event.DeleteChara(18)
	end
	event.DeleteChara(9)
	event.DeleteChara(19)
	event.DeleteChara(13)
	event.DeleteChara(20)
	event.DeleteChara(21)
	event.DeleteChara(22)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 1)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 1)
	event.SetStatusbarShow(1, 1.0)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1439c()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 18 then
			if at <= 5 then
				helper_12f20()
				helper_1281c23c()
			end
			if at <= 6 then
				helper_d779bb0d(30)
			end
			if at <= 7 then
				helper_512cd149(3520010)
			end
			if at <= 8 then
				helper_512cd149(3520020)
			end
			if at <= 9 then
				helper_b01df685(2)
			end
			if at <= 10 then
				helper_d779bb0d(27)
			end
			if at <= 11 then
				helper_d779bb0d(60)
			end
			if at <= 12 then
				helper_d779bb0d(60)
			end
			if at <= 13 then
				helper_d779bb0d(60)
			end
			if at <= 14 then
				helper_d779bb0d(30)
			end
			if at <= 15 then
				helper_d779bb0d(60)
			end
			if at <= 16 then
				helper_d779bb0d(75)
			end
			if at <= 17 then
				helper_d779bb0d(75)
			end
			if vm.skip_end() then
				return skip(19)
			end
			return part2()
		end
		if at <= 19 then
			helper_d779bb0d(30)
		end
		if at <= 21 then
			helper_129cc()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CmrsFadeOut(30, 255.0, 255.0, 255.0)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(20)
		end
		event.ScrEffStopRaster(0.0, 0.0, 0.0, 0)
		event.SndSeAllStop(4)
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(21)
		end
		helper_129cc()
		if vm.skipping() then
			return skip(22)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(352, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotionBlur(0)
	event.StopBgm(0)
	if vm.wait() then
		return skip(2)
	end
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.LoadSound(3831)
	var4 = event.SndLoadSound(3831) or var4
	helper_12f20()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "通常目パチ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(2, "上見立ち", 4)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 9)
	event.CmrsSetPos(496.47, 169.37, -809.35)
	event.CmrsSetRef(508.77, 169.14, -850.82)
	event.ObjsSetPos(2, 543.2, 144.04, -840.61)
	event.ObjsSetRot(2, 0.0, -1.99, 0.0)
	event.ObjsSetPos(0, 538.49, 145.86, -872.44)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetPos(1, 567.83, 142.65, -858.12)
	event.ObjsSetRot(1, 0.0, -0.92, 0.0)
	event.CmrsMove2(530.44, 169.37, -799.27, 542.75, 169.14, -840.74, 120, 2, 1.0)
	event.SetFadeIn(30)
	helper_1281c23c()
	if vm.skipping() then
		return skip(6)
	end
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_512cd149(3520010)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "うなづく", 6)
	event.ObjsNextMotion(2, "上見立ち", 4)
	event.SetPakuAnim(4, "通常口パク")
	helper_512cd149(3520020)
	if vm.skipping() then
		return skip(9)
	end
	event.ResetPakuAnim()
	helper_b01df685(2)
	if vm.skipping() then
		return skip(10)
	end
	event.SetReference(global1, "sword_hand", 13)
	event.CharaActive(1, 13)
	event.ObjsSetPos(1, 519.39, 147.4, -861.34)
	event.ObjsSetRot(1, 0.0, -0.2, 0.0)
	event.ObjsSetRot(0, 0.0, -0.6, 0.0)
	event.ObjsSetMotion(2, "下見立ち", 4)
	event.SndSePlay(var4, 0)
	event.ObjsSetMotion(1, "置く～下見", 6)
	event.ObjsNextMotion(1, "下見", 4)
	event.CmrsSetPos(485.69, 161.28, -803.81)
	event.CmrsSetRef(535.39, 163.79, -859.0)
	helper_d779bb0d(27)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var4, 1)
	event.DelReference(13)
	event.CharaActive(0, 13)
	event.CharaActive(1, 19)
	event.SetCharaPos(19, 516.77, 149.74, -850.63)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(499.2, 155.53, -839.73)
	event.CmrsSetRef(516.77, 149.74, -850.63)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(13)
	end
	event.CharaActive(1, 20)
	event.SetCharaPos(20, 516.77, 149.74, -850.63)
	event.SetMotion(20, "砂時計光る", 2, -1, 1)
	event.SndSePlay(var4, 2)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "目とじ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "目とじ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "無表情")
	event.ObjsTexAnime(2, 1, "目とじ")
	event.ObjsTexAnime(2, 1, "半口")
	event.ObjsSetMotion(2, "まぶしい", 6)
	event.ObjsSetMotion(0, "まぶしい", 6)
	event.ObjsSetMotion(1, "まぶしい", 6)
	event.ObjsNextMotion(2, "まぶしいＬ", 4)
	event.ObjsNextMotion(0, "まぶしいＬ", 4)
	event.ObjsNextMotion(1, "まぶしいＬ", 4)
	event.ObjsSetPos(0, 539.17, 145.1, -856.52)
	event.ObjsSetRot(0, 0.0, -1.99, 0.0)
	event.ObjsSetPos(1, 538.92, 143.03, -823.0)
	event.ObjsSetRot(1, 0.0, -2.24, 0.0)
	event.CmrsSetPos(494.78, 152.75, -815.47)
	event.CmrsSetRef(543.94, 165.9, -843.48)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(15)
	end
	event.CharaActive(1, 21)
	event.SetCharaPos(21, 547.24, 149.74, -859.21)
	event.SetMotion(21, "まぶしい", 2, -1, 1)
	helper_d779bb0d(60)
	if vm.skipping() then
		return skip(16)
	end
	event.CharaActive(0, 21)
	event.CmrsSetPos(1717.19, 225.79, 121.59)
	event.CmrsSetRef(543.94, 165.9, -843.48)
	event.SndSePlay(var4, 3)
	event.CharaActive(1, 22)
	event.SetCharaPos(22, 516.77, 149.74, -850.63)
	event.SetMotion(22, "光る光る", 2, -1, 1)
	helper_d779bb0d(75)
	if vm.skipping() then
		return skip(17)
	end
	event.ScrEffInitRaster(0.0, 0.0, 0.15707964)
	event.ScrEffStartRaster(60.0, 0.3926991, -1.0, 60)
	helper_d779bb0d(75)
	if vm.skipping() then
		return skip(18)
	end
	return part2()
end

--- Helper function.
local function helper_17c58()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_b01df685(0)
		end
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if active_chr_no == 2 or active_chr_no == 3 then
		if vm.wait() then
			return skip(1)
		end
		event.Finish()
		return
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_b01df685(0)
	if vm.skipping() then
		return skip(3)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
	event.Finish()
end

--- Helper function.
local function helper_102d4()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				active_chr_no = 0
				helper_d779bb0d(80)
			end
			if at <= 2 then
				helper_3a88f4ff(3480010, 120)
			end
			if at <= 3 then
				helper_1281c23c()
			end
			if at <= 4 then
				helper_d779bb0d(10)
			end
			if at <= 5 then
				helper_1281c23c()
			end
			if at <= 6 then
				helper_d779bb0d(10)
			end
			if at <= 7 then
				helper_512cd149(3480020)
			end
			if at <= 8 then
				helper_d779bb0d(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSyncChara(0, 1)
		event.EohSetShow(0, 1)
		event.EohSyncChara(0, 2)
		event.EohSetShow(0, 1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.LoadMes(0, -1)
		event.SetStatusbarShow(1, 1.0)
		event.PlayBgm(0)
		event.SetCharaPos(0, 1390.73, -76.07, 523.09)
		event.SetCharaRot(0, 0.0, -2.28, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(348, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(524.9)
	event.StopBgm(0)
	var0 = event.SndLoadSound(3829) or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 0 or active_chr_no ~= 1 then
		event.DngSetupMainUnit(0)
		event.SetActiveChrNo(0)
		active_chr_no = 0
	end
	event.ChangeDir("event/e300/e348/")
	event.LoadMes(0, 5, "e348.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e348_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e348_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e348_lin.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(2, 11)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 9)
		event.LoadEquip(5, 0, 4, "info", 9)
		event.LoadEquip(5, 0, 3, "info", 9)
		event.LoadEquip(5, 0, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_mints.gltf", "info", 10)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 9)
		event.EohSyncChara(0, 9)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 9)
		event.LoadEquip(5, 1, 4, "info", 9)
		event.LoadEquip(5, 1, 3, "info", 9)
		event.LoadEquip(5, 1, 2, "info", 9, 10)
		event.LoadMotion(5, "event/e300/e348/e348_monica.gltf", "info", 9)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 9)
		event.EohSyncChara(1, 9)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(9)
	event.CharaActive(10)
	event.EohSyncChara(3, 1)
	event.EohSetShow(3, 0)
	event.EohSyncChara(4, 2)
	event.EohSetShow(4, 0)
	event.EohSetPos(0, 1521.47, -107.28, 771.74)
	event.EohSetRot(0, 0.0, -2.88, 0.0)
	event.EohSetMotion(0, "歩き", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetFootSoundId(0, 2)
	event.EohNormalDrive(0)
	event.EohResetDaPosition(0)
	event.EohSetPos(1, 1505.66, -106.53, 783.49)
	event.EohSetRot(1, 0.0, 3.04, 0.0)
	event.EohSetMotion(1, "歩き", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetTexAnim(1, 1, "半口")
	event.EohSetFootSoundId(1, 2)
	event.EohNormalDrive(1)
	event.EohResetDaPosition(1)
	event.EohSetPos(2, 1506.3, -108.37, 803.96)
	event.EohSetRot(2, 0.0, -3.12, 0.0)
	event.EohSetMotion(2, "歩き", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "無表情")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.EohSetTexAnim(2, 1, "半口")
	event.ObjsMove(0, 1521.47, -107.28, 731.74, 80)
	event.ObjsMove(1, 1505.66, -106.53, 743.49, 80)
	event.ObjsMove(2, 1506.3, -108.37, 763.96, 80)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1478.0, -94.44, 748.45)
	event.CmrsSetRef(1526.09, -83.38, 795.48)
	event.CmrsMove(1478.0, -94.44, 708.45, 1526.09, -83.38, 755.48, 80)
	event.SetFadeIn(30)
	helper_d779bb0d(80)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(1635.22, -45.35, 898.95)
	event.CmrsSetRef(1509.85, -91.47, 744.47)
	event.CmrsMove2(1635.22, -45.35, 898.95, 1509.85, 36.75, 744.47, 60, 0, 1.0)
	event.ObjsSetPos(0, 1522.58, -104.86, 733.22)
	event.ObjsSetRot(0, 0.0, -2.52, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 1508.09, -104.9, 755.07)
	event.ObjsSetRot(1, 0.0, -2.76, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 1536.72, -109.15, 777.79)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.ObjsMove(0, 1491.96, -99.81, 672.57, 90)
	event.ObjsMove(1, 1473.85, -100.1, 691.32, 90)
	event.ObjsMove(2, 1493.11, -100.84, 700.12, 90)
	helper_3a88f4ff(3480010, 120)
	if vm.skipping() then
		return skip(3)
	end
	helper_1281c23c()
	if vm.skipping() then
		return skip(4)
	end
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1459.8, -32.33, 632.79)
	event.CmrsSetRef(1494.99, -96.61, 704.05)
	event.CmrsMove2(1475.8, -54.94, 665.2, 1494.99, -84.52, 704.05, 60, 0, 1.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "上見立ち", 4)
	helper_1281c23c()
	if vm.skipping() then
		return skip(6)
	end
	helper_d779bb0d(10)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1518.17, -76.49, 671.12)
	event.CmrsSetRef(1493.05, -78.0, 693.7)
	event.ObjsSetPos(2, 1501.04, -100.84, 688.87)
	event.ObjsSetRot(2, 0.0, -2.68, 0.0)
	event.SndSePlay(var0, 6)
	event.ObjsSetMotion(1, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "右向くL", 4)
	helper_512cd149(3480020)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_16c20()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_cfb096c9(0, 21, 5, 256, 208)
			end
			if at <= 2 then
				helper_d779bb0d(10)
			end
			return 0
		end
		if at <= 6 then
			if at <= 4 then
				helper_d779bb0d(30)
			end
			if at <= 5 then
				helper_d779bb0d(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_cfb096c9(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_cfb096c9(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetFadeOut(10)
		helper_d779bb0d(10)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaPos(0, 1804.36, -189.51, 1279.76)
		event.SetCharaRot(0, 0.0, -2.47, 0.0)
		event.SetCameraPos(1889.79, -158.65, 1386.92)
		event.SetCameraRef(1804.36, -159.51, 1279.76)
		event.ResetCamera(0)
		event.SetFadeIn(10)
		event.Finish()
		return 0
	end
	var1 = helper_430489d5(2, -1)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.CmrsSetPos(1776.49, -106.69, 1400.79)
		event.CmrsSetRef(1951.33, -163.61, 1351.42)
		event.ObjsSetPos(0, 1943.88, -189.72, 1357.17)
		event.ObjsSetRot(0, 0.0, 1.21, 0.0)
		event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
		event.ObjsInitPas(0)
		event.ObjsSetPasFrm(0, 60)
		event.ObjsAddPas(0, 1943.88, -189.72, 1357.17)
		event.ObjsAddPas(0, 2022.78, -189.88, 1386.95)
		event.ObjsAddPas(0, 2104.45, -195.47, 1399.2)
		event.ObjsAddPas(0, 2155.72, -202.4, 1401.26)
		event.ObjsStartPas(0)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFadeOut(30)
		helper_d779bb0d(30)
		if vm.skipping() then
			return skip(6)
		end
		event.SetMotion(0, "立ち", 4)
		event.EohSetFootSoundId(0, -1)
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		var5 = vm.f32(vm.f32(vm.sin(vm.f32(-2.14)) * 30.0) + var2)
		var6 = var3
		var7 = vm.f32(vm.f32(vm.cos(vm.f32(-2.14)) * 30.0) + var4)
		event.ObjsMove(0, var5, var6, var7, 30, 1)
		event.ObjsReference(0, var5, var6, var7, 10)
		event.ObjsSetMotion(0, "歩き")
		var8 = 0
		while var8 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var2 = out1 or var2
				var3 = out2 or var3
				var4 = out3 or var4
			end
			var3 = vm.f32(var3 + 30.0)
			event.SetCameraRef(var2, var3, var4)
			var8 = var8 + 1
			if vm.wait() then
				return skip(7)
			end
		end
		event.EohSetFootSoundId(0, -1)
		event.ResetCamera(0)
		event.Finish()
	end
	return 0
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_16800()
		end
	end
	program_99()
	if vm.skipping() then
		return skip(1)
	end
	helper_16800()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_816cbf1e(32)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_816cbf1e(32)
	if vm.skipping() then
		return skip(2)
	end
	event.Finish()
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				var0 = 2
				helper_d779bb0d(6)
			end
			if at <= 3 then
				helper_d779bb0d(20)
			end
			if at <= 4 then
				helper_1439c()
				if not vm.skipping() then
					return landing1()
				end
			end
			return
		end
		if at <= 6 then
			helper_d779bb0d(6)
		end
	end
	function part2()
		helper_d779bb0d(6)
		if vm.skipping() then
			return skip(7)
		end
		event.Finish()
	end
	function landing1()
		event.LoadDungeonMapFile("d03b02")
		event.LoadScript("d03b02/d03b02.stb", 502)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		local t0 = helper_160d0()
		if vm.skipping() then
			return skip(1)
		end
		if t0 ~= 0 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.SetStatusbarShow(0, 0.16666667)
		helper_d779bb0d(6)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoUseItem(371)
		do
			local skipped = vm.wait()
			var1 = event.DeferredOutput() or var1
			if skipped then
				return skip(3)
			end
		end
		if var1 == 371 then
			event.FuncPointShow("", "event", 0)
			event.SetFadeOut(20)
			helper_d779bb0d(20)
			if vm.skipping() then
				return skip(4)
			end
			event.DngSetupMainUnit(0)
			helper_1439c()
			if vm.skipping() then
				return skip(5)
			end
			event.LoadDungeonMapFile("d03b02")
			event.LoadScript("d03b02/d03b02.stb", 502)
			return
		elseif var1 > 0 then
			helper_17c58()
			if vm.skipping() then
				return skip(6)
			end
		end
		event.SetStatusbarShow(1, 0.16666667)
	end
	return part2()
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_102d4()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.FuncPointShow("", "e348", 0)
	event.EohSyncObj(0, "p07_d03b01")
	event.EohSetShow(0, 0)
	helper_52115bbf()
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_d779bb0d(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_102d4()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_16c20()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.LoadScript("d03/d03.stb", 1000)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e49eb19b(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13480.
script[13480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_102d4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13520.
script[13520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DngSetupMainUnit(0)
	helper_1439c()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadDungeonMapFile("d03b02")
	event.LoadScript("d03b02/d03b02.stb", 502)
end

return script
