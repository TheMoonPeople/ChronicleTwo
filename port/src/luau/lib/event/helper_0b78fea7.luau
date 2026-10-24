--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b5edc9 = require("@lib/event/helper_09b5edc9")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_a19c5ee3 = require("@lib/event/helper_a19c5ee3")
local helper_b35e85eb = require("@lib/event/helper_b35e85eb")
local helper_f1cdfb4a = require("@lib/event/helper_f1cdfb4a")

--- Helper function.
local function helper_0b78fea7()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 12 then
			if at <= 1 then
				helper_b35e85eb()
			end
			if at <= 2 then
				helper_a0e17f3c(4)
			end
			if at <= 3 then
				helper_b35e85eb()
			end
			if at <= 4 then
				helper_f1cdfb4a(10210, -1, 10)
			end
			if at <= 5 then
				helper_f1cdfb4a(10220, -1, 10)
			end
			if at <= 6 then
				helper_a19c5ee3(0)
			end
			if at <= 7 then
				helper_f1cdfb4a(10230, -1, 10)
			end
			if at <= 8 then
				helper_a19c5ee3(0)
			end
			if at <= 9 then
				helper_a0e17f3c(30)
			end
			if at <= 10 then
				helper_09b5edc9(10236, 250)
			end
			if at <= 11 then
				helper_b35e85eb()
			end
			if vm.skip_end() then
				return skip(13)
			end
			return part2()
		end
		if at <= 13 then
			helper_a0e17f3c(6)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StreamClose(1)
		event.EohSetFootSoundId(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.LoadMes(0, -1)
		event.EohSetShow(7, 0)
		event.EohSetShow(8, 1)
		event.EohSetShow(9, 0)
		event.EohSetShow(10, 1)
		event.StopEnvBgm()
		event.StopBgm(0)
		helper_a0e17f3c(6)
		if vm.skipping() then
			return skip(14)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetMotion(0, "立ち")
	event.CmrsInit()
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(2)
	end
	event.StopBgm(0)
	helper_a0e17f3c(4)
	if vm.skipping() then
		return skip(3)
	end
	event.LoadBgm(101)
	event.PlayBgm(0, -1)
	event.LoadSound(1203)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p1/op1ch3_1.txt")
	var0 = event.SndLoadSound(1203) or var0
	event.LoadMotion(5, "event/opening/p1/p1_mints2.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 114.59, -0.02, -150.64)
	event.ObjsSetRot(0, 0.0, 1.57, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "真剣な目")
	event.ObjsTexAnime(0, 1, "真剣な口")
	event.LoadChara(5, "event/opening/p1/kougu.gltf", "info", 9)
	event.CharaActive(0, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 114.59, -0.02, -150.64)
	event.ObjsSetRot(1, 0.0, 1.57, 0.0)
	event.ObjsSetMotion(1, "工具をかまえる", 5)
	event.EohSyncObj(2, "p10_i01h01")
	event.EohSetShow(2, 0)
	event.EohSyncObj(3, "p11_i01h01")
	event.EohSetShow(3, 0)
	event.EohSyncObj(4, "p12_i01h01")
	event.EohSetShow(4, 0)
	event.EohSyncObj(5, "p16_i01h01")
	event.EohSetShow(5, 0)
	event.EohSyncObj(6, "p17_i01h01")
	event.EohSetShow(6, 1)
	event.EohSyncObj(7, "p09_i01h01", "i01h01_19-m0")
	event.EohSetShow(7, 1)
	event.EohSyncObj(8, "p09_i01h01", "i01h01_20-m0")
	event.EohSetShow(8, 0)
	event.EohSyncObj(9, "p09_i01h01", "i01h01_19-m1")
	event.EohSetShow(9, 0)
	event.EohSyncObj(10, "p09_i01h01", "i01h01_20-m1")
	event.EohSetShow(10, 1)
	event.SetActiveLight(4)
	event.ObjsSetMotion(0, "いすに座る_s", 4)
	event.ObjsSePlay(0, var0, 18)
	event.CmrsSetPos(154.48, 32.42, -164.94)
	event.CmrsSetRef(118.46, 17.85, -145.84)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_f1cdfb4a(10210, -1, 10)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	event.ObjsSetMotion(0, "かばんをさぐる", 6)
	event.ObjsNextMotion(0, "かばんをさぐるL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_f1cdfb4a(10220, -1, 10)
	if vm.skipping() then
		return skip(6)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "工具をかまえる", 6)
	event.ObjsNextMotion(0, "工具をかまえるL", 4)
	event.ObjsSePlay(0, var0, 19)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 19)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 20)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 21)
	event.CharaActive(9)
	event.ObjsSetMotion(1, "工具をかまえる", 6)
	event.ObjsNextMotion(1, "工具をかまえるL", 4)
	event.SetPakuAnim(0, "通常口パク", "真剣な口")
	helper_f1cdfb4a(10230, -1, 10)
	if vm.skipping() then
		return skip(8)
	end
	event.ResetPakuAnim()
	helper_a19c5ee3(0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsSetMotion(0, "作業中", 6)
	event.ObjsSetMotion(1, "作業中", 6)
	event.ObjsNextMotion(0, "作業中2", 6)
	event.ObjsNextMotion(1, "作業中2", 6)
	event.ObjsNextMotion(0, "作業中", 6)
	event.ObjsNextMotion(1, "作業中", 6)
	event.ObjsNextMotion(0, "作業中2", 6)
	event.ObjsNextMotion(1, "作業中2", 6)
	event.ObjsNextMotion(0, "作業中", 6)
	event.ObjsNextMotion(1, "作業中", 6)
	event.ObjsSePlay(0, var0, 22)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 25)
	event.ObjsSeDelay(0, 80)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 40)
	event.ObjsSePlay(0, var0, 22)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 24)
	event.ObjsSeDelay(0, 20)
	event.ObjsSePlay(0, var0, 23)
	event.ObjsSeDelay(0, 40)
	event.CmrsSetPos(63.4, 45.38, -118.3)
	event.CmrsSetRef(118.98, 17.85, -149.19)
	event.CmrsMove(34.75, 60.8, -102.39, 118.98, 17.85, -149.19, 400)
	event.CmrsFadeDelay(340)
	event.CmrsFadeInit()
	event.CmrsFadeOut(60)
	helper_a0e17f3c(30)
	if vm.skipping() then
		return skip(10)
	end
	helper_09b5edc9(10236, 250)
	if vm.skipping() then
		return skip(11)
	end
	event.FadeOutBgm(60)
	helper_b35e85eb()
	if vm.skipping() then
		return skip(12)
	end
	return part2()
end

return helper_0b78fea7
