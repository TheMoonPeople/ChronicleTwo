--!strict
-- map/s/s71/s71_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4337dd96 = require("@lib/event/helper_4337dd96")
local helper_b5a6794c = require("@lib/event/helper_b5a6794c")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")
local helper_e83cea40 = require("@lib/event/helper_e83cea40")

local global0: s32 = 0
local global1: s32 = 0

--- Helper function.
local function helper_1d5c0()
	local active_chr_no: s32 = 0
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e600/e616/e616_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e600/e616/e616_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e600/e616/e616_osmond.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(2, 38)
	event.ObjsInit(2, 38)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(3, 39)
	event.ObjsInit(3, 39)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "event/e600/e616/e616_beam_f.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.EohSyncChara(8, 40)
	event.ObjsInit(8, 40)
	event.ObjsSyncObj(8, 8)
	event.LoadChara(5, "event/e600/e616/e616_beam_h.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(9, 41)
	event.ObjsInit(9, 41)
	event.ObjsSyncObj(9, 9)
	event.LoadChara(5, "event/e600/e616/e616_tama1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.EohSyncChara(10, 42)
	event.ObjsInit(10, 42)
	event.ObjsSyncObj(10, 10)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ６１６月花ビームＢ")
	event.EsmInitFix(5)
	event.LoadChara(5, "event/e600/e616/e616_iwa.gltf", "info", 43)
	event.CharaActive(0, 43)
	event.EohSyncChara(11, 43)
	event.ObjsInit(11, 43)
	event.ObjsSyncObj(11, 11)
	event.CopyChara(5, 43, 44)
	event.CharaActive(0, 44)
	event.EohSyncChara(12, 44)
	event.ObjsInit(12, 44)
	event.ObjsSyncObj(12, 12)
	event.EohSyncObj(4, "p01_train01")
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.EohSyncObj(14, "p04_s7101-0", "shadow-m")
	event.EohSyncObj(5, "p01_train01", "s3601_12-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "s3601_14-m6")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj(7, "p01_train01", "s3601_16-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.EohSyncObj(13, "p01_train01", "s3601_17-m")
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e600/e616/e616_1.txt")
end

--- Helper function.
local function helper_1d1c8()
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
		event.DeleteChara(37)
	end
	if active_chr_no == 1 then
		event.CharaActive(1, global1)
		event.CharaActive(0, global0)
		event.DelExtMotion(global0)
		event.DelExtMotion(global1)
		event.DeleteChara(global0)
		event.DeleteChara(37)
	end
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.DeleteChara(43)
	event.DeleteChara(44)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

--- Helper function.
local function helper_1eea0()
	local var6: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 19 then
			if at <= 1 then
				helper_e2203e72(30)
			end
			if at <= 2 then
				helper_e2203e72(10)
			end
			if at <= 3 then
				helper_e2203e72(20)
			end
			if at <= 4 then
				helper_e2203e72(30)
			end
			if at <= 5 then
				helper_e2203e72(30)
			end
			if at <= 6 then
				helper_e2203e72(30)
			end
			if at <= 7 then
				helper_e2203e72(30)
			end
			if at <= 8 then
				helper_e2203e72(20)
			end
			if at <= 9 then
				var10 = 2
				helper_e2203e72(10)
			end
			if at <= 10 then
				var10 = 0
				helper_e2203e72(10)
			end
			if at <= 11 then
				var10 = 1
				helper_e83cea40(1)
			end
			if at <= 12 then
				helper_e2203e72(10)
			end
			if at <= 13 then
				helper_b5a6794c()
			end
			if at <= 14 then
				helper_e2203e72(30)
			end
			if at <= 15 then
				helper_e2203e72(60)
			end
			if at <= 16 then
				helper_e2203e72(30)
			end
			if at <= 17 then
				helper_e83cea40(4)
			end
			if at <= 18 then
				var11 = 790.0
				var12 = 0.0
				var13 = vm.f32(0.26666668)
				var14 = 70.0
				var15 = 0.0
				var16 = vm.f32(0.1)
				var17 = 4500.0
				var18 = 0.0
				var19 = 0.0
				var20 = 0
				var11 = vm.f32(var11 + var12)
				var12 = vm.f32(var12 + var13)
				var14 = vm.f32(var14 + var15)
				var15 = vm.f32(var15 + var16)
				var17 = vm.f32(var17 + var18)
				var18 = vm.f32(var18 + var19)
				var20 = var20 + 1
			end
			if vm.skip_end() then
				return skip(20)
			end
			return part2()
		end
		if at <= 21 then
			helper_1d1c8()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(30)
		event.SetFadeOut(0)
		event.StopBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeStop(var6, 3)
		event.EsmClear()
		event.BgmLoadCancel()
		if vm.wait() then
			return skip(21)
		end
		helper_1d1c8()
		if vm.skipping() then
			return skip(22)
		end
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7202)
	var6 = event.SndLoadSound(7202) or var6
	helper_4337dd96()
	helper_1d5c0()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 16)
	event.EohSetFootSoundId(1, 16)
	event.EohSetFootSoundId(2, 16)
	event.SndSePlay(var6, 3)
	event.EohSyncChrobj(20, 39, "puropera")
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsRotation(20, 0.0, -0.08, 0.0, -1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 38)
	event.CharaActive(1, 39)
	event.ObjsSetPos(4, 790.0, 20.0, 4500.0)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetPos(8, 913.78, 1815.71, -1455.71)
	event.ObjsSetPos(10, 913.78, 1815.71, -1455.71)
	event.ObjsSetRot(10, 0.0, -0.04, 0.0)
	event.ObjsSetPos(9, 347.12, 200.0, 1407.85)
	event.CharaActive(1, 40)
	event.SndSePlay(var6, 0)
	event.ObjsSetMotion(8, "入り", 6)
	event.ObjsNextMotion(8, "溜めループ", 4)
	event.CmrsSetPos(740.39, 361.22, 3768.25)
	event.CmrsSetRef(58.72, 398.27, 1944.66)
	event.ObjsSetMotion(0, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(1, "走り", 4, -1.0, 1)
	event.ObjsSetMotion(2, "走り")
	event.ObjsSetPos(3, 607.53, 453.56, -239.32)
	event.ObjsSetRot(3, 0.0, -2.56, 0.0)
	event.ObjsInitPas(2)
	event.ObjsSetPasFrm(2, 120)
	event.ObjsAddPas(2, 0.0, 173.54, 2717.0)
	event.ObjsAddPas(2, 0.0, 59.11, 3144.44)
	event.ObjsStartPas(2, 1)
	event.ObjsInitPas(1)
	event.ObjsSetPasFrm(1, 140)
	event.ObjsAddPas(1, 25.0, 189.22, 2617.0)
	event.ObjsAddPas(1, 25.0, 49.45, 3179.82)
	event.ObjsStartPas(1, 1)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 130)
	event.ObjsAddPas(0, -25.0, 184.27, 2667.0)
	event.ObjsAddPas(0, -25.75, 51.4, 3172.67)
	event.ObjsStartPas(0, 1)
	event.ObjsSetMotion(3, "岩を投げる", 4)
	event.CharaActive(1, 43)
	event.CharaActive(1, 44)
	event.SetFadeIn(30)
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(1, 42)
	event.SndSePlay(var6, 1)
	event.ObjsSetMotion(8, "発射", 6)
	event.ObjsSetMotion(10, "弾道", 6)
	event.EsmCreate("Ｅ６１６月花ビームＢ")
	event.EsmSetVect1(913.78, 1815.71, -1455.71)
	event.EsmSetVect2(0.0, -0.04, 0.0)
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(3, 395.57, 707.08, -157.89, 10)
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(20)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var6, 2)
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(368.47, 270.27002, 3796.05)
	event.CmrsSetRef(296.74, 129.55, 4410.1)
	event.SndSePlay(var6, 7)
	do
		local out1, out2, out3 = event.EohGetPos(13)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsRotation(5, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(6, 0.0, 0.0, 1.5707964, 30)
	event.ObjsRotation(7, 0.0, 0.0, -0.3926991, 30)
	event.ObjsRotation(13, 0.0, 0.0, -0.3926991, 30)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
	helper_e2203e72(20)
	if vm.skipping() then
		return skip(9)
	end
	var10 = 2
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 20.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 20.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 34.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 48.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_e2203e72(10)
	if vm.skipping() then
		return skip(10)
	end
	var10 = 0
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 20.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 20.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 34.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 48.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_e2203e72(10)
	if vm.skipping() then
		return skip(11)
	end
	var10 = 1
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 20.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 20.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 34.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 48.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_e83cea40(1)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 38)
	helper_e2203e72(10)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(368.47, 270.27002, 3796.05, 296.74, 129.55, 4410.1)
	event.CmrsAddPas(368.47, 270.27002, 3796.05, 693.41, 129.55, 4324.2)
	event.CmrsStartPas()
	helper_b5a6794c()
	if vm.skipping() then
		return skip(14)
	end
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetShow(14, 0)
	event.CmrsSetPos(306.21, 254.45, 6861.67)
	event.CmrsSetRef(234.87, 316.89, 4492.6)
	event.SndSePlay(var6, 8)
	helper_e2203e72(60)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "浮遊", 4)
	event.ObjsRotation2(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
	event.ObjsMove(3, 8374.23, 2964.08, 3500.0, 400)
	helper_e2203e72(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var6, 9)
	event.ObjsMove2(4, 790.0, 70.0, 4500.0, 60, 0, 1.0)
	event.CmrsMoveRef(790.0, 120.0, 4500.0, 60)
	helper_e83cea40(4)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsRotation2(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
	var11 = 790.0
	var12 = 0.0
	var13 = vm.f32(0.26666668)
	var14 = 70.0
	var15 = 0.0
	var16 = vm.f32(0.1)
	var17 = 4500.0
	var18 = 0.0
	var19 = 0.0
	var20 = 0
	while var20 < 240 do
		event.ObjsSetPos(4, var11, var14, var17)
		event.CmrsSetRef(var11, var14 + 50.0, var17)
		var11 = vm.f32(var11 + var12)
		var12 = vm.f32(var12 + var13)
		var14 = vm.f32(var14 + var15)
		var15 = vm.f32(var15 + var16)
		var17 = vm.f32(var17 + var18)
		var18 = vm.f32(var18 + var19)
		var20 = var20 + 1
		if var20 == 210 then
			event.FadeOutBgm(30)
			event.SetFadeOut(30)
		end
		if vm.wait() then
			return skip(19)
		end
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = function()
	print("map_init-------------------------\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1eea0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 590.
script[590] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1eea0()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 502)
	if vm.wait() then
		return skip(2)
	end
end

return script
