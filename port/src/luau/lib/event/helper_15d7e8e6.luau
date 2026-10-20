--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06d6de33 = require("@lib/event/helper_06d6de33")
local helper_392556bf = require("@lib/event/helper_392556bf")
local helper_53d6cf91 = require("@lib/event/helper_53d6cf91")
local helper_6bf1b541 = require("@lib/event/helper_6bf1b541")
local helper_7ea1bd46 = require("@lib/event/helper_7ea1bd46")
local helper_8c5b31a1 = require("@lib/event/helper_8c5b31a1")
local helper_8eff3290 = require("@lib/event/helper_8eff3290")
local helper_957385c2 = require("@lib/event/helper_957385c2")
local helper_9d522960 = require("@lib/event/helper_9d522960")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b0bc344a = require("@lib/event/helper_b0bc344a")
local helper_cd920289 = require("@lib/event/helper_cd920289")
local helper_ed5fe55d = require("@lib/event/helper_ed5fe55d")

--- Helper function.
local function helper_15d7e8e6()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 13 then
			if at <= 1 then
				helper_957385c2(var0)
			end
			if at <= 2 then
				helper_cd920289(var0)
			end
			if at <= 3 then
				helper_b0bc344a(var0)
			end
			if at <= 4 then
				helper_ed5fe55d(var0)
			end
			if at <= 5 then
				helper_8c5b31a1(var0)
			end
			if at <= 6 then
				helper_7ea1bd46(var0)
			end
			if at <= 7 then
				helper_06d6de33(var0)
			end
			if at <= 8 then
				helper_9d522960(var0)
			end
			if at <= 9 then
				helper_392556bf(var0)
			end
			if at <= 10 then
				helper_6bf1b541(var0)
			end
			if at <= 11 then
				helper_8eff3290(var0)
			end
			if at <= 12 then
				helper_aafd6a80(30)
			end
			if vm.skip_end() then
				return skip(14)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.StopBgm(0)
		event.StopBgm(1)
		event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
		event.SndSeStop(var0, 6)
		event.SndSeStop(var0, 9)
		event.SndSeStop(var0, 10)
		event.CharaActive(1, 0)
		event.EsmClear()
		event.DeleteChara(33)
		event.DeleteChara(34)
		event.DeleteChara(35)
		event.DeleteChara(36)
		event.DeleteChara(38)
		event.DeleteChara(39)
		event.DeleteChara(40)
		event.SetFadeIn(30)
	end
	event.SetFlag(109, 1)
	event.SetFlag(9, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.LoadSound(1246)
	var0 = event.SndLoadSound(1246) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 33)
	event.CharaActive(1, 33)
	event.EohSyncChara(1, 33)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(33, -251.33, 36.72, -1629.09)
	event.SetCharaRot(33, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_vorneo.gltf", "info", 34)
	event.CharaActive(1, 34)
	event.EohSyncChara(2, 34)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(34, -251.33, 36.72, -1629.09)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_tom.gltf", "info", 35)
	event.CharaActive(1, 35)
	event.EohSyncChara(3, 35)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(35, -251.33, 36.72, -1629.09)
	event.SetCharaRot(35, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e109/e109_need.gltf", "info", 36)
	event.CharaActive(0, 36)
	event.EohSyncChara(4, 36)
	event.ObjsInit(4)
	event.ObjsSyncObj(4, 4)
	event.SetCharaPos(36, -251.33, 36.72, -1629.09)
	event.SetCharaRot(36, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e200/e202/e202_train_pika.gltf", "info", 40)
	event.CharaActive(0, 40)
	event.LoadChara(5, "event/train/steam/steam_l.gltf", "info", 38)
	event.CharaActive(0, 38)
	event.EohSyncChara(6, 38)
	event.ObjsInit(6)
	event.ObjsSyncObj(6, 6)
	event.ObjsSetPos(6, -120.0, 0.0, -1690.0)
	event.LoadChara(5, "event/train/steam/steam_r.gltf", "info", 39)
	event.CharaActive(0, 39)
	event.EohSyncChara(7, 39)
	event.ObjsInit(7)
	event.ObjsSyncObj(7, 7)
	event.ObjsSetPos(7, -120.0, 0.0, -1690.0)
	event.EohSyncObj(10, "p01_train01")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, -120.0, 0.0, -1690.0)
	event.EohSyncObj(11, "p41_i02h01", "i02h01_41-m")
	event.ObjsInit(11)
	event.ObjsSyncObj(11, 11)
	event.ObjsSetPos(11, 0.0, 0.0, 0.0)
	event.EohSyncObj(12, "p42_i02h01", "i02h01_42-m")
	event.ObjsInit(12)
	event.ObjsSyncObj(12, 12)
	event.ObjsSetPos(12, 0.0, 0.0, 0.0)
	event.EsmInitialize(5)
	event.EsmLoadBase("列車煙")
	event.EsmInitFix(5)
	event.LoadMes(0, 5, "event/e100/e109/e109b_1.txt")
	event.StopBgm(0)
	event.SndSePlay(var0, 6)
	event.EohSetSoundId(1, var0)
	event.EohSetSoundId(2, var0)
	event.EohSetSoundId(3, var0)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "デフォルト顔")
	event.ObjsTexAnime(1, 1, "通常目パチ")
	event.ObjsTexAnime(2, 0)
	event.ObjsTexAnime(2, 1, "目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "目パチ")
	event.InitDramaScene()
	helper_53d6cf91(var0)
	if vm.skipping() then
		return skip(1)
	end
	helper_957385c2(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_cd920289(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_b0bc344a(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_ed5fe55d(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_8c5b31a1(var0)
	if vm.skipping() then
		return skip(6)
	end
	helper_7ea1bd46(var0)
	if vm.skipping() then
		return skip(7)
	end
	helper_06d6de33(var0)
	if vm.skipping() then
		return skip(8)
	end
	helper_9d522960(var0)
	if vm.skipping() then
		return skip(9)
	end
	helper_392556bf(var0)
	if vm.skipping() then
		return skip(10)
	end
	helper_6bf1b541(var0)
	if vm.skipping() then
		return skip(11)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "停止")
	helper_8eff3290(var0)
	if vm.skipping() then
		return skip(12)
	end
	event.FadeOutBgm(30)
	event.SetFadeOut(30)
	helper_aafd6a80(30)
	if vm.skipping() then
		return skip(13)
	end
	return part2()
end

return helper_15d7e8e6
