--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_b027b809 = require("@lib/event/helper_b027b809")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_6481c62e()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 32 then
			if at <= 1 then
				helper_b027b809()
			end
			if at <= 2 then
				helper_e8f4b85c(1)
			end
			if at <= 3 then
				helper_2f481f12(160)
			end
			if at <= 4 then
				helper_93bb7fa4(4400010)
			end
			if at <= 5 then
				helper_e8f4b85c(1)
			end
			if at <= 6 then
				helper_93bb7fa4(4400020)
			end
			if at <= 7 then
				helper_e8f4b85c(0)
			end
			if at <= 8 then
				helper_e8f4b85c(5)
			end
			if at <= 9 then
				helper_93bb7fa4(4400025)
			end
			if at <= 10 then
				helper_93bb7fa4(4400030)
			end
			if at <= 11 then
				helper_93bb7fa4(4400040)
			end
			if at <= 12 then
				helper_e8f4b85c(0)
			end
			if at <= 13 then
				var3 = 0.0
				var4 = vm.f32(-0.35)
				var5 = 0
				pos_y = vm.f32(pos_y + var3)
				var3 = vm.f32(var3 + var4)
				var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
				var5 = var5 + 1
			end
			if at <= 14 then
				helper_93bb7fa4(4400045)
			end
			if at <= 15 then
				helper_e8f4b85c(2)
			end
			if at <= 16 then
				helper_b027b809()
			end
			if at <= 17 then
				helper_93bb7fa4(4400050)
			end
			if at <= 18 then
				helper_e8f4b85c(2)
			end
			if at <= 19 then
				helper_93bb7fa4(4400060)
			end
			if at <= 20 then
				helper_2f481f12(2)
			end
			if at <= 21 then
				helper_e8f4b85c(2)
			end
			if at <= 22 then
				helper_93bb7fa4(4400063)
			end
			if at <= 23 then
				helper_b027b809()
			end
			if at <= 24 then
				helper_93bb7fa4(4400066)
			end
			if at <= 25 then
				helper_e8f4b85c(2)
			end
			if at <= 26 then
				helper_93bb7fa4(4400070)
			end
			if at <= 27 then
				helper_e8f4b85c(1)
			end
			if at <= 28 then
				helper_93bb7fa4(4400080)
			end
			if at <= 29 then
				helper_93bb7fa4(4400083)
			end
			if at <= 30 then
				helper_b027b809()
			end
			if at <= 31 then
				helper_2f481f12(30)
			end
			if vm.skip_end() then
				return skip(33)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 0)
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SpriteSetDraw(0, 0)
		event.PlayBgm(0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SetStatusbarShow(1, 1.0)
		event.EohSetShow(8, 1)
		event.EohSetShow(9, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.DeleteChara(15)
		event.DeleteChara(16)
		event.DeleteChara(17)
		event.DeleteChara(18)
		event.DeleteChara(19)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.CmrsInit()
	end
	event.SetFlag(440, 1)
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
	event.LoadBgm(34)
	event.LoadSound(4826)
	var1 = event.SndLoadSound(4826) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e400/e440/")
	event.LoadMes(0, 5, "e440_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e440_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e440_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e440_jamming.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e440_sourcer.gltf", "info", 11)
	event.CharaActive(11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e440_seagura.gltf", "info", 12)
	event.CharaActive(12)
	event.EohSyncChara(4, 12)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.CopyChara(5, 12, 13)
	event.CharaActive(13)
	event.EohSyncChara(5, 13)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.CopyChara(5, 12, 14)
	event.CharaActive(14)
	event.EohSyncChara(6, 14)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.CopyChara(5, 12, 15)
	event.CharaActive(15)
	event.EohSyncChara(7, 15)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	block = event.LoadImg_4(5, "e440telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e440telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 292)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(10, 0)
	event.ObjsInit(8)
	event.ObjsSyncObj(8, 10)
	event.ChangeDir("")
	event.LoadChara(5, "event/e400/e440/mariometto_a.gltf", "info", 16)
	event.CharaActive(16)
	event.SetReference(12, "mettoa_null", 16)
	event.CopyChara(5, 16, 17)
	event.CharaActive(17)
	event.SetReference(13, "mettoa_null", 17)
	event.CopyChara(5, 16, 18)
	event.CharaActive(18)
	event.SetReference(14, "mettoa_null", 18)
	event.CopyChara(5, 16, 19)
	event.CharaActive(19)
	event.SetReference(15, "mettoa_null", 19)
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e440/e440_mints.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 8)
		event.EohSyncChara(0, 8)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 0)
	else
		event.LoadChara(5, "chara/c02_base.gltf", "info", 8)
		event.LoadEquip(5, 1, 4, "info", 8)
		event.LoadEquip(5, 1, 3, "info", 8)
		event.LoadEquip(5, 1, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e400/e440/e440_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(8, 1)
	event.EohSyncChara(9, 2)
	event.EohSetShow(8, 0)
	event.EohSetShow(9, 0)
	event.EohSetPos(0, 682.0, 0.0, 189.0)
	event.EohSetRot(0, 0.0, -1.57, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 14)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "大口")
	event.EohSetPos(1, 700.0, 0.0, 200.0)
	event.EohSetRot(1, 0.0, -1.57, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 14)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 1381.99, 900.0, 2158.32)
	event.EohSetRot(2, 0.0, 3.0, 0.0)
	event.EohSetMotion(2, "立ち", 4)
	event.EohSetSoundId(2, var1)
	event.EohSetTexAnim(2, 0)
	event.EohSetTexAnim(2, 1, "目パチ")
	event.EohSetPos(3, 1381.99, 900.0, 2158.32)
	event.EohSetRot(3, 0.0, 2.04, 0.0)
	event.EohSetPos(4, 132.83, 0.0, -305.18)
	event.EohSetRot(4, 0.0, 0.72, 0.0)
	event.EohSetMotion(4, "立ち", 4)
	event.EohSetTexAnim(4, 0)
	event.EohSetTexAnim(4, 1, "目赤")
	event.EohSetPos(5, -456.48, 0.0, 1086.61)
	event.EohSetRot(5, 0.0, 2.28, 0.0)
	event.EohSetMotion(5, "立ち", 4)
	event.EohSetTexAnim(5, 0)
	event.EohSetTexAnim(5, 1, "目赤")
	event.EohSetPos(6, 1347.63, 0.0, 856.01)
	event.EohSetRot(6, 0.0, -2.28, 0.0)
	event.EohSetMotion(6, "立ち", 4)
	event.EohSetTexAnim(6, 0)
	event.EohSetTexAnim(6, 1, "目赤")
	event.EohSetPos(7, 894.8, 0.0, -315.53)
	event.EohSetRot(7, 0.0, -0.72, 0.0)
	event.EohSetMotion(7, "立ち", 4)
	event.EohSetTexAnim(7, 0)
	event.EohSetTexAnim(7, 1, "目赤")
	event.InitDramaScene()
	event.SndSePlay(var1, 0)
	event.CmrsInit()
	event.CmrsSetPos(1793.56, 223.9, 283.1)
	event.CmrsSetRef(1848.03, 252.49, 433.57)
	event.CmrsMove2(1793.56, 403.69, 283.1, 1848.03, 478.81, 433.57, 90, 2, 1.0)
	event.SetFadeIn(30)
	helper_b027b809()
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(488.77, 606.28, -354.72)
	event.CmrsSetRef(488.77, 429.77, -146.44)
	event.ObjsMove(0, 482.0, 0.0, 189.0, 60)
	event.ObjsSetMotion(0, "走り", 4)
	event.ObjsMotionDelay(0, 60)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsMove(1, 486.99, 0.0, 202.8, 64)
	event.ObjsSetMotion(1, "走り", 4)
	event.ObjsMotionDelay(1, 64)
	event.ObjsSetMotion(1, "立ち")
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 1)
	event.ObjsMove(4, 267.78, 0.0, -96.39, 210)
	event.ObjsSetMotion(4, "歩き", 0)
	event.ObjsMotionDelay(4, 210)
	event.ObjsSetMotion(4, "立ち")
	event.ObjsMove(5, 171.77, 0.0, 463.88, 230)
	event.ObjsSetMotion(5, "歩き", 0, 0.48)
	event.ObjsMotionDelay(5, 230)
	event.ObjsSetMotion(5, "立ち")
	event.ObjsMove(6, 773.64, 0.0, 443.16, 220)
	event.ObjsSetMotion(6, "歩き", 0, 0.48)
	event.ObjsMotionDelay(6, 220)
	event.ObjsSetMotion(6, "立ち")
	event.ObjsMove(7, 711.27, 0.0, -99.08, 202)
	event.ObjsSetMotion(7, "歩き", 0)
	event.ObjsMotionDelay(7, 202)
	event.ObjsSetMotion(7, "立ち")
	helper_2f481f12(160)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsSetPos(433.73, 10.85, 194.55)
	event.CmrsSetRef(494.45, 22.5, 195.7)
	event.ObjsSetMotion(0, "あとずさり", 6)
	event.ObjsNextMotion(0, "あとずさりL", 4)
	event.ObjsSetMotion(1, "のけぞり", 6)
	event.ObjsNextMotion(1, "のけぞりL", 4)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4400010)
	if vm.skipping() then
		return skip(5)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(6)
	end
	event.ObjsSetMotion(0, "指さす", 2)
	event.ObjsNextMotion(0, "指さすL", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 2)
	event.SetPakuAnim(0, "通常口パク")
	helper_93bb7fa4(4400020)
	if vm.skipping() then
		return skip(7)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(8)
	end
	helper_e8f4b85c(5)
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(482.22, 295.97, 32.59)
	event.CmrsSetRef(358.04, 280.12, 4.29)
	event.SndSePlay(var1, 3)
	helper_93bb7fa4(4400025)
	if vm.skipping() then
		return skip(10)
	end
	event.SndSeStop(var1, 3)
	event.CmrsSetPos(426.29, 336.99, 1022.57)
	event.CmrsSetRef(446.51, 249.73, 695.36)
	event.PlayBgm(0)
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4400030)
	if vm.skipping() then
		return skip(11)
	end
	event.CmrsSetPos(466.23, 33.98, 224.28)
	event.CmrsSetRef(486.89, 17.34, 191.61)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetTexAnim(0, 1, "口とじ～大口")
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetTexAnim(1, 1, "口とじ～大口")
	event.ObjsSetMotion(0, "左上を見る", 6)
	event.ObjsNextMotion(0, "左上を見るL", 4)
	event.ObjsSetMotion(1, "左上", 6)
	event.ObjsNextMotion(1, "左上L", 4)
	helper_93bb7fa4(4400040)
	if vm.skipping() then
		return skip(12)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(13)
	end
	event.CmrsSetPos(468.1, 89.63, 136.48)
	event.CmrsSetRef(619.55, 292.69, 882.71)
	event.CmrsMove2(604.45, 261.89, 808.35, 619.55, 286.12, 882.71, 90, 0, 1.0)
	event.SndSePlay(var1, 4)
	event.ObjsSetPos(0, 474.35, 0.0, 208.29)
	event.ObjsSetRot(0, 0.0, 0.5, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetPos(1, 486.05, 0.0, 198.18)
	event.ObjsSetRot(1, 0.0, 0.23, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.ObjsSetMotion(2, "演奏1", 4)
	event.ObjsMove2(2, 600.0, 900.0, 850.0, 60, 2, 0.5)
	event.ObjsMove2(3, 600.0, 900.0, 850.0, 60, 2, 0.5)
	var3 = 0.0
	var4 = vm.f32(-0.35)
	var5 = 0
	while var5 < 70 do
		do
			local out1, out2, out3 = event.EohGetPos(2)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		pos_y = vm.f32(pos_y + var3)
		if var5 < 50 then
			var3 = vm.f32(var3 + var4)
		else
			var3 = vm.f32(var3 - vm.f32(var4 * vm.f32(2.2)))
		end
		event.EohSetPos(2, pos_x, pos_y, pos_z)
		event.EohSetPos(3, pos_x, pos_y, pos_z)
		var5 = var5 + 1
		if vm.wait() then
			return skip(14)
		end
	end
	event.SndSePlay(var1, 5)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(8, 128, 128, 128, 128, 30)
	event.ObjsMotionDelay(2, 60)
	event.ObjsNextMotion(2, "演奏2", 6)
	event.ObjsNextMotion(2, "演奏1", 4)
	helper_93bb7fa4(4400045)
	if vm.skipping() then
		return skip(15)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(16)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(17)
	end
	event.SpriteSetDraw(0, 0)
	event.CmrsSetPos(520.65, 18.19, 210.67)
	event.CmrsSetRef(478.14, 21.46, 206.21)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SetPakuAnim(1, "通常口パク")
	helper_93bb7fa4(4400050)
	if vm.skipping() then
		return skip(18)
	end
	event.CmrsSetPos(640.97, 288.67, 848.2)
	event.CmrsSetRef(617.43, 290.99, 881.13)
	event.SndSePlay(var1, 6)
	event.ObjsSetMotion(2, "耳に手in", 6)
	event.ObjsMotionWait(2)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(19)
	end
	event.CmrsMoveAhd2(-2.74, -19.32, 54.92, 90, 0, 1.0)
	event.SetPakuMotion(2, "耳に手（会話）", 4, "耳に手", 0)
	helper_93bb7fa4(4400060)
	if vm.skipping() then
		return skip(20)
	end
	event.ObjsSetMotion(2, "ギャーンin", 2)
	event.ObjsMotionWait(2)
	helper_2f481f12(2)
	if vm.skipping() then
		return skip(21)
	end
	event.SndSePlay(var1, 7)
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(22)
	end
	event.SetPakuMotion(2, "ギャーン（会話）", 4, "ギャーン", 0)
	helper_93bb7fa4(4400063)
	if vm.skipping() then
		return skip(23)
	end
	helper_b027b809()
	if vm.skipping() then
		return skip(24)
	end
	event.ObjsSetMotion(2, "笑うin", 2)
	event.ObjsNextMotion(2, "笑う", 4)
	helper_93bb7fa4(4400066)
	if vm.skipping() then
		return skip(25)
	end
	helper_e8f4b85c(2)
	if vm.skipping() then
		return skip(26)
	end
	event.CmrsSetPos(493.73, 43.46, 227.63)
	event.CmrsSetRef(488.06, 20.7, 202.27)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.SndSePlay(var1, 8)
	event.ObjsSetMotion(1, "半歩前", 6)
	event.ObjsNextMotion(1, "半歩前L", 4)
	event.SetPakuAnim(1, "大口パク")
	helper_93bb7fa4(4400070)
	if vm.skipping() then
		return skip(27)
	end
	helper_e8f4b85c(1)
	if vm.skipping() then
		return skip(28)
	end
	event.CmrsSetPos(615.36, 287.58, 855.01)
	event.CmrsSetRef(619.05, 292.49, 877.81)
	event.ObjsSetMotion(2, "会話（演奏）", 6)
	event.ObjsNextMotion(2, "立ち（演奏）", 4)
	helper_93bb7fa4(4400080)
	if vm.skipping() then
		return skip(29)
	end
	helper_93bb7fa4(4400083)
	if vm.skipping() then
		return skip(30)
	end
	event.CmrsMove2(482.56, 23.28, 34.42, 619.05, 121.85, 877.81, 60, 0, 1.0)
	helper_b027b809()
	if vm.skipping() then
		return skip(31)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(32)
	end
	return part2()
end

return helper_6481c62e
