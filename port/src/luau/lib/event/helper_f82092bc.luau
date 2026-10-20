--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1953c457 = require("@lib/event/helper_1953c457")
local helper_1f6c4dc7 = require("@lib/event/helper_1f6c4dc7")
local helper_23bda4ba = require("@lib/event/helper_23bda4ba")
local helper_261c70db = require("@lib/event/helper_261c70db")
local helper_3ea45d11 = require("@lib/event/helper_3ea45d11")
local helper_894b5c3b = require("@lib/event/helper_894b5c3b")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_e797fcc8 = require("@lib/event/helper_e797fcc8")

--- Helper function.
local function helper_f82092bc()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 25 then
			if at <= 1 then
				helper_adea7ba0(30)
			end
			if at <= 2 then
				helper_894b5c3b(1)
			end
			if at <= 3 then
				helper_e797fcc8(0, -1, 8, 0, 0)
				helper_1f6c4dc7(0, 30)
			end
			if at <= 4 then
				helper_1953c457(0)
				helper_23bda4ba(6)
			end
			if at <= 5 then
				helper_adea7ba0(14)
			end
			if at <= 6 then
				helper_adea7ba0(10)
			end
			if at <= 7 then
				helper_adea7ba0(5)
			end
			if at <= 8 then
				helper_23bda4ba(2)
			end
			if at <= 9 then
				helper_23bda4ba(0)
			end
			if at <= 10 then
				helper_23bda4ba(0)
			end
			if at <= 11 then
				helper_261c70db()
			end
			if at <= 12 then
				helper_adea7ba0(6)
			end
			if at <= 13 then
				helper_adea7ba0(4)
			end
			if at <= 14 then
				helper_adea7ba0(3)
			end
			if at <= 15 then
				helper_adea7ba0(20)
			end
			if at <= 16 then
				helper_3ea45d11(40080, 30)
			end
			if at <= 17 then
				helper_adea7ba0(10)
			end
			if at <= 18 then
				var2 = 0
				helper_adea7ba0(40 - var2)
			end
			if at <= 19 then
				helper_adea7ba0(46)
			end
			if at <= 20 then
				helper_23bda4ba(0)
			end
			if at <= 21 then
				helper_adea7ba0(30)
			end
			if at <= 22 then
				helper_23bda4ba(0)
			end
			if at <= 23 then
				helper_adea7ba0(30)
			end
			if at <= 24 then
				helper_261c70db()
			end
			if vm.skip_end() then
				return skip(26)
			end
			return part2()
		end
		if at <= 26 then
			var3 = 0
			var3 = var3 + 1
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 33)
		event.SndSeStop(var1, 27)
		event.SndSeStop(var1, 28)
		event.StreamClose(1)
		event.LoadMes(0, -1)
		event.LoadSound(1217)
		event.SndSeAllStop(4)
		var3 = 0
		while var3 < 32 do
			event.ObjsInit(var3)
			var3 = var3 + 1
		end
		event.SetCameraRef(0.0, 33.8, 6.0)
		event.SetCameraPos(0.0, 38.8, 86.0)
		event.ResetCamera(0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.DeleteChara(20)
		event.DeleteChara(8)
		event.CharaActive(1, 0)
		event.DelReference(0)
		event.SetCharaPos(0, 0.0, 8.8, 6.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "バトル立ち", 4)
		event.CharaResetDa(0)
		event.EohSyncChara(21, 1)
		event.EohSetShow(21, 1)
		event.EohSyncChara(21, 2)
		event.EohSetShow(21, 0)
		event.SndInitPort(4)
		event.AssignStack(3)
		event.ClearStack(3)
		event.LoadMonsterFile(600, 1)
		event.AutoSetMonster(600, -46.01, 8.8, 50.48, 0.0, 2.42, 0.0)
		event.AutoSetMonster(600, 48.62, 8.8, 60.52, 0.0, -2.42, 0.0)
		event.AutoSetMonster(600, -35.87, 8.8, -54.34, 0.0, 0.38, 0.0)
		event.AutoSetMonster(600, 30.12, 8.8, -61.93, 0.0, -0.6, 0.0)
		var0 = event.SndLoadSound(4, "snd2/event/ev_200_000.sound.json") or var0
		event.SndSePlay(var0, 0)
		if vm.wait() then
			return skip(27)
		end
		event.DngPause(16384, 1)
		var4 = event.GetSndId(4) or var4
		event.SetCharaExSoundid(0, var4)
		event.ActchrSoundInfoCopy(0)
		event.DngPause(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.SetFadeIn(30)
		event.Finish()
	end
	event.DngPause(1, 1)
	event.SetStatusbarShow(0, 0.033333335)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(2)
	end
	event.DelMonster(-1)
	event.DngPause(16384, 0)
	event.Initialize()
	event.SetStatusbarShow(0, 1.0)
	event.AddHpRate(1.0, 0)
	event.AddWhp(0, 999)
	var1 = event.SndLoadSound(1216) or var1
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMes(0, 5, "event/opening/p4/op4ch1_1.txt")
	event.LoadMotion(5, "event/opening/p4/p4_mints3.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 3)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 0.0, 0.0, 0.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsTexAnime(0, 0)
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 0)
	event.EohSyncChara(21, 2)
	event.EohSetShow(21, 0)
	event.LoadChara(5, "event/opening/p4/light.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.EohSetFrameShow(2, "kusari", 0)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ObjsSetPos(2, 0.0, 0.0, 0.0)
	event.ObjsSetRot(2, 0.0, 0.0, 0.0)
	event.EohSyncChrobj(7, 10, "light_rot")
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsRotation(7, 0.01, 0.0, 0.0, -1)
	event.LoadChara(5, "event/opening/p4/p4_pierrot_kihon.gltf", "info", 11)
	event.LoadMotion(5, "event/opening/p4/p4_pierrot3.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.EohSetSoundId(3, var1)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ObjsSetPos(3, 0.0, 0.0, 0.0)
	event.ObjsSetRot(3, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.EohSetSoundId(4, var1)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.ObjsSetRot(4, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.EohSetSoundId(5, var1)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.ObjsSetPos(5, 0.0, 0.0, 0.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.CopyChara(5, 11, 14)
	event.CharaActive(0, 14)
	event.LoadChara(5, "event/opening/p4/p4_people.gltf", "info", 15)
	event.CharaActive(15)
	event.SetCharaPos(15, 0.0, 0.0, -405.0)
	event.LoadChara(5, "event/opening/p4/up_kusari.gltf", "info", 18)
	event.CharaActive(18)
	event.SetReference(10, "up_kusari", 18)
	event.LoadChara(5, "event/opening/p4/shuchusen.gltf", "info", 8)
	event.CharaActive(0, 8)
	event.EohSyncChara(6, 8)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "event/opening/p4/p4_kemuri.gltf", "info", 20)
	event.CharaActive(0, 20)
	event.SetCharaPos(20, 0.0, 10.0, 0.0)
	event.ObjsSetMotion(4, "つかまりL", 4)
	event.SetReference(10, "pierrot2", 12)
	event.ObjsSetMotion(5, "つかまりL", 4)
	event.SetReference(10, "pierrot3", 13)
	event.ObjsSetMotion(3, "つかまりL", 4)
	event.SetReference(10, "pierrot1", 11)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetReference(10, "mints", 0)
	event.ObjsSetMotion(0, "見上げるL", 4)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.StreamOpen3(1, 40060)
	helper_894b5c3b(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(10, "落下", 6, 0.3)
	event.InitDramaScene()
	event.SetFadeIn(30)
	event.CmrsInit()
	event.CmrsSyncObj(0, 0.0, 0.0, 8.0, -0.16, 15.0, 20.0, "bcol00", 2)
	event.SndSePlay(var1, 33)
	event.CmrsCharaAttach(8, 60.0, 30)
	event.CharaActive(8)
	event.CharaActive(18)
	event.ObjsResetDaPosition(0)
	event.ObjsSeDelay(0, 1)
	event.ObjsResetDaPosition(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "落ちるー（３）")
	event.ObjsTexAnime(0, 1, "大口")
	event.StreamPlay(1)
	event.MesMake_2(0, 40060)
	helper_e797fcc8(0, -1, 8, 0, 0)
	helper_1f6c4dc7(0, 30)
	if vm.skipping() then
		return skip(4)
	end
	helper_1953c457(0)
	event.SetMesPos(0, 0)
	helper_23bda4ba(6)
	if vm.skipping() then
		return skip(5)
	end
	event.StreamClose(1)
	event.CmrsReleaseObj()
	event.CharaActive(0, 8)
	event.CmrsSetPos(0.0, 18.46, -95.54)
	event.CmrsSetRef(0.0, 194.33, 107.78)
	event.CmrsMove(0.0, 18.46, -95.54, 0.0, 66.62, 107.78, 30)
	event.CharaActive(11)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CharaActive(0, 18)
	event.ObjsResetMotion(2)
	event.ObjsSetMotion(2, "落下", 6, 0.3)
	event.ObjsNextMotion(2, "停止", 4)
	event.SndSePlay(var1, 27)
	helper_adea7ba0(14)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "飛び降りる", 2)
	event.ObjsNextMotion(0, "飛び降りるL", 6, 0.2)
	event.ObjsNextMotion(0, "ライトから着地", 6)
	event.ObjsMotionWait(0)
	event.ObjsMotionDelay(0, 10)
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(7)
	end
	event.DelReference(0)
	event.ObjsSetPos(0, 0.0, 65.81, 94.16)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsJump(0, 0.0, 10.6, 6.0, -0.2, 30)
	helper_adea7ba0(5)
	if vm.skipping() then
		return skip(8)
	end
	event.CharaActive(20)
	event.SetMotion(20, "けむり", 6)
	helper_23bda4ba(2)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsInit(7)
	event.DelReference(11)
	event.ObjsSetPos(3, -46.01, 150.0, 50.48)
	event.ObjsSetRot(3, 0.0, 2.42, 0.0)
	event.DelReference(12)
	event.ObjsSetPos(4, -48.62, 150.0, 60.52)
	event.ObjsSetRot(4, 0.0, -2.42, 0.0)
	event.DelReference(13)
	event.ObjsSetPos(5, -35.87, 150.0, -54.34)
	event.ObjsSetRot(5, 0.0, 0.38, 0.0)
	event.CharaActive(14)
	event.EohSyncChara(20, 14)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.ObjsSetPos(20, 30.12, 150.0, -61.93)
	event.ObjsSetRot(20, 0.0, -0.6, 0.0)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(10)
	end
	event.CmrsSetPos(1.17, 26.95, -26.03)
	event.CmrsSetRef(1.17, 33.68, 4.49)
	event.ObjsSetPos(0, 0.0, 10.0, 6.0)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "舞台上キョロキョロ", 6)
	event.ObjsMotionWait(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "拍手喝采（３）")
	event.ObjsTexAnime(0, 1, "開きからにこり")
	event.ObjsSePlay(0, var1, 28)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetRef(0.0, 33.68, 4.49)
	event.CmrsSetAhd(0.9, 9.0, 50.0)
	event.CmrsMoveAhd(-0.9, 9.0, 50.0, 180)
	event.ObjsSetMotion(0, "手を振る", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "感動（３）")
	event.ObjsTexAnime(0, 1, "うれし口（３）")
	helper_261c70db()
	if vm.skipping() then
		return skip(12)
	end
	event.CmrsSetPos(0.61, 45.86, -150.28)
	event.CmrsSetRef(0.57, 21.14, 5.95)
	event.CharaActive(0, 10)
	event.ObjsSetMotion(20, "落下中", 6, 0.15)
	event.ObjsNextMotion(20, "着地", 6)
	event.ObjsNextMotion(20, "立ち", 4)
	event.ObjsJump(20, 30.12, 8.8, -61.93, -0.2, 30)
	event.ObjsSeDelay(20, 30)
	event.ObjsSePlay(20, var1, 34)
	helper_adea7ba0(6)
	if vm.skipping() then
		return skip(13)
	end
	event.ObjsSetMotion(3, "落下中", 6, 0.15)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	event.ObjsJump(3, -46.01, 8.8, 50.48, -0.2, 30)
	event.ObjsSeDelay(3, 30)
	event.ObjsSePlay(3, var1, 34)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(14)
	end
	event.ObjsSetMotion(5, "落下中", 6, 0.15)
	event.ObjsNextMotion(5, "着地", 6)
	event.ObjsNextMotion(5, "立ち", 4)
	event.ObjsJump(5, -35.87, 8.8, -54.34, -0.2, 30)
	event.ObjsSeDelay(5, 30)
	event.ObjsSePlay(5, var1, 34)
	helper_adea7ba0(3)
	if vm.skipping() then
		return skip(15)
	end
	event.ObjsSetMotion(4, "落下中", 6, 0.15)
	event.ObjsNextMotion(4, "着地", 6)
	event.ObjsNextMotion(4, "立ち", 4)
	event.ObjsJump(4, 48.62, 8.8, 60.52, -0.2, 30)
	event.ObjsSeDelay(4, 30)
	event.ObjsSePlay(4, var1, 34)
	helper_adea7ba0(20)
	if vm.skipping() then
		return skip(16)
	end
	event.ObjsSetMotion(0, "キョロキョロ立ち")
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "怒り目")
	event.ObjsTexAnime(0, 1, "怒り口")
	helper_3ea45d11(40080, 30)
	if vm.skipping() then
		return skip(17)
	end
	helper_adea7ba0(10)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(-20.61, 33.01, -18.61)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.CharaActive(0, 11)
	event.CharaActive(0, 12)
	event.ObjsSetMotion(0, "レンチを取り出す", 6)
	event.ObjsNextMotion(0, "レンチを取り出すL", 4)
	event.StreamClose(1)
	var2 = 0
	helper_adea7ba0(40 - var2)
	if vm.skipping() then
		return skip(19)
	end
	event.EohSyncChara(21, 1)
	event.EohSetShow(21, 1)
	helper_adea7ba0(46)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSePlay(0, var1, 35)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(21)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-4.51, 25.29, -32.6)
	event.CmrsSetRef(1.45, 30.1, 6.28)
	event.ObjsSetMotion(0, "かまえる", 6)
	event.ObjsNextMotion(0, "かまえるL", 4)
	event.ObjsSeDelay(0, 4)
	event.ObjsSePlay(0, var1, 36)
	helper_23bda4ba(0)
	if vm.skipping() then
		return skip(23)
	end
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(24)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_261c70db()
	if vm.skipping() then
		return skip(25)
	end
	return part2()
end

return helper_f82092bc
