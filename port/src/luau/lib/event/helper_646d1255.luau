--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_156b7abc = require("@lib/event/helper_156b7abc")
local helper_26d3825b = require("@lib/event/helper_26d3825b")
local helper_664f3040 = require("@lib/event/helper_664f3040")
local helper_822c13cb = require("@lib/event/helper_822c13cb")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")
local helper_cb6ceba4 = require("@lib/event/helper_cb6ceba4")
local helper_d38ab34f = require("@lib/event/helper_d38ab34f")

--- Helper function.
local function helper_646d1255()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_d38ab34f(var0)
			end
			if at <= 2 then
				helper_156b7abc(var0)
			end
			if at <= 3 then
				helper_664f3040(var0)
			end
			if at <= 4 then
				helper_822c13cb(var0)
			end
			if at <= 5 then
				helper_26d3825b(var0)
				helper_cb6ceba4(var0)
				helper_b51fc149(30)
			end
			if vm.skip_end() then
				return skip(7)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SndSeStop(var0, 0)
		event.DelExtMotion(0)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(108, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetStatusbarShow(0, 1.0)
	var0 = event.SndLoadSound(1822) or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.CmrsInit()
	event.SetCameraPos(6.02, 94.24, 399.23)
	event.SetCameraRef(-4.96, 118.28, 117.71)
	event.LoadMotion(5, "event/e100/e108/e108_mints.gltf", "info", 0)
	event.CharaActive(1, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.SetCharaPos(0, 0.0, 50.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_steve.gltf", "info", 9)
	event.CharaActive(1, 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.SetCharaPos(9, 0.0, 50.0, 0.0)
	event.SetCharaRot(9, 0.0, 0.0, 0.0)
	event.EohSetSoundId(1, var1)
	event.LoadChara(5, "event/e100/e108/e108_erephant.gltf", "info", 10)
	event.CharaActive(0, 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.SetCharaPos(10, 0.0, 50.0, 0.0)
	event.SetCharaRot(10, 0.0, 0.0, 0.0)
	event.LoadChara(5, "event/e100/e108/e108_polcurse.gltf", "info", 11)
	event.CharaActive(0, 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.SetCharaPos(11, 0.0, 50.0, 0.0)
	event.SetCharaRot(11, 0.0, 0.0, 0.0)
	event.SetTexAnim(11, 0, "口パク")
	event.EohSyncChara(10, 1)
	event.EohSetShow(10, 0)
	event.EohSyncChara(11, 2)
	event.EohSetShow(11, 0)
	event.LoadMes(0, 5, "event/e100/e108/e108b_1.txt")
	event.StopBgm(0)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おこり顔")
	event.ObjsTexAnime(0, 1, "おこり目パチ")
	event.ObjsTexAnime(3, 0)
	event.ObjsTexAnime(3, 1, "たかわらい顔")
	event.EohSetSoundId(1, var0)
	event.InitDramaScene()
	helper_d38ab34f(var0)
	if vm.skipping() then
		return skip(2)
	end
	helper_156b7abc(var0)
	if vm.skipping() then
		return skip(3)
	end
	helper_664f3040(var0)
	if vm.skipping() then
		return skip(4)
	end
	helper_822c13cb(var0)
	if vm.skipping() then
		return skip(5)
	end
	helper_26d3825b(var0)
	helper_cb6ceba4(var0)
	event.SetFadeOut(30)
	helper_b51fc149(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

return helper_646d1255
