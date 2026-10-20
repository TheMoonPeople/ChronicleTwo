--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_212f6fed = require("@lib/event/helper_212f6fed")
local helper_23161f99 = require("@lib/event/helper_23161f99")
local helper_523e9e7f = require("@lib/event/helper_523e9e7f")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_e543d0f3 = require("@lib/event/helper_e543d0f3")

--- Helper function.
local function helper_1a48175d()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 5 then
			if at <= 1 then
				helper_523e9e7f(var0)
			end
			if at <= 2 then
				helper_e543d0f3(var0)
			end
			if at <= 3 then
				helper_212f6fed(var0)
				helper_23161f99(var0)
			end
			if at <= 4 then
				helper_adea7ba0(15)
			end
			if vm.skip_end() then
				return skip(6)
			end
			return part2()
		end
		if at <= 6 then
			helper_adea7ba0(4)
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
		helper_adea7ba0(4)
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
	helper_adea7ba0(4)
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
	helper_523e9e7f(var0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "ポカーン顔")
	event.ObjsTexAnime(0, 1, "ぱちぱち")
	helper_e543d0f3(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_212f6fed(var0)
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "わらい顔")
	helper_23161f99(var0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetFadeOut(15)
	helper_adea7ba0(15)
	if vm.skipping() then
		return skip(5)
	end
	return part2()
end

return helper_1a48175d
