--!strict
-- map/s/s05/s05_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_07bc3618 = require("@lib/event/helper_07bc3618")
local helper_2073777c = require("@lib/event/helper_2073777c")
local helper_20f256cb = require("@lib/event/helper_20f256cb")
local helper_2454e4e4 = require("@lib/event/helper_2454e4e4")
local helper_2690eb2a = require("@lib/event/helper_2690eb2a")
local helper_3539f0a5 = require("@lib/event/helper_3539f0a5")
local helper_3cae1bdc = require("@lib/event/helper_3cae1bdc")
local helper_459f6eff = require("@lib/event/helper_459f6eff")
local helper_4a47348c = require("@lib/event/helper_4a47348c")
local helper_72506d21 = require("@lib/event/helper_72506d21")
local helper_8d283e19 = require("@lib/event/helper_8d283e19")
local helper_949157d8 = require("@lib/event/helper_949157d8")
local helper_af0c88eb = require("@lib/event/helper_af0c88eb")
local helper_b4af9ac1 = require("@lib/event/helper_b4af9ac1")
local helper_ccf7aeb2 = require("@lib/event/helper_ccf7aeb2")
local helper_ce27a7cc = require("@lib/event/helper_ce27a7cc")
local helper_ce64820a = require("@lib/event/helper_ce64820a")
local helper_d35bdec4 = require("@lib/event/helper_d35bdec4")
local helper_e0a9948d = require("@lib/event/helper_e0a9948d")

local global0: s32 = 0
local global1: s32 = 0

--- Program 99.
local function program_99()
	event.SetBitCtrl(16, 1)
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_274b8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_20f256cb(1)
		helper_20f256cb(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(3) or var0
	if var0 < 7 then
		helper_20f256cb(1)
	else
		helper_20f256cb(0)
	end
end

--- Helper function.
local function helper_25c3c(arg0: f32, arg1: f32, arg2: f32, arg3: f32)
	local var4: s32 = 0
	local angle: f32 = 0
	local active_chr_no: s32 = 0
	local var11: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 10 then
			if at <= 1 then
				helper_2454e4e4(0)
			end
			if at <= 2 then
				helper_2454e4e4(0)
			end
			if at <= 3 then
				helper_ccf7aeb2(14)
			end
			if at <= 4 then
				helper_ccf7aeb2(16)
			end
			if at <= 5 then
				helper_2454e4e4(0)
			end
			if at <= 6 then
				helper_ccf7aeb2(30)
			end
			if at <= 7 then
				helper_3cae1bdc()
			end
			if at <= 8 then
				var11 = vm.f32(var11 - vm.f32(3.1415927))
				helper_2454e4e4(0)
			end
			if at <= 9 then
				helper_ccf7aeb2(15)
			end
			if vm.skip_end() then
				return skip(11)
			end
			return part2()
		end
	end
	function part2()
		event.SetFadeIn(0)
		event.ObjsInit(0)
		event.EohSetMotion(0, "立ち")
		event.EohSetPos(0, -170.0, 0.0, 50.0)
		event.EohSetRot(0, 0.0, -1.57, 0.0)
		event.EohResetDaPosition(0)
		event.SetCameraRef(-170.0, 30.0, 50.0)
		event.SetCameraPos(-70.0, 35.0, 50.0)
		event.ResetCamera(0)
		event.DelExtMotion(0)
	end
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	var4 = event.SndLoadSound(8, "snd2/sp/sp_031.sound.json") or var4
	event.AssignStack(5)
	event.ClearStack(5)
	angle = event.AngleLimit(angle) or angle
	event.SetWorldCoord(arg0, arg1, arg2, arg3)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		event.LoadMotion(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 116.96, 18.76, 19.22)
	event.ObjsSetRot(0, 0.0, -1.96, 0.0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.EohSetFootSoundId(0, 3)
	event.CmrsInit()
	event.CmrsSetPos(186.89, 58.05, -1.19)
	event.CmrsSetRef(50.97, 32.07, 20.9)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	if active_chr_no == 0 then
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 160, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 140)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 130)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		helper_2454e4e4(0)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.3)
		event.ObjsNextMotion(0, "着地", 6)
	else
		event.CmrsMove2(137.93, 48.95, 6.77, 50.97, 32.07, 20.9, 100, 2, 0.4)
		event.ObjsMove(0, 23.61, 18.53, -17.13, 60)
		event.ObjsSetMotion(0, "丸太歩き", 4)
		event.ObjsRotDelay(0, 50)
		event.ObjsRotation(0, 0.0, -1.0, 0.0, 10)
		helper_2454e4e4(0)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsSetMotion(0, "ジャンプ", 2)
		event.ObjsNextMotion(0, "ジャンプ中", 6, 0.2)
		event.ObjsNextMotion(0, "着地", 6)
	end
	event.EohSetFootSoundId(0, 16)
	helper_ccf7aeb2(14)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var4, 2)
	event.ObjsJump(0, -85.0, 0.0, 50.0, -0.25, 30)
	event.ObjsRotDelay(0, 10)
	event.ObjsRotation(0, 0.0, -1.57, 0.0, 20)
	helper_ccf7aeb2(16)
	if vm.skipping() then
		return skip(5)
	end
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(6)
	end
	event.SndSePlay(var4, 4)
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMove(0, -170.0, 0.0, 50.0, 50)
	helper_3cae1bdc()
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(30)
	do
		local _, out2, _ = event.EohGetRot(0)
		var11 = out2 or var11
	end
	event.CmrsSetRef(-170.0, 30.0, 50.0)
	var11 = vm.f32(var11 - vm.f32(3.1415927))
	var11 = event.AngleLimit(var11) or var11
	event.CmrsSetAhd(var11, 5.0, 100.0)
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "立ち")
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(10)
	end
	event.CancelDramaScene()
	return part2()
end

--- Helper function.
local function helper_12944()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e215/e215_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e215/e215_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e215/e215_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadMes(0, 5, "event/e200/e215/e215_1.txt")
end

--- Helper function.
local function helper_1266c()
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
end

--- Helper function.
local function helper_135a0()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_12944()
				var9 = vm.f32(0.46)
				var10 = vm.f32(0.0066666664)
				var12 = 0
				var7 = vm.f32(var7 + 20.0)
				vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
				vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
				vector_y = vm.f32(vector_y + vm.f32(29.79))
				var9 = vm.f32(var9 + var10)
				var9 = vm.f32(var9 - vm.f32(6.2831855))
				var9 = vm.f32(var9 + vm.f32(6.2831855))
				var12 = var12 + 1
			end
			if at <= 2 then
				helper_ccf7aeb2(10)
			end
			if at <= 3 then
				helper_949157d8(2150010)
			end
			if at <= 4 then
				helper_949157d8(2150020)
			end
			if at <= 5 then
				helper_2454e4e4(0)
			end
			if at <= 6 then
				helper_ccf7aeb2(6)
			end
			if at <= 7 then
				helper_949157d8(2150030)
			end
			if at <= 8 then
				helper_2454e4e4(1)
			end
			if at <= 9 then
				helper_ccf7aeb2(10)
			end
			if at <= 10 then
				helper_2454e4e4(1)
			end
			if at <= 11 then
				helper_2454e4e4(1)
			end
			if at <= 12 then
				helper_949157d8(2150040)
			end
			if at <= 13 then
				helper_949157d8(2150050)
			end
			if at <= 14 then
				helper_ccf7aeb2(16)
			end
			if at <= 15 then
				helper_949157d8(2150060)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		if at <= 17 then
			helper_ccf7aeb2(45)
		end
		helper_1266c()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_ccf7aeb2(45)
		if vm.skipping() then
			return skip(18)
		end
		helper_1266c()
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(215, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var13 = event.SndLoadSound(2800) or var13
	helper_12944()
	event.InitDramaScene()
	event.StopBgm(0)
	event.EohSetSoundId(0, var13)
	event.EohSetSoundId(1, var13)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CmrsInit()
	event.CmrsSetPos(2810.55, 19.2, 1417.95)
	event.CmrsSetRef(2838.92, 19.55, 1472.76)
	event.ObjsSetPos(0, 3016.47, 0.01, 1619.33)
	event.ObjsSetRot(0, 0.0, -2.17, 0.0)
	event.ObjsSetPos(1, 3035.62, 0.01, 1589.73)
	event.ObjsSetRot(1, 0.0, -2.28, 0.0)
	event.ObjsMove(0, 2903.57, 0.01, 1552.25, 130)
	event.ObjsRotation(0, 0.0, -2.05, 0.0, 90)
	event.ObjsMove(1, 2918.09, 0.01, 1527.87, 130)
	event.ObjsRotation(1, 0.0, -2.04, 0.0, 90)
	event.ObjsSetMotion(0, "キョロキョロ歩き", 4, -1.0, 1)
	event.ObjsSetMotion(1, "きょろきょろ歩き", 4, -1.0, 1)
	var9 = vm.f32(0.46)
	var10 = vm.f32(0.0066666664)
	var12 = 0
	while var12 < 121 do
		do
			local out1, out2, out3 = event.GetCharaPos(global0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = event.GetCharaPos(global1)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.SubVector(var0, var1, var2, var6, var7, var8)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.ScaleVector(var0, var1, var2, 0.5)
			var0 = out1 or var0
			var1 = out2 or var1
			var2 = out3 or var2
		end
		do
			local out1, out2, out3 = event.AddVector(var6, var7, var8, var0, var1, var2)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		var7 = vm.f32(var7 + 20.0)
		event.CmrsSetRef(var6, var7, var8)
		do
			local out1, out2, out3 = event.CopyVector(var6, var7, var8)
			vector_x = out1 or vector_x
			vector_y = out2 or vector_y
			vector_z = out3 or vector_z
		end
		vector_x = vm.f32(vector_x + vm.f32(130.0 * vm.sin(var9)))
		vector_z = vm.f32(vector_z + vm.f32(130.0 * vm.cos(var9)))
		vector_y = vm.f32(vector_y + vm.f32(29.79))
		event.CmrsSetPos(vector_x, vector_y, vector_z)
		var9 = vm.f32(var9 + var10)
		if var9 > vm.f32(3.1415927) then
			var9 = vm.f32(var9 - vm.f32(6.2831855))
		end
		if var9 <= vm.f32(-3.1415927) then
			var9 = vm.f32(var9 + vm.f32(6.2831855))
		end
		var12 = var12 + 1
		if vm.wait() then
			return skip(2)
		end
	end
	helper_ccf7aeb2(10)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(2803.91, 11.38, 1411.86)
	event.CmrsSetRef(2831.84, 19.55, 1460.49)
	event.ObjsSetPos(0, 2831.19, 0.01, 1465.72)
	event.ObjsSetRot(0, 0.0, -2.05, 0.0)
	event.ObjsSetPos(1, 2837.63, 0.01, 1446.26)
	event.ObjsSetRot(1, 0.0, -1.92, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2150010)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SndSePlay(var13, 4)
	event.ObjsSetMotion(0, "待って", 6, -1.0, 1)
	event.ObjsNextMotion(0, "待ってL", 0)
	event.SetPakuAnim(0, "通常口パク")
	helper_949157d8(2150020)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 0)
	helper_ccf7aeb2(6)
	if vm.skipping() then
		return skip(7)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2150030)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "待って戻り", 6, -1.0, 1)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_ccf7aeb2(10)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "左向く戻り", 2)
	event.ObjsMotionWait(1)
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(11)
	end
	event.SndSePlay(var13, 5)
	event.ObjsNextMotion(1, "身を乗り出す", 2)
	event.ObjsNextMotion(1, "身を乗り出すＬ", 0)
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2150040)
	if vm.skipping() then
		return skip(13)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "身を乗り出す戻り", 6)
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2150050)
	if vm.skipping() then
		return skip(14)
	end
	event.ResetPakuAnim()
	event.ObjsNextMotion(0, "右向くうなづき", 2)
	event.ObjsNextMotion(0, "右向くL", 0)
	helper_ccf7aeb2(16)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.SetPakuAnim(0, "通常口パク")
	helper_949157d8(2150060)
	if vm.skipping() then
		return skip(16)
	end
	event.ResetPakuAnim()
	return part2()
end

--- Program 501.
local function program_501()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_135a0()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_8d283e19()
	end
	function part2()
		event.SetCnt(3, 1)
		helper_8d283e19()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_135a0()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Helper function.
local function helper_19664()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e240/e240_monica.gltf", "info", global1)
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
		event.LoadMotion(5, "event/e200/e240/e240_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.LoadMotion(5, "event/e200/e240/e240_monica.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e240/e240_madan.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "event/e200/e240/e240_sao.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/e200/e240/e240_wink.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.SetCharaType(38, 4)
	event.LoadChara(5, "event/e200/e240/mizubasira.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.LoadChara(5, "event/e200/e240/hamon.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e240/e240_line.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.EohSyncChara(5, 41)
	event.ObjsInit(4, 41)
	event.ObjsSyncObj(4, 5)
	event.LoadChara(5, "event/e200/e240/e240_line1.gltf", "info", 42)
	event.CharaActive(0, 42)
	event.LoadMes(0, 5, "event/e200/e240/e240_1.txt")
end

--- Helper function.
local function helper_19290()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(38)
	event.DeleteChara(39)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
end

--- Helper function.
local function helper_1a8dc()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 72 then
			if at <= 1 then
				helper_ccf7aeb2(45)
			end
			if at <= 2 then
				helper_19664()
			end
			if at <= 3 then
				helper_ccf7aeb2(15)
			end
			if at <= 4 then
				helper_2454e4e4(0)
			end
			if at <= 5 then
				helper_ccf7aeb2(30)
			end
			if at <= 6 then
				helper_2454e4e4(0)
			end
			if at <= 7 then
				helper_ccf7aeb2(60)
			end
			if at <= 8 then
				helper_ccf7aeb2(15)
			end
			if at <= 9 then
				helper_ccf7aeb2(30)
			end
			if at <= 10 then
				helper_ccf7aeb2(30)
			end
			if at <= 11 then
				helper_ccf7aeb2(30)
			end
			if at <= 12 then
				helper_2454e4e4(1)
			end
			if at <= 13 then
				helper_2454e4e4(1)
			end
			if at <= 14 then
				helper_ccf7aeb2(30)
			end
			if at <= 15 then
				helper_ccf7aeb2(15)
			end
			if at <= 16 then
				helper_ccf7aeb2(60)
			end
			if at <= 21 then
				helper_ccf7aeb2(60)
			end
			if at <= 22 then
				helper_ccf7aeb2(10)
			end
			if at <= 23 then
				helper_ce27a7cc(2400010, -1)
			end
			if at <= 24 then
				helper_ce27a7cc(2400015, -1)
			end
			if at <= 25 then
				helper_ccf7aeb2(30)
			end
			if at <= 26 then
				helper_ccf7aeb2(120)
			end
			if at <= 27 then
				helper_949157d8(2400020)
			end
			if at <= 28 then
				helper_2454e4e4(1)
			end
			if at <= 29 then
				helper_949157d8(2400025)
			end
			if at <= 30 then
				helper_2454e4e4(1)
			end
			if at <= 31 then
				helper_ccf7aeb2(15)
			end
			if at <= 32 then
				helper_2454e4e4(2)
			end
			if at <= 33 then
				helper_ce27a7cc(2400030, -1)
			end
			if at <= 34 then
				helper_ccf7aeb2(30)
			end
			if at <= 35 then
				helper_2454e4e4(2)
			end
			if at <= 36 then
				helper_ce27a7cc(2400035, -1)
			end
			if at <= 37 then
				helper_949157d8(2400040)
			end
			if at <= 38 then
				helper_2454e4e4(1)
			end
			if at <= 39 then
				helper_949157d8(2400045)
			end
			if at <= 40 then
				helper_2454e4e4(1)
			end
			if at <= 41 then
				helper_ce27a7cc(2400050, -1)
			end
			if at <= 42 then
				helper_2454e4e4(2)
			end
			if at <= 43 then
				helper_ce27a7cc(2400055, -1)
			end
			if at <= 44 then
				helper_949157d8(2400060)
			end
			if at <= 45 then
				helper_2454e4e4(1)
			end
			if at <= 46 then
				helper_949157d8(2400070)
			end
			if at <= 47 then
				helper_2454e4e4(0)
			end
			if at <= 48 then
				helper_2454e4e4(2)
			end
			if at <= 49 then
				helper_ce27a7cc(2400080, -1)
			end
			if at <= 50 then
				helper_ce27a7cc(2400085, -1)
			end
			if at <= 51 then
				helper_2454e4e4(2)
			end
			if at <= 52 then
				helper_ce27a7cc(2400090, -1)
			end
			if at <= 53 then
				helper_ce27a7cc(2400095, -1)
			end
			if at <= 54 then
				helper_2454e4e4(2)
			end
			if at <= 55 then
				helper_ce27a7cc(2400100, -1)
			end
			if at <= 56 then
				helper_ce27a7cc(2400105, -1)
			end
			if at <= 57 then
				helper_949157d8(2400110)
			end
			if at <= 58 then
				helper_ce27a7cc(2400115, -1)
			end
			if at <= 59 then
				helper_ccf7aeb2(60)
			end
			if at <= 60 then
				helper_949157d8(2400120)
			end
			if at <= 61 then
				helper_2454e4e4(0)
			end
			if at <= 62 then
				helper_949157d8(2400125)
			end
			if at <= 63 then
				helper_2454e4e4(0)
			end
			if at <= 64 then
				helper_949157d8(2400130)
			end
			if at <= 65 then
				helper_949157d8(2400140)
			end
			if at <= 66 then
				helper_2454e4e4(1)
			end
			if at <= 67 then
				helper_ccf7aeb2(30)
			end
			if at <= 68 then
				helper_ccf7aeb2(15)
			end
			if at <= 69 then
				helper_ce27a7cc(2400150, -1)
			end
			if at <= 70 then
				helper_ccf7aeb2(60)
			end
			if at <= 71 then
				helper_ccf7aeb2(35)
			end
			if vm.skip_end() then
				return skip(73)
			end
			return part2()
		end
		helper_19290()
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var4, 4)
		event.SndSeStop(var4, 6)
		event.SndSeStop(var4, 10)
		event.StopBgm(0)
		helper_19290()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	event.SetFlag(240, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_ccf7aeb2(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(193)
	event.PlayBgm(1)
	event.LoadSound(2812)
	var4 = event.SndLoadSound(2812) or var4
	event.SetFadeOut(30)
	helper_ccf7aeb2(45)
	if vm.skipping() then
		return skip(2)
	end
	helper_19664()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 35)
	event.CharaActive(0, 34)
	event.CharaActive(1, 41)
	event.SetCameraPos(-111.63, 33.95, -443.55)
	event.SetCameraRef(-297.56, 30.0, -373.68)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetPos(0, -303.57, 0.0, -356.14)
	event.ObjsSetRot(0, 0.0, 2.57, 0.0)
	event.ObjsSetPos(1, -327.35, 0.0, -377.28)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetPos(2, -127.39, 0.0, -701.37)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.SetCharaRot(41, 0.0, 0.0, 1.57)
	event.SetReference(35, "ito", 41)
	if vm.wait() then
		return skip(3)
	end
	event.SetReference(global0, "gun_hand", 35)
	event.SndSePlay(var4, 4)
	event.SndSePlay(var4, 6)
	event.SetFadeIn(30)
	event.SetMotion(41, "糸切れる", 5, -1, 1)
	event.ObjsSetMotion(0, "竿を引く", 4, -1.0, 1)
	event.ObjsSetMotion(3, "竿を引く", 4)
	event.ObjsSetMotion(1, "釣り観戦", 4, -1.0, 1)
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsMove(0, -300.7, 0.0, -364.52, 90)
	event.SndSePlay(var4, 5)
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-331.46, 23.14, -254.41)
	event.CmrsSetRef(-295.08, 10.97, -376.82)
	event.ObjsMove(0, -297.56, 0.0, -373.68, 90)
	event.SndSePlay(var4, 8)
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(7)
	end
	helper_ccf7aeb2(60)
	if vm.skipping() then
		return skip(8)
	end
	event.SndSeStop(var4, 4)
	event.SndSeStop(var4, 6)
	event.SndSePlay(var4, 7)
	event.SetMotion(41, "糸切れる", 2, -1, 1)
	event.CharaActive(1, 42)
	event.SetCharaPos(42, -184.19, -4.56, -446.98)
	event.SetCharaRot(42, 0.0, 2.57, 0.0)
	event.SetMotion(42, "糸切れる", 2, -1, 1)
	event.ObjsSetMotion(0, "糸切れる", 2)
	event.ObjsSetMotion(3, "糸切れる", 2)
	event.ObjsSetMotion(1, "ユリス追う（顔）", 2)
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var4, 5)
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(0, 42)
	event.CharaActive(0, 41)
	event.CharaActive(0, 35)
	event.DeleteChara(35)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.ObjsSetPos(0, -284.58, 0.0, -370.78)
	event.ObjsSetRot(0, 0.0, 2.93, 0.0)
	event.ObjsSetPos(1, -370.53, 0.0, -348.56)
	event.ObjsSetRot(1, 0.0, 0.89, 0.0)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMove(1, -334.31, 0.0, -340.4, 60)
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.CmrsQuakeDelay(30)
	event.CmrsQuake(0.0, 0.3, 0.0, 90)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -127.39, -18.0, -701.37)
	event.SetCharaRot(40, 0.0, -1.68, 0.0)
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(11)
	end
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 34)
	event.ObjsSetMotion(2, "浮かび笑", 6)
	event.ObjsNextMotion(2, "待機")
	event.CharaActive(1, 39)
	event.SetCharaPos(39, -241.56, -9.72, -479.54)
	event.SetCharaRot(39, 0.0, 0.0, 0.0)
	event.SetMotion(39, "水柱", 2, -1, 1)
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(var4, 9)
	event.ObjsRotation(1, 0.0, 2.45, 0.0, 10)
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(1, "立ち")
	event.ObjsSetMotion(0, "マーダン出現", 2)
	event.ObjsSetMotion(3, "マーダン出現", 2)
	event.ObjsNextMotion(0, "マーダン出現L")
	event.ObjsNextMotion(3, "マーダン出現L")
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(15)
	end
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(16)
	end
	event.FadeOutBgm(60)
	helper_ccf7aeb2(60)
	if vm.skipping() then
		return skip(17)
	end
	event.StopBgm(1)
	if vm.wait() then
		return skip(18)
	end
	if vm.wait() then
		return skip(19)
	end
	if vm.wait() then
		return skip(20)
	end
	if vm.wait() then
		return skip(21)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	event.SndSeStop(var4, 9)
	event.SndSePlay(var4, 10)
	helper_ccf7aeb2(60)
	if vm.skipping() then
		return skip(22)
	end
	event.CharaActive(0, 39)
	event.DeleteChara(39)
	event.ObjsSetMotion(2, "あせる")
	helper_ccf7aeb2(10)
	if vm.skipping() then
		return skip(23)
	end
	helper_ce27a7cc(2400010, -1)
	if vm.skipping() then
		return skip(24)
	end
	helper_ce27a7cc(2400015, -1)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(26)
	end
	event.ObjsSetMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	helper_ccf7aeb2(120)
	if vm.skipping() then
		return skip(27)
	end
	event.CmrsSetPos(-312.91, 53.63, -372.03)
	event.CmrsSetRef(-334.31, 16.44, -340.4)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2400020)
	if vm.skipping() then
		return skip(28)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(29)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2400025)
	if vm.skipping() then
		return skip(30)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(31)
	end
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(32)
	end
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsSetPos(0, -305.91, 0.0, -329.68)
	event.ObjsResetDaPosition(0)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(2, "目ほそめ", 2)
	event.ObjsNextMotion(2, "目ほそめL", 4)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(33)
	end
	event.ObjsSetMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_ce27a7cc(2400030, -1)
	if vm.skipping() then
		return skip(34)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(35)
	end
	event.ObjsSetMotion(2, "目とじ", 2)
	event.ObjsNextMotion(2, "目とじL", 4)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(36)
	end
	event.ObjsSetMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	helper_ce27a7cc(2400035, -1)
	if vm.skipping() then
		return skip(37)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsMotionWait(2)
	event.ObjsSetMotion(2, "目とじ戻り", 2)
	event.ObjsNextMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	event.ObjsSetMotion(1, "上向く", 2)
	event.ObjsNextMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	helper_949157d8(2400040)
	if vm.skipping() then
		return skip(38)
	end
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(39)
	end
	event.ObjsSetMotion(1, "上向く会話", 2)
	event.ObjsNextMotion(1, "上向くL")
	helper_949157d8(2400045)
	if vm.skipping() then
		return skip(40)
	end
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(41)
	end
	event.ObjsSetMotion(2, "会話")
	helper_ce27a7cc(2400050, -1)
	if vm.skipping() then
		return skip(42)
	end
	event.ObjsSetMotion(2, "目ほそめ", 2)
	event.ObjsNextMotion(2, "目ほそめL", 4)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(43)
	end
	event.ObjsSetMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目とじ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_ce27a7cc(2400055, -1)
	if vm.skipping() then
		return skip(44)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(0, 38)
	event.CmrsSetPos(-292.54, 67.5, -392.04)
	event.CmrsSetRef(-319.35, 18.11, -332.98)
	event.ObjsSetMotion(1, "上向きから頭抱え", 2)
	event.ObjsNextMotion(1, "頭かかえＬ", 4)
	event.ObjsSetMotion(0, "左向く", 2)
	event.ObjsNextMotion(0, "左向くL")
	helper_949157d8(2400060)
	if vm.skipping() then
		return skip(45)
	end
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(46)
	end
	event.ObjsSetMotion(0, "左向く戻り", 2)
	event.ObjsNextMotion(0, "上向く", 2)
	event.ObjsNextMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL")
	event.SetPakuAnim(0, "通常口パク")
	helper_949157d8(2400070)
	if vm.skipping() then
		return skip(47)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(48)
	end
	event.CmrsSetPos(-348.01, 19.24, -271.83)
	event.CmrsSetRef(-309.88, 30.88, -357.76)
	event.ObjsSetMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向くL", 4)
	event.ObjsSetMotion(2, "ユリスを見る", 6)
	event.ObjsNextMotion(2, "ユリスを見るL", 4)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(49)
	end
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_ce27a7cc(2400080, -1)
	if vm.skipping() then
		return skip(50)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ぶちゅー", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	event.ObjsMotionWait(2)
	helper_ce27a7cc(2400085, -1)
	if vm.skipping() then
		return skip(51)
	end
	event.CharaActive(0, 38)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(52)
	end
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_ce27a7cc(2400090, -1)
	if vm.skipping() then
		return skip(53)
	end
	helper_ce27a7cc(2400095, -1)
	if vm.skipping() then
		return skip(54)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(55)
	end
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_ce27a7cc(2400100, -1)
	if vm.skipping() then
		return skip(56)
	end
	event.CharaActive(0, 38)
	helper_ce27a7cc(2400105, -1)
	if vm.skipping() then
		return skip(57)
	end
	helper_949157d8(2400110)
	if vm.skipping() then
		return skip(58)
	end
	helper_ce27a7cc(2400115, -1)
	if vm.skipping() then
		return skip(59)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "ウィンク", 2, -1, 1)
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL")
	helper_ccf7aeb2(60)
	if vm.skipping() then
		return skip(60)
	end
	event.CharaActive(0, 38)
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_949157d8(2400120)
	if vm.skipping() then
		return skip(61)
	end
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(62)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_949157d8(2400125)
	if vm.skipping() then
		return skip(63)
	end
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(64)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_949157d8(2400130)
	if vm.skipping() then
		return skip(65)
	end
	event.ObjsSetMotion(1, "上向きから驚き", 2)
	event.ObjsNextMotion(1, "驚きＬ")
	event.ObjsNextMotion(2, "モニカを見る", 2)
	event.ObjsNextMotion(2, "モニカを見るL")
	event.SndSePlay(var4, 11)
	helper_949157d8(2400140)
	if vm.skipping() then
		return skip(66)
	end
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(67)
	end
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(68)
	end
	event.CmrsSetPos(-756.17, 221.27, 17.93)
	event.CmrsSetRef(-308.68, 56.91, -420.42)
	event.SndSeStop(var4, 10)
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(69)
	end
	event.SetPakuAnim(1, "通常口パク")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_ce27a7cc(2400150, -1)
	if vm.skipping() then
		return skip(70)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(2, "ユリスを見るL")
	event.FadeOutBgm(60)
	helper_ccf7aeb2(60)
	if vm.skipping() then
		return skip(71)
	end
	event.SetFadeOut(30)
	helper_ccf7aeb2(35)
	if vm.skipping() then
		return skip(72)
	end
	return part2()
end

--- Helper function.
local function helper_158f0()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.CharaActive(0, global1)
		event.CharaActive(1, 37)
	end
	if active_chr_no == 1 then
		global0 = 32
		global1 = 0
		event.LoadChara(5, "chara/c01_base.gltf", "info", global0)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.LoadMotion(5, "event/e200/e220/e220_mints.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadEquip(5, 0, 4, "info", global0)
		event.LoadEquip(5, 0, 3, "info", global0)
		event.LoadEquip(5, 0, 2, "info", global0, 37)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e220/e220_noam.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, 34, "wine")
	event.LoadChara(5, "item/f_rod.gltf", "info", 35)
	event.CharaActive(0, 35)
	event.EohSyncChara(4, 35)
	event.ObjsInit(3, 35)
	event.ObjsSyncObj(3, 4)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(5, 36)
	event.ObjsInit(4, 36)
	event.ObjsSyncObj(4, 5)
	event.LoadMes(0, 5, "event/e200/e220/e220_1.txt")
end

--- Helper function.
local function helper_155ac()
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
	event.DeleteChara(34)
	event.DeleteChara(35)
	event.DeleteChara(36)
end

--- Helper function.
local function helper_16814()
	local var1: s32 = 0
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_158f0()
			helper_ccf7aeb2(15)
		end
		if at <= 2 then
			helper_949157d8(2200010)
		end
		if at <= 3 then
			helper_949157d8(2200020)
		end
		if at <= 4 then
			helper_2454e4e4(0)
		end
		if at <= 5 then
			helper_949157d8(2200030)
		end
		if at <= 6 then
			helper_949157d8(2200040)
		end
		if at <= 7 then
			helper_ccf7aeb2(15)
		end
		if at <= 8 then
			helper_ccf7aeb2(10)
		end
		if at <= 9 then
			helper_949157d8(2200050)
		end
		if at <= 10 then
			helper_949157d8(2200055)
		end
		if at <= 11 then
			helper_ccf7aeb2(16)
		end
		if at <= 13 then
			helper_949157d8(2200080)
		end
		if at <= 14 then
			helper_949157d8(2200085)
		end
		if at <= 15 then
			helper_949157d8(2200090)
		end
		if at <= 16 then
			helper_d35bdec4(302, 1)
		end
		if at <= 17 then
			helper_d35bdec4(313, 1)
		end
		if at <= 18 then
			helper_949157d8(2200095)
		end
		if at <= 19 then
			helper_72506d21(0, -1, 8, 0, 0)
		end
		if at <= 20 then
			helper_72506d21(0, -1, 8, 0, 0)
		end
		if at <= 21 then
			helper_ccf7aeb2(16)
		end
		if at <= 22 then
			helper_ccf7aeb2(5)
		end
		if at <= 23 then
			helper_949157d8(2200060)
		end
		if at <= 24 then
			helper_2454e4e4(2)
		end
		if at <= 25 then
			helper_ccf7aeb2(15)
		end
		if at <= 26 then
			helper_949157d8(2200070)
		end
		if at <= 27 then
			helper_2454e4e4(2)
		end
		if at <= 28 then
			helper_ccf7aeb2(45)
		end
		if at <= 29 then
			helper_155ac()
			helper_459f6eff()
		end
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var5 = event.SndLoadSound(2803) or var5
	var4 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var4
	event.SetFadeOut(30)
	helper_ccf7aeb2(45)
	if vm.skipping() then
		return skip(1)
	end
	helper_158f0()
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.CharaActive(0, 9)
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(2187.89, 60.39, 925.42)
	event.CmrsSetRef(2234.31, 29.74, 1032.94)
	event.ObjsSetPos(0, 2298.04, 0.0, 1110.65)
	event.ObjsSetRot(0, 0.0, -2.41, 0.0)
	event.ObjsSetPos(1, 2311.91, 0.0, 1092.4)
	event.ObjsSetRot(1, 0.0, -2.28, 0.0)
	event.ObjsSetPos(2, 2199.07, 29.83, 981.55)
	event.ObjsSetRot(2, 0.0, 2.68, 0.0)
	var2 = event.EohGetFrameStatus(2, "wine") or var2
	event.EohSetFrameShow(2, "wine", 0)
	event.EohSetSoundId(2, var5)
	event.SetFadeIn(30)
	flag = event.GetFlag(220) or flag
	if flag == 0 then
		event.SetFlag(220, 1)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "釣り", 4)
		helper_ccf7aeb2(15)
		if vm.skipping() then
			return skip(2)
		end
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 195)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_949157d8(2200010)
		if vm.skipping() then
			return skip(3)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
		event.ObjsSetMotion(0, "会話", 2)
		event.ObjsNextMotion(0, "立ち", 0)
		event.SetPakuAnim(0, "通常口パク")
		helper_949157d8(2200020)
		if vm.skipping() then
			return skip(4)
		end
		event.ResetPakuAnim()
		helper_2454e4e4(0)
		if vm.skipping() then
			return skip(5)
		end
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 270)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_949157d8(2200030)
		if vm.skipping() then
			return skip(6)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
		event.ObjsSetMotion(2, "釣り会話", 0)
		event.ObjsMotionDelay(2, 180)
		event.ObjsSetMotion(2, "釣り", 0)
		helper_949157d8(2200040)
		if vm.skipping() then
			return skip(7)
		end
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
		event.ObjsSetMotion(2, "釣り", 0)
	else
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "釣り", 4)
	end
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsMotionDelay(2, 30)
	event.ObjsSetMotion(2, "右向く", 6)
	event.ObjsNextMotion(2, "右向くL", 0)
	helper_ccf7aeb2(10)
	if vm.skipping() then
		return skip(9)
	end
	helper_949157d8(2200050)
	if vm.skipping() then
		return skip(10)
	end
	helper_949157d8(2200055)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(0, "右向く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "左向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_ccf7aeb2(16)
	if vm.skipping() then
		return skip(12)
	end
	event.GotoUseItem(370)
	do
		local skipped = vm.wait()
		var1 = event.DeferredOutput() or var1
		if skipped then
			return skip(13)
		end
	end
	if var1 == 370 then
		event.SetFlag(28, 1)
		event.EohSetFrameStatus(2, "wine", var2)
		event.EohSetFrameShow(2, "wine", 1)
		event.CmrsSetPos(2256.03, 46.87, 1157.6)
		event.CmrsSetRef(2209.88, 21.76, 1049.74)
		event.ObjsSetPos(0, 2212.29, 0.0, 1088.81)
		event.ObjsSetRot(0, 0.0, 3.03, 0.0)
		event.ObjsSetPos(1, 2241.69, 0.0, 1085.4)
		event.ObjsSetRot(1, 0.0, -2.64, 0.0)
		event.ObjsSetPos(2, 2211.11, -1.43, 1044.24)
		event.ObjsSetRot(2, 0.0, 0.16, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "とびおり", 6)
		event.SetPakuAnim(0, "通常口パク")
		helper_949157d8(2200080)
		if vm.skipping() then
			return skip(14)
		end
		event.ResetPakuAnim()
		event.SetPakuAnim(0, "通常口パク")
		helper_949157d8(2200085)
		if vm.skipping() then
			return skip(15)
		end
		event.ResetPakuAnim()
		event.SndSePlay(var5, 5)
		event.ObjsSetMotion(2, "竿やる", 2)
		event.ObjsNextMotion(2, "竿やるL", 0)
		helper_949157d8(2200090)
		if vm.skipping() then
			return skip(16)
		end
		event.EohSetFrameShow(2, "rod", 0)
		event.EohSetFrameShow(2, "obj3", 0)
		event.EohSetFrameShow(2, "obj4", 0)
		event.CharaActive(0, global1)
		event.CharaActive(0, 34)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.CmrsSetPos(2216.13, 50.5, 1037.69)
		event.CmrsSetRef(2211.23, 28.7, 1078.48)
		event.ObjsSetPos(4, 2209.46, 34.32, 1071.72)
		event.ObjsSetRot(4, 0.0, 0.0, 0.0)
		event.SndSePlay(var5, 6)
		event.SndSePlay(var4, 0)
		event.SetReference(global0, "gun_hand", 35)
		event.ObjsSetMotion(0, "釣り竿ゲット", 4, -1.0, 1)
		event.ObjsSetMotion(4, "発動", 6)
		helper_d35bdec4(302, 1)
		if vm.skipping() then
			return skip(17)
		end
		helper_d35bdec4(313, 1)
		if vm.skipping() then
			return skip(18)
		end
		event.CharaActive(1, global1)
		event.CharaActive(1, 34)
		event.CharaActive(0, 35)
		event.CharaActive(0, 36)
		event.CmrsSetPos(2256.03, 46.87, 1157.6)
		event.CmrsSetRef(2209.88, 21.76, 1049.74)
		event.EohSetFrameShow(2, "chn64", 0)
		event.ObjsSetPos(0, 2212.29, 0.0, 1088.81)
		event.ObjsSetRot(0, 0.0, 3.03, 0.0)
		event.ObjsSetPos(1, 2241.69, 0.0, 1085.4)
		event.ObjsSetRot(1, 0.0, -2.64, 0.0)
		event.ObjsSetMotion(0, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
		event.ObjsSetMotion(2, "立ち", 4)
		event.ObjsSetMotion(2, "会話", 6)
		event.ObjsNextMotion(2, "立ち", 0)
		helper_949157d8(2200095)
		if vm.skipping() then
			return skip(19)
		end
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(
			0,
			"[(!)]Nimm zum Angeln zuerst die Angel.\n   Bringe im Ggst.-Men[UNI00fc] K[UNI00f6]der (Mimi)\n   an, sonst kannst du nicht angeln."
		)
		helper_72506d21(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(20)
		end
		event.MesMake_2(
			0,
			"[(!)]Wenn du damit fertig bist,\n   stelle dich ans Wasser und\n   dr[UNI00fc]cke (O), um zu angeln."
		)
		helper_72506d21(0, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(21)
		end
		event.SetMesWindowMode(0, 7)
	else
		event.ObjsSetMotion(0, "右向く戻り", 6, -1.0, 1)
		event.ObjsNextMotion(0, "立ち", 4)
		event.ObjsSetMotion(1, "左向く戻り", 6, -1.0, 1)
		event.ObjsNextMotion(1, "立ち", 4)
		helper_ccf7aeb2(16)
		if vm.skipping() then
			return skip(22)
		end
		if var1 <= 0 then
			event.ObjsSetMotion(2, "そっぽ向く", 2)
			event.ObjsNextMotion(2, "そっぽ向くL", 0)
			helper_ccf7aeb2(5)
			if vm.skipping() then
				return skip(23)
			end
			helper_949157d8(2200060)
			if vm.skipping() then
				return skip(24)
			end
			helper_2454e4e4(2)
			if vm.skipping() then
				return skip(25)
			end
			event.CmrsSetPos(2342.69, 17.58, 1135.11)
			event.CmrsSetRef(2285.51, 29.74, 1075.97)
		else
			event.ObjsSetMotion(2, "首を振る", 6)
			event.ObjsNextMotion(2, "釣り", 0)
			helper_ccf7aeb2(15)
			if vm.skipping() then
				return skip(26)
			end
			helper_949157d8(2200070)
			if vm.skipping() then
				return skip(27)
			end
			helper_2454e4e4(2)
			if vm.skipping() then
				return skip(28)
			end
			event.CmrsSetPos(2342.69, 17.58, 1135.11)
			event.CmrsSetRef(2285.51, 29.74, 1075.97)
		end
	end
	event.SetFadeOut(30)
	helper_ccf7aeb2(45)
	if vm.skipping() then
		return skip(29)
	end
	helper_155ac()
	event.CharaActive(1, 9)
	flag_2 = event.GetFlag(28) or flag_2
	if flag_2 ~= 0 then
		event.AddItem(302, 1)
		event.AddItem(313, 1)
		helper_459f6eff()
		if vm.skipping() then
			return skip(30)
		end
		event.SubItem(370, 1)
		event.EohSyncChara(0, 9)
		event.EohSetFrameStatus(0, "wine", 1)
	end
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f3d4()
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		global0 = 0
		global1 = 32
		global0 = 32
		global1 = 0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 7)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		global0 = 0
		global1 = 32
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", global0)
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.LoadChara(5, "chara/c02_base.gltf", "info", global1)
		event.LoadEquip(5, 1, 4, "info", global1)
		event.LoadEquip(5, 1, 3, "info", global1)
		event.LoadEquip(5, 1, 2, "info", global1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
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
		event.EohSyncChara(0, global0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.CharaActive(0, global0)
		event.CharaActive(1, 37)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", global1)
		event.EohSyncChara(1, global1)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.CharaActive(0, global1)
	end
	event.LoadChara(5, "event/e200/e245/e245_madan.gltf", "info", 34)
	event.CharaActive(0, 34)
	event.EohSyncChara(4, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	event.LoadChara(5, "event/e200/e245/e245_ma_kaeru.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(6, 39)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 6)
	event.SetCharaType(39, 4)
	event.LoadChara(5, "event/e200/e245/e245_ma_hamon.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/e200/e245/e245_magicwink.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.LoadChara(5, "event/e200/e245/e245_pink.gltf", "info", 41)
	event.CharaActive(0, 41)
	event.LoadMes(0, 5, "event/e200/e245/e245_1.txt")
end

--- Helper function.
local function helper_1f048()
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
	event.DeleteChara(34)
	event.DeleteChara(38)
	event.DeleteChara(41)
	event.DeleteChara(39)
	event.DeleteChara(40)
end

--- Helper function.
local function helper_202c0()
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 26 then
			if at <= 1 then
				helper_ccf7aeb2(4)
			end
			if at <= 2 then
				helper_ccf7aeb2(45)
			end
			if at <= 3 then
				helper_1f3d4()
				helper_ccf7aeb2(15)
			end
			if at <= 4 then
				helper_ce27a7cc(2450010, -1)
			end
			if at <= 5 then
				helper_ce27a7cc(2450015, -1)
			end
			if at <= 6 then
				helper_2454e4e4(2)
			end
			if at <= 7 then
				helper_ce27a7cc(2450020, -1)
			end
			if at <= 8 then
				helper_949157d8(2450030)
			end
			if at <= 9 then
				helper_2454e4e4(0)
			end
			if at <= 10 then
				helper_ce27a7cc(2450040, -1)
			end
			if at <= 11 then
				helper_ccf7aeb2(30)
			end
			if at <= 12 then
				helper_ccf7aeb2(150)
			end
			if at <= 13 then
				helper_ccf7aeb2(40)
			end
			if at <= 14 then
				helper_949157d8(2450050)
			end
			if at <= 15 then
				helper_2454e4e4(0)
			end
			if at <= 16 then
				helper_2454e4e4(2)
			end
			if at <= 17 then
				helper_ce27a7cc(2450060, -1)
			end
			if at <= 18 then
				helper_ce27a7cc(2450070, -1)
			end
			if at <= 19 then
				helper_2454e4e4(2)
			end
			if at <= 20 then
				helper_949157d8(2450080)
			end
			if at <= 21 then
				helper_2454e4e4(0)
			end
			if at <= 22 then
				helper_949157d8(2450090)
			end
			if at <= 23 then
				helper_949157d8(2450100)
			end
			if at <= 24 then
				helper_2454e4e4(1)
			end
			if at <= 25 then
				helper_ccf7aeb2(30)
			end
			if vm.skip_end() then
				return skip(27)
			end
			return part2()
		end
		if at <= 27 then
			helper_ccf7aeb2(35)
		end
		helper_1f048()
	end
	function part2()
		event.CancelDramaScene()
		event.SetFadeOut(30)
		helper_ccf7aeb2(35)
		if vm.skipping() then
			return skip(28)
		end
		event.StopBgm(0)
		event.SndSeStop(var4, 4)
		helper_1f048()
		event.ResetCamera(0)
		event.SetFadeIn(30)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(245, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.StopBgm(0)
	helper_ccf7aeb2(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(193)
	event.PlayBgm(0)
	var4 = event.SndLoadSound(2815) or var4
	event.SetFadeOut(30)
	helper_ccf7aeb2(45)
	if vm.skipping() then
		return skip(3)
	end
	helper_1f3d4()
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.CharaActive(1, global0)
	event.CharaActive(1, global1)
	event.CharaActive(1, 34)
	event.CmrsSetPos(-390.3, 27.35, -176.88)
	event.CmrsSetRef(-290.9, 59.06, -387.86)
	event.SetCharaPos(0, -297.56, 0.0, -373.68)
	event.SetCharaRot(0, 0.0, 2.57, 0.0)
	event.CharaActive(1, 40)
	event.SetCharaPos(40, -127.39, -18.0, -701.37)
	event.SetCharaRot(40, 0.0, -1.68, 0.0)
	event.ObjsSetPos(0, -289.3, 0.0, -369.79)
	event.ObjsSetRot(0, 0.0, 2.93, 0.0)
	event.ObjsSetPos(1, -320.6, 0.0, -374.1)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.ObjsSetPos(2, -127.39, 0.0, -701.37)
	event.ObjsSetRot(2, 0.0, -1.68, 0.0)
	event.SetFadeIn(30)
	event.SndSePlay(var4, 4)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(1, "上向くL", 2, -1.0, 1)
	event.ObjsSetMotion(2, "笑う", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(4)
	end
	helper_ce27a7cc(2450010, -1)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	event.ObjsSetMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 2)
	event.ObjsNextMotion(2, "会話速", 2)
	event.ObjsNextMotion(2, "目ほそめ会話", 4)
	helper_ce27a7cc(2450015, -1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 4)
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(2, "笑う", 4)
	helper_ce27a7cc(2450020, -1)
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリスを見るL", 4)
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_949157d8(2450030)
	if vm.skipping() then
		return skip(9)
	end
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリス見会話")
	helper_ce27a7cc(2450040, -1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(2, "ウィンク", 2)
	event.ObjsNextMotion(2, "待機")
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(12)
	end
	event.CharaActive(1, 38)
	event.SetCharaPos(38, -127.39, 0.0, -701.37)
	event.SetCharaRot(38, 0.0, -1.68, 0.0)
	event.SetMotion(38, "魔法解く", 2, -1, 1)
	event.CharaActive(1, 41)
	event.SetCharaPos(41, -127.39, 0.0, -701.37)
	event.SetCharaRot(41, 0.0, -1.68, 0.0)
	event.SetMotion(41, "桃色世界", 2, -1, 1)
	event.SndSePlay(var4, 5)
	helper_ccf7aeb2(150)
	if vm.skipping() then
		return skip(13)
	end
	event.SetCharaShow(41, 0, 1, 0.025)
	helper_ccf7aeb2(40)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "上向く会話", 2)
	event.ObjsNextMotion(0, "上向くL", 4)
	helper_949157d8(2450050)
	if vm.skipping() then
		return skip(15)
	end
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "上向くL")
	event.ObjsSetMotion(2, "ユリスを見る", 2)
	event.ObjsNextMotion(2, "ユリス見会話")
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(17)
	end
	helper_ce27a7cc(2450060, -1)
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetPos(4, -127.39, 0.0, -701.37)
	event.ObjsSetRot(4, 0.0, -1.68, 0.0)
	event.SetScale(39, 2.0, 2.0, 2.0)
	event.ObjsMotionDelay(2, 70)
	event.ObjsSetMotion(2, "帰る", 2)
	event.CharaActive(1, 39)
	event.ObjsSetMotion(4, "帰る", 5)
	event.ObjsMotionDelay(4, 70)
	event.ObjsSetMotion(4, "帰る", 6)
	event.ObjsSeDelay(2, 70)
	event.ObjsSePlay(2, var4, 6)
	helper_ce27a7cc(2450070, -1)
	if vm.skipping() then
		return skip(19)
	end
	helper_2454e4e4(2)
	if vm.skipping() then
		return skip(20)
	end
	event.CharaActive(0, 39)
	event.CharaActive(0, 40)
	event.ObjsSetMotion(1, "立ち", 4, -1.0, 1)
	event.ObjsSetPos(1, -324.44, 0.0, -385.55)
	event.ObjsSetRot(1, 0.0, 2.57, 0.0)
	event.CmrsSetPos(-247.47, 25.33, -442.62)
	event.CmrsSetRef(-302.69, 22.64, -384.86)
	event.ObjsSetMotion(0, "左向く", 2)
	event.ObjsNextMotion(0, "左向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2450080)
	if vm.skipping() then
		return skip(21)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuAnim(0, "通常口パク")
	helper_949157d8(2450090)
	if vm.skipping() then
		return skip(23)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(1, "右向く", 6)
	event.ObjsNextMotion(1, "右向くL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_949157d8(2450100)
	if vm.skipping() then
		return skip(24)
	end
	event.ResetPakuAnim()
	helper_2454e4e4(1)
	if vm.skipping() then
		return skip(25)
	end
	event.FadeOutBgm(60)
	helper_ccf7aeb2(30)
	if vm.skipping() then
		return skip(26)
	end
	return part2()
end

--- Program 506.
local function program_506()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ccf7aeb2(15)
		end
		if at <= 2 then
			helper_202c0()
			if not vm.skipping() then
				return part2()
			end
		end
		helper_8d283e19()
	end
	function part2()
		event.SetCnt(3, 6)
		helper_8d283e19()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_ccf7aeb2(15)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(14)
	event.FuncPointShow("p01_s0501", "invent_2008-0", 0)
	event.FuncPointShow("p01_s0501", "kaiwa02-0", 0)
	event.EohSyncObj(0, "p08_s0501")
	event.EohSetShow(0, 0)
	helper_202c0()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Helper function.
local function helper_26f10()
	local active_chr_no: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			helper_2454e4e4(0)
		end
	end
	if vm.skipping() then
		return skip(1)
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
			return skip(2)
		end
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
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	helper_2454e4e4(0)
	if vm.skipping() then
		return skip(4)
	end
	if active_chr_no == 0 or active_chr_no == 1 then
		event.DelExtMotion(0)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local var0: s32 = 0
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local mc_load: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			program_501()
			if not vm.skipping() then
				return landing1()
			end
		end
	end
	function part2() end
	function landing1()
		event.SetFadeIn(15)
		return part2()
	end
	event.StopBgm(0)
	event.Initialize()
	var0 = event.GetFloorInfo(1, 6, 7) or var0
	event.SetFloorInfo(1, 6, 7, vm.i32(var0 + 1))
	print("s05StartEvent kita------------------------------------------\n")
	program_99()
	helper_274b8()
	helper_8d283e19()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 2808.3, 0.0, 1609.9)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 0.0, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		event.GetMapType(old_map_no)
		flag = event.GetFlag(215) or flag
		if flag ~= 0 then
			helper_25c3c(vm.f32(3205.97), 0.0, vm.f32(1599.83), 0.0)
			if vm.skipping() then
				return skip(1)
			end
		end
		event.SetFadeIn(15)
		flag = event.GetFlag(209) or flag
		if flag == 1 then
			flag = event.GetFlag(215) or flag
			if flag == 0 then
				program_501()
				if vm.skipping() then
					return skip(2)
				end
				event.SetFadeIn(15)
			end
		end
	end
	return part2()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1a8dc()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 504)
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3539f0a5(64)
		end
	end
	event.SetCnt(3, 0)
	event.SetFlag(215, 0)
	event.SetFlag(220, 0)
	event.SetFlag(230, 0)
	event.SetFlag(235, 0)
	event.SubItem(302, 1)
	helper_8d283e19()
	if vm.wait() then
		return skip(1)
	end
	helper_3539f0a5(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_ce64820a()
	if vm.skipping() then
		return skip(1)
	end
end

script[501] = program_501

--- Program 502.
script[502] = function()
	local flag: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_8d283e19()
		helper_8d283e19()
		helper_8d283e19()
	end
	event.SetMotion(0, "立ち")
	helper_16814()
	if vm.skipping() then
		return skip(1)
	end
	argc = event.GetItemNum(302) or argc
	flag = event.GetFlag(230) or flag
	if argc ~= 0 and flag == 1 then
		event.SetCnt(3, 3)
		helper_8d283e19()
	end
	if argc > 0 and flag == 0 then
		event.SetCnt(3, 2)
		helper_8d283e19()
	end
	helper_8d283e19()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 501)
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 502)
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_274b8()
		helper_8d283e19()
	end
	helper_1a8dc()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(3, 5)
	helper_274b8()
	helper_8d283e19()
end

script[506] = program_506

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 503)
end

--- Program 508.
script[508] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 504)
end

--- Program 550.
script[550] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 2
		end
		if at <= 2 then
			program_506()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_26f10()
		end
	end
	function part2() end
	function landing1()
		return part2()
	end
	event.Initialize()
	print("use item--------------\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Geben wir dem Heiligen den\nPriscleen-Fisch.\n(Ggst. benutzen mit (#).)")
		var1 = helper_2073777c(0, -1, 5, 256, 208, var1)
		if vm.skipping() then
			return skip(1)
		end
		event.SetMesShippo(0, 1)
		if var1 == 1 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.GotoUseItem(310)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(2)
			end
		end
		if var2 == 310 then
			program_506()
			if vm.skipping() then
				return skip(3)
			end
		elseif var2 <= 0 then
		else
			helper_26f10()
			if vm.skipping() then
				return skip(4)
			end
		end
	end
	return part2()
end

--- Program 551.
script[551] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 1
			var2 = 4
			var1 = 6
		end
	end
	event.Initialize()
	local t0 = helper_4a47348c() == 1
	if vm.skipping() then
		return skip(1)
	end
	if t0 then
		event.SetBitCtrl(16, 0)
		var0 = 1
		var2 = 4
		var1 = 6
		event.DngSetFloorId(var2)
		event.SetFloorInfo(var0, var1, 5, 2)
		event.SetFloorInfo(var0, var2, 5, 1)
		event.FuncPointShow("", "next_floor", 0)
		event.GotoDng(1, var2, 1000)
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 552.
script[552] = function()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_72506d21(0, -1, 3, 170, 208)
		end
		if at <= 3 then
			program_506()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 4 then
			helper_26f10()
		end
	end
	function part2() end
	function landing1()
		return part2()
	end
	print("e552--------------\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetCameraPos(-203.52, 16.84, -181.02)
		event.SetCameraRef(-184.65, 30.0, -343.81)
		player_chara = event.GetControlChrid() or player_chara
		var3 = 14
		event.SetMesShippo(0, 1)
		event.SetMesPreset(0, 0)
		do
			local out1, _, out3 = event.GetCharaPos(player_chara)
			var4 = out1 or var4
			var6 = out3 or var6
		end
		do
			local out1, _, out3 = event.GetCharaPos(var3)
			var7 = out1 or var7
			var9 = out3 or var9
		end
		var10 = event.GetRotLookPos(var7 - var4, var9 - var6) or var10
		helper_07bc3618(player_chara, var10)
		if vm.skipping() then
			return skip(1)
		end
		event.SetCharaRot(player_chara, 0.0, var10, 0.0)
		event.SetMotion(player_chara, "立ち")
		event.SetMotion(14, "会話")
		event.MesMake_2(
			0,
			"Hast du einen\nPriscleen bekommen?<page>Wenn meine Sch[UNI00f6]nheit\nleidet, ist das eine Katastrophe.<page>Sei ein Schatz und\nbesorg mir einen, abgemacht?\n(Ggst. benutzen mit (#).)"
		)
		helper_72506d21(0, -1, 3, 170, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(14, "立ち")
	end
	if var0 == 2 then
		event.GotoUseItem(310)
		do
			local skipped = vm.wait()
			var11 = event.DeferredOutput() or var11
			if skipped then
				return skip(3)
			end
		end
		if var11 == 310 then
			program_506()
			if vm.skipping() then
				return skip(4)
			end
		elseif 0 < var11 then
			helper_26f10()
			if vm.skipping() then
				return skip(5)
			end
		end
	end
	return part2()
end

--- Program 553.
script[553] = function()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b4af9ac1(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_b4af9ac1(0, -1, var1, player_chara, 0)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = 8
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_07bc3618(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(240) or flag
	if flag == 0 then
		event.MesMake_2(
			0,
			'Der gro[UNI00df]e "Heilige" aus\nden S[UNI00fc]mpfen ist ein\ng[UNI00f6]ttlich geweihter Fisch.'
		)
		helper_b4af9ac1(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			'Falls du den "Heiligen" triffst,\nziehe ihn nicht aus dem\nWasser. Das w[UNI00e4]re schlecht.'
		)
	else
		flag_2 = event.GetFlag(253) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(0, "Tja, offenbar warst du\nja beim Heiligen.\nDu warst hoffentlich h[UNI00f6]flich?")
		else
			event.MesMake_2(
				0,
				"Als ich klein war, konnte ich\nSteine wie diese weiter werfen,\nals man sah. Altern ist schlimm ..."
			)
		end
	end
	helper_b4af9ac1(0, -1, var1, player_chara, 0)
	if vm.skipping() then
		return skip(3)
	end
end

--- Program 560.
script[560] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_af0c88eb(1)
		end
		helper_8d283e19()
	end
	argc = event.GetItemNum(291) or argc
	if argc <= 0 then
		event.SetMotion(0, "立ち")
		helper_d35bdec4(291, 4)
		if vm.skipping() then
			return skip(1)
		end
		event.AddItem(291, 4)
		helper_af0c88eb(1)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMesWindowMode(0, 7)
	end
	helper_8d283e19()
end

--- Program 561.
script[561] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b4af9ac1(0, -1, var0, player_chara, 0)
		end
		if at <= 2 then
			helper_d35bdec4(313, 5)
		end
		if at <= 3 then
			helper_af0c88eb(1)
		end
	end
	event.SetMotion(0, "立ち", 4)
	var0 = 9
	helper_e0a9948d(var0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	argc = event.GetItemNum(313) or argc
	var2 = event.GetSavedataEtc(3, 302) or var2
	if argc <= 0 and var2 ~= 313 then
		event.MesMake_2(0, "Keine K[UNI00f6]der mehr?\nUm Himmels willen ...!\nNa ja, hier, bitte.")
	else
		event.MesMake_2(
			0,
			"Manchmal bei[UNI00df]en sie an,\nmanchmal eben nicht.\nAber keine Sorge um die K[UNI00f6]der."
		)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_b4af9ac1(0, -1, var0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	if argc <= 0 and var2 ~= 313 then
		event.SetMesWindowMode(0, 7)
		helper_d35bdec4(313, 5)
		if vm.skipping() then
			return skip(3)
		end
		event.AddItem(313, 5)
		helper_af0c88eb(1)
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_2690eb2a() == 1
	if vm.skipping() then
		return skip(1)
	end
	if t0 then
		event.DngSetStageId(1)
		event.DngSetFloorId(0)
		event.SetBitCtrl(16, 0)
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local var2: s32 = 0
	local player_chara: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local player_chara_2: s32 = 0
	local player_chara_3: s32 = 0
	local player_chara_4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b4af9ac1(0, -1, 10, player_chara, 0)
		end
		if at <= 2 then
			helper_b4af9ac1(0, -1, 10, player_chara_2, 0)
		end
		if at <= 3 then
			helper_b4af9ac1(0, -1, 11, player_chara_3, 0)
		end
		if at <= 4 then
			helper_b4af9ac1(0, -1, 12, player_chara_4, 0)
		end
	end
	var0 = event.GetMesWindowMode(0) or var0
	event.SetMesWindowMode(0, 1)
	var2 = event.GetEventData_2(13) or var2
	event.GetEventData_2(14)
	event.SetMotion(0, "立ち", 4)
	helper_e0a9948d(var2)
	if vm.skipping() then
		return skip(1)
	end
	if var2 == 8 then
		flag = event.GetFlag(240) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				'Der gro[UNI00df]e "Heilige" aus\nden S[UNI00fc]mpfen ist ein\ng[UNI00f6]ttlich geweihter Fisch.'
			)
			event.MesMake_2(
				0,
				'Falls du den "Heiligen" triffst,\nziehe ihn nicht aus dem\nWasser. Das w[UNI00e4]re schlecht.'
			)
		else
			flag_2 = event.GetFlag(253) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(0, "Tja, offenbar warst du\nja beim Heiligen.\nDu warst hoffentlich h[UNI00f6]flich?")
			else
				event.MesMake_2(
					0,
					"Als ich klein war, konnte ich\nSteine wie diese weiter werfen,\nals man sah. Altern ist schlimm ..."
				)
			end
		end
		player_chara = event.GetControlChrid() or player_chara
		helper_b4af9ac1(0, -1, 10, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var2 == 10 then
		event.MesMake_2(0, "Ich bin froh hier!\nGeh einfach weg, lass mich in Ruhe!")
		player_chara_2 = event.GetControlChrid() or player_chara_2
		helper_b4af9ac1(0, -1, 10, player_chara_2, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var2 == 11 then
		event.MesMake_2(
			0,
			"Ich geh nicht zur[UNI00fc]ck.\nIch bleib f[UNI00fc]r immer hier,\nund du kannst nichts daran [UNI00e4]ndern!"
		)
		player_chara_3 = event.GetControlChrid() or player_chara_3
		helper_b4af9ac1(0, -1, 11, player_chara_3, 0)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var2 == 12 then
		event.MesMake_2(
			0,
			"Dieser Ort ist wundervoll!\nWenn ich hier bin, bin\nich immer unglaublich gl[UNI00fc]cklich.<page>Wir gehen nie mehr\nweg von hier ..."
		)
		player_chara_4 = event.GetControlChrid() or player_chara_4
		helper_b4af9ac1(0, -1, 12, player_chara_4, 0)
		if vm.skipping() then
			return skip(5)
		end
	end
	event.SetMesWindowMode(0, var0)
end

--- Program 12150.
script[12150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(215, 0)
	event.SetCnt(3, 0)
	helper_20f256cb(1)
	helper_135a0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12200.
script[12200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(220, 0)
	event.SetFlag(28, 0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.SetMotion(0, "立ち")
	helper_16814()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12300.
script[12300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 501)
end

--- Program 12350.
script[12350] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 502)
end

--- Program 12400.
script[12400] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_8d283e19()
	end
	helper_1a8dc()
	if vm.skipping() then
		return skip(1)
	end
	event.SetCnt(3, 5)
	helper_8d283e19()
end

--- Program 12450.
script[12450] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_202c0()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12470.
script[12470] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 503)
end

--- Program 12530.
script[12530] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s05/s05b_1.stb", 504)
end

return script
