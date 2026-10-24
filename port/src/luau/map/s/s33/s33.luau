--!strict
-- map/s/s33/s33.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02bfaf68 = require("@lib/event/helper_02bfaf68")
local helper_4303896d = require("@lib/event/helper_4303896d")
local helper_774ccd87 = require("@lib/event/helper_774ccd87")
local helper_b2a0ed41 = require("@lib/event/helper_b2a0ed41")
local helper_e42033a8 = require("@lib/event/helper_e42033a8")
local helper_f79a127e = require("@lib/event/helper_f79a127e")

--- Helper function.
local function helper_eac8()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_774ccd87(60)
			end
			if at <= 2 then
				helper_f79a127e(6040010, 150)
			end
			if at <= 3 then
				helper_f79a127e(6040020, 240)
			end
			if at <= 4 then
				helper_f79a127e(6040030, 240)
			end
			if at <= 5 then
				helper_774ccd87(20)
			end
			if at <= 6 then
				helper_4303896d(1)
			end
			if at <= 7 then
				helper_f79a127e(6040040, -1)
			end
			if at <= 8 then
				helper_774ccd87(15)
			end
			if at <= 9 then
				helper_e42033a8(6040050)
			end
			if at <= 10 then
				helper_4303896d(1)
			end
			if at <= 11 then
				helper_774ccd87(30)
			end
			if at <= 12 then
				helper_774ccd87(120)
			end
			if at <= 13 then
				helper_e42033a8(6040060)
			end
			if at <= 14 then
				helper_e42033a8(6040070)
			end
			if at <= 15 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		helper_b2a0ed41(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetRot(2, 0.0, 0.61, 0.0)
		event.EohSetRot(3, 0.0, -0.61, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.LoadMes(0, -1)
		helper_b2a0ed41(0.0, vm.f32(140.7), -770.0, vm.f32(3.14))
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(604, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_774ccd87(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(51)
	event.PlayBgm(0)
	event.LoadSound(7803)
	var0 = event.SndLoadSound(7803) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e600/e604/")
	event.LoadMes(0, 5, "e604.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e604_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e604_monica.gltf", "info", 0)
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
		event.LoadMotion(5, "event/e600/e604/e604_mints.gltf", "info", 33)
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
		event.LoadMotion(5, "event/e600/e604/e604_monica.gltf", "info", 33)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 33)
		event.EohSyncChara(1, 33)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(33)
	event.CharaActive(34)
	event.EohSyncObj(2, "p01_s3302-0", "s330208-m0")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p01_s3302-0", "s330208-m1")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSetPos(0, 14.06, 0.0, -283.76)
	event.EohSetRot(0, 0.0, -3.09, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, -22.57, 0.0, -283.73)
	event.EohSetRot(1, 0.0, -3.09, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetRot(3, 0.0, 0.0, 0.0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-1409.3, 33.17, 699.45)
	event.CmrsSetRef(-1317.3, 207.26, 35.03)
	event.CharaActive(0)
	event.CharaActive(33)
	event.CharaActive(34)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, 14.06, 0.0, -588.5, 540, 1)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMove(1, -22.57, 0.0, -588.26, 540, 1)
	event.SetFadeIn(30)
	event.CmrsMove(1340.45, 33.17, 781.09, 1266.94, 207.26, 116.17, 450)
	helper_774ccd87(60)
	if vm.skipping() then
		return skip(2)
	end
	helper_f79a127e(6040010, 150)
	if vm.skipping() then
		return skip(3)
	end
	helper_f79a127e(6040020, 240)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(1, -13.05, 82.65, -581.69)
	event.ObjsSetRot(1, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 10.82, 82.79, -581.79)
	event.ObjsSetRot(0, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(0)
	event.SetCrossfade(30)
	event.CmrsSetPos(-1.05, 107.16, -512.55)
	event.CmrsSetRef(-0.34, 115.06, -632.94)
	event.ObjsMove(1, -11.66, 140.66, -709.98, 260, 1)
	event.ObjsMove(0, 11.57, 140.66, -707.0, 260, 1)
	helper_f79a127e(6040030, 240)
	if vm.skipping() then
		return skip(5)
	end
	helper_774ccd87(20)
	if vm.skipping() then
		return skip(6)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1.24, 142.22, -872.19)
	event.CmrsSetRef(1.67, 177.22, -765.97)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(1, -8.87, 140.66, -739.81)
	event.ObjsSetRot(1, 0.0, 3.07, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 12.17, 140.66, -739.07)
	event.ObjsSetRot(0, 0.0, -3.09, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsMove(1, -9.09, 140.66, -794.9, 120, 1)
	event.ObjsMove(0, 11.95, 140.66, -793.78, 120, 1)
	event.ObjsMotionDelay(0, 120)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMotionDelay(1, 120)
	event.ObjsSetMotion(1, "立ち")
	event.SetPakuAnim(0, "通常口パク")
	helper_f79a127e(6040040, -1)
	if vm.skipping() then
		return skip(8)
	end
	helper_774ccd87(15)
	if vm.skipping() then
		return skip(9)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_e42033a8(6040050)
	if vm.skipping() then
		return skip(10)
	end
	helper_4303896d(1)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(-0.36, 446.02, 122.03)
	event.CmrsSetRef(3.18, 151.42, -826.58)
	event.ObjsSetPos(1, -22.1, 140.66, -908.82)
	event.ObjsSetRot(1, 0.0, 2.95, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(0, 13.59, 140.66, -906.11)
	event.ObjsSetRot(0, 0.0, -2.97, 0.0)
	event.ObjsResetDaPosition(0)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var0, 0)
	event.ObjsRotation(2, 0.0, 0.61, 0.0, 60)
	event.ObjsRotation(3, 0.0, -0.61, 0.0, 60)
	helper_774ccd87(120)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向く会話", 4)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "左向く", 6)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_e42033a8(6040060)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsMotionDelay(1, 30)
	event.ObjsSetMotion(1, "右向くうなづき", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_e42033a8(6040070)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

--- Helper function.
local function helper_db28()
	local var0: any = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_774ccd87(30)
			end
			return 1
		end
		return 0
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_02bfaf68(7, 97)
	if vm.skipping() then
		return skip(1)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	else
		do
			local out1, out2, out3 = event.GetCharaPos(0)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		var4 = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + var1)
		var5 = var2
		var6 = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + var3)
		event.ObjsMove(0, var4, var5, var6, 30)
		event.ObjsReference(0, var4, var5, var6, 10)
		event.ObjsSetMotion(0, "歩き")
		var7 = 0
		while var7 < 30 do
			do
				local out1, out2, out3 = event.GetCharaPos(0)
				var1 = out1 or var1
				var2 = out2 or var2
				var3 = out3 or var3
			end
			var2 = vm.f32(var2 + 30.0)
			event.SetCameraRef(var1, var2, var3)
			var7 = var7 + 1
			if vm.wait() then
				return skip(3)
			end
		end
	end
	return 0
end

--- Helper function.
local function helper_e254()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_774ccd87(30)
		end
		return 1
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = helper_02bfaf68(4, -1)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == 0 then
		event.SetFadeOut(30)
		helper_774ccd87(30)
		if vm.skipping() then
			return skip(2)
		end
		return 1
	end
	return 0
end

--- Helper function.
local function helper_e410()
	local flag: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_e42033a8(3720190)
			end
			if at <= 2 then
				helper_e42033a8(3720200)
			end
			if at <= 3 then
				helper_e42033a8(3720210)
			end
			if at <= 4 then
				helper_e42033a8(3720220)
			end
			if at <= 5 then
				helper_774ccd87(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(32)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadMes(0, 5, "event/e300/e372/e372.txt")
	flag = event.GetFlag(43) or flag
	if flag ~= 0 then
		event.StopBgm(0)
		helper_774ccd87(4)
		if vm.skipping() then
			return skip(1)
		end
		event.LoadBgm(59)
		event.PlayBgm(0)
		event.SetFlag(43, 0)
	end
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.SetCrossfade(0, 0, 90)
	event.CmrsSetPos(-178.53, 128.12, 2185.49)
	event.CmrsSetRef(-546.76, 268.24, 1697.27)
	event.ObjsSetPos(0, -546.76, 268.24, 1697.27)
	event.CmrsCharaAttach(32, 608.78, 99999999)
	event.CmrsMove2(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
	helper_e42033a8(3720190)
	if vm.skipping() then
		return skip(2)
	end
	helper_e42033a8(3720200)
	if vm.skipping() then
		return skip(3)
	end
	helper_e42033a8(3720210)
	if vm.skipping() then
		return skip(4)
	end
	helper_e42033a8(3720220)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsInit()
	event.SetFadeOut(30)
	helper_774ccd87(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b2a0ed41(0.0, 0.0, 2300.0, vm.f32(3.14))
	end
	flag = event.GetFlag(600) or flag
	flag_2 = event.GetFlag(604) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_eac8()
		if vm.skipping() then
			return skip(1)
		end
	else
		if flag_2 == 1 then
			event.EohSyncObj(0, "p01_s3302-0", "s330208-m0")
			event.EohSyncObj(1, "p01_s3302-0", "s330208-m1")
			event.EohSetRot(0, 0.0, 0.61, 0.0)
			event.EohSetRot(1, 0.0, -0.61, 0.0)
		end
		helper_b2a0ed41(0.0, 0.0, 2300.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_db28()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.BgmLoadCancel()
		event.GotoDng(5, -1, 500)
	end
end

--- Program 210.
script[210] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_e254()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.MapJump(-1, "s31")
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_e410()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "f02", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 16040.
script[16040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_eac8()
	if vm.skipping() then
		return skip(1)
	end
end

return script
