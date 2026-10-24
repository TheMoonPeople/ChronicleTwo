--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_fc987dac()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 9 then
			if at <= 1 then
				helper_c1c32f84(285)
			end
			if at <= 2 then
				helper_c1c32f84(165)
			end
			if at <= 3 then
				helper_c1c32f84(90)
			end
			if at <= 4 then
				helper_c1c32f84(450)
			end
			if at <= 5 then
				helper_c1c32f84(30)
			end
			if at <= 6 then
				helper_c1c32f84(90)
			end
			if at <= 7 then
				helper_c1c32f84(190)
			end
			if at <= 8 then
				helper_c1c32f84(30)
			end
			if vm.skip_end() then
				return skip(10)
			end
			return part2()
		end
		if at <= 11 then
			helper_c1c32f84(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.EohSetFootSoundId(0, 0)
		event.DelExtMotion(0)
		event.CmrsReleaseObj()
		event.SetCameraPos(-559.4, 187.73, -249.37)
		event.SetCameraRef(-556.51, 162.33, -127.3)
		event.SetCharaPos(0, -557.84, 132.17, -142.95)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		if vm.wait() then
			return skip(11)
		end
		event.EohSetFootSoundId(0, 0)
		event.StopBgm(0)
		helper_c1c32f84(4)
		if vm.skipping() then
			return skip(12)
		end
		event.LoadBgm(193)
		event.PlayBgm(0)
		event.ResetCamera(1, 0.0, 20.0)
		event.SetFadeIn(30)
	end
	event.SetFlag(201, 1)
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetMesWindowMode(0, 7)
	event.LoadMotion(5, "event/e200/e201/e201_mints.gltf", "info", 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsTexAnime(0, 0)
	event.ObjsTexAnime(0, 1, "おどろき顔")
	event.ObjsTexAnime(0, 1, "おどろき目パチ")
	event.SetFadeOut(0)
	event.StopBgm(0)
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(1)
	end
	event.LoadBgm(111)
	event.PlayBgm(0)
	event.CmrsSetPos(-560.0, 157.51, -568.46)
	event.CmrsSetRef(-560.0, 157.27, -483.32)
	event.SetFadeIn(30)
	event.InitDramaScene()
	event.EohSyncObj(10, "p01_train01")
	event.ObjsInit(10)
	event.ObjsSyncObj(10, 10)
	event.ObjsSetPos(10, 0.0, -24.0, -1000.0)
	event.ObjsSetPos(0, -560.0, 132.17, -500.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsMove(0, -560.0, 132.17, -300.0, 270)
	helper_c1c32f84(285)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -300.0)
	event.ObjsMove(0, -560.0, 132.17, -100.0, 255)
	event.CmrsSyncObj(0, 0.0, 25.0, 0.0, 0.55, -1.91, 34.9)
	helper_c1c32f84(165)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSetFootSoundId(0, -1)
	event.CmrsFadeInit()
	event.CmrsFadeOut(90, 200, 200, 200)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsReleaseObj()
	event.CmrsInit()
	event.CmrsSetRef(-567.88, 154.74, -22.62)
	event.CmrsSetAhd(1.68, -0.34, 88.57)
	event.CmrsMoveAhd2(-1.72, -0.34, 88.57, 360, 0, 0.2)
	event.CmrsFadeIn(90, 200, 200, 200)
	helper_c1c32f84(450)
	if vm.skipping() then
		return skip(5)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -200.0)
	event.ObjsMove(0, -560.0, 132.17, -100.0, 120)
	event.CmrsInit()
	event.CmrsSetPos(-785.67, 205.49, 52.24)
	event.CmrsSetRef(-512.83, 162.33, -212.01)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(6)
	end
	event.CmrsMove2(-3101.09, 205.49, 1822.12, -512.83, 162.33, -212.01, 210, 0, 0.2)
	helper_c1c32f84(90)
	if vm.skipping() then
		return skip(7)
	end
	event.ObjsSetPos(0, -560.0, 132.17, -100.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "立ち", 4)
	helper_c1c32f84(190)
	if vm.skipping() then
		return skip(8)
	end
	event.SetFadeOut(30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(9)
	end
	return part2()
end

return helper_fc987dac
