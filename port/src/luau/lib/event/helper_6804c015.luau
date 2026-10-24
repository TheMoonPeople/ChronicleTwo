--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_a88b23ab = require("@lib/event/helper_a88b23ab")

--- Helper function.
local function helper_6804c015()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_474c5bc8(90)
			end
			if at <= 2 then
				helper_41c448af(2)
			end
			if at <= 3 then
				helper_a88b23ab()
			end
			if at <= 4 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SpriteSetDraw(0, 0)
		event.SndSeStop(var0, 4)
		event.SndSeStop(var0, 20)
		event.SndSeStop(var0, 21)
		event.SndSeStop(var0, 22)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.DeleteChara(12)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(1, 0)
		event.SetCharaPos(0, 3308.05, 2411.42, 3265.06)
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
	var0 = event.SndLoadSound(5, "snd2/mon/en_287.sound.json") or var0
	event.SndSePlay(var0, 0)
	event.SndSeStop(var0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.GetActiveChrNo()
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("dungeon/monster/")
	event.LoadChara(5, "e220e.gltf", "e220e", 12)
	event.CharaActive(12)
	event.EohSyncChara(2, 12)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.ChangeDir("event/e700/e728/")
	block = event.LoadImg_4(5, "e728telop02_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e728telop02", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
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
	event.EohSetPos(1, 3308.05, 2411.42, 3265.06)
	event.EohSetRot(1, 0.0, -1.54, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, 3309.86, 2411.42, 3306.96)
	event.EohSetRot(0, 0.0, -1.69, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 3226.64, 2528.88, 3294.36)
	event.EohSetRot(2, 0.0, 1.5, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(0, 0)
	event.CharaActive(12)
	event.CmrsInit()
	event.CmrsSetPos(3170.59, 2432.59, 3163.04)
	event.CmrsSetRef(3269.4, 2439.28, 3302.02)
	event.SetProjection(524.9)
	event.SetFadeIn(30)
	event.ObjsMove(2, 3226.64, 2411.42, 3294.36, 20)
	event.ObjsSetMotion(2, "落下", 6)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.ObjsSePlay(2, var0, 21)
	event.CmrsQuakeDelay(20)
	event.CmrsQuake(0.0, 1.0, 0.0, 30)
	helper_474c5bc8(90)
	if vm.skipping() then
		return skip(2)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsSetPos(3330.27, 2500.07, 3406.83)
	event.CmrsSetRef(3233.27, 2448.19, 3292.97)
	event.ObjsSetPos(0, 3309.86, 2911.42, 3306.96)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 3308.05, 2911.42, 3265.06)
	event.ObjsResetDaPosition(1)
	event.CmrsMove2(3371.95, 2435.67, 3236.53, 3241.2, 2447.69, 3291.49, 150, 2, 1.0)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 4)
	event.ObjsSeDelay(2, 45)
	event.ObjsSePlay(2, var0, 22)
	event.ObjsSetMotion(2, "攻撃１", 6)
	event.ObjsNextMotion(2, "遊び", 6)
	event.ObjsNextMotion(2, "立ち")
	helper_a88b23ab()
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

return helper_6804c015
