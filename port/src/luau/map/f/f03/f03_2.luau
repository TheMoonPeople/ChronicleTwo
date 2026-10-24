--!strict
-- map/f/f03/f03_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0048d4e7 = require("@lib/event/helper_0048d4e7")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_13ff22fe = require("@lib/event/helper_13ff22fe")
local helper_18107086 = require("@lib/event/helper_18107086")
local helper_2850e663 = require("@lib/event/helper_2850e663")
local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_41e80f11 = require("@lib/event/helper_41e80f11")
local helper_42761601 = require("@lib/event/helper_42761601")
local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")
local helper_72334e82 = require("@lib/event/helper_72334e82")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_8501c1e4 = require("@lib/event/helper_8501c1e4")
local helper_9e2fef46 = require("@lib/event/helper_9e2fef46")
local helper_a2a9cc01 = require("@lib/event/helper_a2a9cc01")
local helper_a99d98bb = require("@lib/event/helper_a99d98bb")
local helper_aebdaee5 = require("@lib/event/helper_aebdaee5")
local helper_be5b78da = require("@lib/event/helper_be5b78da")
local helper_dff91a5d = require("@lib/event/helper_dff91a5d")
local helper_e22df8b0 = require("@lib/event/helper_e22df8b0")
local helper_e881d0f7 = require("@lib/event/helper_e881d0f7")

--- Helper function.
local function helper_1d7c0()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(302) or var0
	return var0
end

--- Helper function.
local function helper_215a8()
	helper_40e84721(307, helper_6be25ed2())
	helper_40e84721(308, helper_6be25ed2())
	helper_40e84721(311, helper_0048d4e7())
	helper_40e84721(312, helper_1d7c0())
	helper_40e84721(313, helper_a99d98bb())
	helper_40e84721(314, helper_be5b78da())
end

--- Program 99.
local function program_99()
	local var0: s32 = 0
	event.EohSyncObj(1, "p04_f0301")
	var0 = helper_6be25ed2()
	if var0 == 0 then
		event.FuncPointShow("", "event_400", 0)
		event.FuncPointShow("", "event_401", 0)
		event.FuncPointShow("", "event_402", 0)
		event.FuncPointShow("", "event_403", 0)
		event.FuncPointShow("", "event_404", 0)
	else
		event.EohSetShow(1, 0)
	end
	if helper_13ff22fe() == 0 then
		event.EohSyncObj(1, "p14_f0301")
		event.EohSetShow(1, 0)
		event.EohSyncObj(1, "p15_f0301")
		event.EohSetShow(1, 0)
		event.EohSyncObj(1, "p16_f0301")
		event.EohSetShow(1, 0)
		event.EohSyncObj(1, "p17_f0301")
		event.EohSetShow(1, 0)
	end
	helper_215a8()
end

--- Helper function.
local function helper_1e3d0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_a2a9cc01(4560010)
			end
			if at <= 2 then
				helper_dff91a5d(0)
			end
			if at <= 3 then
				helper_a2a9cc01(4560020)
			end
			if at <= 4 then
				helper_dff91a5d(0)
			end
			if at <= 5 then
				helper_7f75e08e(4)
			end
			if at <= 6 then
				helper_7f75e08e(26)
			end
			if at <= 7 then
				helper_7f75e08e(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		helper_8501c1e4(0.0, 190.0, 500.0, vm.f32(-3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		helper_8501c1e4(0.0, 190.0, 500.0, vm.f32(-3.14))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	event.SetFlag(456, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e456/")
	event.LoadMes(0, 5, "e456_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e456_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e456_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e456/e456_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e456/e456_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, -15.0, 190.0, 980.0)
	event.EohSetRot(0, 0.0, 2.42, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 10.0, 190.0, 1010.0)
	event.EohSetRot(1, 0.0, 2.66, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-121.94, 324.32, 1079.66)
	event.CmrsSetRef(60.51, 330.31, 947.34)
	event.CmrsMove2(-121.94, 324.32, 1079.66, -127.07, 330.31, 851.61, 60, 0, 1.0)
	event.SetFadeIn(30)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-43.47, 251.31, 889.38)
	event.CmrsSetRef(0.73, 198.66, 1005.94)
	event.ObjsSetMotion(0, "指さし", 6)
	event.ObjsNextMotion(0, "指さしL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a2a9cc01(4560010)
	if vm.skipping() then
		return skip(2)
	end
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "指さし戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a2a9cc01(4560020)
	if vm.skipping() then
		return skip(4)
	end
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, -15.0, 190.0, 820.0, 60)
	event.ObjsRotation(0, 0.0, 3.14, 0.0, 10)
	helper_7f75e08e(4)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, 10.0, 190.0, 870.0, 56)
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 10)
	helper_7f75e08e(26)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_1dd8c()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1d7c0() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1d7c0() == 0 then
		return 0
	end
	flag = event.GetFlag(460) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1fa94()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_9e2fef46()
			end
			if at <= 2 then
				helper_dff91a5d(0)
			end
			if at <= 3 then
				helper_dff91a5d(1)
			end
			if at <= 4 then
				helper_a2a9cc01(4600010)
			end
			if at <= 5 then
				helper_dff91a5d(1)
			end
			if at <= 6 then
				helper_a2a9cc01(4600020)
			end
			if at <= 7 then
				helper_dff91a5d(1)
			end
			if at <= 8 then
				helper_7f75e08e(4)
			end
			if at <= 9 then
				helper_7f75e08e(26)
			end
			if at <= 10 then
				helper_7f75e08e(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		helper_8501c1e4(0.0, 190.0, 500.0, vm.f32(-3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.CharaActive(32)
		event.CharaActive(33)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.LoadMes(0, -1)
		helper_8501c1e4(0.0, 190.0, 500.0, vm.f32(-3.14))
		event.ResetCamera(1, 3.14, 10)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(460, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(4514)
	var0 = event.SndLoadSound(4514) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e460/")
	event.LoadMes(0, 5, "e460_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e460_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e460_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e460/e460_mints.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e400/e460/e460_monica.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, 190.0, 1010.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(0, 6)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -15.0, 190.0, 980.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetFootSoundId(1, 6)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1.18, 274.82, 1359.97)
	event.CmrsSetRef(120.59, 276.91, 1224.84)
	event.CmrsMove2(1.18, 274.82, 1359.97, -53.13, 276.91, 1185.49, 60, 0, 1.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 70)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 10.0, 190.0, 950.0, 70)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 80)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsMove(1, -15.0, 190.0, 900.0, 60)
	event.SetFadeIn(30)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(2)
	end
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_dff91a5d(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(-86.36, 229.97, 864.78)
	event.CmrsSetRef(-1.3, 198.75, 922.91)
	event.ObjsSetRot(0, 0.0, -2.54, 0.0)
	event.ObjsResetDaPosition(0)
	event.SndSePlay(var0, 0)
	event.ObjsSetRot(1, 0.0, -2.18, 0.0)
	event.ObjsSetMotion(1, "遠見", 6, -1.0, 1)
	event.ObjsNextMotion(1, "遠見Ｌ", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_a2a9cc01(4600010)
	if vm.skipping() then
		return skip(5)
	end
	helper_dff91a5d(1)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "遠見戻り", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_a2a9cc01(4600020)
	if vm.skipping() then
		return skip(7)
	end
	helper_dff91a5d(1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(1, "走り")
	event.ObjsMove(1, -15.0, 190.0, 740.0, 60)
	event.ObjsRotation(1, 0.0, 3.14, 0.0, 10)
	helper_7f75e08e(4)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMove(0, 10.0, 190.0, 790.0, 56)
	event.ObjsRotation(0, 0.0, 3.14, 0.0, 10)
	helper_7f75e08e(26)
	if vm.skipping() then
		return skip(10)
	end
	event.SetFadeOut(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

--- Helper function.
local function helper_1daf4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetDioramaPercent(2) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_1e0cc()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1daf4() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1daf4() == 0 then
		return 0
	end
	flag = event.GetFlag(468) or flag
	if flag ~= 0 then
		return 0
	end
	var1 = event.CheckEnableCharaChange(1) or var1
	if var1 == 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_160a0()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_1612c(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_41e80f11(0, -1, 5, 0, 0)
		end
		helper_160a0()
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(612) or flag
	if flag == 0 then
		return
	end
	event.SetMesWindowMode(0, 12)
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetPos(0, 256, 208)
	event.SpriteSetPutsize(0, 512, 416)
	event.SpriteSetColor(0, 255, 255, 255, 255)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.SpriteSetDraw(0, 1)
	event.SetFadeIn(0)
	if vm.wait() then
		return skip(2)
	end
	if arg0 ~= 0 then
		event.MesMake_2(
			0,
			"On a [UNI00e9]t[UNI00e9] propuls[UNI00e9]s dans le futur\npar la machine temporelle d'Ixion."
		)
	else
		event.MesMake_2(
			0,
			"On a r[UNI00e9]int[UNI00e9]gr[UNI00e9] le pr[UNI00e9]sent gr[UNI00e2]ce [UNI00e0]\nla machine temporelle d'Ixion."
		)
	end
	if vm.wait() then
		return skip(3)
	end
	helper_41e80f11(0, -1, 5, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	if vm.wait() then
		return skip(5)
	end
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	if vm.wait() then
		return skip(6)
	end
	helper_160a0()
end

--- Helper function.
local function helper_19af8(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var17: s32 = 0
	local active_chr_no_2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_18107086()
			end
			if at <= 2 then
				helper_7f75e08e(20)
			end
			if at <= 3 then
				helper_dff91a5d(0)
			end
			if at <= 4 then
				helper_18107086()
			end
			if at <= 5 then
				print("pumpkin---------------------------\n")
				print("stripte -----------------------------\n")
				print("princess-----------------------------\n")
				print("separate----------------------------\n")
				helper_dff91a5d(6)
			end
			if at <= 6 then
				helper_7f75e08e(60)
			end
			if at <= 7 then
				helper_7f75e08e(60)
			end
			if at <= 8 then
				helper_1612c(0)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		end
		event.FadeOutBgm(30)
		event.SndSeStop(var13, 0)
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
		event.DeleteChara(37)
		if active_chr_no_2 == 1 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no_2 == 0 then
			event.DeleteChara(32)
		end
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetMotion(0, "立ち")
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(1)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	helper_18107086()
	if vm.skipping() then
		return skip(2)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.CharaActive(35)
		event.SetCharaType(35, 4)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 70.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
		event.CharaActive(36)
		event.SetCharaType(36, 4)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.88, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	else
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.CharaActive(35)
		event.SetCharaType(35, 4)
		event.EohSyncChara(3, 35)
		event.ObjsInit(3)
		event.ObjsSyncObj(3, 3)
		event.ObjsSetPos(3, 0.0, 70.0, 0.0)
		event.ObjsSetRot(3, 0.0, 0.0, 0.0)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
		event.CharaActive(36)
		event.SetCharaType(36, 4)
		event.EohSyncChara(4, 36)
		event.ObjsInit(4)
		event.ObjsSyncObj(4, 4)
		event.ObjsSetPos(4, 0.0, 0.88, 0.0)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 23.24, 0.0, -46.31)
		event.EohSetRot(2, 0.0, -0.44, 0.0)
		event.EohSetTexAnim(2, 0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 0, 4, "info", 33)
			event.LoadEquip(5, 0, 3, "info", 33)
			event.LoadEquip(5, 0, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
		end
		if active_chr_no == 0 then
			event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 1, 4, "info", 32)
			event.LoadEquip(5, 1, 3, "info", 32)
			event.LoadEquip(5, 1, 2, "info", 32, 37)
			event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 32)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 3.19, 0.0, -55.28)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, 0.02)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, -23.79, 0.0, -39.77)
		event.EohSetRot(1, 0.0, 0.64, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 3.19, 0.0, -55.28)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, 0.02)
		event.ObjsResetDaPosition(0)
		event.ObjsTexAnime(0, 0)
	end
	flag = event.GetFlag(612) or flag
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 == 0 then
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	else
		event.SetLoadbgFile("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
	end
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_7f75e08e(20)
		if vm.skipping() then
			return skip(3)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(21.59, 19.4, 49.13)
		event.CmrsSetRef(3.27, 21.44, 1.91)
	else
		event.CmrsSetPos(-1.62, 25.82, 35.3)
		event.CmrsSetRef(-0.26, 22.33, -0.02)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6)
	event.ObjsNextMotion(0, "タイムワープL", 5)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目を閉じる")
	event.ObjsTexAnime(0, 1, "すまし口")
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_18107086()
	if vm.skipping() then
		return skip(5)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.SetCharaType(38, 4)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSetPos(6, pos_x + vm.f32(0.18), pos_y + vm.f32(0.02), pos_z + vm.f32(0.3))
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	var17 = event.GetEquipItemno(1, 4) or var17
	if var17 == 263 then
		print("pumpkin---------------------------\n")
		event.ObjsSetPos(6, -0.35, 22.68, 1.67)
		event.ObjsSetRot(6, 0.0, -6.33, 0.0)
	end
	if var17 == 264 then
		print("stripte -----------------------------\n")
		event.ObjsSetPos(6, -0.48, 22.78, 2.07)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 265 then
		event.ObjsSetPos(6, -0.33, 22.73, 1.95)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 266 then
		print("princess-----------------------------\n")
		event.ObjsSetPos(6, -0.42, 22.89, 1.99)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	if var17 == 267 then
		print("separate----------------------------\n")
		event.ObjsSetPos(6, -0.23, 23.26, 2.52)
		event.ObjsSetRot(6, 0.0, -6.4, 0.0)
	end
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	event.ObjsTexAnime(0, 0, "目を閉じる")
	event.ObjsTexAnime(0, 1, "閉じたまま")
	event.ObjsTexAnime(0, 1, "すまし口")
	if flag ~= 0 then
		event.SndSePlay(var12, 2)
	end
	helper_dff91a5d(6)
	if vm.skipping() then
		return skip(6)
	end
	if arg4 == 0 then
		event.LoadChara(5, "event/time_gate/blue/atora_glare2.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare2.chr", "info", 39)
	end
	event.CharaActive(39)
	event.SetCharaType(39, 4)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.88, 0.0)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.CmrsSetPos(-2.99, 25.82, 71.15)
	event.CmrsSetRef(-0.26, 22.33, 0.02)
	event.CmrsMove2(-7.1, 25.8, 178.24, -0.26, 45.36, 0.02, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_7f75e08e(60)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_7f75e08e(60)
	if vm.skipping() then
		return skip(8)
	end
	helper_1612c(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_14eac(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local language_code: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_7f75e08e(30)
			end
			if at <= 2 then
				helper_9e2fef46()
			end
			if at <= 3 then
				helper_dff91a5d(0)
			end
			if at <= 4 then
				helper_a2a9cc01(5220010)
			end
			if at <= 5 then
				helper_a2a9cc01(5220015)
			end
			if at <= 6 then
				helper_7f75e08e(30)
			end
			if vm.skip_end() then
				return skip(8)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var7, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(522, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var7 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var7
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	event.LoadMotion(5, "event/e500/e522/e522_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 33)
		event.CharaActive(0, 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.SetCharaType(34, 4)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.LoadMes(0, 5, "event/e500/e522/e522.txt")
	else
		event.LoadMes(0, 5, "event/e500/e522/e522_1.txt")
	end
	event.SetFadeOut(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeIn(30)
	event.SndSePlay(var7, 0)
	event.InitDramaScene()
	event.CharaActive(1, 33)
	event.CmrsSetPos(5.32, 62.92, -97.07)
	event.CmrsSetRef(11.48, 61.6, -39.43)
	event.ObjsSetPos(0, 39.64, -0.0, 9.33)
	event.ObjsSetRot(0, 0.0, -2.33, 0.0)
	event.ObjsSetPos(1, 34.65, 0.0, 29.92)
	event.ObjsSetRot(1, 0.0, -2.36, 0.0)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 0)
	event.CmrsMove2(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(0, 33)
	event.CmrsSetPos(25.53, 21.33, -15.17)
	event.CmrsSetRef(32.72, 21.29, -3.29)
	event.ObjsSetRot(0, 0.0, -2.69, 0.0)
	event.CharaDaEnable(0, 0)
	event.CharaActive(1, 34)
	event.EohGetFramePos(0, "atoramiria")
	event.SetReference(0, "atoramiria", 34)
	event.SetCharaPos(34, 0.04, -1.42988, 0.89)
	event.ObjsSeDelay(2, 25)
	event.ObjsSePlay(2, var7, 1)
	event.ObjsSetMotion(2, "発動", 6)
	event.ObjsNextMotion(2, "発動L", 0)
	event.ObjsSetMotion(0, "アトラ見る", 6)
	event.ObjsNextMotion(0, "アトラ見るL", 0)
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 6)
	helper_a2a9cc01(5220010)
	if vm.skipping() then
		return skip(5)
	end
	helper_a2a9cc01(5220015)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_166e4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
	local flag: s32 = 0
	local now_party_chara_id: s32 = 0
	local active_chr_no: s32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_9e2fef46()
			end
			if at <= 2 then
				helper_18107086()
			end
			if at <= 3 then
				helper_7f75e08e(30)
			end
			if at <= 4 then
				helper_dff91a5d(0)
			end
			if at <= 5 then
				helper_18107086()
			end
			if at <= 6 then
				helper_dff91a5d(6)
			end
			if at <= 7 then
				helper_7f75e08e(60)
			end
			if at <= 8 then
				helper_7f75e08e(60)
			end
			if at <= 9 then
				helper_1612c(1)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		if flag ~= 0 then
			event.SndSeStop(var12, 0)
		else
			event.SndSeStop(var13, 0)
		end
		event.FadeOutBgm(30)
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.DelExtMotion(0)
			event.DeleteChara(33)
		end
		if active_chr_no == 1 then
			event.DeleteChara(32)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id ~= -1 then
			event.DeleteChara(34)
		end
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DeleteChara(38)
		event.DeleteChara(39)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	flag = event.GetFlag(612) or flag
	event.SetMotion(0, "立ち")
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
	end
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_9e2fef46()
	if vm.skipping() then
		return skip(2)
	end
	helper_18107086()
	if vm.skipping() then
		return skip(3)
	end
	event.InitDramaScene()
	event.SetSkipBotton(20)
	event.SetSkipFcol(255.0, 255.0, 255.0)
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	event.SetCharaShow(120, 0)
	event.SetCharaShow(121, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
	else
		event.LoadChara(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
		event.LoadChara(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
	end
	event.CharaActive(35)
	event.SetCharaType(35, 4)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 70.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CharaActive(36)
	event.SetCharaType(36, 4)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if now_party_chara_id ~= -1 then
		event.LoadCharaNpc(0, 5, now_party_chara_id, 34)
		event.CharaActive(34)
		event.EohSyncChara(2, 34)
		event.EohSetPos(2, 49.73999, 0.0, 8.969971)
		event.EohSetRot(2, 0.0, -1.76, 0.0)
	end
	if arg5 ~= 0 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 0 then
			event.GetEquipItemno(1, 2)
			event.GetEquipItemno(1, 3)
			event.GetEquipItemno(1, 4)
		end
		if active_chr_no == 1 then
			event.GetEquipItemno(0, 2)
			event.GetEquipItemno(0, 3)
			event.GetEquipItemno(0, 4)
		end
		if active_chr_no == 0 then
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 0)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			end
			event.CharaActive(0)
			event.EohSyncChara(0, 0)
			event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
			event.CharaActive(33)
			event.EohSyncChara(1, 33)
			event.LoadEquip(5, 1, 4, "info", 33)
			event.LoadEquip(5, 1, 3, "info", 33)
			event.LoadEquip(5, 1, 2, "info", 33, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
		end
		if active_chr_no == 1 then
			event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
			if flag ~= 0 then
				event.LoadMotion(5, "event/e00/e80/e80_mints.gltf", "info", 32)
			else
				event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
			end
			event.CharaActive(32)
			event.EohSyncChara(0, 32)
			event.LoadEquip(5, 0, 4, "info", 32)
			event.LoadEquip(5, 0, 3, "info", 32)
			event.LoadEquip(5, 0, 2, "info", 32, 37)
			event.CharaActive(37)
			event.EohSyncChara(5, 37)
			event.EohSetShow(5, 1)
			event.CharaActive(0)
			event.EohSyncChara(1, 0)
		end
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
		event.EohSetPos(1, 18.619995, 0.0, 35.179993)
		event.EohSetRot(1, 0.0, -2.48, 0.0)
		event.EohSetMotion(1, "立ち", 0.02)
		event.EohResetDaPosition(1)
	else
		event.GetEquipItemno(1, 2)
		event.GetEquipItemno(1, 3)
		event.GetEquipItemno(1, 4)
		event.LoadMotion(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
		event.LoadMotion(5, "event/e500/e523/e523_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.ObjsSetPos(0, 38.0, 0.0, 22.0)
		event.ObjsSetRot(0, 0.0, -2.12, 0.0)
		event.ObjsSetMotion(0, "立ち", 4)
		event.ObjsTexAnime(0, 0)
	end
	if flag ~= 0 then
		var12 = event.SndLoadSound(8, "snd2/sp/sp_043.sound.json") or var12
	else
		var13 = event.SndLoadSound(8, "snd2/sp/sp_013.sound.json") or var13
	end
	if arg4 ~= 0 then
		event.SetLoadbgFile("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
	else
		event.SetLoadbgFile("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
	end
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "旧・立ち", 4)
	event.ObjsResetDaPosition(0)
	if flag ~= 0 then
		event.SndSePlay(var12, 0)
	else
		event.SndSePlay(var13, 0)
		helper_7f75e08e(30)
		if vm.skipping() then
			return skip(4)
		end
	end
	event.SetFadeIn(30)
	if flag ~= 0 then
		event.CmrsSetPos(-56.29, 15.74, 3.56)
		event.CmrsSetRef(-12.65, 16.48, 2.06)
	else
		event.CmrsSetPos(-48.179993, 19.61, -28.70996)
		event.CmrsSetRef(-0.789978, 16.48, -0.05999756)
	end
	if arg5 == 0 and arg4 == 0 and flag == 0 then
		event.CmrsSetPos(-30.09, 19.5, 4.41)
		event.CmrsSetRef(-14.63, 21.71, 1.0)
	end
	event.ObjsSetMotion(0, "タイムワープ", 6, 0.45)
	event.ObjsNextMotion(0, "タイムワープL", 4)
	event.ObjsTexAnime(0, 1, "開閉口")
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_18107086()
	if vm.skipping() then
		return skip(6)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
	else
		event.LoadChara(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
	end
	if flag ~= 0 then
		event.CharaActive(0, 38)
	else
		event.CharaActive(1, 38)
	end
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	do
		local out1, out2, out3 = event.EohGetFramePos(0, "atoramiria")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	if arg4 ~= 0 then
		event.ObjsSetPos(6, pos_x, pos_y, pos_z)
	else
		event.ObjsSetPos(6, -3.54, 17.04, -1.46)
	end
	event.ObjsSetRot(6, -0.45, -2.12, 0.0)
	event.CmrsSetPos(-21.5, 23.92, -12.580017)
	event.CmrsSetRef(-0.789978, 16.17, -0.05999756)
	event.ObjsTexAnime(0, 0, "開閉口")
	event.ObjsTexAnime(0, 1, "開き口")
	event.ObjsSetMotion(0, "タイムワープL", 5)
	event.ObjsSetMotion(6, "発動", 6)
	event.ObjsNextMotion(6, "発動L", 4)
	if flag == 0 then
		helper_dff91a5d(6)
		if vm.skipping() then
			return skip(7)
		end
	else
		event.SndSePlay(var12, 2)
	end
	if arg4 ~= 0 then
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	else
		event.LoadChara(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
	end
	event.CharaActive(39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 0.0, 0.0)
	event.ObjsSetRot(7, 0.0, -2.12, 0.0)
	event.CmrsSetPos(-40.590027, 19.47, -24.339966)
	event.CmrsSetRef(13.950012, 15.23, 9.190002)
	event.CmrsMove2(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
	event.ObjsSetScale(3, 2.8, 2.8, 2.8, 90)
	event.ObjsSetScale(4, 2.0, 2.0, 2.0, 90)
	event.ObjsSetScale(7, 2.0, 2.0, 2.0, 90)
	helper_7f75e08e(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_7f75e08e(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_1612c(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1d3d8(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_14eac(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_166e4(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_166e4(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_19af8(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_14eac(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_166e4(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_22ae0(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_dff91a5d(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_22fe4(arg0: f32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(30)
		end
	end
	helper_22ae0(arg0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var2 = event.GetSndId(2) or var2
	if arg1 ~= 0 then
		event.SndSePlay(var2, 92)
	else
		event.SndSePlay(var2, 94)
	end
	event.SetFadeOut(30)
	helper_7f75e08e(30)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_10ca4()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aebdaee5(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_e22df8b0(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_aebdaee5(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_42761601(player_chara_2, var22)
		end
		if at <= 5 then
			helper_aebdaee5(0, -1, var1, player_chara_2, 0)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"H[UNI00e9] ! Qui [UNI00ea]tes... ? Ceci est le plus\ngrand des centres de recherches,\nle Laboratoire psych[UNI00e9]-psychique.<page>Et m[UNI00ea]me si pour l'instant il n'en\na pas trop l'aspect, nous devrions\npouvoir terminer nos recherches."
				)
			else
				event.MesMake_2(
					0,
					"Il est impossible de qualifier le\nniveau d'excellence du Labo psy.\nIl faut le voir pour le croire."
				)
			end
		else
			event.MesMake_2(
				0,
				"Si on laisse faire Griffon,\nl'histoire ne reprendra jamais\nson cours normal.<page>L'existence m[UNI00ea]me de Griffon\nperturbe le cours de l'histoire."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haaan, houuu, haaan, houuu.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Ces quelques trucs t'aideront [UNI00e0]\ninventer un aquarium : une bo[UNI00ee]te en\nbois, une fen[UNI00ea]tre et une fontaine.\nTu as bien [UNI00e7]a dans ta ville, non ?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							"D[UNI00e9]j[UNI00e0], donne un \"ver [UNI00e9]lectrique\" [UNI00e0]\nun poisson de l'aquarium pour\nl'[UNI00e9]lectrifier. Ensuite donne<page>ce poisson au Shigura. Tu as bien\ncompris, hein ?"
						)
					else
						event.MesMake_2(
							0,
							"Ooh, alors tu as le poisson ?\nMaintenant, donne-le au Shigura.\nTu devrais y arriver, non ?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"H[UNI00e9] bien, oui, tu y es arriv[UNI00e9] !\nOn dirait que mon invention a\nmarch[UNI00e9] pour toi, hein ? H[UNI00e9] oui."
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(0, "Que ce soit Osmond ou le directeur\ndu labo, ils sont un peu bizarres\nici.")
	end
	if var2 == 303 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(448) or flag_8
					if flag_8 == 0 then
						event.MesMake_2(
							0,
							"Prends soin de la traducoquille\ncar c'est l'une des plus\nimportantes inventions du Labo psy."
						)
					else
						event.MesMake_2(
							0,
							"Le temps presse. D[UNI00e9]p[UNI00ea]che-toi,\nles forces de Griffon s'approchent\nd'H[UNI00e9]l[UNI00e8]ne, et elles sont rapides..."
						)
					end
				else
					event.MesMake_2(0, "Je me demande quel type de\npersonne peut [UNI00ea]tre ce Griffon...")
				end
			else
				event.MesMake_2(
					0,
					"Les pierres que tu cherches sont les\ncristaux de sagesse des anciens.<page>Selon l'analyse de l'ordinateur du\nLabo psy, elles sont cach[UNI00e9]es en\nquatre lieux diff[UNI00e9]rents :"
				)
				helper_2850e663(player_chara, var1, 0)
				if vm.skipping() then
					return skip(1)
				end
				helper_aebdaee5(0, -1, var1, player_chara, 0)
				if vm.skipping() then
					return skip(2)
				end
				var3 = 1
				event.MesMake_2(
					0,
					"le Bois du Papillon arc-en-ciel, le\nCa[UNI00f1]on astral, la Caverne grondante \net le Mt. Gundor.<page>[UNI00c0] l'entr[UNI00e9]e de chaque lieu, il\ndevrait y avoir un symbole en forme\nd'[UNI00e9]toile... Ouvre bien les yeux."
				)
			end
		else
			event.MesMake_2(
				0,
				"Bien, il est temps d'[UNI00e9]liminer\nGriffon. Le destin du monde est\nentre vos mains. Bonne chance !"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"Tout est question de talent dans ce\nLabo. M[UNI00ea]me un enfant, s'il est tr[UNI00e8]s\ndou[UNI00e9], peut [UNI00ea]tre le chef ici."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Les lunites du Shigura aident [UNI00e0]\nnous lib[UNI00e9]rer l'esprit et [UNI00e0] nous\nconcentrer sur nos recherches.<page>Mais je ne sais pas exactement en\nquoi consistent ces lunites..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Un labo oc[UNI00e9]anique, c'est pas top ?\nTu te rends compte du travail que\nj'ai fourni pour travailler ici ?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Que penses-tu du design du Labo ?\nJe me demande qui a eu l'id[UNI00e9]e\nde ce dr[UNI00f4]le de concept..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Un jour, je les surpasserai et ils\nverront mon intelligence. Ici, tout\nest question de talent, tu sais."
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			"Je respecte beaucoup le patron. Il\nfaut reconna[UNI00ee]tre qu'un type qui\n[UNI00e9]crit un best-seller de 40 volumes<page> \"La Bible du G[UNI00e9]nie scientifique\n\" [UNI00e0] son [UNI00e2]ge, c'est quelqu'un."
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Je suis encore novice ici. Mais\nje progresse chaque jour, je\ndeviendrai un grand chercheur."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"Depuis ce labo, la vue sur la\nmer est exceptionnelle.<page>Tr[UNI00e8]s loin, [UNI00e0] l'horizon,\nl'obscurit[UNI00e9] de la mer et\ncelle du ciel fusionnent."
		)
	end
	if var2 == 312 then
		event.MesMake_2(
			0,
			"Ici c'est le Labo N[UNI00b0]2.<page>Au Labo psy, les laboratoires\ntravaillent tous sur\ndes domaines diff[UNI00e9]rents."
		)
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Ici, au Labo psy, nous simulons un\nenvironnement nocturne pour activer\nle pouvoir des lunites."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Quand j'ai commenc[UNI00e9] ici, moi aussi\nje me perdais sans cesse dans les\nlabos. Je vais t'expliquer : le<page>Labo 1 est rouge, le 2 est bleu,\nle 3 est violet et le Labo 4 est\nvert. Chacun a sa propre couleur."
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "L'embl[UNI00e8]me au-dessus du Labo\ncentral repr[UNI00e9]sente la lune.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Il para[UNI00ee]t que ce Labo a pu [UNI00ea]tre\ntermin[UNI00e9] gr[UNI00e2]ce aux lunites apport[UNI00e9]es\npar Shingala, un Drac de mer. <page>Il semble que ces cr[UNI00e9]atures soient\nplut[UNI00f4]t intelligentes, hein ? "
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Ne lui dis pas que je t'ai dit [UNI00e7]a,<page> mais on en a ras-le-bol des\nsoi-disant blagues d'Osmond.\n Elles donnent envie de le frapper."
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"C'est vrai, moi aussi, j'ai pris\npart aux [UNI00e9]tudes du Ver [UNI00e9]lectrique.\nL[UNI00e0], je bosse sur un autre projet.<page> Ah non ! Je ne dirai pas quoi !\nJe peux pas le raconter [UNI00e0] tout le\nmonde, c'est top secret !"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Comment ? Toi aussi tu veux\ndevenir chercheur ?<page>C'est pas [UNI00e9]vident pour y arriver,\ntu sais.\nIl y a beaucoup de concurrence."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Certains chercheurs critiquent le\ndesign du Labo psy. Pour ma part,\nje le trouve plut[UNI00f4]t chouette...<page> Mais il semble que je sois un\ndes rares [UNI00e0] l'appr[UNI00e9]cier."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Nous discutons de recherches\ntr[UNI00e8]s confidentielles.<page>Pourriez-vous nous laisser\n seuls pendant un petit moment ?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Pardonnez-nous, mais notre\ndiscussion concerne des\nrecherches tr[UNI00e8]s confidentielles.<page>On ne peut pas vraiment vous\nparler pour le moment, alors..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Dr Nobb est tr[UNI00e8]s talentueux,\nbien s[UNI00fb]r, mais il\ntravaille aussi tr[UNI00e8]s dur.<page>En comparaison, je fais bien peu...\nJe serais presque paresseux..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"C'est toi ? On m'a dit que tu\nt'[UNI00e9]tais pris le bec avec Dr Osmond.<page>Je ne critique pas. Je trouve [UNI00e7]a\nbien. La remise en cause permet\nsouvent de nouvelles d[UNI00e9]couvertes."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Tu n'arrives pas [UNI00e0] t'habituer aux\nlumi[UNI00e8]res fortes, hein ?<page>Je suppose qu'il vous faudra\nun peu de temps pour vous y\nhabituer, vous qui venez du pass[UNI00e9]."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"H[UNI00e9] bien, je fais une petite\npause.<page> Il faut parfois donner [UNI00e0] son\ncerveau un temps de repos, sinon on\nfinit par perdre de son acuit[UNI00e9]."
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"Para[UNI00ee]t que t'es bon inventeur ?\n Alors plus tard, [UNI00e7]a te dirait\nde venir travailler ici ?<page>Ce Labo psy sera tout juste fini\nquand tu deviendras adulte. Tu y\n serais s[UNI00fb]rement bien accueilli."
			)
		else
			event.MesMake_2(
				0,
				"Tu trouves pas que les inventeurs\nont beaucoup de charme ?<page>Mais ne tombe pas amoureuse de moi,\nmes recherches, c'est toute ma vie.\n[UNI00c7]a ne marcherait jamais entre nous."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"J'ai une id[UNI00e9]e r[UNI00e9]volutionnaire. Un\nsyst[UNI00e8]me qui permettrait [UNI00e0] monstres\net hommes de vivre en harmonie.<page>Je vais cr[UNI00e9]er une machine qui\ncomprend la langue humaine."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Les lunites sont [UNI00e0] la base de\ntoutes les activit[UNI00e9]s du Labo psy.<page>Sans elles, tous nos syst[UNI00e8]mes\ns'arr[UNI00ea]teraient instantan[UNI00e9]ment."
		)
	end
	if var3 == 0 then
		helper_e22df8b0(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_aebdaee5(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.GetRotLookPos(var19 - var16, var21 - var18) or var22
		helper_42761601(player_chara_2, var22)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var22, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_aebdaee5(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local var1: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				local _ = helper_1dd8c()
				var1 = 1
				helper_1fa94()
				if not vm.skipping() then
					return part2()
				end
			end
			if at <= 2 then
				local _ = helper_1e0cc()
				var1 = 1
			end
			return
		end
		if at <= 4 then
			helper_e881d0f7(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
		end
		if at <= 5 then
			helper_e881d0f7(0.0, 360.0, -755.0, 0.0)
			helper_e881d0f7(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
			helper_e881d0f7(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
			helper_e881d0f7(315.0, 280.0, -1515.0, vm.f32(2.3561945))
			helper_e881d0f7(315.0, 280.0, -885.0, vm.f32(0.7853982))
		end
		if at <= 6 then
			helper_e881d0f7(1080.0, 190.0, -120.0, vm.f32(-2.355))
		end
		if at <= 7 then
			helper_e881d0f7(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
		end
		if at <= 8 then
			helper_e881d0f7(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
		end
		helper_e881d0f7(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
		print("map_no=", old_map_no, "##############\n")
		print("old_submap_no=", old_sub_map_no, "##############\n")
		print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
	end
	function part2()
		if helper_1e0cc() ~= 0 then
			var1 = 1
			event.BgmPlayCancel()
			event.MapJump(-1, "f03i0301", 504)
			if vm.wait() then
				return skip(3)
			end
		end
		if var1 == 1 then
			return
		end
		old_map_no = event.GetOldMapNo() or old_map_no
		if old_map_no == 2 then
			event.Initialize()
			if vm.wait() then
				return skip(4)
			end
			helper_e881d0f7(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			event.ResetCamera(1, 3.14, 2.0)
			event.SetFadeIn(30)
		end
		if old_map_no == 110 then
			event.Initialize()
			if vm.wait() then
				return skip(5)
			end
			var3 = event.GetCnt(2) or var3
			if var3 == 0 then
				helper_e881d0f7(0.0, 360.0, -755.0, 0.0)
			end
			if var3 == 1 then
				helper_e881d0f7(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
			end
			if var3 == 2 then
				helper_e881d0f7(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
			end
			if var3 == 3 then
				helper_e881d0f7(315.0, 280.0, -1515.0, vm.f32(2.3561945))
			end
			if var3 == 4 then
				helper_e881d0f7(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			event.ResetCamera(1, 0.0, 2.0)
			event.SetFadeIn(30)
		end
		if old_map_no == 113 then
			event.Initialize()
			if vm.wait() then
				return skip(6)
			end
			helper_e881d0f7(1080.0, 190.0, -120.0, vm.f32(-2.355))
			event.ResetCamera(1, 0.0, 2.0)
			event.SetFadeIn(30)
		end
		if old_map_no == 141 then
			event.Initialize()
			if vm.wait() then
				return skip(7)
			end
			helper_e881d0f7(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			event.ResetCamera(1, 0.0, 2.0)
			event.SetFadeIn(30)
		end
		if old_map_no == 142 then
			event.Initialize()
			if vm.wait() then
				return skip(8)
			end
			helper_e881d0f7(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			event.ResetCamera(1, 0.0, 2.0)
			event.SetFadeIn(30)
		end
		if old_map_no == 114 then
			event.Initialize()
			if vm.wait() then
				return skip(9)
			end
			helper_e881d0f7(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			event.ResetCamera(1, 0.0, 2.0)
			event.SetFadeIn(30)
		end
		old_sub_map_no = event.GetOldSubmapNo() or old_sub_map_no
		get_old_interior_map_no = event.GetOldInteriorMapNo() or get_old_interior_map_no
		print("map_no=", old_map_no, "##############\n")
		print("old_submap_no=", old_sub_map_no, "##############\n")
		print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
	end
	program_99()
	helper_215a8()
	event.GetDioramaPercent(2)
	var1 = 0
	if helper_72334e82() ~= 0 then
		var1 = 1
		helper_1e3d0()
		if vm.skipping() then
			return skip(1)
		end
	end
	if helper_1dd8c() ~= 0 then
		var1 = 1
		helper_1fa94()
		if vm.skipping() then
			return skip(2)
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "[UNI00c7]a s'ouvre pas. Essayons plus tard.")
	helper_41e80f11(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1d3d8(160.0, vm.f32(286.2), 1849.5, 0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g03")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(3.1415927), 1)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 0)
	event.MapJump(-1, "f03i04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 401.
script[401] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 2)
	event.MapJump(-1, "f03i04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 402.
script[402] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(2.3561945), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 1)
	event.MapJump(-1, "f03i04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 403.
script[403] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(-2.3561945), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 4)
	event.MapJump(-1, "f03i04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 404.
script[404] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(-0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(2, 3)
	event.MapJump(-1, "f03i04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 405.
script[405] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(408) or flag
	flag_2 = event.GetFlag(412) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.BgmLoadCancel()
	end
	event.MapJump(-1, "f03i0301", 100)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 406.
script[406] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	flag = event.GetFlag(400) or flag
	flag_2 = event.GetFlag(420) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.SetMotion(0, "立ち")
		helper_125385ee(0, 1)
		event.MesMake_2(0, "[UNI00c7]a s'ouvre pas. Essayons plus tard.")
		helper_41e80f11(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		return
	else
		flag_3 = event.GetFlag(428) or flag_3
		if flag_3 == 0 then
			event.BgmLoadCancel()
		end
	end
	helper_22fe4(vm.f32(-2.3561945), 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MapJump(-1, "f03i0302", 100)
	if vm.wait() then
		return skip(3)
	end
end

--- Program 407.
script[407] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(2.3561945), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f03i0303", 100)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 408.
script[408] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22fe4(vm.f32(-0.7853982), 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "f03i0304", 100)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10ca4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 14560.
script[14560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(2, 2, 0)
	event.DbgSetAnalyzeFlag(2, 3, 0)
	event.DbgSetAnalyzeFlag(2, 4, 0)
	event.DbgSetAnalyzeFlag(2, 5, 0)
	event.DbgSetAnalyzeFlag(2, 6, 0)
	event.DbgSetAnalyzeFlag(2, 7, 0)
	event.DbgSetAnalyzeFlag(2, 8, 0)
	event.DbgSetAnalyzeFlag(2, 9, 0)
	event.DbgSetAnalyzeFlag(2, 0, 1)
	event.DbgSetAnalyzeFlag(2, 1, 1)
	event.SetFlag(456, 0)
	event.SetFlag(460, 1)
	event.MapJump(-1, 82, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 14600.
script[14600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(2, 3, 0)
	event.DbgSetAnalyzeFlag(2, 4, 0)
	event.DbgSetAnalyzeFlag(2, 5, 0)
	event.DbgSetAnalyzeFlag(2, 6, 0)
	event.DbgSetAnalyzeFlag(2, 7, 0)
	event.DbgSetAnalyzeFlag(2, 8, 0)
	event.DbgSetAnalyzeFlag(2, 9, 0)
	event.DbgSetAnalyzeFlag(2, 0, 1)
	event.DbgSetAnalyzeFlag(2, 1, 1)
	event.DbgSetAnalyzeFlag(2, 2, 1)
	event.SetFlag(456, 1)
	event.SetFlag(460, 0)
	event.MapJump(-1, 82, 100)
	if vm.wait() then
		return skip(1)
	end
end

return script
