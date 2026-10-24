--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_32dba483 = require("@lib/event/helper_32dba483")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_0ae06a38()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 16 then
			if at <= 1 then
				helper_2f481f12(110)
			end
			if at <= 2 then
				helper_2f481f12(10)
			end
			if at <= 3 then
				helper_e8f4b85c(1)
			end
			if at <= 4 then
				helper_93bb7fa4(4320010)
			end
			if at <= 5 then
				helper_93bb7fa4(4320015)
			end
			if at <= 6 then
				helper_b027b809()
			end
			if at <= 7 then
				helper_e8f4b85c(1)
			end
			if at <= 8 then
				helper_93bb7fa4(4320020)
			end
			if at <= 9 then
				helper_b027b809()
			end
			if at <= 10 then
				helper_93bb7fa4(4320030)
			end
			if at <= 11 then
				helper_e8f4b85c(0)
			end
			if at <= 12 then
				helper_93bb7fa4(4320040)
			end
			if at <= 13 then
				helper_e8f4b85c(1)
			end
			if at <= 14 then
				helper_93bb7fa4(4320045)
			end
			if at <= 15 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(17)
			end
			return part2()
		end
		helper_32dba483(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var2, 0)
		event.SndSeStop(var2, 1)
		event.PlayBgm(0)
		event.CharaActive(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.EohSetRot(2, 0.0, 0.0, 0.0)
		event.EohSetPos(3, 0.0, 0.0, 0.0)
		event.DelExtMotion(0)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.LoadMes(0, -1)
		helper_32dba483(vm.f32(1779.8), 0.0, 354.5, vm.f32(-0.96))
		event.SetCameraPos(1878.94, 40.0, 285.33)
		event.SetCameraRef(1779.8, 30.0, 354.5)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.SetFlag(432, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.StopBgm(0)
	helper_2f481f12(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(3)
	event.LoadSound(4814)
	var2 = event.SndLoadSound(8, "snd2/sp/sp_041.sound.json") or var2
	var1 = event.SndLoadSound(4814) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e432/")
	event.LoadMes(0, 5, "e432_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e432_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e432_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 16)
		event.LoadEquip(5, 0, 4, "info", 16)
		event.LoadEquip(5, 0, 3, "info", 16)
		event.LoadEquip(5, 0, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e432/e432_mints.gltf", "info", 16)
		event.EohSyncChara(0, 16)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 16)
		event.LoadEquip(5, 1, 4, "info", 16)
		event.LoadEquip(5, 1, 3, "info", 16)
		event.LoadEquip(5, 1, 2, "info", 16, 17)
		event.LoadMotion(5, "event/e400/e432/e432_monica.gltf", "info", 16)
		event.EohSyncChara(1, 16)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.CharaActive(16)
	event.CharaActive(17)
	event.EohSyncObj(2, "p02_d04b01")
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.EohSyncObj(3, "p03_d04b01")
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.EohSyncChara(4, 1)
	event.EohSyncChara(5, 2)
	event.EohSetShow(4, 0)
	event.EohSetShow(5, 0)
	event.EohSetPos(0, 2030.0, 0.0, -740.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, 2046.0, 0.0, -740.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.ObjsRotation2(2, 0.0, 0.0, 3.14, 40, 0, 0.5)
	event.ObjsRotDelay(2, 168)
	event.ObjsRotation2(2, 0.0, 0.0, 0.0, 40, 0, 0.5)
	event.ObjsSePlay(2, var2, 0)
	event.ObjsSeDelay(2, 170)
	event.ObjsSePlay(2, var2, 1)
	event.ObjsPosDelay(3, 80)
	event.ObjsMove2(3, 0.0, 80.0, 0.0, 32, 1, 0.5)
	event.ObjsPosDelay(3, 40)
	event.ObjsMove2(3, 0.0, 0.0, 0.0, 32, 2, 0.5)
	event.CmrsInit()
	event.CmrsSetPos(2198.81, 99.4, -537.94)
	event.CmrsSetRef(2056.98, 54.61, -679.8)
	event.InitDramaScene()
	event.SetFadeIn(30)
	helper_2f481f12(110)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(0, 2030.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	helper_2f481f12(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(1, 2046.0, 0.0, -680.0, 60)
	event.ObjsSetMotion(1, "歩き")
	event.ObjsMotionDelay(1, 60)
	event.ObjsSetMotion(1, "立ち")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(2061.53, 10.96, -648.18)
	event.CmrsSetRef(2030.82, 23.87, -686.56)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目～おどろき目")
	event.EohSetTexAnim(0, 1, "口とじ～口あけ")
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4320010)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(1924.65, 64.05, 196.6)
	event.CmrsSetRef(1932.83, 64.94, 223.63)
	event.CmrsMove2(1924.65, 64.05, 196.6, 1904.25, 64.94, 216.36, 90, 0, 0.4)
	event.PlayBgm(0)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4320015)
	if vm.skipping() then
		return skip(6)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(1800.0, 39.0, 176.0)
	event.CmrsSetRef(1800.0, 22.0, 260.0)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.ObjsSetPos(0, 1794.0, 0.0, 200.0)
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsMove(0, 1794.0, 0.0, 260.0, 20)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 20)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 1808.0, 0.0, 190.0)
	event.ObjsMove(1, 1808.0, 0.0, 260.0, 24)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 24)
	event.ObjsSetMotion(1, "立ち")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(8)
	end
	event.CmrsMoveAhd2(0.9, -10.0, 38.0, 40, 0, 1.0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4320020)
	if vm.skipping() then
		return skip(9)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(0, "キョロキョロ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4320030)
	if vm.skipping() then
		return skip(11)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(12)
	end
	event.SndSePlay(var1, 0)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "目あき～目とじ")
	event.ObjsSetMotion(1, "さぁ？", 6)
	event.ObjsNextMotion(1, "さぁ？L", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4320040)
	if vm.skipping() then
		return skip(13)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(14)
	end
	event.CmrsSetPos(1785.99, 22.09, 263.93)
	event.CmrsSetRef(1808.23, 23.58, 259.85)
	if active_chr_no == 0 then
		event.CharaActive(0, 0)
	else
		event.CharaActive(0, 16)
		event.CharaActive(0, 17)
	end
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "目とじ～目あき")
	event.ObjsSetMotion(1, "こぶし", 6)
	event.ObjsNextMotion(1, "こぶしL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 1)
	event.SetPakuAnim(1, "わらい口パク")
	helper_93bb7fa4(4320045)
	if vm.skipping() then
		return skip(15)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(16)
	end
	return part2()
end

return helper_0ae06a38
