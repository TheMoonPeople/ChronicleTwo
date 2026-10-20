--!strict
-- map/f/f03/f03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local function helper_1d2d0()
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
local function helper_210b8()
	helper_40e84721(307, helper_6be25ed2())
	helper_40e84721(308, helper_6be25ed2())
	helper_40e84721(311, helper_0048d4e7())
	helper_40e84721(312, helper_1d2d0())
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
	helper_210b8()
end

--- Helper function.
local function helper_1dee0()
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
local function helper_1d89c()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1d2d0() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1d2d0() == 0 then
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
local function helper_1f5a4()
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
local function helper_1d604()
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
local function helper_1dbdc()
	local flag: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1d604() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1d604() == 0 then
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
local function helper_15c00()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_15c8c(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_41e80f11(0, -1, 5, 0, 0)
		end
		helper_15c00()
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
		event.MesMake_2(0, "Siamo andati nel futuro con un\nviaggio temporale dell'Ixion.")
	else
		event.MesMake_2(0, "Siamo tornati al presente con un\nviaggio temporale dell'Ixion.")
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
	helper_15c00()
end

--- Helper function.
local function helper_19608(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_15c8c(0)
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
	helper_15c8c(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_14a0c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
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
local function helper_161f4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_15c8c(1)
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
	helper_15c8c(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1cee8(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_14a0c(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_161f4(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_161f4(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_19608(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_14a0c(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_161f4(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_225f0(arg0: f32)
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
local function helper_22af4(arg0: f32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7f75e08e(30)
		end
	end
	helper_225f0(arg0)
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
local function helper_10aa4()
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
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	var3 = 0
	if var2 == 300 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(456) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Eh? Chi siete...?\nIl Laboratorio di Scienza Lunatica\n[UNI00e8] il miglior centro di ricerca<page>del mondo. Non [UNI00e8] ancora un\ngranch[UNI00e9], ma dovremmo riuscire\na terminare i nostri studi."
				)
			else
				event.MesMake_2(
					0,
					"Le parole non possono descrivere\nla maestosit[UNI00e0] del Lab-Lunatica.\nDovete vederlo con i vostri occhi."
				)
			end
		else
			event.MesMake_2(
				0,
				"Se la questione Grifone non viene\nrisolta, la storia non torner[UNI00e0]\nmai com'era prima.<page>La sola esistenza di Grifone\naltera il corso della storia."
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.GetFlag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.GetFlag(408) or flag_4
			if flag_4 == 0 then
				event.MesMake_2(0, "Haahn, shooo, haahn, shooo.")
				var3 = 2
			else
				argc = event.GetInventionId(309) or argc
				if argc < 0 then
					event.MesMake_2(
						0,
						"Ecco delle dritte per inventare un\nacquario: Una Scatola di Legno,\nuna Finestra e una Fontana. Puoi\ntrovarli in citt[UNI00e0], capito?"
					)
				else
					var9 = event.GetSavedataEtc(2) or var9
					if var9 == 0 then
						event.MesMake_2(
							0,
							"Prima, dai un \"Verme elettrico\"\na un pesce dell'acquario\nper elettrificarlo.<page>Poi, dai il pesce allo Shigura.\nTutto chiaro, 'sta volta?"
						)
					else
						event.MesMake_2(
							0,
							"Ooh, hai il pesce, vero?\nDallo da mangiare allo Shigura!\nNon dovrebbe essere difficile, no?"
						)
					end
				end
			end
		else
			event.MesMake_2(
				0,
				"Bene! Sembra ce l'abbiate fatta!\nA quanto pare, la mia invenzione\n[UNI00e8] stata proprio utile, eh?"
			)
		end
	end
	if var2 == 302 then
		event.MesMake_2(0, "Che sia Osmond o il capo del\nlaboratorio, ce n'[UNI00e8] di matti qui!")
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
							"Badate alla Radioconchiglia.\n[UNI00c8] tra le invenzioni pi[UNI00f9]\nimportanti del Lab-Lunatica."
						)
					else
						event.MesMake_2(
							0,
							"Presto, muovetevi! Le truppe\ndi Grifone stanno raggiungendo\nElena: non resisteranno a lungo..."
						)
					end
				else
					event.MesMake_2(0, "Mi chiedo che uomo sia\nquesto Grifone...")
				end
			else
				event.MesMake_2(
					0,
					"Cercate le gemme? Sono cristalli\ndi saggezza, forgiati dagli antichi.<page>Secondo l'analisi del computer del\nLab-Lunatica,si trovano nascoste\nin quattro luoghi:"
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
					"il Bosco Farfalla Arcobaleno, il\nCanyon Stellare, la Caverna \nRuggente e il Monte Gundor.<page>Un simbolo a forma di stella\ndovrebbe trovarsi ad ogni entrata,\nquindi fate attenzione."
				)
			end
		else
			event.MesMake_2(
				0,
				"Bene, [UNI00e8] ora di sistemare Grifone\nper sempre! Il destino del mondo [UNI00e8]\nnelle vostre mani. Buona fortuna!"
			)
		end
	end
	if var2 == 304 then
		event.MesMake_2(
			0,
			"In questo laboratorio, anche un\nragazzino, con le giuste qualit[UNI00e0],\npu[UNI00f2] diventare un pezzo grosso."
		)
	end
	if var2 == 305 then
		event.MesMake_2(
			0,
			"Le Pietre Luna, portate dagli\nShigura, ci liberano la mente per\nmeglio concentrarci sulla ricerca.<page>Ma non saprei dirti cosa siano\nesattamente queste Pietre Luna..."
		)
	end
	if var2 == 306 then
		event.MesMake_2(
			0,
			"Un laboratorio sull'oceano, niente\nmale, eh? Sapete quanto ho dovuto\nfaticare per avere un posto qui?"
		)
	end
	if var2 == 307 then
		event.MesMake_2(
			0,
			"Che ne pensate del progetto del\nLab-Lunatica? Chiss[UNI00e0] chi ha ideato\nil parco dei divertimenti..."
		)
	end
	if var2 == 308 then
		event.MesMake_2(
			0,
			"Un giorno dimostrer[UNI00f2] a tutti\nquanto sono in gamba! Sapete,\nqui si tratta solo di abilit[UNI00e0]."
		)
	end
	if var2 == 309 then
		event.MesMake_2(
			0,
			'Sapete, io rispetto molto il capo.\n[UNI00c8] da ammirare uno che scrive\nun best seller di 40 volumi,<page>"La Bibbia del Super\nScienziato,", a quell\'et[UNI00e0] poi!'
		)
	end
	if var2 == 310 then
		event.MesMake_2(
			0,
			"Io sono ancora un pivellino qui.\nSto imparando molto e un giorno\ndiventer[UNI00f2] un grande ricercatore."
		)
	end
	if var2 == 311 then
		event.MesMake_2(
			0,
			"La vista del mare da questo\nlaboratorio [UNI00e8] incredibile.<page>Laggi[UNI00f9] all'orizzonte,\nl'oscurit[UNI00e0] del mare e del cielo\nsi fondono in un tutt'uno."
		)
	end
	if var2 == 312 then
		event.MesMake_2(
			0,
			"Questo [UNI00e8] il Laboratorio Numero 2.<page>Nel Lab-Lunatica, ogni\nsingolo laboratorio ha\nla sua area di ricerca."
		)
	end
	if var2 == 313 then
		event.MesMake_2(
			0,
			"Al Lab-Lunatica, viene simulato\nun ambiente notturno che amplifica\nil potere delle Pietre Luna."
		)
	end
	if var2 == 314 then
		event.MesMake_2(
			0,
			"Quando iniziai a lavorare qui, non\nriuscivo neanch'io a distinguere i\nlaboratori. Questo pu[UNI00f2] aiutarvi:<page>il laboratorio 1 [UNI00e8] rosso, il 2 [UNI00e8]\nblu, il 3 [UNI00e8] viola e il 4 [UNI00e8] verde.\nUn colore per ogni laboratorio!"
		)
	end
	if var2 == 315 then
		event.MesMake_2(0, "L'emblema sul Laboratorio Centrale\nha la forma della luna.")
	end
	if var2 == 316 then
		event.MesMake_2(
			0,
			"Ho saputo che il Laboratorio [UNI00e8]\nstato terminato grazie alle Pietre\nLuna portate dal drago Shingala.<page>A quanto pare, alcuni draghi\nmarini sanno essere in gamba, eh?"
		)
	end
	if var2 == 317 then
		event.MesMake_2(
			0,
			"Non dirglielo, ma ne abbiamo fin<page>sopra i capelli delle cosiddette\nbattute di Osmond.\nSono cos[UNI00ec] irritanti!"
		)
	end
	if var2 == 318 then
		event.MesMake_2(
			0,
			"Ebbene s[UNI00ec]: anch'io ho contribuito\nalla ricerca sul Verme elettrico.\nOra seguo un altro progetto.<page>Ehi, non posso rivelare quale!\nTop secret! Mica posso andare a\nspifferarlo ai quattro venti!"
		)
	end
	if var2 == 319 then
		event.MesMake_2(
			0,
			"Cosa? Anche voi ragazzi volete\ndiventare dei ricercatori?<page>Non penserete mica che sia una\npasseggiata entrare qui?!\nLa competizione [UNI00e8] spietata."
		)
	end
	if var2 == 320 then
		event.MesMake_2(
			0,
			"Alcuni ricercatori criticano i\nprogetti qui al Lab-Lunatica.\nIn effetti non sono un granch[UNI00e9]...<page>Ad ogni modo, [UNI00e8] solo\nuna piccola minoranza."
		)
	end
	if var2 == 321 then
		event.MesMake_2(
			0,
			"Siamo nel mezzo di una riunione\nsu ricerche di massima segretezza.<page>Vi spiacerebbe lasciarci\nsoli un momento?"
		)
	end
	if var2 == 322 then
		event.MesMake_2(
			0,
			"Mi spiace molto, ma siamo nel\nmezzo di una riunione su\nricerche di massima segretezza.<page>Non possiamo andare avanti\ncon voi qui, quindi..."
		)
	end
	if var2 == 323 then
		event.MesMake_2(
			0,
			"Il Dottor Nobb [UNI00e8] un vero genio,\ncerto, ma [UNI00e8] anche un\ngran lavoratore.<page>Io impallidisco a confronto...\nUn vero albino direi..."
		)
	end
	if var2 == 324 then
		event.MesMake_2(
			0,
			"Sei tu? Ho sentito dire che hai\nlitigato con il Dottor Osmond.<page>Ehi! Non sto criticando, anzi! Le\nscoperte avvengono quando si mette\nin discussione qualcosa."
		)
	end
	if var2 == 325 then
		event.MesMake_2(
			0,
			"Dite di non riuscire ad abituarvi\nalla luce intensa?<page>Ritengo che per voi\nvisitatori dal passato\nci voglia del tempo per adattarsi."
		)
	end
	if var2 == 326 then
		event.MesMake_2(
			0,
			"Beh, sto riprendendo\nfiato un attimo.<page>Bisogna far riposare il cervello\ndi quando in quando, altrimenti\nsi d[UNI00e0] fuori di matto!"
		)
	end
	if var2 == 327 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no ~= 1 then
			event.MesMake_2(
				0,
				"So che sei bravino come inventore.\nChe ne dici? Ti andrebbe di venire\na lavorare con noi da grande?<page>Per allora, il Lab-Lunatica sar[UNI00e0]\nstato appena terminato. La tua\ncollaborazione sar[UNI00e0] apprezzata."
			)
		else
			event.MesMake_2(
				0,
				"Non credi che gli inventori\nsiano veramente affascinanti?<page>Beh, vedi di non innamorarti di\nme, intesi? La ricerca [UNI00e8] la mia\nvita. Non funzionerebbe mai."
			)
		end
	end
	if var2 == 328 then
		event.MesMake_2(
			0,
			"Ho avuto un'idea rivoluzionaria:\nun sistema che permette ai mostri\ndi vivere al fianco degli Umani.<page>Realizzer[UNI00f2] una macchina che\ncomprende il linguaggio umano."
		)
	end
	if var2 == 329 then
		event.MesMake_2(
			0,
			"Le Pietre Luna sono la spina\ndorsale del Lab-Lunatica.<page>Senza, tutto il nostro\nsistema si paralizzerebbe."
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
				local _ = helper_1d89c()
				var1 = 1
				helper_1f5a4()
				if not vm.skipping() then
					return part2()
				end
			end
			if at <= 2 then
				local _ = helper_1dbdc()
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
		if helper_1dbdc() ~= 0 then
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
	helper_210b8()
	event.GetDioramaPercent(2)
	var1 = 0
	if helper_72334e82() ~= 0 then
		var1 = 1
		helper_1dee0()
		if vm.skipping() then
			return skip(1)
		end
	end
	if helper_1d89c() ~= 0 then
		var1 = 1
		helper_1f5a4()
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
	event.MesMake_2(0, "Non si apre. Riproviamo dopo.")
	helper_41e80f11(0, -1, 5, 256, 208)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1cee8(160.0, vm.f32(286.2), 1849.5, 0.0)
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
	helper_22af4(vm.f32(3.1415927), 1)
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
	helper_22af4(vm.f32(0.7853982), 0)
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
	helper_22af4(vm.f32(2.3561945), 0)
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
	helper_22af4(vm.f32(-2.3561945), 0)
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
	helper_22af4(vm.f32(-0.7853982), 0)
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
	helper_22af4(vm.f32(0.7853982), 0)
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
		event.MesMake_2(0, "Non si apre. Riproviamo dopo.")
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
	helper_22af4(vm.f32(-2.3561945), 0)
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
	helper_22af4(vm.f32(2.3561945), 0)
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
	helper_22af4(vm.f32(-0.7853982), 0)
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
	helper_10aa4()
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
