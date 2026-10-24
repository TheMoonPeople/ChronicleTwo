--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41c448af = require("@lib/event/helper_41c448af")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_a88b23ab = require("@lib/event/helper_a88b23ab")

--- Helper function.
local function helper_dc7a969c()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_474c5bc8(60)
			end
			if at <= 2 then
				helper_a88b23ab()
			end
			if at <= 3 then
				helper_474c5bc8(20)
			end
			if at <= 4 then
				helper_474c5bc8(10)
			end
			if at <= 5 then
				helper_474c5bc8(90)
			end
			if at <= 6 then
				helper_41c448af(2)
			end
			if at <= 7 then
				helper_a88b23ab()
			end
			if at <= 8 then
				helper_474c5bc8(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SpriteSetDraw(0, 0)
		event.SndSeStop(var0, 0)
		event.CharaActive(0)
		event.CharaActive(8)
		event.CharaActive(9)
		event.SetStatus(1, 0, 256, 0)
		event.EohSetFootSoundId(0, 0)
		event.EohSetFootSoundId(1, 0)
		event.DelExtMotion(0)
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DelImg(0)
		event.LoadMes(0, -1)
		event.CharaActive(0)
		event.SetCharaPos(0, 4036.58, 1622.31, -1856.87)
		event.SetCharaRot(0, 0.0, -2.05, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		if vm.wait() then
			return skip(11)
		end
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7836)
	var0 = event.SndLoadSound(7836) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("dungeon/monster/")
	event.LoadChara(5, "e214e.gltf", "e214e", 10)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.ChangeDir("")
	event.ChangeDir("event/e700/e728/")
	event.LoadMes(0, 5, "e728.txt")
	if active_chr_no == 0 then
		event.LoadMotion(5, "e728_mints.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(0, 0)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
	end
	if active_chr_no == 1 then
		event.LoadMotion(5, "e728_monica.gltf", "info", 0)
		event.CharaActive(0)
		event.EohSyncChara(1, 0)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
	end
	block = event.LoadImg_4(5, "e728telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e728telop01", block)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 256, 312)
	event.SpriteSetDraw(0, 1)
	event.EohSyncSprite(3, 0)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.ChangeDir("")
	if active_chr_no == 1 then
		event.LoadChara(5, "chara/c01_base.gltf", "info", 8)
		event.LoadEquip(5, 0, 4, "info", 8)
		event.LoadEquip(5, 0, 3, "info", 8)
		event.LoadEquip(5, 0, 2, "info", 8, 9)
		event.LoadMotion(5, "event/e700/e728/e728_mints.gltf", "info", 8)
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
		event.LoadMotion(5, "event/e700/e728/e728_monica.gltf", "info", 8)
		event.LoadMotion(5, "event/basic_evmot/monica_set.gltf", "info", 8)
		event.EohSyncChara(1, 8)
		event.ObjsInit(1)
		event.ObjsSyncObj(1, 1)
		event.LoadMotion(5, "event/basic_evmot/mints_set.gltf", "info", 0)
	end
	event.CharaActive(8)
	event.CharaActive(9)
	event.EohSetPos(1, 4028.5, 1622.31, -1892.41)
	event.EohSetRot(1, 0.0, -1.54, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, 4034.32, 1622.31, -1873.58)
	event.EohSetRot(0, 0.0, -1.69, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 4329.53, 1541.01, -1873.11)
	event.EohSetRot(2, 0.0, 2.9, 0.0)
	event.EohSetFootSoundId(2, 2)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CmrsInit()
	event.CmrsSetPos(3987.77, 1635.56, -1881.54)
	event.CmrsSetRef(4044.8, 1645.92, -1884.2)
	event.SetProjection(524.9)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "上向く", 6)
	event.ObjsNextMotion(0, "上向くL", 4)
	event.ObjsSetMotion(1, "上向く", 6)
	event.ObjsNextMotion(1, "上向くL", 4)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "まばたき目パチ")
	event.ObjsTexAnime(0, 1, "半口")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おどろき目パチ")
	helper_474c5bc8(60)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "おこり顔")
	event.ObjsTexAnime(1, 1, "おこり目パチ")
	event.ObjsSetMotion(0, "上→右", 6)
	event.ObjsNextMotion(0, "右向くL", 4)
	event.ObjsSetMotion(1, "上から左", 6)
	event.ObjsNextMotion(1, "左向くL", 4)
	helper_474c5bc8(60)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(4119.77, 1673.4, -1851.32)
	event.CmrsSetRef(3992.15, 1648.49, -1851.49)
	event.SetProjection(300.9)
	event.SndSePlay(var0, 0)
	event.CmrsMove(9389.19, 2315.05, -1704.48, 8139.49, 2508.8, -1483.43, 300)
	helper_a88b23ab()
	if vm.skipping() then
		return skip(3)
	end
	helper_474c5bc8(20)
	if vm.skipping() then
		return skip(4)
	end
	helper_474c5bc8(10)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(3887.54, 1636.19, -1974.75)
	event.CmrsSetRef(4005.51, 1653.83, -1855.26)
	event.SetProjection(524.9)
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetPos(0, 4036.58, 1622.31, -1856.87)
	event.ObjsSetRot(0, 0.0, -2.05, 0.0)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 4032.15, 1622.31, -1892.75)
	event.ObjsSetRot(1, 0.0, -1.54, 0.0)
	event.ObjsResetDaPosition(1)
	event.ObjsSetPos(2, 3919.19, 1729.55, -1864.92)
	event.ObjsSetRot(2, 0.0, 1.5, 0.0)
	event.ObjsResetDaPosition(2)
	event.ObjsMove(2, 3919.19, 1622.31, -1864.92, 20)
	event.ObjsSetMotion(2, "落下", 6)
	event.ObjsMotionDelay(2, 20)
	event.ObjsNextMotion(2, "着地", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	event.SndSePlay(var0, 1)
	event.CmrsQuakeDelay(20)
	event.CmrsQuake(0.0, 1.0, 0.0, 30)
	helper_474c5bc8(90)
	if vm.skipping() then
		return skip(6)
	end
	helper_41c448af(2)
	if vm.skipping() then
		return skip(7)
	end
	event.CmrsSetPos(4061.29, 1628.51, -1771.93)
	event.CmrsSetRef(3940.77, 1672.13, -1868.07)
	event.ObjsSetPos(0, 4036.58, 1222.31, -1856.87)
	event.ObjsResetDaPosition(0)
	event.ObjsSetPos(1, 4032.15, 1222.31, -1892.75)
	event.ObjsResetDaPosition(1)
	event.CmrsMove(4052.6, 1698.8, -1956.36, 3928.33, 1648.67, -1867.69, 150)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 2)
	event.ObjsSeDelay(2, 90)
	event.ObjsSePlay(2, var0, 3)
	event.ObjsSetMotion(2, "攻撃１", 6)
	event.ObjsNextMotion(2, "攻撃２", 6)
	event.ObjsNextMotion(2, "立ち", 4)
	helper_a88b23ab()
	if vm.skipping() then
		return skip(8)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_474c5bc8(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_dc7a969c
