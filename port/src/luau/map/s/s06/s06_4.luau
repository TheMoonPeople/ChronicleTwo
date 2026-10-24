--!strict
-- map/s/s06/s06_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d53ec5 = require("@lib/event/helper_06d53ec5")
local helper_0da018f4 = require("@lib/event/helper_0da018f4")
local helper_203fe835 = require("@lib/event/helper_203fe835")
local helper_237fc52c = require("@lib/event/helper_237fc52c")
local helper_25f278c2 = require("@lib/event/helper_25f278c2")
local helper_2799c4e0 = require("@lib/event/helper_2799c4e0")
local helper_30652181 = require("@lib/event/helper_30652181")
local helper_3a5b1e2b = require("@lib/event/helper_3a5b1e2b")
local helper_5ebfecdc = require("@lib/event/helper_5ebfecdc")
local helper_88625211 = require("@lib/event/helper_88625211")
local helper_adbbb722 = require("@lib/event/helper_adbbb722")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")
local helper_e445e2f6 = require("@lib/event/helper_e445e2f6")
local helper_f33fd19e = require("@lib/event/helper_f33fd19e")
local helper_fab3eef4 = require("@lib/event/helper_fab3eef4")

--- Helper function.
local function helper_20d88()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(15)
		end
		if at <= 2 then
			helper_f33fd19e(0)
		end
		if at <= 3 then
			helper_f33fd19e(10)
		end
		if at <= 4 then
			helper_b51fc149(40)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	var0 = event.SndLoadSound(8, "snd2/sp/sp_040.sound.json") or var0
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCameraPos(133.95, 349.85, 995.49)
	event.SetCameraRef(10.87, 287.26, 1174.06)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.CharaActive(1, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 3.0, 263.17, 1196.78)
	event.ObjsSetRot(0, 0.0, -3.08, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	event.EohSyncObj(10, "p08_s06", "s06_08-m1")
	event.EohSetShow(10, 1)
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 2.90684, 312.375, 1188.04)
	event.ObjsMove(10, 2.90684, 412.375, 1188.04, 30)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	helper_b51fc149(15)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "走り")
	event.ObjsMotionDelay(0, 30)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(0, 3.0, 263.17, 1131.27, 30)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f33fd19e(10)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSePlay(var0, 1)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 10)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 8)
	event.ObjsJump(10, 2.90684, 312.375, 1188.04, -0.2, 5)
	helper_b51fc149(40)
	if vm.skipping() then
		return skip(5)
	end
	event.SetStatusbarShow(1, 0.033333335)
	event.SetCharaPos(0, 3.0, 263.17, 1131.27)
	event.EohSetPos(10, 2.90684, 312.375, 1188.04)
	event.SetCameraRef(3.0, 293.17, 1131.27)
	event.SetCameraPos(3.0, 303.17, 1011.27)
	event.ResetCamera(0)
	event.Finish()
end

--- Program 310.
local function program_310()
	local flag: s32 = 0
	local var1: s32 = 0
	local member: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_b51fc149(30)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ActchrSetDefMotion(0)
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		event.Initialize()
		event.DngPause(1, 1)
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Ora non c'[UNI00e8] tempo!")
			helper_e445e2f6(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(2)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		else
			event.SetMotion(0, "立ち")
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(104) or flag
			if flag == 1 then
				event.MesMake_2(0, "Questa porta non si vuole aprire!\nTorniamo su per ora.")
			else
				event.MesMake_2(0, "Ora non c'[UNI00e8] tempo!")
			end
			helper_e445e2f6(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(4)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "Non [UNI00e8] possibile proseguire\nsenza scendere dal\nRobomobile.")
		helper_e445e2f6(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(5)
		end
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		helper_e445e2f6(0, 21, 8, 256, 208)
		if vm.skipping() then
			return skip(6)
		end
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var5 = helper_203fe835(1, -1)
	if vm.skipping() then
		return skip(7)
	end
	if var5 == 0 then
		event.SetBitCtrl(1, 0)
		stage_id = event.DngGetStageId() or stage_id
		var7 = event.DngGetFloorId() or var7
		argc = event.GetNextFloor(var7, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var7, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetFadeOut(30)
		helper_b51fc149(30)
		if vm.skipping() then
			return skip(8)
		end
		flag = event.GetFlag(8) or flag
		if flag == 0 then
			event.StopBgm(0)
			event.SetFlag(8, 1)
			event.BgmLoadCancel()
			event.GotoEdit(12, 540)
			if vm.wait() then
				return skip(9)
			end
			return
		end
		event.BgmLoadCancel()
		event.GotoDng(0, 5, 1000)
		if vm.wait() then
			return skip(10)
		end
	end
	event.Finish()
end

--- Helper function.
local function helper_21938(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.EohSyncObj(0, "p01_s06", "s06_02-a0")
	event.EohSyncObj(1, "p01_s06", "s06_03-a0")
	if arg0 ~= 0 then
		event.EohSetShow(0, 1)
		event.EohSetShow(1, 1)
	else
		event.EohSetShow(0, 0)
		event.EohSetShow(1, 0)
	end
end

--- Helper function.
local function helper_17d44(arg0: any)
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(30)
		end
		if at <= 2 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 3 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 4 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
		if at <= 5 then
			helper_e445e2f6(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-276.53, 81.94, 10.07)
	event.CmrsSetRef(31.75, 72.44, -9.51)
	event.ObjsSetPos(0, -165.91, 50.0, 2.54)
	event.ObjsSetRot(0, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetPos(1, -165.91, 50.0, 2.54)
	event.ObjsSetRot(1, 0.0, 1.65, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(2)
	end
	var1 = event.GetMesWindowMode() or var1
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(
		0,
		"[(!)]Puoi usare il Robomobile con il\n   relativo comando sotto Personaggio\n   nel Menu principale.<page>Per scendere, seleziona\nMax sotto Personaggio."
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.MesMake_2(0, "[(!)]Puoi chiedere a Cedric di fare\n   il pieno al Robomobile per te.")
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(
		0,
		"[(!)]Man mano che il Robomobile acquista\n   ESP, puoi farne potenziare\n   il Nucleo da Cedric.<page>Cos[UNI00ec], la Capacit[UNI00e0] del Nucleo crescer[UNI00e0] e\npotrai equipaggiare pi[UNI00f9] componenti."
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(
		0,
		"[(!)]Aumenta la Capacit[UNI00e0] del Nucleo e prova a\n   installare varie parti, per\n   personalizzare il Robomobile!"
	)
	helper_e445e2f6(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMesWindowMode(0, var1)
end

--- Helper function.
local function helper_18530()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_5ebfecdc(var0)
			end
			if at <= 2 then
				helper_adbbb722(var0)
			end
			if at <= 3 then
				helper_30652181(var0)
			end
			if at <= 4 then
				helper_25f278c2(var0)
			end
			if at <= 5 then
				helper_2799c4e0(var0)
			end
			if at <= 6 then
				helper_17d44(var0)
			end
			if at <= 7 then
				helper_b51fc149(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
		if at <= 9 then
			helper_b51fc149(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.SndSeStop(var0, 2)
		event.CharaActive(1, 0)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 0)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SetCameraPos(-276.53, 81.94, 10.07)
		event.SetCameraRef(31.75, 72.44, -9.51)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.SetCharaPos(0, -167.59, 50.0, 2.86)
		event.SetCharaRot(0, 0.0, 1.77, 0.0)
		event.SetStatusbarShow(1)
		event.StopBgm(0)
		helper_b51fc149(4)
		if vm.skipping() then
			return skip(10)
		end
		event.LoadBgm(15)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
		if vm.wait() then
			return skip(11)
		end
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1819) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108a_1.txt")
	event.StopBgm(0)
	event.InitDramaScene()
	helper_5ebfecdc(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "デフォルト顔")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "おこり顔")
	event.ObjsTexAnime(3, 1, "通常目パチ")
	helper_adbbb722(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_30652181(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_25f278c2(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_2799c4e0(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_17d44(var0)
	if vm.skipping() then
		return skip(7)
	end
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

--- Helper function.
local function helper_196e4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0da018f4()
		end
		if at <= 2 then
			helper_06d53ec5(1080040)
		end
		if at <= 3 then
			helper_06d53ec5(1080041)
		end
		if at <= 4 then
			helper_06d53ec5(1080042)
		end
		if at <= 5 then
			helper_f33fd19e(2)
		end
		if at <= 6 then
			helper_f33fd19e(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-129.32, 99.43, 13.13)
	event.CmrsSetRef(-44.6, 102.72, 11.17)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 9.11, 50.0, -10.14)
	event.ObjsSetRot(2, 0.0, -1.44, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.54, 105.26, 40.3)
	event.ObjsSetRot(3, 0.0, -1.8, 0.0)
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30, 0.0, 0.0, 0.0)
	helper_0da018f4()
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 1)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080040)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080041)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetPakuAnim()
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080042)
	if vm.skipping() then
		return skip(5)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(6)
	end
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(7)
	end
end

--- Helper function.
local function helper_19da8(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06d53ec5(1080050)
		end
		if at <= 2 then
			helper_06d53ec5(1080060)
		end
		if at <= 3 then
			helper_f33fd19e(3)
		end
		if at <= 4 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 1.21, 102.73, 26.08)
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.ObjsSetMotion(3, "逃げちゃうの？", 4)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔2")
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080050)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.CmrsSetPos(-17.46, 142.28, 29.34)
	event.CmrsSetRef(1.26, 135.02, 26.5)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.ObjsSetMotion(3, "オーッホッホ", 4)
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080060)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(4)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1a2a4(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(50)
		end
		if at <= 2 then
			helper_f33fd19e(0)
		end
		if at <= 3 then
			helper_f33fd19e(1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-408.29, 60.12, 94.13)
	event.CmrsSetRef(-475.86, 71.34, 81.15)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -492.64, 50.09, 76.79)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "プルプル", 4, -1.0, 1)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -492.64, 50.09, 76.79)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(1, "プルプル", 4)
	event.SndSePlay(arg0, 0)
	helper_b51fc149(50)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(0, "ジャンプ", 6, 0.4)
	event.ObjsSetMotion(1, "ジャンプ", 6, 0.4)
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsJump(1, -739.96, 133.89, -9.49, -0.28, 33)
	event.ObjsMotionWait(0)
	event.ObjsMotionWait(1)
	event.CmrsMove2(-408.29, 60.12, 94.13, -709.98, 167.81, 0.97, 25, 0, 0.4)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(3)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(4)
	end
	event.SndSeStop(arg0, 0)
end

--- Helper function.
local function helper_1aa14(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f33fd19e(0)
		end
		if at <= 2 then
			helper_f33fd19e(1)
		end
		if at <= 3 then
			helper_0da018f4()
		end
		if at <= 4 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-501.66, 281.73, -144.66)
	event.CmrsSetRef(-757.43, 150.05, -3.21)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -739.96, 133.89, -9.49)
	event.ObjsSetRot(0, 0.0, 1.2, 0.0)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -739.96, 133.89, -9.49)
	event.ObjsSetRot(1, 0.0, 1.2, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsRotation(0, 0.0, -1.44, 0.0, 20)
	event.ObjsRotation(1, 0.0, -1.44, 0.0, 20)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(100)
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -915.85, 133.64, -6.02, 150)
	event.ObjsMove(1, -915.85, 133.64, -6.02, 150)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(50, 0.0, 0.0, 0.0)
	helper_0da018f4()
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1b138(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1b1ac(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1b220()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_196e4(var0)
			end
			if at <= 2 then
				helper_19da8(var0)
			end
			if at <= 3 then
				helper_1a2a4(var0)
			end
			if at <= 4 then
				helper_1aa14(var0)
			end
			if at <= 5 then
				helper_1b138(var0)
				helper_1b1ac(var0)
				helper_b51fc149(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1822) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var1)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(11, 0.0, 50.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetTexAnim(11, 0, "口パク")
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108b_1.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.EohSetSoundId(1, var0)
	event.InitDramaScene()
	helper_196e4(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_19da8(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_1a2a4(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1aa14(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_1b138(var0)
	helper_1b1ac(var0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

--- Helper function.
local function helper_1c05c(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f33fd19e(0)
		end
		if at <= 2 then
			helper_f33fd19e(1)
		end
		if at <= 3 then
			helper_0da018f4()
		end
		if at <= 4 then
			helper_f33fd19e(0)
		end
		if at <= 5 then
			helper_f33fd19e(1)
		end
		if at <= 6 then
			helper_f33fd19e(0)
		end
		if at <= 7 then
			helper_f33fd19e(1)
		end
		if at <= 8 then
			helper_0da018f4()
		end
		if at <= 9 then
			helper_b51fc149(30)
		end
		if at <= 10 then
			var4 = 0
			helper_b51fc149(2)
		end
		if at <= 12 then
			var4 = var4 + 1
			helper_b51fc149(22)
		end
		if at <= 13 then
			helper_f33fd19e(0)
		end
		if at <= 14 then
			helper_f33fd19e(1)
		end
		if at <= 15 then
			helper_b51fc149(30)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsFadeInit()
	event.CmrsFadeIn(200, 0.0, 0.0, 0.0)
	event.CmrsSetPos(1010.98, 218.14, -55.12)
	event.CmrsSetRef(-755.14, 237.29, -2.56)
	event.ObjsSetPos(0, -943.03, 134.76, 0.63)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -943.03, 134.76, 0.63)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.CmrsMove(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 120)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 120)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(2)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.CmrsSetPos(-667.47, 186.39, -3.73)
	event.CmrsSetRef(-755.14, 160.61, -2.56)
	event.ObjsSetPos(0, -768.25, 133.66, -2.78)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -768.25, 133.66, -2.78)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "歩き（スティーブ）", 4)
	event.ObjsSetMotion(1, "歩き（スティーブ）", 4)
	event.ObjsMove(0, -739.93, 134.76, -3.16, 20)
	event.ObjsMove(1, -739.93, 134.76, -3.16, 20)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(5)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "立ち（スティーブ）")
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(7)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(8)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(9)
	end
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(-302.7, 76.94, -10.38)
	event.CmrsSetRef(-787.0, 134.76, 18.98)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -802.5, 134.76, -2.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -802.5, 134.76, -2.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(1, "立ち（スティーブ）", 4)
	event.SndSePlay(arg0, 2)
	event.ObjsSetMotion(0, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(0, "立ち（スティーブ）")
	event.ObjsSetMotion(1, "ジャンプ", 2, 0.4)
	event.ObjsNextMotion(1, "立ち（スティーブ）")
	event.ObjsPosDelay(0, 3)
	event.ObjsPosDelay(1, 3)
	event.ObjsJump(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.ObjsJump(1, -378.73, 50.06, 32.39, -0.35, 31)
	var4 = 0
	helper_b51fc149(2)
	if vm.skipping() then
		return skip(11)
	end
	while var4 < 31 do
		do
			local out1, out2, out3 = event.GetCharaPos(9)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.CmrsSetRef(var1 - 14.5, var2 + 17.0, var3 + vm.f32(21.3))
		if vm.wait() then
			return skip(12)
		end
		var4 = var4 + 1
	end
	do
		local out1, out2, out3 = event.GetCharaPos(9)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(var5, var6 + 5.0, var7)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-378.99, 55.0, 20.63)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	event.EsmCreate("砂煙e107")
	event.EsmSetVect1(-379.65, 55.0, 46.12)
	event.EsmSetVect2(1.2, 1.2, 1.2)
	helper_b51fc149(22)
	if vm.skipping() then
		return skip(13)
	end
	event.SndSePlay(arg0, 3)
	event.SndSePlay(arg0, 1)
	event.CmrsSetPos(-261.64, 62.84, 2.96)
	event.CmrsSetRef(-368.77, 78.25, 5.08)
	event.ObjsSetPos(0, -377.87, 50.06, 4.42)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetPos(1, -377.87, 50.06, 4.42)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	helper_f33fd19e(0)
	if vm.skipping() then
		return skip(14)
	end
	helper_f33fd19e(1)
	if vm.skipping() then
		return skip(15)
	end
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(16)
	end
end

--- Helper function.
local function helper_1d7e0(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(43)
		end
		if at <= 2 then
			helper_f33fd19e(2)
		end
		if at <= 3 then
			helper_0da018f4()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSeStop(arg0, 1)
	event.SndSePlay(arg0, 4)
	event.CmrsSetPos(-133.46, 84.21, 3.17)
	event.CmrsSetRef(44.81, 76.82, -5.13)
	event.CharaActive(1, 0)
	event.ObjsSetPos(0, -240.84, 50.51, -5.32)
	event.ObjsSetRot(0, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 9)
	event.ObjsSetPos(1, -240.84, 50.51, -5.32)
	event.ObjsSetRot(1, 0.0, 1.6, 0.0)
	event.ObjsSetMotion(0, "立ち（スティーブ）", 4)
	event.CharaActive(1, 10)
	event.ObjsSetPos(2, 10.66, 50.0, -0.04)
	event.ObjsSetRot(2, 0.0, -1.56, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.PlayBgm(0)
	event.CmrsQuakeDelay(6)
	event.CmrsQuake(0.0, 1.5, 0.0, 24)
	event.CmrsPrdelay(30)
	event.CmrsSetPos(82.22, 91.62, -68.3)
	event.CmrsSetRef(-234.51, 58.39, 145.67)
	event.ObjsSetMotion(2, "着地", 6)
	event.ObjsMotionWait(2)
	helper_b51fc149(43)
	if vm.skipping() then
		return skip(2)
	end
	event.SndSePlay(arg0, 5)
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_0da018f4()
	if vm.skipping() then
		return skip(4)
	end
end

--- Helper function.
local function helper_1df08(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
end

--- Helper function.
local function helper_1df7c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_06d53ec5(1080070)
		end
		if at <= 2 then
			helper_88625211(1080075, 100)
		end
		if at <= 3 then
			helper_f33fd19e(2)
		end
		if at <= 4 then
			helper_f33fd19e(3)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(-44.56, 149.8, 16.49)
	event.CmrsSetRef(29.9, 155.39, 35.57)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CharaActive(1, 10)
	event.ObjsSetRot(2, 0.0, -1.32, 0.0)
	event.ObjsSetScale(2, 1.2, 1.2, 1.2)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 35.03, 137.05, 41.92)
	event.ObjsSetRot(3, 0.0, -1.92, 0.0)
	event.SndSePlay(arg0, 6)
	event.ObjsSetMotion(3, "まわる", 6)
	event.ObjsNextMotion(3, "会話")
	event.SetPakuAnim(3, "わらい口パク")
	helper_06d53ec5(1080070)
	if vm.skipping() then
		return skip(2)
	end
	event.ResetPakuAnim()
	event.ObjsSetRot(3, 0.0, -1.56, 0.0)
	event.SndSePlay(arg0, 8)
	event.ObjsSetMotion(2, "パオーン", 6)
	event.ObjsNextMotion(2, "立ち", 0)
	event.ObjsSetMotion(3, "指差す", 6)
	event.CmrsMove2(-158.84, 98.6, 40.59, 12.88, 114.56, 18.64, 10, 1, 0.3)
	event.SetPakuAnim(3, "わらい口パク")
	helper_88625211(1080075, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.ResetPakuAnim()
	helper_f33fd19e(2)
	if vm.skipping() then
		return skip(4)
	end
	helper_f33fd19e(3)
	if vm.skipping() then
		return skip(5)
	end
end

--- Helper function.
local function helper_1e6a8()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_1c05c(var0)
			end
			if at <= 2 then
				helper_1d7e0(var0)
			end
			if at <= 3 then
				helper_1df08(var0)
				helper_1df7c(var0)
			end
			if at <= 4 then
				helper_b51fc149(15)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		if at <= 6 then
			helper_b51fc149(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 1)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 1)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 1)
		event.EsmClear()
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.DeleteChara(10)
		event.StopBgm(0)
		helper_b51fc149(4)
		if vm.skipping() then
			return skip(7)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
		event.SetCameraPos(-372.02, 97.7, 1.24)
		event.SetCameraRef(-275.93, 89.37, -1.57)
		event.ResetCamera(0)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.CharaActive(1, 0)
		event.SetCharaPos(0, -240.84, 50.0, -5.32)
		event.SetCharaRot(0, 0.0, 1.6, 0.0)
		event.SetStatusbarShow(1)
		event.SetFadeIn(30)
		event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
		event.Finish()
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.InitDramaScene()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.BgmLoadEnable()
	event.SoundLoadEnable()
	event.BgmPlayEnable()
	event.LoadSound(1825)
	var0 = event.SndLoadSound(1825) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.CmrsSetPos(6.02, 94.24, 399.23)
	event.CmrsSetRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e107/e107_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 50.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var0)
	event.LoadChara(5, "event/e100/e107/e107_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 50.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSetShadow(2, 0)
	event.LoadChara(5, "event/e100/e107/e107_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_b51fc149(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.EsmInitialize(5, 1)
	event.EsmLoadBase("砂煙e107")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e100/e108/e108c_1.txt")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_1c05c(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち")
	helper_1d7e0(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_1df08(var0)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	helper_1df7c(var0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(15)
	helper_b51fc149(15)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_20d88()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_237fc52c(64)
		end
	end
	event.SetCharaPos(0, -240.84, 50.0, -5.32)
	event.SetCharaRot(0, 0.0, 1.6, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_237fc52c(64)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_310()
	if vm.skipping() then
		return skip(1)
	end
end

script[310] = program_310

--- Program 500.
script[500] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local member: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_21938(1)
			return
		end
		if at <= 2 then
			helper_20d88()
		end
		if at <= 3 then
			helper_20d88()
		end
		if at <= 4 then
			helper_20d88()
		end
		if at <= 5 then
			helper_20d88()
		end
	end
	helper_fab3eef4()
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		flag = event.GetFlag(106) or flag
		flag_2 = event.GetFlag(104) or flag_2
		member = event.JoinPartyMember(2) or member
		if (if flag == 1 then member else 0) ~= 0 or flag_2 == 0 then
			event.SetBitCtrl(1, 1)
			helper_21938(1)
		end
	end
	event.FuncPointShow("", "dun_out", 0)
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		flag = event.GetFlag(109) or flag
		if flag ~= 0 then
			event.FuncPointShow("", "dun_out", 1)
		end
	else
		event.FuncPointShow("p01_s06", "doa1", 0)
		event.FuncPointShow("p01_s06", "doa0", 1)
		member = event.JoinPartyMember(2) or member
		if member == 0 then
			flag = event.GetFlag(105) or flag
			if flag == 1 then
				event.FuncPointShow("", "dun_out", 1)
			end
		else
			event.FuncPointShow("", "dun_out", 0)
		end
	end
	event.Initialize()
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(1)
	end
	flag = event.GetFlag(103) or flag
	if flag == 0 then
		helper_21938(1)
		event.LoadScript("s06/s06b_1.stb", 500)
		return
	else
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			flag = event.GetFlag(25) or flag
			if flag == 1 then
				event.SetFlag(5, 0)
				flag = event.GetFlag(6) or flag
				if flag == 0 then
					event.SetFadeOut(0)
					event.SetFlag(6, 1)
					event.LoadScript("s06/s06b_1.stb", 510)
					return
				else
					flag = event.GetFlag(7) or flag
					if flag == 0 then
						event.SetFadeOut(0)
						event.LoadScript("s06/s06b_1.stb", 520)
						return
					else
						helper_20d88()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			else
				helper_20d88()
				if vm.skipping() then
					return skip(3)
				end
			end
		else
			event.SetFlag(5, 0)
			flag = event.GetFlag(7) or flag
			if flag == 1 then
				helper_20d88()
				if vm.skipping() then
					return skip(4)
				end
			else
				member = event.JoinPartyMember(2) or member
				if member == 0 then
					flag = event.GetFlag(105) or flag
					if flag == 1 then
						helper_20d88()
						if vm.skipping() then
							return skip(5)
						end
					end
				else
					event.LoadMonsterFile(601, 1)
					helper_20d88()
					if vm.skipping() then
						return skip(6)
					end
					event.Initialize()
					event.AutoSetMonster(601, -36.31, 50.0, 1.24, 0.0, 0.0, 0.0)
					event.Finish()
				end
			end
		end
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	event.LoadScript("s06/s06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_21938(0)
			helper_18530()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.DelMonster(-1)
	end
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetFlag(7, 1)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	helper_21938(0)
	event.DngPause(17, 1)
	helper_18530()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1b220()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	helper_21938(0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_1b220()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 504.
script[504] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	helper_1e6a8()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 505.
script[505] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 506.
script[506] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.LoadScript("s06/06c_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 507.
script[507] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFadeOut(0)
	event.SetFlag(6, 1)
	event.LoadScript("s06/s06b_1.stb", 510)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 600.
script[600] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e445e2f6(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_b51fc149(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.Initialize()
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_e445e2f6(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_e445e2f6(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.SetMesDrawspeed(0, 0)
		event.DngPause(1, 0)
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	var1 = helper_203fe835(2, -1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_b51fc149(30)
		if vm.skipping() then
			return skip(4)
		end
		event.SetBitCtrl(1, 0)
		event.LoadScript("d01/d01.stb", 1000)
		return
	end
	event.Finish()
end

--- Program 601.
script[601] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_21938(1)
	end
	if vm.wait() then
		return skip(1)
	end
	helper_21938(1)
	event.LoadScript("s06/s06c_1.stb", 600)
end

--- Program 630.
script[630] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.GotoEdit(12, 540)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 1200.
script[1200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3a5b1e2b(0)
		end
		if at <= 2 then
			helper_3a5b1e2b(0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		flag = event.GetFlag(7) or flag
		if flag == 0 then
			event.SetFlag(6, 1)
			if vm.wait() then
				return skip(1)
			end
			event.LoadScript("s06/s06.stb", 503)
		else
			helper_3a5b1e2b(0)
			if vm.skipping() then
				return skip(2)
			end
		end
	else
		helper_3a5b1e2b(0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

--- Program 11030.
script[11030] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(103, 0)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b_1.stb", 500)
end

--- Program 11040.
script[11040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06c_1.stb", 500)
end

--- Program 11070.
script[11070] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(107, 1)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("s06/s06b_1.stb", 510)
end

--- Program 11081.
script[11081] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_18530()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetFlag(7, 1)
	end
	event.DngPause(1, 1)
	event.SetFadeOut(15)
	helper_b51fc149(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_18530()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 11082.
script[11082] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_1b220()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.BgmLoadCancel()
		event.GotoEdit(10, 531)
		if vm.wait() then
			return skip(3)
		end
	end
	event.SetBitCtrl(1, 0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(1)
	end
	event.AddHpRate(1.0, 0)
	event.DngSetupMainUnit(0)
	event.SetActiveChrNo(0)
	event.DngPause(17, 1)
	helper_1b220()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 21010.
script[21010] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b51fc149(4)
		end
		helper_21938(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_b51fc149(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(190)
	event.PlayBgm(0)
	event.SetFadeIn(30)
	event.SetCharaPos(0, 0.0, 50.0, 100.0)
	event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
	helper_21938(1)
	event.LoadMonsterFile(601, 1)
	event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
	event.Finish()
	event.ResetCamera(1, 0.0, 20.0)
end

return script
