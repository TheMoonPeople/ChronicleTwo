--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1901b956 = require("@lib/event/helper_1901b956")
local helper_1a842043 = require("@lib/event/helper_1a842043")
local helper_36fd7669 = require("@lib/event/helper_36fd7669")
local helper_39b18f99 = require("@lib/event/helper_39b18f99")
local helper_501d8cbf = require("@lib/event/helper_501d8cbf")
local helper_532bf9f4 = require("@lib/event/helper_532bf9f4")
local helper_62408eeb = require("@lib/event/helper_62408eeb")
local helper_7b294026 = require("@lib/event/helper_7b294026")
local helper_9c9fa0c2 = require("@lib/event/helper_9c9fa0c2")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_cf7fd64c = require("@lib/event/helper_cf7fd64c")

--- Helper function.
local function helper_6c7b36cf()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_39b18f99(var0)
			end
			if at <= 2 then
				helper_501d8cbf(var0)
			end
			if at <= 3 then
				helper_532bf9f4(var0)
			end
			if at <= 4 then
				helper_1a842043(var0)
			end
			if at <= 5 then
				helper_cf7fd64c(var0)
			end
			if at <= 6 then
				helper_9c9fa0c2(var0)
			end
			if at <= 7 then
				helper_1901b956(var0)
				helper_36fd7669(var0)
			end
			if at <= 8 then
				helper_7b294026(var0)
			end
			if at <= 9 then
				helper_62408eeb(var0)
			end
			if at <= 10 then
				helper_adea7ba0(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		if at <= 12 then
			helper_adea7ba0(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EsmClear()
		event.SndSeStop(var0, 0)
		event.EohSyncChara(10, 1)
		event.EohSetShow(10, 1)
		event.EohSyncChara(11, 2)
		event.EohSetShow(11, 1)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(11)
		event.ResetCamera(0)
		event.DngSetupMainUnit(2)
		event.SetActiveChrNo(2)
		event.EohSetShadow(2, 1)
		event.DeleteChara(10)
		event.SpriteSetDraw(0, 0)
		event.DelImg(0)
		event.SetCameraPos(-372.02, 97.7, 1.24)
		event.SetCameraRef(-275.93, 89.37, -1.57)
		event.ResetCamera(0)
		event.StopBgm(0)
		helper_adea7ba0(4)
		if vm.skipping() then
			return skip(13)
		end
		event.LoadBgm(190)
		event.PlayBgm(0)
		event.ObjsInit(0)
		event.ObjsInit(1)
		event.CharaActive(1, 0)
		event.SetCharaPos(0, -240.84, 50.0, -5.32)
		event.SetCharaRot(0, 0.0, 1.6, 0.0)
		event.SetFadeIn(30)
		event.SetStatusbarShow(1)
		event.AutoSetMonster(601, 10.66, 50.0, -0.04, 0.0, -1.5707964, 0.0)
		event.Finish()
	end
	event.SetFlag(107, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	event.SetFadeOut(0)
	event.BgmLoadEnable()
	event.SoundLoadEnable()
	event.BgmPlayEnable()
	event.LoadSound(1816)
	var0 = event.SndLoadSound(1816) or var0
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
	event.LoadChara(5, "event/e100/e107/e107_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, 50.0, 0.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
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
	event.EohSyncChara(10, 2)
	event.EohSetShow(10, 0)
	event.LoadMes(0, 5, "event/e100/e107/e107_1.txt")
	block = event.LoadImg_4(5, "textures/event/e100/e107/e107telop01_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e107telop01", block)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 320, 318)
	event.SpriteSetColor(0, 128, 128, 128, 0)
	event.SpriteSetScale(0, 1.0, 1.0)
	event.SpriteSetDraw(0, 0)
	event.EohSyncSprite(20, 0)
	event.ObjsInit(20)
	event.ObjsSyncObj(20, 20)
	event.EsmInitialize(5, 1)
	event.EsmLoadBase("砂煙e107")
	event.EsmInitFix(5)
	event.StopBgm(0)
	helper_adea7ba0(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.EohSetSoundId(3, var0)
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_39b18f99(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_501d8cbf(var0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち")
	helper_532bf9f4(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1a842043(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_cf7fd64c(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_9c9fa0c2(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_1901b956(var0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "びっくり顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち2")
	helper_36fd7669(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_7b294026(var0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	helper_62408eeb(var0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 0.0, 15)
	event.SetFadeOut(30)
	helper_adea7ba0(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

return helper_6c7b36cf
