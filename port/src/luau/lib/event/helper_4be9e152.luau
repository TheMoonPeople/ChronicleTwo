--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_93bb7fa4 = require("@lib/event/helper_93bb7fa4")
local helper_e8f4b85c = require("@lib/event/helper_e8f4b85c")

--- Helper function.
local function helper_4be9e152()
	local var0: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 6 then
			if at <= 1 then
				helper_2f481f12(90)
			end
			if at <= 2 then
				helper_93bb7fa4(3160010)
			end
			if at <= 3 then
				helper_e8f4b85c(0)
			end
			if at <= 4 then
				helper_93bb7fa4(3160020)
			end
			if at <= 5 then
				helper_2f481f12(30)
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
		event.DelExtMotion(13)
		event.CharaActive(0, 8)
		event.CharaActive(0, 9)
		event.CharaActive(0, 10)
		event.CharaActive(0, 11)
		event.CharaActive(0, 12)
		event.DelReference(15)
		event.CharaActive(0, 15)
		event.LoadMes(0, -1)
		event.Finish()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(316, 1)
	event.SetCameraPos(-88.57, 74.62, 1267.26)
	event.SetCameraRef(20.74, 79.67, 1276.18)
	event.StopBgm(0)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	var0 = event.SndLoadSound(8, "snd2/sp/sp_000.sound.json") or var0
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetStatusbarShow(0, 1.0)
	event.GetActiveChrNo()
	event.LoadMes(0, 5, "event/e300/e316/e316_1.txt")
	event.LoadMotion(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.LoadMotion(5, "event/e300/e316/e316_mints.gltf", "info", 0)
	event.CharaActive(0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.DelExtMotion(13)
	event.LoadMotion(5, "event/e300/e316/e316_monica.gltf", "info", 13)
	event.EohSyncChara(1, 13)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.EohSetPos(0, -1.4, 62.34, 1267.0)
	event.EohSetRot(0, 0.0, -2.68, 0.0)
	event.EohSetMotion(0, "立ち", 4)
	event.EohSetTexAnim(0, 0)
	event.EohSetTexAnim(0, 1, "デフォルト顔")
	event.EohSetTexAnim(0, 1, "通常目パチ")
	event.EohSetPos(1, -18.67, 62.68, 1288.34)
	event.EohSetRot(1, 0.0, -2.66, 0.0)
	event.EohSetMotion(1, "立ち", 4)
	event.EohSetTexAnim(1, 0)
	event.EohSetTexAnim(1, 1, "デフォルト顔")
	event.EohSetTexAnim(1, 1, "通常目パチ")
	event.CharaNormalDrive(13)
	event.CharaResetDa(13)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(-0.23, 74.74, 1183.98)
	event.CmrsSetRef(-6.52, 79.67, 1277.87)
	event.CmrsMove2(-1.7, 74.74, 1206.03, -6.52, 79.67, 1277.87, 90, 2, 0.3)
	event.SndSePlay(var0, 0)
	event.SetFadeIn(30)
	event.ObjsSetMotion(0, "カップインポーズ", 6)
	event.ObjsNextMotion(0, "カップインポーズL", 4)
	helper_2f481f12(90)
	if vm.skipping() then
		return skip(2)
	end
	event.SetPakuAnim(0, "わらい口パク")
	helper_93bb7fa4(3160010)
	if vm.skipping() then
		return skip(3)
	end
	helper_e8f4b85c(0)
	if vm.skipping() then
		return skip(4)
	end
	event.SetPakuAnim(1, "わらい口パク")
	helper_93bb7fa4(3160020)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFadeOut(30)
	helper_2f481f12(30)
	if vm.skipping() then
		return skip(6)
	end
	return part2()
end

return helper_4be9e152
