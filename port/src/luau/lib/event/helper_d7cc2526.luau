--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_fa57afea = require("@lib/event/helper_fa57afea")

--- Helper function.
local function helper_d7cc2526()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_a19c5ee3(2)
			end
			if at <= 2 then
				helper_a19c5ee3(0)
			end
			if at <= 3 then
				helper_fa57afea(3280020)
			end
			if at <= 4 then
				helper_a19c5ee3(0)
			end
			if at <= 5 then
				helper_fa57afea(3280030)
			end
			if at <= 6 then
				helper_a19c5ee3(1)
			end
			if at <= 7 then
				helper_fa57afea(3280040)
			end
			if at <= 8 then
				helper_a19c5ee3(2)
			end
			if at <= 9 then
				helper_fa57afea(3280050)
			end
			if at <= 10 then
				helper_a19c5ee3(1)
			end
			if at <= 11 then
				helper_fa57afea(3280055)
			end
			if at <= 12 then
				helper_a19c5ee3(0)
			end
			if at <= 13 then
				helper_fa57afea(3280060)
			end
			if at <= 14 then
				helper_a19c5ee3(0)
			end
			if at <= 15 then
				helper_a0e17f3c(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DelExtMotion(0)
		event.DeleteChara(32)
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.LoadMes(0, -1)
		event.SetAi(1, 24)
		event.CharaActive(1, 24)
		event.SetMotion(24, "立ち", 4)
		event.CharaActive(0)
		event.SetCharaPos(0, 12.0, 0.0, -85.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.1415927, 10.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(328, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetAi(0, 24)
	event.CharaActive(0, 24)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadSound(3214)
	var0 = event.SndLoadSound(3214) or var0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ChangeDir("event/e300/e328/")
	event.LoadMes(0, 5, "e328_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e328_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e328_moinca.chr", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	event.LoadChara(5, "event/e300/e330/e330_shirooza.gltf", "info", 34)
	event.CharaActive(34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 32)
		event.LoadEquip(5, 0, 4, "info", 32)
		event.LoadEquip(5, 0, 3, "info", 32)
		event.LoadEquip(5, 0, 2, "info", 32, 33)
		event.LoadMotion(5, "event/e300/e328/e328_mints.gltf", "info", 32)
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
		event.LoadMotion(5, "event/e300/e328/e328_monica.gltf", "info", 32)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 32)
		event.EohSyncChara(1, 32)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(32)
	event.CharaActive(33)
	event.EohSetPos(0, 10.0, 0.0, 100.0)
	event.EohSetRot(0, 0.0, 3.14, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(1, 28.0, 0.0, 100.0)
	event.EohSetRot(1, 0.0, 3.14, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(2, -16.0, 22.0, -139.0)
	event.EohSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetFrameShow(2, "skin2", 1)
	event.EohSetFrameShow(2, "skin2_2", 0)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(25.92, 36.8, 138.37)
	event.CmrsSetRef(19.04, 28.52, 93.05)
	event.SetFadeIn(30)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_fa57afea(3280010)
	if vm.skipping() then
		return skip(1)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(-96.42, 37.63, -127.02)
	event.CmrsSetRef(-24.38, 22.71, -119.34)
	event.ObjsSetPos(0, -28.0, 0.0, -60.0)
	event.ObjsMove(0, -28.0, 0.0, -94.0, 54)
	event.ObjsSetMotion(0, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(0, 54)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, -8.0, 0.0, -54.0)
	event.ObjsMove(1, -8.0, 0.0, -94.0, 60)
	event.ObjsSetMotion(1, "歩き", 4, -1.0, 1)
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(0, "会話", 2)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "わらい口パク")
	helper_fa57afea(3280020)
	if vm.skipping() then
		return skip(4)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3280030)
	if vm.skipping() then
		return skip(6)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(-19.25, 29.93, -55.81)
	event.CmrsSetRef(-17.02, 24.91, -120.47)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "会話", 2)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_fa57afea(3280040)
	if vm.skipping() then
		return skip(8)
	end
	helper_a19c5ee3(2)
	if vm.skipping() then
		return skip(9)
	end
	event.SndSePlay(var0, 1)
	event.ObjsSetMotion(1, "会話", 2)
	event.ObjsNextMotion(1, "立ち", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3280050)
	if vm.skipping() then
		return skip(10)
	end
	helper_a19c5ee3(1)
	if vm.skipping() then
		return skip(11)
	end
	event.ObjsSetMotion(1, "左向く", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "右向く", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.SetPakuAnim(1, "わらい口パク")
	helper_fa57afea(3280055)
	if vm.skipping() then
		return skip(12)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "右向くうなづき", 2)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSeDelay(0, 14)
	event.ObjsSePlay(0, var0, 2)
	event.SetPakuAnim(0, "わらい口パク")
	helper_fa57afea(3280060)
	if vm.skipping() then
		return skip(14)
	end
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_d7cc2526
