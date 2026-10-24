--!strict
-- map/s/s43/s43_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_366d50dc = require("@lib/event/helper_366d50dc")
local helper_49084d68 = require("@lib/event/helper_49084d68")
local helper_7330bf70 = require("@lib/event/helper_7330bf70")
local helper_a3a5400c = require("@lib/event/helper_a3a5400c")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_b055e396 = require("@lib/event/helper_b055e396")
local helper_f82092bc = require("@lib/event/helper_f82092bc")

--- Helper function.
local function helper_1b774()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 20 then
			if at <= 1 then
				helper_adea7ba0(30)
			end
			if at <= 2 then
				helper_adea7ba0(16)
			end
			if at <= 3 then
				helper_adea7ba0(20)
			end
			if at <= 4 then
				helper_adea7ba0(60)
			end
			if at <= 5 then
				helper_b055e396(0, -1, 8, 0, 0)
			end
			if at <= 6 then
				helper_adea7ba0(10)
			end
			if at <= 7 then
				helper_23bda4ba(0)
			end
			if at <= 8 then
				helper_adea7ba0(20)
			end
			if at <= 9 then
				helper_adea7ba0(40)
			end
			if at <= 11 then
				helper_366d50dc(40090, -1, 10)
			end
			if at <= 12 then
				helper_a3a5400c(40100)
			end
			if at <= 13 then
				helper_adea7ba0(12)
			end
			if at <= 14 then
				helper_adea7ba0(10)
			end
			if at <= 15 then
				helper_23bda4ba(0)
			end
			if at <= 16 then
				helper_23bda4ba(0)
			end
			if at <= 17 then
				helper_23bda4ba(0)
			end
			if at <= 18 then
				helper_adea7ba0(20)
			end
			if at <= 19 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(21)
			end
			return part2()
		end
		if at <= 21 then
			helper_adea7ba0(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.CharaDaEnable(0, 1)
		event.AddHpRate(1.0, 0)
		event.AddWhp(0, 999)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_adea7ba0(4)
		if vm.skipping() then
			return skip(22)
		end
		event.BgmLoadCancel()
		event.SoundLoadCancel()
	end
	event.Initialize()
	event.SetStatusbarShow(0, 0.033333335)
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	event.SetMotion(0, "バトル立ち")
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	event.SetMesWindowMode(0, 7)
	event.InitDramaScene()
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p4/op4ch2_1.txt")
	event.LoadSound(1218)
	var0 = event.SndLoadSound(1216) or var0
	var1 = event.SndLoadSound(8, "snd2/sp/sp_006.sound.json") or var1
	event.LoadMotion(5, "event/opening/p4/p4_mints4.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 10.0, -80.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(0, 0)
	event.ObjsSetMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 1)
	event.EohSyncChara(21, 2)
	event.EohSetShow(21, 0)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko1.gltf", "info", 9)
	event.CharaActive(9)
	event.SetCharaPos(9, 20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/p4_otoko2.gltf", "info", 10)
	event.CharaActive(10)
	event.SetCharaPos(10, -20.0, 0.0, -420.0)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.LoadMotion(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, -50.82, 150.0, -15.75)
	event.ObjsSetRot(3, 0.0, 2.2, 0.0)
	event.CopyChara(5, 11, 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 47.49, 150.0, -2.37)
	event.ObjsSetRot(4, 0.0, -2.64, 0.0)
	event.CopyChara(5, 11, 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var0)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, -28.7, 150.0, 70.26)
	event.ObjsSetRot(5, 0.0, 2.8, 0.0)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.EohSyncChara(6, 14)
	event.EohSetSoundId(6, var0)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, 1.79, 150.0, 28.91)
	event.ObjsSetRot(6, 0.0, 2.92, 0.0)
	event.LoadChara(5, "event/itemget_ev/itemget_ev.gltf", "info", 15)
	event.CharaActive(15)
	event.EohSyncChara(7, 15)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, 0.0, 42.0, -84.0)
	event.ObjsSetRot(7, 1.57, 0.0, 0.0)
	event.ObjsSetMotion(7, "発動", 5)
	event.CmrsSetPos(-2.8, 29.02, -36.61)
	event.CmrsSetRef(0.85, 26.87, -88.33)
	event.SetFadeIn(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(0, "かかげる", 6)
	event.ObjsNextMotion(0, "かかげるL", 4)
	event.ObjsSePlay(0, var0, 37)
	helper_adea7ba0(16)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsSetMotion(7, "発動", 6)
	event.CmrsMove2(-0.86, 81.13, -64.1, 0.85, 26.87, -88.33, 12, 2, 1.0)
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSePlay(0, var0, 38)
	helper_adea7ba0(60)
	if vm.skipping() then
		return skip(5)
	end
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 0)
	event.MesMake_2(0, "La clef anglaise est devenue\nune clef de combat.")
	helper_b055e396(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, 7)
	event.SetMesDrawspeed(0, 1)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetMotion(0, "気がつく", 6)
	event.ObjsNextMotion(0, "気がつくL", 4)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(14)
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -50.82, 8.8, -15.75, -0.1, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var0, 29)
	event.ObjsMotionDelay(4, 3)
	event.ObjsPosDelay(4, 3)
	event.ObjsSeDelay(4, 3)
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, 47.49, 8.8, -2.37, -0.1, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var0, 29)
	event.ObjsMotionDelay(5, 9)
	event.ObjsPosDelay(5, 9)
	event.ObjsSeDelay(5, 9)
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, -28.7, 8.8, 70.26, -0.1, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var0, 29)
	event.ObjsMotionDelay(6, 15)
	event.ObjsPosDelay(6, 15)
	event.ObjsSeDelay(6, 15)
	event.ObjsSetMotion(6, "落下中", 6, 0.15)
	event.ObjsNextMotion(6, "着地", 6)
	event.ObjsNextMotion(6, "立ち", 4)
	event.ObjsJump(6, 1.79, 8.8, 28.91, -0.1, 30)
	event.ObjsSeDelay(6, 30)
	event.ObjsSePlay(6, var0, 29)
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(9)
	end
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 0)
	event.CmrsSetPos(-12.49, 56.75, -150.16)
	event.CmrsSetRef(-0.59, 13.56, -3.76)
	event.ObjsSetRot(0, 0.0, -1.57, 0.0)
	event.ObjsSetMotion(0, "かまえ立ち", 4, -1.0, 1)
	helper_adea7ba0(40)
	if vm.skipping() then
		return skip(10)
	end
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.CharaActive(0, 14)
	event.CmrsSetPos(-27.38, 36.23, -86.69)
	event.CmrsSetRef(29.33, 26.13, -60.27)
	event.CharaDaEnable(0, 0)
	event.ObjsSetRot(0, 0.0, -3.14, 0.0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "かまえ立ち", 4, -1.0, 1)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	if vm.wait() then
		return skip(11)
	end
	event.SetPakuAnim(0, "通常口パク", "怒り口（３）")
	helper_366d50dc(40090, -1, 10)
	if vm.skipping() then
		return skip(12)
	end
	event.ResetPakuAnim()
	helper_a3a5400c(40100)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(0, "出口を見る", 6)
	event.ObjsNextMotion(0, "出口を見るL", 6)
	helper_adea7ba0(12)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(0, "→走り", 2)
	event.ObjsNextMotion(0, "走り", 4)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsMove(0, 0.0, 10.0, -120.0, 20)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(16)
	end
	event.CmrsSetPos(0.0, 41.13, -104.26)
	event.CmrsSetRef(0.0, 20.2, -217.19)
	event.ObjsSetPos(0, 0.0, 0.0, -200.0)
	event.ObjsMove(0, 0.0, 0.0, -350.0, 30)
	event.ObjsResetDaPosition(0)
	event.ObjsResetMotion(0)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(17)
	end
	event.CmrsSetPos(-60.96, 9.43, -525.19)
	event.CmrsSetRef(0.0, 28.11, -410.09)
	event.CmrsMove(-60.96, 9.43, -525.19, 0.0, 28.11, -451.39, 35)
	event.ObjsSetMotion(0, "客を飛び超える", 6)
	event.ObjsMove(0, 0.0, 0.0, -470.0, 35)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var0, 30)
	event.SetMotion(9, "振り向き", 2)
	event.SetMotion(10, "振り向き", 2)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-107.5, 71.31, -471.79)
	event.CmrsSetRef(21.82, 28.11, -671.17)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsSetPos(0, -40.33, 0.0, -525.86)
	event.ObjsSetRot(0, 0.0, 2.7, 0.0)
	event.ObjsMove(0, 29.23, 5.07, -691.14, 50)
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(19)
	end
	event.SetFadeOut(30)
	event.FadeOutBgm(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(20)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.Finish()
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	event.LoadScript("s43/s43b.stb", 100)
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7330bf70()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.LoadScript("s43/s43b.stb", 151)
	end
	event.SetTimeStepEnable(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	helper_49084d68()
	if vm.skipping() then
		return skip(1)
	end
	helper_7330bf70()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 152.
script[152] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.AssignStack(3)
	event.ClearStack(3)
	event.LoadMonsterFile(600, 1)
	event.AutoSetMonster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
	event.AutoSetMonster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
	event.AutoSetMonster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
	event.AutoSetMonster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
	var0 = event.SndLoadSound(4, "snd2/event/ev_200_000.sound.json") or var0
	event.SndSePlay(var0, 0)
	event.DngPause(16384, 1)
	event.SetCnt(5, 2)
	if vm.wait() then
		return skip(1)
	end
	event.SetStatusbarShow(1, 0.033333335)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_f82092bc()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1500.
script[1500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1b774()
	if vm.skipping() then
		return skip(1)
	end
	event.AddItem(1)
	event.SetCharaEquip(0, 1)
	event.SubItem(387)
	event.SetBitCtrl(1, 0)
	event.DngPause(256, 0)
	event.GotoEdit(17, 153)
end

--- Program 8000.
script[8000] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7330bf70()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2() end
	event.Initialize()
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_adea7ba0(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1213)
	event.LoadBgm(103)
	event.PlayBgm(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	helper_7330bf70()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 8001.
script[8001] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.StopBgm(0)
	event.StopEnvBgm()
	helper_adea7ba0(6)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadSound(1213)
	event.LoadBgm(103)
	event.PlayBgm(0)
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadScript("s43/s43b.stb", 151)
end

--- Program 8002.
script[8002] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.SetStatusbarShow(0, 1.0)
	event.SetBitCtrl(1, 1)
	event.DngPause(256, 1)
	event.EohSyncChara(2, 1)
	event.EohSetShow(2, 0)
	event.EohSyncChara(3, 2)
	event.EohSetShow(3, 0)
	event.LoadScript("s43/s43b.stb", 8000)
end

return script
