--!strict
-- map/f/f04/f04_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00bf9baa = require("@lib/event/helper_00bf9baa")
local helper_1209c623 = require("@lib/event/helper_1209c623")
local helper_1e3fcd92 = require("@lib/event/helper_1e3fcd92")
local helper_1effc8e5 = require("@lib/event/helper_1effc8e5")
local helper_2d2dcd04 = require("@lib/event/helper_2d2dcd04")
local helper_307f5027 = require("@lib/event/helper_307f5027")
local helper_310b1032 = require("@lib/event/helper_310b1032")
local helper_35522b05 = require("@lib/event/helper_35522b05")
local helper_35fe0d1b = require("@lib/event/helper_35fe0d1b")
local helper_3ebf8f70 = require("@lib/event/helper_3ebf8f70")
local helper_40e84721 = require("@lib/event/helper_40e84721")
local helper_47d0a278 = require("@lib/event/helper_47d0a278")
local helper_4b879185 = require("@lib/event/helper_4b879185")
local helper_6213684d = require("@lib/event/helper_6213684d")
local helper_878ce637 = require("@lib/event/helper_878ce637")
local helper_b12236ef = require("@lib/event/helper_b12236ef")
local helper_bda50c78 = require("@lib/event/helper_bda50c78")
local helper_c027080d = require("@lib/event/helper_c027080d")
local helper_c6e079ae = require("@lib/event/helper_c6e079ae")
local helper_de8ac2af = require("@lib/event/helper_de8ac2af")

--- Helper function.
local function helper_1c578()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(410) or var0
	return var0
end

--- Helper function.
local function helper_1c2e8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(403) or var0
	return var0
end

--- Helper function.
local function helper_1c4d4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(406) or var0
	return var0
end

--- Helper function.
local function helper_2a390()
	helper_40e84721(401, helper_1c2e8())
	if helper_de8ac2af() == 0 then
		helper_40e84721(406, 0)
	end
	if helper_1c4d4() == 0 then
		helper_40e84721(407, 0)
	end
end

--- Program 99.
local function program_99()
	if helper_1c578() ~= 0 then
		event.EohSyncObj(0, "p10_f0401")
		event.EohSetShow(0, 0)
	end
	helper_2a390()
end

--- Helper function.
local function helper_2a4dc()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		pos_y = 0.0
		pos_y_2 = 0.0
		pos_y = 1160.0
		pos_y_2 = 1160.0
		pos_y = 2320.0
		pos_y_2 = 2320.0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(14) or var0
	event.EohSyncObj(0, "p09_f0401")
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.EohSyncObj(1, "p24_f0401")
	do
		local out1, out2, out3 = event.EohGetPos(1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	if var0 == 0 then
		pos_y = 0.0
		pos_y_2 = 0.0
	end
	if var0 == 1 then
		pos_y = 1160.0
		pos_y_2 = 1160.0
	end
	if var0 == 2 then
		pos_y = 2320.0
		pos_y_2 = 2320.0
	end
	event.EohSetPos(0, pos_x, pos_y, pos_z)
	event.EohSetPos(1, pos_x_2, pos_y_2, pos_z_2)
end

--- Helper function.
local function helper_1c714()
	local flag: s32 = 0
	if helper_1c2e8() == 0 then
		return 0
	end
	flag = event.GetFlag(548) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2274c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_2d2dcd04(20)
			end
			if at <= 2 then
				helper_1effc8e5(5480010)
			end
			if at <= 3 then
				helper_1effc8e5(5480020)
			end
			if at <= 4 then
				helper_4b879185()
			end
			if at <= 5 then
				helper_1effc8e5(5480030)
			end
			if at <= 6 then
				helper_4b879185()
			end
			if at <= 7 then
				helper_1effc8e5(5480040)
			end
			if at <= 8 then
				helper_4b879185()
			end
			if at <= 9 then
				helper_1effc8e5(5480050)
			end
			if at <= 10 then
				helper_1effc8e5(5480060)
			end
			if at <= 11 then
				helper_1effc8e5(5480070)
			end
			if at <= 12 then
				helper_2d2dcd04(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
		helper_c027080d(0.0, 0.0, 50.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_c027080d(0.0, 0.0, 50.0, 0.0)
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(548, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(5519)
	var0 = event.SndLoadSound(5519) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e548/")
	event.LoadMes(0, 5, "e548_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e548_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e548_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 6.86, 0.0, 78.4)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -11.07, 0.0, 79.71)
	event.EohSetRot(1, 0.0, 0.03, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-0.89, 17.4, 23.48)
	event.CmrsSetRef(-4.13, 26.67, 318.08)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 6.86, 0.0, 134.2, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -16.25, 0.0, 134.11, 90)
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	event.SetFadeIn(30)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_00bf9baa(1)
	if vm.skipping() then
		return skip(1)
	end
	helper_2d2dcd04(20)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(17.79, 9.71, 164.37)
	event.CmrsSetRef(-8.32, 25.41, 125.32)
	event.ObjsSetPos(1, -9.86, 0.0, 136.53)
	event.ObjsSetRot(1, 0.0, 0.03, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5480010)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(365.14, 3489.04, 547.36)
	event.CmrsSetRef(1061.18, 2794.56, 1334.73)
	event.CmrsMove(-1008.44, 3489.04, 1761.6, -311.9, 2794.56, 2548.54, 120)
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5480020)
	if vm.skipping() then
		return skip(4)
	end
	helper_4b879185()
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(462.3, 74.35, 2186.93)
	event.CmrsSetRef(265.85, 104.22, 2195.54)
	event.CmrsMoveAhd(2.9, -74.33, 524.9, 240)
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5480030)
	if vm.skipping() then
		return skip(6)
	end
	helper_4b879185()
	if vm.skipping() then
		return skip(7)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-601.26, 2565.32, 2318.97)
	event.CmrsSetRef(-558.59, 2522.74, 2438.67)
	event.CmrsMove(-1019.04, 2565.32, 1129.79, -967.92, 2522.74, 1273.21, 180)
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5480040)
	if vm.skipping() then
		return skip(8)
	end
	helper_4b879185()
	if vm.skipping() then
		return skip(9)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(83.14, 76.3, 216.76)
	event.CmrsSetRef(6.83, 24.83, 142.53)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	helper_1effc8e5(5480050)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向く会話", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "左向くL")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5480060)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 0)
	event.ObjsSetMotion(0, "右向くうなづき", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5480070)
	if vm.skipping() then
		return skip(12)
	end
	event.SetFadeOut(30)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

--- Helper function.
local function helper_1c83c()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1c4d4() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1c4d4() == 0 then
		return 0
	end
	flag = event.GetFlag(552) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_24824()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_00bf9baa(0)
			end
			if at <= 2 then
				helper_2d2dcd04(20)
			end
			if at <= 3 then
				helper_1effc8e5(5520010)
			end
			if at <= 4 then
				helper_2d2dcd04(90)
			end
			if at <= 5 then
				helper_2d2dcd04(20)
			end
			if at <= 6 then
				helper_1effc8e5(5520020)
			end
			if at <= 7 then
				helper_2d2dcd04(10)
			end
			if at <= 8 then
				helper_2d2dcd04(90)
			end
			if at <= 9 then
				helper_2d2dcd04(30)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
		helper_c027080d(vm.f32(255.2), 0.0, vm.f32(125.39), vm.f32(1.47))
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.LoadMes(0, -1)
		helper_c027080d(vm.f32(255.2), 0.0, vm.f32(125.39), vm.f32(1.47))
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(552, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e552/")
	event.LoadMes(0, 5, "e552_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e552_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, 6.86, 0.0, 78.4)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-48.86, 89.93, 248.19)
	event.CmrsSetRef(12.07, 9.71, 74.55)
	event.CharaActive(0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 3.32, 0.0, 116.62, 80)
	event.ObjsMotionDelay(0, 80)
	event.ObjsSetMotion(0, "立ち")
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_2d2dcd04(20)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(22.04, 8.19, 149.45)
	event.CmrsSetRef(-1.58, 23.89, 108.84)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "通常目～おどろき目")
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5520010)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(142.67, 815.3, 537.72)
	event.CmrsSetRef(130.25, 993.61, 1012.41)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsMove(81.88, 1714.97, 1427.25, 69.16, 1893.28, 1913.55, 90)
	helper_2d2dcd04(90)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(-48.86, 89.93, 248.19)
	event.CmrsSetRef(12.07, 9.71, 74.55)
	helper_2d2dcd04(20)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5520020)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "走り", 4)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsRotation(0, 0.0, 1.47, 0.0, 5)
	event.ObjsMove(0, 255.2, 0.0, 125.39, 120)
	event.CmrsMove(-51.8, 89.93, 247.2, 139.01, 3.51, 77.46, 90)
	helper_2d2dcd04(90)
	if vm.skipping() then
		return skip(9)
	end
	event.SetFadeOut(30)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1c964()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_1c578() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_1c578() == 0 then
		return 0
	end
	flag = event.GetFlag(556) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_2809c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_2d2dcd04(60)
			end
			if at <= 2 then
				helper_2d2dcd04(90)
			end
			if at <= 3 then
				helper_2d2dcd04(90)
			end
			if at <= 4 then
				helper_2d2dcd04(120)
			end
			if at <= 5 then
				helper_1effc8e5(5560010)
			end
			if at <= 6 then
				helper_1effc8e5(5560020)
			end
			if at <= 7 then
				helper_1effc8e5(5560025)
			end
			if at <= 8 then
				helper_2d2dcd04(75)
			end
			if at <= 9 then
				helper_1effc8e5(5560030)
			end
			if at <= 10 then
				helper_2d2dcd04(60)
			end
			if at <= 11 then
				helper_2d2dcd04(30)
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		helper_c027080d(0.0, 0.0, 50.0, 0.0)
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		var2 = event.GetDefBgmNo(102) or var2
		event.LoadBgm(var2)
		event.PlayBgm(0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_c027080d(0.0, 0.0, 50.0, 0.0)
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(556, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	event.LoadSound(5524)
	var0 = event.SndLoadSound(5524) or var0
	event.SndSePlay(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e556/")
	event.LoadMes(0, 5, "e556_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e556_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e556_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e548/e548_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSetPos(0, -193.68, 0.0, 73.48)
	event.EohSetRot(0, 0.0, 0.03, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -216.19, 0.0, 74.79)
	event.EohSetRot(1, 0.0, 0.03, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1887.71, 3927.56, 1055.04)
	event.CmrsSetRef(-1156.25, 3675.26, 2209.98)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.CmrsMove(-1527.79, 3854.3, 1598.26, -829.22, 3554.42, 2756.88, 60)
	event.SetFadeIn(30)
	event.SndSePlay(var0, 1)
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(695.29, 4027.12, 592.97)
	event.CmrsSetRef(1043.56, 2105.14, 2169.9)
	event.SndSeStop(var0, 1)
	event.SndSePlay(var0, 2)
	event.CmrsMove(792.52, 3840.41, 1112.82, 1023.76, 2204.87, 2154.46, 90)
	helper_2d2dcd04(90)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(390.04, 1913.65, 1546.59)
	event.CmrsSetRef(-3.71, 2508.25, 2769.81)
	event.SndSeStop(var0, 2)
	event.SndSePlay(var0, 3)
	event.CmrsMove(311.55, 2000.73, 1796.37, -36.66, 2508.25, 2871.9, 90)
	helper_2d2dcd04(90)
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(77.11, 1977.53, 568.47)
	event.CmrsSetRef(-6.16, 2923.06, 2851.89)
	event.SndSeStop(var0, 3)
	event.SndSePlay(var0, 4)
	event.CmrsMove(-8.75, 1736.89, 256.13, -3.94, 2828.04, 2790.99, 120)
	helper_2d2dcd04(120)
	if vm.skipping() then
		return skip(5)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-168.35, 63.68, 137.42)
	event.CmrsSetRef(-203.33, 14.92, 72.64)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5560010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5560020)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-208.74, 0.55, 25.47)
	event.CmrsSetRef(-204.56, 33.98, 76.86)
	event.ObjsSetMotion(1, "上向く会話", 6)
	event.ObjsMotionDelay(1, 120)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "上向く戻り", 6)
	event.ObjsNextMotion(0, "右向く", 4)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "右向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_1effc8e5(5560025)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetPos(1, -9.86, 0.0, 136.53)
	event.ObjsSetRot(1, 0.0, 0.03, 0.0)
	event.ObjsResetDaPosition(1)
	event.CmrsSetPos(-181.0, 10.89, 97.27)
	event.CmrsSetRef(-195.22, 24.21, 69.35)
	event.ObjsSetMotion(0, "右向く戻り", 6)
	event.ObjsNextMotion(0, "上向く", 4)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(0, "上向くL")
	helper_2d2dcd04(75)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5560030)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-2993.05, 3147.07, -1117.3)
	event.CmrsSetRef(-2885.8, 3145.8, -973.91)
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(11)
	end
	event.SetFadeOut(30)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

--- Helper function.
local function helper_1cd90()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 46 then
			if at <= 1 then
				helper_2d2dcd04(180)
			end
			if at <= 2 then
				helper_2d2dcd04(30)
			end
			if at <= 3 then
				helper_2d2dcd04(150)
			end
			if at <= 4 then
				helper_2d2dcd04(30)
			end
			if at <= 5 then
				helper_1effc8e5(5080010)
			end
			if at <= 6 then
				helper_1effc8e5(5080020)
			end
			if at <= 7 then
				helper_1effc8e5(5080025)
			end
			if at <= 8 then
				helper_1effc8e5(5080030)
			end
			if at <= 9 then
				helper_bda50c78(5080040, 210)
			end
			if at <= 10 then
				helper_bda50c78(5080050, 210)
			end
			if at <= 11 then
				helper_4b879185()
			end
			if at <= 12 then
				helper_1effc8e5(5080060)
			end
			if at <= 13 then
				helper_00bf9baa(2)
			end
			if at <= 14 then
				helper_1effc8e5(5080070)
			end
			if at <= 15 then
				helper_1effc8e5(5080075)
			end
			if at <= 16 then
				helper_00bf9baa(2)
			end
			if at <= 17 then
				helper_1effc8e5(5080080)
			end
			if at <= 18 then
				helper_2d2dcd04(10)
			end
			if at <= 19 then
				helper_2d2dcd04(30)
			end
			if at <= 20 then
				helper_1effc8e5(5080090)
			end
			if at <= 21 then
				helper_00bf9baa(0)
			end
			if at <= 22 then
				helper_1effc8e5(5080100)
			end
			if at <= 23 then
				helper_00bf9baa(0)
			end
			if at <= 24 then
				helper_00bf9baa(2)
			end
			if at <= 25 then
				helper_1effc8e5(5080110)
			end
			if at <= 26 then
				helper_1effc8e5(5080120)
			end
			if at <= 27 then
				helper_bda50c78(5080130, 180)
			end
			if at <= 28 then
				helper_bda50c78(5080140, 240)
			end
			if at <= 29 then
				helper_4b879185()
			end
			if at <= 30 then
				helper_1effc8e5(5080150)
			end
			if at <= 31 then
				helper_1effc8e5(5080160)
			end
			if at <= 32 then
				helper_00bf9baa(1)
			end
			if at <= 33 then
				helper_1effc8e5(5080170)
			end
			if at <= 34 then
				helper_00bf9baa(2)
			end
			if at <= 35 then
				helper_1effc8e5(5080180)
			end
			if at <= 36 then
				helper_00bf9baa(2)
			end
			if at <= 37 then
				helper_47d0a278(372, 1)
			end
			if at <= 38 then
				helper_00bf9baa(5)
			end
			if at <= 39 then
				helper_1effc8e5(5080190)
			end
			if at <= 40 then
				helper_1effc8e5(5080195)
			end
			if at <= 41 then
				helper_00bf9baa(2)
			end
			if at <= 42 then
				helper_1effc8e5(5080200)
			end
			if at <= 43 then
				helper_00bf9baa(0)
			end
			if at <= 44 then
				helper_1effc8e5(5080210)
			end
			if at <= 45 then
				helper_2d2dcd04(30)
			end
			if vm.skip_end() then
				return skip(47)
			end
			return part2()
		end
		if at <= 47 then
			helper_1209c623(0)
		end
		helper_c027080d(vm.f32(-1688.6), 1160.0, 5131.0, vm.f32(2.55))
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.SndSeStop(var2, 0)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SndSeStop(var1, 5)
		event.CharaActive(1, var0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SpriteSetDraw(0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
		event.DelImg(0)
		event.LoadMes(0, -1)
		helper_1209c623(0)
		if vm.skipping() then
			return skip(48)
		end
		event.PlayBgm(0)
		helper_c027080d(vm.f32(-1688.6), 1160.0, 5131.0, vm.f32(2.55))
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(508, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SearchCharaNo(401) or var0
	event.CharaActive(0, var0)
	event.LoadSound(5500)
	var1 = event.SndLoadSound(5500) or var1
	var2 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var2
	event.SetStatus(1, 0, 256, 1)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e500/e508/")
	event.LoadMes(0, 5, "e508_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e508_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e508_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e508_gisecon.gltf", "info", 35)
	event.CharaActive(35)
	event.EohSyncChara(2, 35)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e508_bom_t.gltf", "info", 36)
	event.CharaActive(36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	block = event.LoadImg_4(5, "e508.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e50801", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 448)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 33)
		event.LoadEquip(5, 0, 4, "info", 33)
		event.LoadEquip(5, 0, 3, "info", 33)
		event.LoadEquip(5, 0, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e508/e508_mints.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 33)
		event.EohSyncChara(0, 33)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 33)
		event.LoadEquip(5, 1, 4, "info", 33)
		event.LoadEquip(5, 1, 3, "info", 33)
		event.LoadEquip(5, 1, 2, "info", 33, 34)
		event.LoadMotion(5, "event/e500/e508/e508_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 37)
	event.CharaActive(37)
	event.EohSyncChara(5, 37)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSetPos(0, 29.8, -1160.0, 5918.68)
	event.EohSetRot(0, 0.0, -2.13, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 116.43, -1160.0, 5909.81)
	event.EohSetRot(1, 0.0, -2.13, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -95.34, 1160.0, 5824.2)
	event.EohSetRot(2, 0.0, 3.07, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(5, -67.36, 1194.16, 5795.09)
	event.EohSetRot(5, 0.0, 1.39, 0.0)
	event.EohSetShow(5, 0)
	event.EohSetShow(4, 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-103.82, 1168.63, 5924.94)
	event.CmrsSetRef(-95.48, 1187.1, 5825.3)
	event.CharaActive(0)
	event.CharaActive(0, 37)
	event.CmrsMoveAhd2(-2.77, -18.15, 77.63, 150, 2, 0.5)
	event.SetFadeIn(30)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	helper_2d2dcd04(180)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetPos(0, 59.27, 1160.0, 5900.71)
	event.ObjsSetPos(1, 116.43, 1160.0, 5909.81)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -29.62, 1160.0, 5881.12, 120)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -17.95, 1160.0, 5866.09, 120)
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "立ち")
	helper_2d2dcd04(150)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var1, 2)
	event.ObjsSetMotion(2, "振り向く", 6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(5)
	end
	event.SndSeStop(var1, 2)
	event.CmrsSetPos(-42.11, 1183.03, 5838.93)
	event.CmrsSetRef(-92.5, 1187.1, 5823.57)
	event.ObjsSetMotion(2, "振り向く（会話）", 6)
	event.ObjsNextMotion(2, "振り向くループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080010)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetRot(0, 0.0, -2.61, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CmrsSetPos(-40.15, 1177.76, 5832.3)
	event.CmrsSetRef(-19.81, 1181.94, 5882.99)
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1effc8e5(5080020)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_1effc8e5(5080025)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1effc8e5(5080030)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-288.23, 1713.07, 1700.32)
	event.CmrsSetRef(-265.03, 1706.85, 1729.17)
	event.CmrsMove(-245.15, 1713.07, 1697.71, -265.03, 1706.85, 1729.17, 420)
	event.SetPakuAnim(1, "わらい口パク")
	helper_bda50c78(5080040, 210)
	if vm.skipping() then
		return skip(10)
	end
	event.SetPakuAnim(2, "口パク")
	helper_bda50c78(5080050, 210)
	if vm.skipping() then
		return skip(11)
	end
	helper_4b879185()
	if vm.skipping() then
		return skip(12)
	end
	event.ObjsSetPos(0, -43.15, 1160.0, 5855.69)
	event.ObjsSetRot(0, 0.0, -1.89, 0.0)
	event.ObjsSetPos(1, -36.4, 1160.0, 5827.54)
	event.ObjsSetRot(1, 0.0, -1.65, 0.0)
	event.ObjsSetPos(2, -95.84, 1160.0, 5822.44)
	event.ObjsSetRot(2, 0.0, 1.11, 0.0)
	event.CmrsSetPos(-43.6, 1261.21, 5957.35)
	event.CmrsSetRef(-64.76, 1175.56, 5833.21)
	event.ObjsSetMotion(2, "会話２（手腰に）", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080060)
	if vm.skipping() then
		return skip(13)
	end
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1effc8e5(5080070)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(1, "会話", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_1effc8e5(5080075)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(2, "歩き")
	event.ObjsMotionDelay(2, 60)
	event.ObjsSetMotion(2, "立ち")
	event.ObjsRotation(2, 0.0, 2.79, 0.0, 12)
	event.ObjsMove(2, -85.83, 1160.0, 5772.54, 60)
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(17)
	end
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080080)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-54.61, 1199.22, 5675.45)
	event.CmrsSetRef(-68.38, 1175.56, 5850.15)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "無表情")
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 90)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsRotation(1, 0.0, -2.97, 0.0, 12)
	event.ObjsMove(1, -55.34, 1160.0, 5775.54, 90)
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "立ち→グイ見る", 6)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(19)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, -2.97, 0.0, 12)
	event.ObjsMove(0, -35.96, 1160.0, 5773.94, 90)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "前向き～目下")
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(20)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_1effc8e5(5080090)
	if vm.skipping() then
		return skip(21)
	end
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(22)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "目下～おどろき目")
	event.ObjsTexAnime(0, 1, "口とじ～大口")
	event.ObjsSetMotion(2, "会話２（手腰に）")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080100)
	if vm.skipping() then
		return skip(23)
	end
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(24)
	end
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "通常目～おどろき目")
	event.ObjsSetMotion(1, "直接？！", 6)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	event.ObjsSetMotion(0, "直接！？", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_1effc8e5(5080110)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080120)
	if vm.skipping() then
		return skip(27)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "立ち")
	event.CmrsSetPos(-1.14, 2507.89, -1061.57)
	event.CmrsSetRef(-1.4, 2524.83, -894.87)
	event.CmrsMove2(-1.25, 516.45, -1054.54, -1.36, 518.76, -917.04, 285, 0, 0.7)
	event.SetPakuAnim(2, "口パク")
	helper_bda50c78(5080130, 180)
	if vm.skipping() then
		return skip(28)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_bda50c78(5080140, 240)
	if vm.skipping() then
		return skip(29)
	end
	helper_4b879185()
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsSetPos(-68.79, 1173.91, 5887.0)
	event.CmrsSetRef(-63.03, 1177.39, 5762.52)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話２（手腰に）")
	event.ObjsMotionDelay(2, 90)
	event.ObjsSetMotion(2, "立ち")
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080150)
	if vm.skipping() then
		return skip(31)
	end
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向く会話", 4)
	event.ObjsMotionDelay(0, 90)
	event.ObjsSetMotion(0, "左向くL")
	event.ObjsMotionDelay(1, 10)
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1effc8e5(5080160)
	if vm.skipping() then
		return skip(32)
	end
	helper_00bf9baa(1)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "モニカ見る", 6)
	event.ObjsNextMotion(2, "モニカ見るループ", 4)
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "モニカ見る（会話）", 6)
	event.ObjsNextMotion(2, "モニカ見るループ", 4)
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち→グイ見る", 4)
	event.ObjsNextMotion(1, "グイ見るL", 4)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080170)
	if vm.skipping() then
		return skip(34)
	end
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(35)
	end
	event.EohSetShow(4, 1)
	event.SetReference(35, "b", 36)
	event.ObjsSetMotion(0, "爆弾ゲット", 4)
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(2, "立ち", 4)
	event.ObjsSetPos(0, -55.61, 1160.0, 5803.78)
	event.ObjsSetRot(0, 0.0, -1.65, 0.0)
	event.ObjsSetPos(1, -55.51, 1160.0, 5780.57)
	event.ObjsSetRot(1, 0.0, -1.65, 0.0)
	event.ObjsSetPos(2, -95.43, 1160.0, 5795.54)
	event.ObjsSetRot(2, 0.0, 1.59, 0.0)
	event.CmrsSetPos(-49.1, 1184.63, 5789.27)
	event.CmrsSetRef(-125.19, 1191.35, 5802.1)
	event.SndSePlay(var1, 3)
	event.ObjsSetMotion(2, "だす", 6)
	event.ObjsNextMotion(2, "だすループ", 4)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080180)
	if vm.skipping() then
		return skip(36)
	end
	event.SndSeStop(var1, 3)
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(37)
	end
	event.EohSetShow(1, 0)
	event.DelReference(36)
	if active_chr_no == 0 then
		event.SetReference(0, "item", 36)
	else
		event.SetReference(33, "item", 36)
	end
	event.ObjsSetMotion(2, "立ち", 4)
	event.CmrsSetPos(-94.34, 1203.09, 5799.78)
	event.CmrsSetRef(-54.1, 1186.29, 5805.08)
	event.SndPauseBgm()
	event.CharaActive(37)
	event.EohSetShow(5, 1)
	event.ObjsSetMotion(5, "発動", 6)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var2, 0)
	event.SndSePlay(var1, 4)
	helper_47d0a278(372, 1)
	if vm.skipping() then
		return skip(38)
	end
	event.ObjsMotionWait(5)
	helper_00bf9baa(5)
	if vm.skipping() then
		return skip(39)
	end
	event.PlayBgm(0)
	event.DelReference(36)
	event.EohSetShow(1, 1)
	event.ObjsSetMotion(0, "立ち", 4)
	event.CmrsSetPos(3.92, 1224.43, 5857.27)
	event.CmrsSetRef(-77.23, 1174.09, 5794.78)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsSetMotion(2, "会話２（手腰に）", 6)
	event.ObjsMotionDelay(2, 90)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080190)
	if vm.skipping() then
		return skip(40)
	end
	event.SetPakuAnim(2, "口パク")
	helper_1effc8e5(5080195)
	if vm.skipping() then
		return skip(41)
	end
	helper_00bf9baa(2)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(0, "会話", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_1effc8e5(5080200)
	if vm.skipping() then
		return skip(43)
	end
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsSetMotion(2, "ぐっ", 6)
	event.ObjsNextMotion(2, "ぐぅ（会話）", 4)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "ぐっループ", 4)
	event.SndSePlay(var1, 5)
	event.ObjsTexAnime(2, 1, "口とじ～くいしばり")
	helper_1effc8e5(5080210)
	if vm.skipping() then
		return skip(45)
	end
	event.SetFadeOut(30)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(46)
	end
	return part2()
end

--- Helper function.
local function helper_14cac()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 0)
end

--- Helper function.
local function helper_14d38(arg0: s32)
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			helper_310b1032(0, -1, 5, 0, 0)
		end
		helper_14cac()
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
		event.MesMake_2(0, "Hemos viajado al futuro con\nla m[UNI00e1]quina del tiempo de Ixion.")
	else
		event.MesMake_2(0, "Hemos vuelto al presente con\nla m[UNI00e1]quina del tiempo de Ixion.")
	end
	if vm.wait() then
		return skip(3)
	end
	helper_310b1032(0, -1, 5, 0, 0)
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
	helper_14cac()
end

--- Helper function.
local function helper_186c4(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_c6e079ae()
			end
			if at <= 2 then
				helper_2d2dcd04(20)
			end
			if at <= 3 then
				helper_00bf9baa(0)
			end
			if at <= 4 then
				helper_c6e079ae()
			end
			if at <= 5 then
				print("pumpkin---------------------------\n")
				print("stripte -----------------------------\n")
				print("princess-----------------------------\n")
				print("separate----------------------------\n")
				helper_00bf9baa(6)
			end
			if at <= 6 then
				helper_2d2dcd04(60)
			end
			if at <= 7 then
				helper_2d2dcd04(60)
			end
			if at <= 8 then
				helper_14d38(0)
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
	helper_4b879185()
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
	helper_c6e079ae()
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
		helper_2d2dcd04(20)
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
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_c6e079ae()
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
	helper_00bf9baa(6)
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
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(8)
	end
	helper_14d38(0)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

--- Helper function.
local function helper_13ab8(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var7: s32 = 0
	local now_party_chara_id: s32 = 0
	local language_code: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 7 then
			if at <= 1 then
				helper_2d2dcd04(30)
			end
			if at <= 2 then
				helper_4b879185()
			end
			if at <= 3 then
				helper_00bf9baa(0)
			end
			if at <= 4 then
				helper_1effc8e5(5220010)
			end
			if at <= 5 then
				helper_1effc8e5(5220015)
			end
			if at <= 6 then
				helper_2d2dcd04(30)
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
	helper_2d2dcd04(30)
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
	helper_4b879185()
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
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "アトラさわる", 6)
	event.ObjsNextMotion(0, "アトラさわるL", 6)
	helper_1effc8e5(5220010)
	if vm.skipping() then
		return skip(5)
	end
	helper_1effc8e5(5220015)
	if vm.skipping() then
		return skip(6)
	end
	event.SetFadeOut(30)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(7)
	end
	return part2()
end

--- Helper function.
local function helper_152b0(arg0: f32, arg1: f32, arg2: f32, arg3: f32, arg4: s32, arg5: s32)
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
				helper_4b879185()
			end
			if at <= 2 then
				helper_c6e079ae()
			end
			if at <= 3 then
				helper_2d2dcd04(30)
			end
			if at <= 4 then
				helper_00bf9baa(0)
			end
			if at <= 5 then
				helper_c6e079ae()
			end
			if at <= 6 then
				helper_00bf9baa(6)
			end
			if at <= 7 then
				helper_2d2dcd04(60)
			end
			if at <= 8 then
				helper_2d2dcd04(60)
			end
			if at <= 9 then
				helper_14d38(1)
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
	helper_4b879185()
	if vm.skipping() then
		return skip(2)
	end
	helper_c6e079ae()
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
		helper_2d2dcd04(30)
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
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_c6e079ae()
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
		helper_00bf9baa(6)
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
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(60, 255.0, 255.0, 255.0)
	helper_2d2dcd04(60)
	if vm.skipping() then
		return skip(9)
	end
	helper_14d38(1)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_1bfa4(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local member: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13ab8(arg0, arg1, arg2, arg3)
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 2 then
			helper_152b0(arg0, arg1, arg2, arg3, 0, 0)
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetWorldCoord(0.0, 0.0, 0.0, 0.0)
	end
	function landing1()
		helper_152b0(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		return part2()
	end
	member = event.JoinPartyMember(1) or member
	if member == 1 then
		helper_186c4(arg0, arg1, arg2, arg3, 0, 1)
		if vm.skipping() then
			return skip(1)
		end
	else
		flag = event.GetFlag(520) or flag
		flag_2 = event.GetFlag(532) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			flag_3 = event.GetFlag(522) or flag_3
			if flag_3 == 0 then
				helper_13ab8(arg0, arg1, arg2, arg3)
				if vm.skipping() then
					return skip(2)
				end
			end
		end
		helper_152b0(arg0, arg1, arg2, arg3, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2b3c0()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_35fe0d1b(1)
		return -1
	end
	var0 = event.GetCnt(14) or var0
	event.SetMesWindowMode(1, 4)
	event.MesMake_2(1, "Aqu[UNI00ed] hay botones de un ascensor.")
	helper_307f5027(1, -1, 5, 0, 0)
	event.SetMesWindowMode(0, 4)
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	event.SetMesEtc(0, 5, var0, 2)
	event.MesMake_2(0, "1er piso\n2[UNI00ba] piso\n3er piso")
	var1 = helper_878ce637(0, -1, 8, 0, 0, 3, var0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.SetMesEtc(0, 5, var0, -1)
	helper_35fe0d1b(1)
	if var1 < 0 or var1 == var0 then
		return -1
	else
		event.SetCnt(14, var1)
		return var1
	end
end

--- Helper function.
local function helper_2b25c()
	local flag: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c2e8()
			helper_1cd90()
			if not vm.skipping() then
				return landing1()
			end
		end
		return 1
	end
	function part2()
		return 0
	end
	function landing1()
		return 1
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(508) or flag
	if helper_1c2e8() ~= 0 and flag == 0 then
		event.AddItem(372, 1)
		helper_1cd90()
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return part2()
end

--- Helper function.
local function helper_2cb68(arg0: s32)
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: any = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_2d2dcd04(30)
		end
		if at <= 3 then
			helper_2d2dcd04(15)
		end
		if at <= 4 then
			helper_c027080d(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			helper_c027080d(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			helper_c027080d(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			helper_c027080d(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
		end
	end
	var1 = helper_1c578()
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 4)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if var1 ~= 0 then
		event.MesMake_2(
			0,
			"Selecciona Destino de la Puerta de salto\nPuerta de salto Norte\nPuerta de salto Este -- Oeste\nEnfrente de la Puerta de salto\nPuente de Paznos"
		)
		var2 = 5
	else
		event.MesMake_2(
			0,
			"Selecciona Destino de la Puerta de salto\nPuerta de salto Norte\nPuerta de salto Este -- Oeste\nEnfrente de la Puerta de salto\n"
		)
		var2 = 4
	end
	var3 = helper_878ce637(0, -1, 8, 0, 0, var2, vm.i32(arg0 + 1))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	if var3 == -1 then
		return
	end
	if vm.wrap(var3 - 1) == arg0 then
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("サンワープ２")
	event.EsmInitFix(5)
	event.EsmCreate("サンワープ２")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	event.EsmSetVect1(var4, var5, var6)
	var7 = event.GetSndId(2) or var7
	event.SndSePlay(var7, 120)
	helper_2d2dcd04(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaShow(0, 0, 1, 0.05)
	event.SetCharaShow(1, 0, 1, 0.05)
	event.SetCharaShow(2, 0, 1, 0.05)
	event.SetCharaShow(3, 0, 1, 0.05)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_2d2dcd04(15)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmClear()
	event.SetCharaShow(0, 1)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetCharaShow(3, 1)
	if vm.wrap(var3 - 1) == 1 then
		helper_c027080d(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
	end
	if vm.wrap(var3 - 1) == 2 then
		helper_c027080d(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
	end
	if vm.wrap(var3 - 1) == 3 then
		helper_c027080d(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
	end
	if vm.wrap(var3 - 1) == 0 then
		helper_c027080d(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
	end
	if vm.wrap(var3 - 1) == 4 then
		event.MapJump(-1, "s30")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	event.ResetCamera(1, 3.1415927)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_2c414()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			helper_2d2dcd04(30)
		end
		if at <= 3 then
			helper_2d2dcd04(15)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesWindowMode(0, 5)
	event.MesMake_2(0, "[UNI00bf]Ir al Puente de Paznos?")
	var0 = helper_878ce637(0, -1, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 0 then
		return
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("サンワープ２")
	event.EsmInitFix(5)
	event.EsmCreate("サンワープ２")
	do
		local out1, out2, out3 = event.GetCharaPos(0)
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	event.EsmSetVect1(var1, var2, var3)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 120)
	helper_2d2dcd04(15)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaShow(0, 0, 1, 0.05)
	event.SetCharaShow(1, 0, 1, 0.05)
	event.SetCharaShow(2, 0, 1, 0.05)
	event.SetCharaShow(3, 0, 1, 0.05)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_2d2dcd04(15)
	if vm.skipping() then
		return skip(4)
	end
	event.EsmClear()
	event.SetCharaShow(0, 1)
	event.SetCharaShow(1, 1)
	event.SetCharaShow(2, 1)
	event.SetCharaShow(3, 1)
	event.MapJump(-1, "s30")
	if vm.wait() then
		return skip(5)
	end
end

--- Helper function.
local function helper_25c1c()
	local var6: s32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_4b879185()
			end
			if at <= 2 then
				helper_2d2dcd04(4)
			end
			if at <= 3 then
				helper_2d2dcd04(10)
			end
			if at <= 4 then
				helper_2d2dcd04(30)
			end
			if at <= 5 then
				helper_2d2dcd04(4)
			end
			if at <= 6 then
				helper_2d2dcd04(10)
			end
			if at <= 7 then
				helper_2d2dcd04(30)
			end
			if at <= 8 then
				var6 = 0
				var7 = vm.f32(0.02)
				var6 = var6 + 1
			end
			if at <= 9 then
				var7 = vm.f32(var7 * vm.f32(1.2))
				helper_2d2dcd04(2)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(524.9)
		event.CharaActive(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(37)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_2d2dcd04(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(116)
	event.PlayBgm(0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.LoadChara(5, "e540_jet.gltf", "info", 32)
	event.CharaActive(0, 32)
	event.CopyChara(5, 32, 33)
	event.CharaActive(0, 33)
	event.LoadChara(5, "e540_parm1.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.LoadChara(5, "e540_parm2.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.LoadChara(5, "e540_parm3.gltf", "info", 36)
	event.CharaActive(1, 36)
	event.LoadChara(5, "e540_parm4.gltf", "info", 37)
	event.CharaActive(1, 37)
	event.ChangeDir("")
	event.EohSyncObj(0, "p10_f0401")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p20_f0401")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_27-m-0")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_27-m-1")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401", "f0401_25-m")
	event.EohSetShow(1, 0)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm1")
	event.SetCharaPos(34, -2400.0, 1700.0, 2600.0)
	event.SetCharaRot(34, 0.0, 1.6, 0.0)
	event.SetMotion(34, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm2")
	event.SetCharaPos(35, -2100.0, 1700.0, 5300.0)
	event.SetCharaRot(35, 0.0, 2.4, 0.0)
	event.SetMotion(35, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm3")
	event.SetCharaPos(36, 2200.0, 1700.0, 5300.0)
	event.SetCharaRot(36, 0.0, -2.4, 0.0)
	event.SetMotion(36, "射出1", 5)
	event.EohSyncObj(1, "p22_f0401")
	event.EohGetFramePos(1, "e540_parm4")
	event.SetCharaPos(37, 2400.0, 1700.0, 2600.0)
	event.SetCharaRot(37, 0.0, -1.6, 0.0)
	event.SetMotion(37, "射出1", 5)
	event.SetCharaPos(32, -930.0, 750.0, 2330.0)
	event.SetCharaPos(33, 930.0, 750.0, 2330.0)
	event.InitDramaScene()
	event.SetProjection(524.9)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 2449.87, -2065.79)
	event.CmrsSetRef(0.0, 2430.55, -2020.14)
	event.CmrsMove2(0.0, 2785.4, -2065.79, 0.0, 2787.08, -2020.14, 120, 2, 1.0)
	event.SetFadeIn(10)
	helper_4b879185()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-2108.31, 1992.04, 1136.27)
	event.CmrsSetRef(-2039.71, 1945.46, 1320.75)
	helper_2d2dcd04(4)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(34, "射出1", 6)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMotion(35, "射出1", 6)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1955.54, 2093.16, 785.71)
	event.CmrsSetRef(1839.34, 1936.52, 1240.3)
	helper_2d2dcd04(4)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(37, "射出1", 6)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetMotion(36, "射出1", 6)
	helper_2d2dcd04(30)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(1709.28, 50.66, -919.25)
	event.CmrsSetRef(1370.18, 511.19, 109.87)
	event.SetProjection(390.0)
	event.CharaActive(1, 32)
	event.CharaActive(1, 33)
	event.SetCharaShow(32, 1, 1, 0.016666668)
	event.SetCharaShow(33, 1, 1, 0.016666668)
	var6 = 0
	var7 = vm.f32(0.02)
	while var6 < 120 do
		var6 = var6 + 1
		if vm.wait() then
			return skip(9)
		end
		if vm.imod(var6, 4) == 0 then
			event.CmrsInit()
			event.CmrsQuake(0.0, var7, 0.0, -1)
			var7 = vm.f32(var7 * vm.f32(1.2))
		end
		if var6 == 110 then
			event.SetFadeOut(10)
		end
	end
	helper_2d2dcd04(2)
	if vm.skipping() then
		return skip(10)
	end
	return part2()
end

--- Helper function.
local function helper_27624()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_00bf9baa(0)
			end
			if at <= 2 then
				helper_2d2dcd04(10)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaActive(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.ChangeDir("event/e500/e540/")
	event.LoadChara(5, "e540_jet.gltf", "info", 32)
	event.CharaActive(32)
	event.SetCharaType(32, 4)
	event.EohSyncChara(3, 32)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CopyChara(5, 32, 33)
	event.CharaActive(33)
	event.SetCharaType(33, 4)
	event.EohSyncChara(4, 33)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.EohSyncObj(0, "p10_f0401")
	event.EohSetShow(0, 0)
	event.EohSyncObj(0, "p20_f0401")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSyncObj(1, "p11_f0401")
	event.EohSetShow(1, 0)
	event.EohSyncObj(2, "p22_f0401")
	event.EohSetShow(2, 0)
	event.EohSetPos(0, 0.0, 0.0, 3300.0)
	event.EohSetPos(3, -930.0, 750.0, 2330.0)
	event.EohSetPos(4, 930.0, 750.0, 2330.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(1276.52, 7391.95, 1416.71)
	event.CmrsSetRef(1173.37, 7042.65, 1560.26)
	event.CmrsQuake(0.0, 3.0, 0.0, -1)
	event.SetFadeIn(10)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(0, 0.0, 9000.0, 3300.0, 160, 1, 1.0)
	event.ObjsMove2(3, -930.0, 9750.0, 2330.0, 160, 1, 1.0)
	event.ObjsMove2(4, 930.0, 9750.0, 2330.0, 160, 1, 1.0)
	helper_00bf9baa(0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(10)
	helper_2d2dcd04(10)
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_10d1c()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_6213684d(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_3ebf8f70(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_6213684d(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_35522b05(player_chara_2, var20)
		end
		if at <= 5 then
			helper_6213684d(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_1e3fcd92(30)
		end
		if at <= 7 then
			helper_1e3fcd92(28)
		end
		if at <= 8 then
			helper_1e3fcd92(29)
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
	event.MesMake_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	var3 = 0
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"Gaspar es un adversario terrible.\nNo bajes la guardia ni\nun momento.<page>S[UNI00e9] que puedes derrotarle.\nLa Atlamillia te eligi[UNI00f3] por\nalgo..."
						)
					else
						event.MesMake_2(
							0,
							"Es verdad, Gaspar tambi[UNI00e9]n era infeliz.<page>[UNI00bf]Qu[UNI00e9] pretender[UNI00e1] Griffon\nmeti[UNI00e9]ndose con gente de dos [UNI00e9]pocas?"
						)
					end
				else
					event.MesMake_2(
						0,
						"Estoy seguro de que si alguien\npuede derrotar a Griffon, sois vosotros.<page>Confiamos en vosotros."
					)
				end
			else
				event.MesMake_2(
					0,
					"La Uni[UNI00f3]n Cronol[UNI00f3]gica... Entonces, la sabidur[UNI00ed]a\nde los ancianos salvar[UNI00e1]\nel mundo..."
				)
			end
		else
			event.MesMake_2(
				0,
				"Con esta va la vencida. Muchos amigos\nhan derramado su sangre en\nla lucha contra Griffon...<page>[UNI00a1]Sois nuestra [UNI00fa]ltima esperanza!\nConf[UNI00ed]o en vosotros. [UNI00a1]Ten[UNI00e9]is que\nderrotar a Griffon!"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"Bien. En primer lugar,\nten[UNI00e9]is que destruir la Tromba de fuego.<page>Si no hacemos algo\npara parar la lluvia de fuego,\nHeim Rada est[UNI00e1] acabada."
							)
						else
							event.MesMake_2(
								0,
								"Bueno, pues ya est[UNI00e1]. Deber[UNI00ed]amos\nestar contentos de que\nla Tromba de fuego haya terminado."
							)
							helper_b12236ef(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_6213684d(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"Pero estoy preocupado por tu amigo\nque cay[UNI00f3] al cr[UNI00e1]ter.<page>Imagino que lo [UNI00fa]nico que podemos hacer\nes reconstruir Heim Rada y hacer\nque el Taller sea mejor que antes."
							)
						end
					else
						event.MesMake_2(
							0,
							"[UNI00a1]Hab[UNI00e9]is vencido a Gaspar!\nChicos, sois fant[UNI00e1]sticos.<page>Ahora le toca el turno a su jefe, el Emperador Griffon.\n[UNI00a1]Acabad con esto de una vez!"
						)
					end
				else
					event.MesMake_2(
						0,
						"Qu[UNI00e9] alegr[UNI00ed]a me dio ver a Paznos en acci[UNI00f3]n.\nSe me ca[UNI00ed]an las l[UNI00e1]grimas.<page>Todo el esfuerzo que hemos invertido ha\nvalido la pena."
					)
				end
			else
				event.MesMake_2(0, "[UNI00bf]Gema? Umm, lo siento pero no\ntengo ni idea de eso.")
			end
		else
			event.MesMake_2(
				0,
				"Ha llegado la hora de v[UNI00e9]rselas con Griffon, [UNI00bf]eh?\nBuena suerte. [UNI00a1]A por [UNI00e9]l!"
			)
		end
	end
	if var2 == 402 then
		event.MesMake_2(
			0,
			"[UNI00a1]Hola! Tenemos un mont[UNI00f3]n de cosas\npara vosotros. [UNI00bf]Qu[UNI00e9] os pongo?"
		)
	end
	if var2 == 403 then
		event.MesMake_2(0, "P[UNI00ed]deme lo que sea. Cualquier pieza\nque busques, yo la tengo fijo.")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"El combate es todo un arte. No\npuedes meterte de\ncabeza en medio de un tiroteo.<page>Si quieres portarte como un campe[UNI00f3]n,\ntendr[UNI00e1]s que usar objetos. Busca las debilidades del\nenemigo y expl[UNI00f3]talas."
		)
	end
	if var2 == 405 then
		event.MesMake_2(0, "En el Taller de Gundorada\ntodo es posible. Sea lo\nque sea, podemos hacerlo.")
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"Eh, [UNI00bf]c[UNI00f3]mo hab[UNI00e9]is llegado hasta aqu[UNI00ed]?\nTened cuidado,\nesto es peligroso."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "[UNI00bf]Qu[UNI00e9] ha ocurrido en este\ntiempo? No me acuerdo de\nnada.")
	end
	if var2 == 408 then
		event.MesMake_2(0, "O sea que Griffon ha acabado con nosotros.\nQu[UNI00e9] pedazo de monstruo tiene que ser.")
	end
	if var2 == 409 then
		event.MesMake_2(0, "Tengo cosas que hacer.\nApartaos de mi camino, por favor.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "Todos te animamos.\nEstamos contigo al 100%.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Las armas de\nesta caja\nno se venden.<page>Hay armas extra[UNI00f1]as\ny bonitas en el\nmundo, de todas formas..."
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"[UNI00bf]O sea que el Gaspar ese puede\ndesatar la Tromba de fuego?<page>No es que sea astuto...\nEs malo de verdad."
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"Qu[UNI00e9] es ese coraz[UNI00f3]n\nque hay en el signo... <page>No me gusta nada,\ntodo sea dicho."
		)
	end
	if var3 == 0 then
		helper_3ebf8f70(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_6213684d(0, -1, var1, player_chara, 0)
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
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_35522b05(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_6213684d(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_1e3fcd92(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_1e3fcd92(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_1e3fcd92(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local part3: () -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c83c()
			helper_24824()
			if not vm.skipping() then
				return part2()
			end
		end
		if at <= 2 then
			local _ = helper_1c964()
			helper_2809c()
			if not vm.skipping() then
				return part3()
			end
		end
		helper_c027080d(0.0, 0.0, 0.0, 0.0)
		helper_2a4dc()
		helper_c027080d(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
		helper_c027080d(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
		helper_c027080d(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
		helper_c027080d(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
		helper_2a4dc()
		helper_c027080d(0.0, 2460.0, 6000.0, vm.f32(3.14))
	end
	function part2()
		if helper_1c964() ~= 0 then
			helper_2809c()
			if vm.skipping() then
				return skip(3)
			end
		end
		return part3()
	end
	function part3()
		if old_map_no == 3 then
			helper_c027080d(0.0, 0.0, 0.0, 0.0)
		end
		if old_map_no == 105 then
			var1 = event.GetCnt(18) or var1
			event.SetCnt(14, 0)
			helper_2a4dc()
			if var1 == 1 then
				helper_c027080d(vm.f32(-2079.4), 6.0, vm.f32(5052.4), vm.f32(2.16))
			end
			if var1 == 2 then
				helper_c027080d(vm.f32(2011.1), 6.0, 5158.5, vm.f32(-2.23))
			end
			if var1 == 3 then
				helper_c027080d(286.5, 6.0, vm.f32(-22.3), vm.f32(-0.16))
			end
			if var1 == 0 then
				helper_c027080d(vm.f32(-228.6), 6.0, vm.f32(5828.1), vm.f32(-0.02))
			end
		end
		if old_map_no == 107 then
			event.SetCnt(14, 2)
			helper_2a4dc()
			helper_c027080d(0.0, 2460.0, 6000.0, vm.f32(3.14))
		end
		event.ResetCamera(1, 0.0, 10.0)
	end
	old_map_no = event.GetOldMapNo() or old_map_no
	event.SetFadeIn(15)
	if old_map_no == 3 then
		event.SetCnt(14, 0)
	end
	program_99()
	helper_2a4dc()
	if helper_1c714() ~= 0 then
		helper_2274c()
		if vm.skipping() then
			return skip(1)
		end
	end
	if helper_1c83c() ~= 0 then
		helper_24824()
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
	helper_2274c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1cd90()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 3, 0)
	event.DbgSetAnalyzeFlag(3, 4, 0)
	event.DbgSetAnalyzeFlag(3, 5, 0)
	event.DbgSetAnalyzeFlag(3, 6, 0)
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.SetFlag(548, 0)
	event.SetFlag(552, 1)
	event.SetFlag(556, 1)
	helper_2274c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1bfa4(0.0, 0.0, 0.0, vm.f32(6.2831855))
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2d2dcd04(10)
		end
		if at <= 2 then
			helper_c027080d(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
			helper_c027080d(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
			local _ = helper_2b25c()
			if not vm.skipping() then
				return landing1()
			end
		end
		helper_2a4dc()
	end
	function part2() end
	function landing1()
		helper_2a4dc()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = helper_2b3c0()
	if vm.skipping() then
		return skip(1)
	end
	if var1 >= 0 then
		event.SndSePlay(var0, 70)
		event.SetFadeOut(10)
		helper_2d2dcd04(10)
		if vm.skipping() then
			return skip(2)
		end
		if var1 == 0 then
			helper_c027080d(vm.f32(684.8), 0.0, vm.f32(6024.3), vm.f32(-2.87))
		end
		if var1 == 1 then
			helper_c027080d(vm.f32(684.8), 1160.0, vm.f32(6024.3), vm.f32(-2.87))
			local t0 = helper_2b25c()
			if vm.skipping() then
				return skip(3)
			end
			if t0 ~= 0 then
				helper_2a4dc()
				event.ResetCamera(1, 0.0, 10.0)
				event.SetFadeIn(10)
				return
			end
		end
		if var1 == 2 then
			helper_c027080d(vm.f32(684.8), 2320.0, vm.f32(6024.3), vm.f32(-2.87))
		end
		event.SndSePlay(var0, 71)
		helper_2a4dc()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	return part2()
end

--- Program 551.
script[551] = function()
	local var0: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2d2dcd04(10)
		end
		if at <= 2 then
			helper_c027080d(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
			helper_c027080d(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
			local _ = helper_2b25c()
			if not vm.skipping() then
				return landing1()
			end
		end
		helper_2a4dc()
	end
	function part2() end
	function landing1()
		helper_2a4dc()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = helper_2b3c0()
	if vm.skipping() then
		return skip(1)
	end
	if var1 >= 0 then
		event.SndSePlay(var0, 70)
		event.SetFadeOut(10)
		helper_2d2dcd04(10)
		if vm.skipping() then
			return skip(2)
		end
		if var1 == 0 then
			helper_c027080d(vm.f32(-2553.7), 0.0, vm.f32(3882.6), vm.f32(1.55))
		end
		if var1 == 1 then
			helper_c027080d(vm.f32(-2553.7), 1160.0, vm.f32(3882.6), vm.f32(1.55))
			local t0 = helper_2b25c()
			if vm.skipping() then
				return skip(3)
			end
			if t0 ~= 0 then
				helper_2a4dc()
				event.ResetCamera(1, 0.0, 10.0)
				event.SetFadeIn(10)
				return
			end
		end
		if var1 == 2 then
			helper_c027080d(vm.f32(-2553.7), 2320.0, vm.f32(3882.6), vm.f32(1.55))
		end
		event.SndSePlay(var0, 71)
		helper_2a4dc()
		event.ResetCamera(1, 0.0, 10.0)
		event.SetFadeIn(10)
	end
	return part2()
end

--- Program 552.
script[552] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetFadeOut(15)
	helper_2d2dcd04(15)
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s39")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2cb68(1)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 561.
script[561] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2cb68(3)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 562.
script[562] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 2)
	helper_2c414()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 563.
script[563] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 3)
	helper_2c414()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 564.
script[564] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 4)
	helper_2c414()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 565.
script[565] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetCnt(13, 5)
	helper_2c414()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 566.
script[566] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2cb68(2)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 567.
script[567] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_2cb68(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_25c1c()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s30", 600)
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_27624()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s55", 600)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10d1c()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 15080.
script[15080] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 3, 0)
	event.DbgSetAnalyzeFlag(3, 4, 0)
	event.DbgSetAnalyzeFlag(3, 5, 0)
	event.DbgSetAnalyzeFlag(3, 6, 0)
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.SetFlag(508, 0)
	event.MapJump(-1, 102, 151)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 15220.
script[15220] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(520, 1)
	event.SetFlag(522, 0)
	event.ExtTyped(1078, "ii", 1, 0)
	helper_1bfa4(0.0, 0.0, 0.0, vm.f32(6.2831855))
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g04")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 15480.
script[15480] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 3, 0)
	event.DbgSetAnalyzeFlag(3, 4, 0)
	event.DbgSetAnalyzeFlag(3, 5, 0)
	event.DbgSetAnalyzeFlag(3, 6, 0)
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.SetFlag(548, 0)
	event.SetFlag(552, 1)
	event.SetFlag(556, 1)
	helper_2274c()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 15520.
script[15520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 7, 0)
	event.DbgSetAnalyzeFlag(3, 8, 0)
	event.DbgSetAnalyzeFlag(3, 9, 0)
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.DbgSetAnalyzeFlag(3, 3, 1)
	event.DbgSetAnalyzeFlag(3, 4, 1)
	event.DbgSetAnalyzeFlag(3, 5, 1)
	event.DbgSetAnalyzeFlag(3, 6, 1)
	event.SetFlag(548, 1)
	event.SetFlag(552, 0)
	event.SetFlag(556, 1)
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 15560.
script[15560] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DbgSetAnalyzeFlag(3, 0, 1)
	event.DbgSetAnalyzeFlag(3, 1, 1)
	event.DbgSetAnalyzeFlag(3, 2, 1)
	event.DbgSetAnalyzeFlag(3, 3, 1)
	event.DbgSetAnalyzeFlag(3, 4, 1)
	event.DbgSetAnalyzeFlag(3, 5, 1)
	event.DbgSetAnalyzeFlag(3, 6, 1)
	event.DbgSetAnalyzeFlag(3, 7, 1)
	event.DbgSetAnalyzeFlag(3, 8, 1)
	event.DbgSetAnalyzeFlag(3, 9, 1)
	event.DbgSetAnalyzeFlag(3, 10, 1)
	event.SetFlag(548, 1)
	event.SetFlag(552, 1)
	event.SetFlag(556, 0)
	event.MapJump(-1, 102, 100)
	if vm.wait() then
		return skip(1)
	end
end

return script
