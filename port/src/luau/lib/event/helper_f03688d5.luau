--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0299f34d = require("@lib/event/helper_0299f34d")
local helper_1d5461ce = require("@lib/event/helper_1d5461ce")
local helper_2a417f24 = require("@lib/event/helper_2a417f24")
local helper_2d95cd8b = require("@lib/event/helper_2d95cd8b")
local helper_341322c2 = require("@lib/event/helper_341322c2")
local helper_5204ac68 = require("@lib/event/helper_5204ac68")
local helper_690ecd8a = require("@lib/event/helper_690ecd8a")
local helper_7f3edc7c = require("@lib/event/helper_7f3edc7c")
local helper_8ab3b21e = require("@lib/event/helper_8ab3b21e")
local helper_cc339a40 = require("@lib/event/helper_cc339a40")
local helper_f49dcfa8 = require("@lib/event/helper_f49dcfa8")

--- Helper function.
local function helper_f03688d5()
	local var0: s32 = 0
	local block: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 11 then
			if at <= 1 then
				helper_2a417f24(var0)
			end
			if at <= 2 then
				helper_cc339a40(var0)
			end
			if at <= 3 then
				helper_2d95cd8b(var0)
			end
			if at <= 4 then
				helper_1d5461ce(var0)
			end
			if at <= 5 then
				helper_7f3edc7c(var0)
			end
			if at <= 6 then
				helper_0299f34d(var0)
			end
			if at <= 7 then
				helper_8ab3b21e(var0)
				helper_f49dcfa8(var0)
			end
			if at <= 8 then
				helper_341322c2(var0)
			end
			if at <= 9 then
				helper_5204ac68(var0)
			end
			if at <= 10 then
				helper_690ecd8a(30)
			end
			if vm.skip_end() then
				return skip(12)
			end
			return part2()
		end
		if at <= 12 then
			helper_690ecd8a(4)
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
		helper_690ecd8a(4)
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
	event.LoadMes(0, 5, "event/e100/e107/e107.txt")
	block = event.LoadImg_4(5, "textures/event/e100/e107/e107telop01.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetTexture(0, "e107telop01", block)
	event.SpriteSetUvsize(0, 0, 0, 512, 128)
	event.SpriteSetPutsize(0, 512, 128)
	event.SpriteSetPos(0, 320, 334)
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
	helper_690ecd8a(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(105)
	event.EohSetSoundId(3, var0)
	event.InitDramaScene()
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "無表情")
	event.ObjsTexAnime(0, 1, "通常目パチ")
	helper_2a417f24(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_cc339a40(var0)
	if vm.skipping() then
		return skip(3)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち")
	helper_2d95cd8b(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_1d5461ce(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_7f3edc7c(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_0299f34d(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_8ab3b21e(var0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "びっくり顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち2")
	helper_f49dcfa8(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_341322c2(var0)
	if vm.skipping() then
		return skip(9)
	end
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	helper_5204ac68(var0)
	if vm.skipping() then
		return skip(10)
	end
	event.ObjsSetColor(20, 128.0, 128.0, 128.0, 0.0, 15)
	event.SetFadeOut(30)
	helper_690ecd8a(30)
	if vm.skipping() then
		return skip(11)
	end
	return part2()
end

return helper_f03688d5
