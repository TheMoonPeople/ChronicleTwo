--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_a88b23ab = require("@lib/event/helper_a88b23ab")

--- Helper function.
local function helper_68cbd6c2()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_474c5bc8(30)
			end
			if at <= 2 then
				helper_474c5bc8(10)
			end
			if at <= 3 then
				helper_474c5bc8(90)
			end
			if at <= 4 then
				helper_41c448af(2)
			end
			if at <= 5 then
				helper_41c448af(3)
			end
			if at <= 6 then
				helper_a88b23ab()
			end
			if at <= 7 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(9)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SpriteSetDraw(0, 0)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DeleteChara(13)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetCharaPos(0, -3866.22, 7277.16, 3386.78)
		event.SetCharaRot(0, 0.0, -2.05, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(5, "snd2/mon/en_290.sound.json") or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("dungeon/monster/")
	event.LoadChara(5, "e117g.gltf", "e117g", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.LoadChara(5, "e117f.gltf", "e117f", 13)
	event.CharaActive(13)
	event.EohSyncChara(3, 13)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	event.ChangeDir("event/e700/e728/")
	block = event.LoadImg_4(5, "e728telop05_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e728telop05", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(4, 0)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.ChangeDir("")
	event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
	event.LoadEquip(5, 0, 4, "info", 8)
	event.LoadEquip(5, 0, 3, "info", 8)
	event.LoadEquip(5, 0, 2, "info", 8, 9)
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSyncChara(0, 8)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.LoadChara(5, "chara/c02_base.gltf", "info", 10)
	event.LoadEquip(5, 1, 4, "info", 10)
	event.LoadEquip(5, 1, 3, "info", 10)
	event.LoadEquip(5, 1, 2, "info", 10, 11)
	event.CharaActive(10)
	event.CharaActive(11)
	event.EohSyncChara(1, 10)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(1, -3865.73, 7277.16, 3359.29)
	event.EohSetRot(1, 0.0, -1.42, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, -3866.22, 7277.16, 3386.78)
	event.EohSetRot(0, 0.0, -1.33, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, -4001.48, 7352.3, 3374.42)
	event.EohSetRot(2, 0.0, 1.74, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.EohSetPos(3, -3985.26, 7352.3, 3434.83)
	event.EohSetRot(3, 0.0, 1.98, 0.0)
	event.EohSetFootSoundId(3, 2)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(0, 0)
	event.CharaActive(12)
	event.CharaActive(13)
	event.CmrsInit()
	event.CmrsSetPos(-4096.39, 7346.63, 3435.97)
	event.CmrsSetRef(-3944.67, 7285.9, 3390.81)
	event.SetProjection(524.9)
	event.SetFadeIn(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsMove(2, -4001.48, 7277.16, 3374.42, 20)
	event.ObjsSetMotion(2, "落下", 6)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	var0 = event.SndLoadSound(5, "snd2/mon/en_290.sound.json") or var0
	event.ObjsSePlay(2, var0, 21)
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsMove(3, -3985.26, 7277.16, 3434.83, 20)
	event.ObjsSetMotion(3, "落下", 6)
	event.ObjsMotionDelay(3, 20)
	event.ObjsNextMotion(3, "着地", 6)
	event.ObjsNextMotion(3, "立ち", 4)
	var0 = event.SndLoadSound(5, "snd2/mon/en_291.sound.json") or var0
	event.ObjsSePlay(3, var0, 21)
	event.CmrsQuakeDelay(15)
	event.CmrsQuake(0.0, 1.0, 0.0, 40)
	helper_474c5bc8(90)
	if vm.skipping() then
		return skip(4)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(5)
	end
	helper_41c448af(3)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsSetPos(-3852.79, 7355.36, 3367.81)
	event.CmrsSetRef(-4014.32, 7278.63, 3412.93)
	event.ObjsSetPos(0, -3866.22, 7677.16, 3386.78)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, -3865.73, 7677.16, 3359.29)
	event.ObjsResetDaPosition(1)
	event.CmrsMove2(-3871.31, 7288.29, 3372.98, -4018.09, 7304.56, 3413.99, 150, 2, 1.0)
	event.ObjsSetColor(4, 128, 128, 128, 128, 30)
	var0 = event.SndLoadSound(5, "snd2/mon/en_290.sound.json") or var0
	event.SndSePlay(var0, 5)
	event.ObjsSeDelay(2, 60)
	event.ObjsSePlay(2, var0, 22)
	event.ObjsSetMotion(2, "攻撃２", 6)
	event.ObjsNextMotion(2, "遊び", 6)
	event.ObjsNextMotion(2, "立ち")
	event.ObjsSetMotion(3, "攻撃２", 6)
	event.ObjsNextMotion(3, "遊び", 6)
	event.ObjsNextMotion(3, "立ち")
	helper_a88b23ab()
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetColor(4, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(8)
	end
	return part2()
end

return helper_68cbd6c2
