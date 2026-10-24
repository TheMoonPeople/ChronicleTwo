--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8f31f334 = require("@lib/event/helper_8f31f334")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_ffb2ea5d()
	local var0: s32 = 0
	local active_chr_no: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_aafd6a80(30)
			end
			if at <= 2 then
				helper_8f31f334(2)
			end
			if at <= 3 then
				helper_aafd6a80(30)
			end
			if at <= 4 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		if at <= 6 then
			helper_aafd6a80(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		helper_aafd6a80(4)
		if vm.skipping() then
			return skip(7)
		end
		event.LoadBgm(39)
		event.PlayBgm(0)
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
	end
	event.SetFlag(728, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(7603)
	var0 = event.SndLoadSound(7603) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.SetStatus(1, 0, 256, 1)
	event.ChangeDir("event/e700/e728/")
	event.LoadMes(0, 5, "e728_1.txt")
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
	event.LoadChara(5, "e728_dark.gltf", "info", 10, 1)
	event.CharaActive(10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	block = event.LoadImg_4(5, "e728telop06_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e728telop06", block)
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
	event.EohSetPos(1, -1.42, 0.0, -83.64)
	event.EohSetRot(1, 0.0, -0.12, 0.0)
	event.EohSetFootSoundId(1, 2)
	event.EohSetPos(0, -23.19, 0.0, -81.74)
	event.EohSetRot(0, 0.0, 0.26, 0.0)
	event.EohSetFootSoundId(0, 2)
	event.EohSetPos(2, 10.04, 99.12, 177.76)
	event.EohSetRot(2, 0.0, -3.07, 0.0)
	event.EohSetFootSoundId(2, 1)
	event.ObjsSetScale(2, 2.0, 2.0, 2.0)
	event.InitDramaScene()
	event.ObjsSetMotion(1, "立ち", 4)
	event.ObjsSetMotion(0, "立ち", 4)
	event.ObjsSetMotion(2, "立ち", 4)
	event.CharaActive(0)
	event.CharaActive(8)
	event.CharaActive(9)
	event.CharaActive(10)
	event.CmrsInit()
	event.CmrsSetPos(-79.96, 12.55, -243.16)
	event.CmrsSetRef(-22.0, 50.18, -66.57)
	event.SetFadeIn(30)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(1)
	end
	event.FadeOutBgm(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(2)
	end
	event.CmrsSetPos(12.3, 90.7, -58.0)
	event.CmrsSetRef(8.16, 163.3, 185.9)
	event.ObjsSetColor(3, 128, 128, 128, 128, 30)
	event.SndSePlay(var0, 0)
	event.ObjsSetMotion(2, "乱舞", 6)
	event.ObjsNextMotion(2, "乱舞L", 4)
	helper_8f31f334(2)
	if vm.skipping() then
		return skip(3)
	end
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(4)
	end
	event.ObjsSetColor(3, 128, 128, 128, 0, 30)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

return helper_ffb2ea5d
