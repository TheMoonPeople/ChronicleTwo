--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f8e2df2 = require("@lib/event/helper_1f8e2df2")
local helper_4bea09db = require("@lib/event/helper_4bea09db")
local helper_699116d4 = require("@lib/event/helper_699116d4")
local helper_890b5665 = require("@lib/event/helper_890b5665")
local helper_8e9e4151 = require("@lib/event/helper_8e9e4151")

--- Helper function.
local function helper_48c3ecae()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 29 then
			if at <= 1 then
				helper_890b5665(70)
			end
			if at <= 2 then
				helper_890b5665(50)
			end
			if at <= 3 then
				helper_4bea09db()
			end
			if at <= 4 then
				helper_699116d4(2)
			end
			if at <= 5 then
				helper_8e9e4151(7160010)
			end
			if at <= 6 then
				helper_699116d4(1)
			end
			if at <= 7 then
				helper_4bea09db()
			end
			if at <= 8 then
				helper_4bea09db()
			end
			if at <= 9 then
				helper_8e9e4151(7160020)
			end
			if at <= 10 then
				helper_8e9e4151(7160030)
			end
			if at <= 11 then
				helper_8e9e4151(7160040)
			end
			if at <= 12 then
				helper_8e9e4151(7160045)
			end
			if at <= 13 then
				helper_4bea09db()
			end
			if at <= 14 then
				helper_8e9e4151(7160050)
			end
			if at <= 15 then
				helper_4bea09db()
			end
			if at <= 16 then
				helper_8e9e4151(7160060)
			end
			if at <= 17 then
				helper_4bea09db()
			end
			if at <= 18 then
				helper_890b5665(20)
			end
			if at <= 19 then
				helper_4bea09db()
			end
			if at <= 20 then
				helper_890b5665(100)
			end
			if at <= 21 then
				helper_890b5665(60)
			end
			if at <= 22 then
				helper_4bea09db()
			end
			if at <= 23 then
				helper_890b5665(6)
			end
			if at <= 24 then
				helper_890b5665(34)
			end
			if at <= 25 then
				helper_699116d4(3)
			end
			if at <= 26 then
				helper_1f8e2df2(7160070, -1)
			end
			if at <= 27 then
				helper_890b5665(30)
			end
			if at <= 28 then
				helper_890b5665(30)
			end
			if vm.skip_end() then
				return skip(30)
			end
			return part2()
		end
		if at <= 30 then
			helper_890b5665(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var1, 3)
		event.SndSeStop(var1, 4)
		event.SpriteSetDraw(0, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DeleteChara(14)
		event.LoadMes(0, -1)
		event.DelImg(0)
		event.StopBgm(0)
		helper_890b5665(4)
		if vm.skipping() then
			return skip(31)
		end
		event.LoadBgm(41)
		event.PlayBgm(0)
		event.SetStatusbarShow(1, 1.0)
		event.Finish()
	end
	event.SetFlag(716, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	helper_890b5665(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(117)
	event.LoadSound(7823)
	var1 = event.SndLoadSound(7823) or var1
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e716/")
	event.LoadMes(0, 5, "e716_1.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e716_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e716_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	event.LoadChara(5, "e716_griffon.gltf", "info", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e716_boss08a.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.LoadChara(5, "e716_hikari.gltf", "info", 12)
	event.CharaActive(0, 12)
	event.EohSyncChara(5, 12)
	event.ObjsInit(5)
	event.ObjsSyncObj(5, 5)
	event.LoadChara(5, "e716_hikari1.gltf", "info", 13)
	event.CharaActive(0, 13)
	event.EohSyncChara(6, 13)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.LoadChara(5, "e716_rolling.gltf", "info", 14)
	event.CharaActive(0, 14)
	block = event.LoadImg_4(5, "e716telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e716telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 272)
	event.SpriteSetAlphab(0, 0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e716/e716_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e716/e716_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
	event.EohSetPos(0, -8.0, 40.0, -1100.0)
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetFootSoundId(0, 2)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "おこり顔")
	event.EohSetTexAnim(0, 1, "おこり目パチ")
	event.EohSetPos(1, 8.0, 40.0, -1100.0)
	event.EohSetRot(1, 0.0, 0.0, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetFootSoundId(1, 2)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "おこり顔")
	event.EohSetTexAnim(1, 1, "おこり目パチ")
	event.EohSetPos(2, 0.0, 0.0, 0.0)
	event.EohSetRot(2, 0.0, 3.14, 0.0)
	event.EohSetMotion(2, "立ち（後ろ）", 4)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(6.27, 44.45, -1056.3)
	event.CmrsSetRef(-5.8, 72.27, -1139.67)
	event.SetFadeIn(30)
	helper_890b5665(70)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(0.0, 45.57, -821.24)
	event.CmrsSetRef(0.0, 62.17, -781.76)
	event.CmrsMove2(0.0, 45.57, -821.24, 0.0, 44.79, -764.81, 60, 2, 0.4)
	event.PlayBgm(0)
	helper_890b5665(50)
	if vm.skipping() then
		return skip(3)
	end
	event.SndSePlay(var1, 0)
	event.ObjsSetMotion(2, "後ろ向きから振り返り", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_4bea09db()
	if vm.skipping() then
		return skip(4)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(0.0, 51.5, -47.79)
	event.CmrsSetRef(0.0, 51.5, 7.22)
	helper_699116d4(2)
	if vm.skipping() then
		return skip(5)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_8e9e4151(7160010)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsInitPas()
	event.CmrsSetPasFrm(100)
	event.CmrsAddPas(0.0, 67.68, -429.93, 0.0, 66.4, -374.92)
	event.CmrsAddPas(0.0, 53.12, -422.5, 0.0, 51.84, -367.49)
	event.CmrsAddPas(0.0, 39.11, -416.35, 0.0, 37.83, -361.34)
	event.CmrsAddPas(0.0, 22.09, -390.47, 0.0, 20.81, -335.46)
	event.CmrsStartPas()
	event.ObjsSetPos(0, -9.0, 0.0, -400.0)
	event.ObjsMove(0, -9.0, 0.0, -300.0, 100)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMotionDelay(0, 100)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsSetPos(1, 9.0, 0.0, -400.0)
	event.ObjsMove(1, 9.0, 0.0, -300.0, 100)
	event.ObjsSetMotion(1, "歩き", 4)
	event.ObjsMotionDelay(1, 100)
	event.ObjsSetMotion(1, "立ち")
	helper_699116d4(1)
	if vm.skipping() then
		return skip(7)
	end
	helper_4bea09db()
	if vm.skipping() then
		return skip(8)
	end
	event.SetCrossfade(60)
	event.CmrsSetPos(6.0, 55.51, -39.78)
	event.CmrsSetRef(6.0, 54.23, 15.23)
	event.CmrsMove(-2.0, 55.51, -39.78, -2.0, 54.23, 15.23, 90)
	helper_4bea09db()
	if vm.skipping() then
		return skip(9)
	end
	event.CmrsSetPos(-36.97, 20.61, -265.32)
	event.CmrsSetRef(7.39, 19.33, -299.35)
	event.ObjsSetMotion(0, "グリフォン！！", 6)
	event.ObjsNextMotion(0, "グリフォン！！L", 4)
	event.ObjsSeDelay(0, 10)
	event.ObjsSePlay(0, var1, 1)
	event.SetPakuAnim(0, "通常口パク")
	helper_8e9e4151(7160020)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetMotion(1, "指差し", 6)
	event.ObjsNextMotion(1, "指差しL", 4)
	event.ObjsSeDelay(1, 10)
	event.ObjsSePlay(1, var1, 2)
	event.SetPakuAnim(1, "通常口パク")
	helper_8e9e4151(7160030)
	if vm.skipping() then
		return skip(11)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-8.0, 20.0, -338.23)
	event.CmrsSetRef(-8.0, 20.0, -277.78)
	event.CmrsMove2(0.0, 20.0, -338.23, 0.0, 20.0, -277.78, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_8e9e4151(7160040)
	if vm.skipping() then
		return skip(12)
	end
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_8e9e4151(7160045)
	if vm.skipping() then
		return skip(13)
	end
	helper_4bea09db()
	if vm.skipping() then
		return skip(14)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-8.0, 52.0, -59.19)
	event.CmrsSetRef(-8.0, 52.0, 15.23)
	event.CmrsMove2(0.0, 52.0, -59.19, 0.0, 52.0, 15.23, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_8e9e4151(7160050)
	if vm.skipping() then
		return skip(15)
	end
	helper_4bea09db()
	if vm.skipping() then
		return skip(16)
	end
	event.SetCrossfade(30)
	event.CmrsSetPos(-4.0, 56.21, -28.1)
	event.CmrsSetRef(-4.0, 56.16, 15.23)
	event.CmrsMove2(0.0, 56.21, -28.1, 0.0, 56.16, 15.23, 90, 2, 0.3)
	event.SetPakuMotion(2, "会話", 0, "立ち", 0)
	helper_8e9e4151(7160060)
	if vm.skipping() then
		return skip(17)
	end
	helper_4bea09db()
	if vm.skipping() then
		return skip(18)
	end
	event.ObjsSetMotion(2, "手広げ", 2)
	event.ObjsNextMotion(2, "手広げＬ", 4)
	event.ObjsSeDelay(2, 10)
	event.ObjsSePlay(2, var1, 3)
	event.CmrsMove2(0.0, 30.2, -186.75, 0.0, 49.5, 15.23, 40, 0, 0.2)
	helper_890b5665(20)
	if vm.skipping() then
		return skip(19)
	end
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetCharaPos(14, 0.0, 0.0, 0.0)
	event.SetMotion(14, "手広げＬ", 6)
	event.CharaActive(1, 14)
	helper_4bea09db()
	if vm.skipping() then
		return skip(20)
	end
	event.CmrsSetPos(-36.48, 7.72, -377.14)
	event.CmrsSetRef(-28.24, 21.42, -338.45)
	event.ObjsSetMotion(0, "上向く", 6, -1.0, 1)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6, -1.0, 1)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsMove(2, 0.0, 160.0, 0.0, 60)
	event.ObjsSetMotion(2, "回る", 6)
	event.ObjsNextMotion(2, "放つ", 6)
	event.ObjsNextMotion(2, "放つＬ", 4)
	event.CharaActive(1, 12)
	event.SetCharaShow(12, 1, 1, 0.025)
	event.ObjsSetPos(5, 0.0, 40.0, -10.0)
	event.ObjsSetRot(5, 0.0, 0.0, 0.0)
	event.ObjsMove(5, 0.0, 200.0, -10.0, 60)
	helper_890b5665(100)
	if vm.skipping() then
		return skip(21)
	end
	event.CharaActive(1, 13)
	event.ObjsSetPos(6, 0.0, 200.0, -10.0)
	event.ObjsSetRot(6, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(6, "放つＬ", 6)
	helper_890b5665(60)
	if vm.skipping() then
		return skip(22)
	end
	event.CmrsSetPos(-9.86, 51.69, -251.99)
	event.CmrsSetRef(1.75, 8.15, -309.3)
	event.CmrsMove2(-7.66, 45.43, -262.87, 1.75, 8.15, -309.3, 60, 2, 0.2)
	event.EohSetTexAnim(0, 1, "半口")
	event.EohSetTexAnim(1, 1, "半口")
	event.ObjsSetRot(0, 0.0, 0.12, 0.0)
	event.ObjsSetMotion(0, "上向くL", 4, -1.0, 1)
	event.ObjsSetRot(1, 0.0, -0.12, 0.0)
	event.ObjsSetMotion(1, "上向くL", 4, -1.0, 1)
	event.CharaActive(0, 12)
	event.CharaActive(0, 13)
	event.SetCharaPos(12, 0.0, 200.0, 0.0)
	event.SetCharaRot(12, 0.0, 0.0, 0.0)
	event.SetMotion(12, "手広げＬ", 4)
	helper_4bea09db()
	if vm.skipping() then
		return skip(23)
	end
	event.CmrsSetPos(0.0, 200.0, -340.0)
	event.CmrsSetRef(0.0, 200.0, 0.0)
	event.CmrsMove2(0.0, 200.0, -130.0, 0.0, 200.0, 0.0, 120, 2, 0.2)
	event.CharaActive(0, 10)
	event.CharaActive(1, 11)
	event.ObjsSetPos(3, 0.0, 160.0, 0.0)
	event.ObjsSetRot(3, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(3, "立ち", 4)
	helper_890b5665(6)
	if vm.skipping() then
		return skip(24)
	end
	event.SndSePlay(var1, 4)
	helper_890b5665(34)
	if vm.skipping() then
		return skip(25)
	end
	event.ObjsNextMotion(3, "舞", 6)
	event.ObjsNextMotion(3, "舞Ｌ", 4)
	helper_699116d4(3)
	if vm.skipping() then
		return skip(26)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsColorDelay(4, 30)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	event.ObjsColorDelay(4, 90)
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	helper_1f8e2df2(7160070, -1)
	if vm.skipping() then
		return skip(27)
	end
	helper_890b5665(30)
	if vm.skipping() then
		return skip(28)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_890b5665(30)
	if vm.skipping() then
		return skip(29)
	end
	return part2()
end

return helper_48c3ecae
