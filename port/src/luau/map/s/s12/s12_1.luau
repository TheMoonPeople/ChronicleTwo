--!strict
-- map/s/s12/s12_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25e7cf9e = require("@lib/event/helper_25e7cf9e")
local helper_40ca6466 = require("@lib/event/helper_40ca6466")
local helper_56fec0ca = require("@lib/event/helper_56fec0ca")
local helper_6018bc39 = require("@lib/event/helper_6018bc39")
local helper_8aaa276e = require("@lib/event/helper_8aaa276e")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_bfdb69dc = require("@lib/event/helper_bfdb69dc")
local helper_c18edf53 = require("@lib/event/helper_c18edf53")
local helper_e0b1b1ab = require("@lib/event/helper_e0b1b1ab")
local helper_e1d7eb5a = require("@lib/event/helper_e1d7eb5a")
local helper_f44fd425 = require("@lib/event/helper_f44fd425")
local helper_f4bde801 = require("@lib/event/helper_f4bde801")
local helper_fb70dad4 = require("@lib/event/helper_fb70dad4")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	print("map_init-------------------------\n")
end

--- Helper function.
local function helper_311e4()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "chara/p00_31a.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, -300.0, 0.0, 4360.0)
	event.SetCharaRot(8, 0.0, 3.1415927, 0.0)
	event.SetCharaNo(8, 301)
end

--- Helper function.
local function helper_2edc0()
	local var0: s32 = 0
	local var1: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var5: f32 = 0
	local var6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(20)
		end
		if at <= 2 then
			helper_40ca6466(0)
		end
		if at <= 3 then
			helper_a8b5d854(10)
		end
		helper_56fec0ca()
	end
	var0 = event.GetCnt(0) or var0
	if var0 == 0 then
		helper_56fec0ca()
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0)
		event.SetFadeIn(30)
		return
	end
	var1 = event.GetCnt(15) or var1
	event.Initialize()
	event.EohSyncObj(1, "p01_train01")
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var1 == 0 then
		event.EohSyncObj(2, "p01_train01", "s3601_12-m1")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m1")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m1")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m5")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m3")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m4")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m2")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m3")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m5")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m5")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m4")
		end
	else
		event.EohSyncObj(2, "p01_train01", "s3601_12-m")
		event.EohSyncObj(3, "p01_train01", "s3601_14-m")
		event.EohSyncObj(4, "p01_train01", "s3601_16-m")
		event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
		if var0 == 2 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m4")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m2")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m2")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m3")
		end
		if var0 == 3 then
			event.EohSyncObj(2, "p01_train01", "s3601_12-m2")
			event.EohSyncObj(3, "p01_train01", "s3601_14-m4")
			event.EohSyncObj(4, "p01_train01", "s3601_16-m3")
			event.EohSyncObj(5, "p01_train01", "s3601_17-m5")
		end
	end
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	var5 = -240.0
	if var0 == 2 then
		var5 = 270.0
	end
	if var0 == 3 then
		var5 = 790.0
	end
	event.CmrsInit()
	if var1 == 0 then
		event.CmrsSetPos(var5 + vm.f32(135.23), 32.86, 4778.39)
		event.CmrsSetRef(var5, 31.8, 4650.0)
	else
		event.CmrsSetPos(var5 - vm.f32(135.23), 32.86, 4221.61)
		event.CmrsSetRef(var5, 31.8, 4350.0)
	end
	event.SetFadeIn(30)
	if var1 == 0 then
		event.ObjsSetPos(0, var5, 25.9, 4550.0)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	else
		event.ObjsSetPos(0, var5, 30.0, 4480.0)
		event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	end
	if var1 == 0 then
		event.ObjsRotation(2, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, 1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, -0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, -0.3926991, 30)
	else
		event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
		event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
		event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	end
	var6 = event.GetSndId(2) or var6
	event.SndSePlay(var6, 92)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(2)
	end
	if var1 == 0 then
		event.ObjsMove(0, var5, 0.0, 4600.0, 30)
	else
		event.ObjsMove(0, var5, 0.0, 4400.0, 30)
	end
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeIn(1)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	helper_56fec0ca()
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0)
end

--- Helper function.
local function helper_2db04()
	local var0: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_40ca6466(1)
		end
		if at <= 2 then
			helper_a8b5d854(10)
		end
		if at <= 3 then
			helper_a8b5d854(30)
		end
		if at <= 4 then
			helper_a8b5d854(20)
		end
		if at <= 5 then
			helper_40ca6466(0)
		end
		if at <= 6 then
			helper_a8b5d854(10)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_019.sound.json") or var0
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.CharaActive(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, -190.0, 0.0, 4500.0)
	event.ObjsSetRot(1, 0.0, -1.57, 0.0)
	event.EohSyncObj(2, "p01_train01", "s3601_12-m")
	event.ObjsSyncObj(2, 2)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncObj(3, "p01_train01", "s3601_14-m")
	event.ObjsSyncObj(3, 3)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.EohSyncObj(4, "p01_train01", "s3601_16-m")
	event.ObjsSyncObj(4, 4)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.EohSyncObj(5, "p01_train01", "s3601_17-m1")
	do
		local out1, out2, out3 = event.EohGetPos(5)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsSyncObj(5, 5)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CmrsSetPos(-1323.57, 7.45, 4810.3)
	event.CmrsSetRef(-994.3, 130.62, 4578.42)
	event.SetFadeIn(30)
	event.ObjsMove2(1, -790.0, 0.0, 4500.0, 40, 2, 1.0)
	event.SndSePlay(var0, 0)
	helper_40ca6466(1)
	if vm.skipping() then
		return skip(2)
	end
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-375.22998, 32.86, 4221.61)
	event.CmrsSetRef(-240.0, 31.8, 4350.0)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.CharaActive(0)
	event.ObjsSetPos(0, -240.0, 30.0, 4480.0)
	event.ObjsSetRot(0, 0.0, 3.1415927, 0.0)
	event.ObjsRotation(2, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(3, 0.0, 0.0, -1.5707964, 30)
	event.ObjsRotation(4, 0.0, 0.0, 0.3926991, 30)
	event.ObjsRotation(5, 0.0, 0.0, 0.3926991, 30)
	var4 = event.GetSndId(2) or var4
	event.SndSePlay(var4, 92)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(5, pos_x - 22.5, pos_y - 9.5, pos_z, 30)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsMove(0, -240.0, 0.0, 4405.0, 30)
	event.ObjsSetMotion(0, "走り", 4)
	event.EohSetFootSoundId(0, 6)
	helper_40ca6466(0)
	if vm.skipping() then
		return skip(6)
	end
	event.EohSetFootSoundId(0, 0)
	event.ObjsSetMotion(0, "立ち")
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeIn(1)
	event.EohSetPos(1, -790.0, 0.0, 4500.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.EohSetRot(4, 0.0, 0.0, 0.0)
	event.EohSetPos(5, pos_x, pos_y, pos_z)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.CmrsInit()
	event.CharaActive(0)
	event.SetCharaPos(0, -240.0, 0.0, 4350.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	event.CharaNormalDrive(0)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
end

--- Helper function.
local function helper_30f48()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a8b5d854(20)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var0 = helper_f4bde801(5, 4)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(20)
		helper_a8b5d854(20)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_24a28()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fb70dad4(0, 1)
			return 0
		end
		if at <= 3 then
			helper_a8b5d854(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_fb70dad4(0, 4)
	event.MesMake_2(0, "Go inside\nLeave")
	var0 = helper_25e7cf9e(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_fb70dad4(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_a8b5d854(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_a8b5d854(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_e7cc()
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
	event.EohSyncObj(14, "p01_shadow-0")
	event.EohSyncObj(5, "p01_train01", "s3601_12-m1")
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.EohSyncObj(6, "p01_train01", "s3601_14-m1")
	event.ObjsSyncObj(6, 6)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.EohSyncObj(7, "p01_train01", "s3601_16-m1")
	event.ObjsSyncObj(7, 7)
	event.ObjsSetRot(7, 0.0, 0.0, 0.0)
	event.EohSyncObj(13, "p01_train01", "s3601_17-m")
	event.ObjsSyncObj(13, 13)
	event.ObjsSetRot(13, 0.0, 0.0, 0.0)
	event.LoadMes(0, 5, "event/e600/e616/e616.txt")
end

--- Helper function.
local function helper_e3d4()
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
local function helper_10090()
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
				helper_a8b5d854(30)
			end
			if at <= 2 then
				helper_a8b5d854(10)
			end
			if at <= 3 then
				helper_a8b5d854(20)
			end
			if at <= 4 then
				helper_a8b5d854(30)
			end
			if at <= 5 then
				helper_a8b5d854(30)
			end
			if at <= 6 then
				helper_a8b5d854(30)
			end
			if at <= 7 then
				helper_a8b5d854(30)
			end
			if at <= 8 then
				helper_a8b5d854(20)
			end
			if at <= 9 then
				var10 = 2
				helper_a8b5d854(10)
			end
			if at <= 10 then
				var10 = 0
				helper_a8b5d854(10)
			end
			if at <= 11 then
				var10 = 1
				helper_40ca6466(1)
			end
			if at <= 12 then
				helper_a8b5d854(10)
			end
			if at <= 13 then
				helper_6018bc39()
			end
			if at <= 14 then
				helper_a8b5d854(30)
			end
			if at <= 15 then
				helper_a8b5d854(60)
			end
			if at <= 16 then
				helper_a8b5d854(30)
			end
			if at <= 17 then
				helper_40ca6466(4)
			end
			if at <= 18 then
				var11 = 790.0
				var12 = 0.0
				var13 = vm.f32(0.26666668)
				var14 = 50.0
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
		if at <= 20 then
			helper_a8b5d854(35)
		end
		if at <= 22 then
			helper_e3d4()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.FadeOutBgm(30)
		event.SetFadeOut(30)
		helper_a8b5d854(35)
		if vm.skipping() then
			return skip(21)
		end
		event.StopBgm(0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SndSeAllStop(4)
		event.EsmClear()
		if vm.wait() then
			return skip(22)
		end
		helper_e3d4()
		if vm.skipping() then
			return skip(23)
		end
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var6 = event.SndLoadSound(7202) or var6
	helper_e7cc()
	event.InitDramaScene()
	event.EohSetFootSoundId(0, 16)
	event.EohSetFootSoundId(1, 16)
	event.EohSetFootSoundId(2, 16)
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
	event.ObjsSetPos(4, 790.0, 0.0, 4500.0)
	event.ObjsSetRot(4, 0.0, 1.57, 0.0)
	event.EohSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsSetPos(8, 913.78, 1815.71, -1455.71)
	event.ObjsSetPos(10, 913.78, 1815.71, -1455.71)
	event.ObjsSetRot(10, 0.0, -0.04, 0.0)
	event.ObjsSetPos(9, 347.12, 200.0, 1407.85)
	event.CharaActive(1, 40)
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
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CharaActive(1, 42)
	event.ObjsSetMotion(8, "発射", 6)
	event.ObjsSetMotion(10, "弾道", 6)
	event.EsmCreate("Ｅ６１６月花ビームＢ")
	event.EsmSetVect1(913.78, 1815.71, -1455.71)
	event.EsmSetVect2(0.0, -0.04, 0.0)
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(3, 395.57, 707.08, -157.89, 10)
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(4)
	end
	event.CharaActive(1, 41)
	event.SetMotion(41, "ヒット", 6, -1, 1)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(11, 395.57, 1007.08, -157.89)
	event.ObjsJump(11, -200.0, 700.0, -1000.0, -1.2, 60)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetPos(12, 395.57, 1007.08, -157.89)
	event.ObjsJump(12, 200.0, 700.0, -1000.0, -1.2, 60)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(368.47, 250.27, 3796.05)
	event.CmrsSetRef(296.74, 109.55, 4410.1)
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
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMove(13, pos_x + 45.0, pos_y - 19.0, pos_z, 30)
	helper_a8b5d854(20)
	if vm.skipping() then
		return skip(9)
	end
	var10 = 2
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(10)
	end
	var10 = 0
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(11)
	end
	var10 = 1
	event.ObjsInitPas(var10)
	event.ObjsSetPasFrm(var10, 120)
	event.ObjsAddPas(var10, 272.66, 0.0, 4119.88)
	event.ObjsAddPas(var10, 249.45, 0.0, 4367.87)
	event.ObjsAddPas(var10, 241.61, 14.02, 4435.0)
	event.ObjsAddPas(var10, 234.87, 28.2, 4492.6)
	event.ObjsStartPas(var10)
	helper_40ca6466(1)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(0, global0)
	event.CharaActive(0, global1)
	event.CharaActive(0, 38)
	helper_a8b5d854(10)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(200)
	event.CmrsAddPas(368.47, 250.27, 3796.05, 296.74, 109.55, 4410.1)
	event.CmrsAddPas(368.47, 250.27, 3796.05, 693.41, 109.55, 4324.2)
	event.CmrsStartPas()
	helper_6018bc39()
	if vm.skipping() then
		return skip(14)
	end
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(15)
	end
	event.EohSetShow(14, 0)
	event.CmrsSetPos(306.21, 234.45, 6861.67)
	event.CmrsSetRef(234.87, 296.89, 4492.6)
	event.SndSePlay(var6, 8)
	helper_a8b5d854(60)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(3, "浮遊", 4)
	event.ObjsRotation2(3, -0.209, 1.57, 0.0, 60, 0, 0.4)
	event.ObjsMove(3, 8374.23, 2944.08, 3500.0, 360)
	helper_a8b5d854(30)
	if vm.skipping() then
		return skip(17)
	end
	event.SndSePlay(var6, 9)
	event.ObjsMove2(4, 790.0, 50.0, 4500.0, 60, 0, 1.0)
	event.CmrsMoveRef(790.0, 100.0, 4500.0, 60)
	helper_40ca6466(4)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsRotation2(4, -0.209, 1.57, 0.0, 120, 0, 0.4)
	var11 = 790.0
	var12 = 0.0
	var13 = vm.f32(0.26666668)
	var14 = 50.0
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
		if vm.wait() then
			return skip(19)
		end
	end
	return part2()
end

--- Helper function.
local function helper_2d8bc()
	local var0: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_fb70dad4(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "I'll wait for you here.\nI hope it all goes well.")
	else
		event.MesMake_2(0, "I'll wait here.\nMake sure you get him.")
	end
	helper_bfdb69dc(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
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
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_56fec0ca()
			print("333--------------------------------------------\n")
			helper_2db04()
		end
		helper_311e4()
		print("444--------------------------------------------\n")
		print("555--------------------------------------------\n")
		print("999--------------------------------------------\n")
	end
	event.Initialize()
	program_99()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_311e4()
		helper_e1d7eb5a(70.0, vm.f32(0.6), 3440.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		print("000--------------------------------------------\n")
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			print("111--------------------------------------------\n")
			var3 = event.GetCnt(1) or var3
			if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 7 then
				print("222--------------------------------------------\n")
				helper_311e4()
				helper_2edc0()
				if vm.skipping() then
					return skip(1)
				end
				helper_56fec0ca()
				event.SetFadeIn(15)
				event.ResetCamera(1, 0.0)
			else
				print("333--------------------------------------------\n")
				helper_2db04()
				if vm.skipping() then
					return skip(2)
				end
				helper_311e4()
			end
			print("444--------------------------------------------\n")
		end
		print("555--------------------------------------------\n")
		event.SetMotion(0, "立ち")
	end
	print("999--------------------------------------------\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f44fd425()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_30f48()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		flag = event.GetFlag(700) or flag
		if flag == 0 then
			event.BgmLoadCancel()
			event.MapJump(-1, "s68", 550)
			if vm.wait() then
				return skip(2)
			end
		else
			event.MapJump(-1, "g05")
			if vm.wait() then
				return skip(3)
			end
		end
	end
end

--- Program 250.
script[250] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 4 then
			helper_e0b1b1ab()
		end
	end
	var0 = helper_24a28()
	if vm.skipping() then
		return skip(1)
	end
	if var0 ~= 1 then
		return
	end
	event.SetCnt(1, 7)
	var1 = event.GetEventData_2(3) or var1
	if var1 <= 1 then
		helper_8aaa276e()
		if vm.skipping() then
			return skip(2)
		end
		event.StopBgm(0)
		if vm.wait() then
			return skip(3)
		end
		event.MapJump(-1, "s37")
		if vm.wait() then
			return skip(4)
		end
	else
		helper_e0b1b1ab()
		if vm.skipping() then
			return skip(5)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_c18edf53()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_311e4()
		helper_e1d7eb5a(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	end
	helper_f44fd425()
	if vm.skipping() then
		return skip(1)
	end
	helper_311e4()
	event.CharaActive(0)
	helper_e1d7eb5a(vm.f32(-249.34), 0.0, vm.f32(4318.43), vm.f32(3.14))
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Program 590.
script[590] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10090()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "s11", 502)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_2d8bc()
		if vm.skipping() then
			return skip(1)
		end
	end
end

return script
