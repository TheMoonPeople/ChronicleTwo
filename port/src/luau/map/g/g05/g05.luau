--!strict
-- map/g/g05/g05.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_076280e8 = require("@lib/event/helper_076280e8")
local helper_0f1c5378 = require("@lib/event/helper_0f1c5378")
local helper_1b06d86e = require("@lib/event/helper_1b06d86e")
local helper_1d96573f = require("@lib/event/helper_1d96573f")
local helper_5baf1087 = require("@lib/event/helper_5baf1087")
local helper_650bfa16 = require("@lib/event/helper_650bfa16")
local helper_7e17ca03 = require("@lib/event/helper_7e17ca03")
local helper_868b9caa = require("@lib/event/helper_868b9caa")
local helper_915fd155 = require("@lib/event/helper_915fd155")
local helper_ff0edc1d = require("@lib/event/helper_ff0edc1d")

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_dcbc(arg0: s32)
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ff0edc1d(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var1 = helper_5baf1087(5, arg0)
	if vm.skipping() then
		return skip(1)
	end
	if var1 == 0 then
		event.SetFadeOut(20)
		helper_ff0edc1d(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_de6c()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(505) or var0
	return var0
end

--- Helper function.
local function helper_e008()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_de6c() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_de6c() == 0 then
		return 0
	end
	flag = event.GetFlag(744) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_df10()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetDioramaPercent(4) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_e130()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		local _ = if helper_df10() == 0 then 1 else 0
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	if helper_df10() == 0 then
		return 0
	end
	flag = event.GetFlag(748) or flag
	if flag ~= 0 then
		return 0
	end
	return 1
end

--- Helper function.
local function helper_e73c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_1d96573f(7000140)
			end
			if at <= 2 then
				helper_1d96573f(7000150)
			end
			if at <= 3 then
				helper_1d96573f(7000155)
			end
			if at <= 4 then
				helper_650bfa16(2)
			end
			if at <= 5 then
				helper_1d96573f(7000160)
			end
			if at <= 6 then
				helper_1d96573f(7000165)
			end
			if at <= 7 then
				helper_1d96573f(7000170)
			end
			if at <= 8 then
				helper_ff0edc1d(30)
			end
			if at <= 9 then
				helper_076280e8()
			end
			if at <= 10 then
				helper_ff0edc1d(20)
			end
			if at <= 11 then
				helper_ff0edc1d(90)
			end
			if at <= 12 then
				helper_ff0edc1d(40)
			end
			if at <= 13 then
				helper_1d96573f(7000180)
			end
			if at <= 14 then
				helper_650bfa16(1)
			end
			if at <= 15 then
				helper_1d96573f(7000190)
			end
			if at <= 16 then
				helper_ff0edc1d(10)
			end
			if at <= 17 then
				helper_ff0edc1d(10)
			end
			if at <= 18 then
				helper_ff0edc1d(30)
			end
			if at <= 19 then
				helper_ff0edc1d(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.LoadMes(0, -1)
	end
	event.SetFlag(700, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.LoadSound(7204)
	var1 = event.SndLoadSound(7204) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e700/")
	event.LoadMes(0, 5, "e700.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e700_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e700_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e700_andrea.gltf", "info", 34)
	event.SetStatus(1, 34, 8, 1)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e700_a_hikari.gltf", "info", 35)
	event.SetCharaType(35, 4)
	event.CharaActive(35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e700/e700/e700_mints.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 32)
		event.LoadEquip(5, 1, 4, "info", 32)
		event.LoadEquip(5, 1, 3, "info", 32)
		event.LoadEquip(5, 1, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e700/e700/e700_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 7.0, 0.0, 200.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "上向くL", 4)
	event.EohSetFootSoundId(0, 7)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -7.0, 0.0, 198.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "上向くL", 4)
	event.EohSetFootSoundId(1, 7)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetPos(2, 0.0, 20.0, 160.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetMotion(2, "両手開くＬ", 4)
	event.EohSetPos(3, 11.0, 40.0, 160.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetMotion(3, "後光", 4)
	event.InitDramaScene()
	time = event.GetTime() or time
	event.SetTime(12.0)
	event.CmrsInit()
	event.CmrsSetPos(24.65, 49.97, 163.5)
	event.CmrsSetRef(-24.72, 49.99, 159.92)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あけ～目とじ２")
	event.ObjsSetMotion(2, "両手開いて深呼吸", 2)
	event.ObjsNextMotion(2, "両手開いて深呼吸Ｌ", 4)
	event.SetPakuAnim(2, "通常口パク")
	helper_1d96573f(7000140)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 17.98, 252.41)
	event.CmrsSetRef(0.0, 26.48, 201.7)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目とじ～目あけ３")
	event.ObjsSetPos(3, 0.0, 40.0, 160.0)
	event.ObjsSetMotion(2, "両手開く戻り", 6)
	event.ObjsNextMotion(2, "浮遊立ち", 4)
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000150)
	if vm.skipping() then
		return skip(3)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000155)
	if vm.skipping() then
		return skip(4)
	end
	helper_650bfa16(2)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(0.0, 48.71, 192.39)
	event.CmrsSetRef(0.0, 48.68, 135.78)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "通常目パチ")
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000160)
	if vm.skipping() then
		return skip(6)
	end
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000165)
	if vm.skipping() then
		return skip(7)
	end
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "デフォルト顔")
	event.EohSetTexAnim(2, 1, "目あき～さみし目とじ")
	event.SetPakuAnim(2, "しんけん口パク")
	helper_1d96573f(7000170)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsSetPos(0.0, 39.02, 371.19)
	event.CmrsSetRef(0.0, 38.99, 314.58)
	event.SndSePlay(var1, 2)
	event.SetCharaShow(34, 0, 1, 0.033333335)
	event.ObjsSetMotion(3, "消失", 2)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsMove2(0.0, 39.02, 371.19, 0.0, 61.67, 314.58, 60, 0, 0.2)
	helper_076280e8()
	if vm.skipping() then
		return skip(10)
	end
	helper_ff0edc1d(20)
	if vm.skipping() then
		return skip(11)
	end
	event.SetTime(time)
	event.SetCrossfade(60)
	helper_ff0edc1d(90)
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(23.26, 26.93, 164.88)
	event.CmrsSetRef(-0.0, 18.34, 203.74)
	helper_ff0edc1d(40)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "上→左", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 3)
	event.ObjsMotionDelay(1, 20)
	event.ObjsSetMotion(1, "上から右", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsSeDelay(1, 30)
	event.ObjsSePlay(1, var1, 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_1d96573f(7000180)
	if vm.skipping() then
		return skip(14)
	end
	helper_650bfa16(1)
	if vm.skipping() then
		return skip(15)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_1d96573f(7000190)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(1, "右向く戻り", 6)
	event.ObjsNextMotion(1, "立ち", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 6)
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "左向く戻り", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var1, 5)
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(17)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "無表情")
	event.EohSetTexAnim(1, 1, "通常目～おこり目")
	helper_ff0edc1d(10)
	if vm.skipping() then
		return skip(18)
	end
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "無表情")
	event.EohSetTexAnim(0, 1, "通常目～おこり目")
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	program_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_915fd155(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_915fd155(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_915fd155(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_868b9caa(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_868b9caa(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_dcbc(155)
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s34")
	end
end

--- Program 210.
script[210] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_dcbc(109)
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump(-1, "d06e01")
	end
end

--- Program 310.
script[310] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			local _ = helper_e008()
			helper_ff0edc1d(30)
		end
		if at <= 4 then
			local _ = helper_e130()
			helper_ff0edc1d(30)
		end
	end
	if (if helper_e008() ~= 0 then helper_e130() else 0) ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(1)
		end
		event.SetFlag(744, 1)
		event.SetFlag(748, 1)
		event.MapJump(-1, "s44", 570)
		if vm.wait() then
			return skip(2)
		end
	end
	if helper_e008() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(3)
		end
		event.SetFlag(744, 1)
		event.MapJump(-1, "s44", 550)
		if vm.wait() then
			return skip(4)
		end
	end
	if helper_e130() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_ff0edc1d(30)
		if vm.skipping() then
			return skip(5)
		end
		event.SetFlag(748, 1)
		event.MapJump(-1, "s44", 560)
		if vm.wait() then
			return skip(6)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_0f1c5378()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_915fd155(0.0, 0.0, -1000.0, vm.f32(3.14))
	end
	helper_e73c()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(0, 9)
	event.LoadSound(7000)
	helper_915fd155(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, -1000.0)
	event.SetCameraPos(0.0, 50.0, -880.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 550.
script[550] = function()
	helper_915fd155(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Program 560.
script[560] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7e17ca03(198, 1)
		end
		if at <= 2 then
			helper_7e17ca03(199, 1)
		end
		if at <= 3 then
			helper_1b06d86e(1)
		end
	end
	helper_915fd155(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	helper_ff0edc1d(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddItem(198, 1)
	event.AddItem(199, 1)
	helper_7e17ca03(198, 1)
	if vm.skipping() then
		return skip(2)
	end
	helper_7e17ca03(199, 1)
	if vm.skipping() then
		return skip(3)
	end
	helper_1b06d86e(1)
	if vm.skipping() then
		return skip(4)
	end
end

return script
