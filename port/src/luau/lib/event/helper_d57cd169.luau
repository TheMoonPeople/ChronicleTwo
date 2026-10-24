--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")

--- Helper function.
local function helper_d57cd169()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 1
			var0 = var0 + 1
			helper_c1c32f84(30)
		end
		if at <= 2 then
			helper_c1c32f84(70)
		end
		if at <= 3 then
			helper_c1c32f84(30)
		end
		if at <= 4 then
			helper_c1c32f84(20)
		end
		if at <= 6 then
			helper_6f70f976(64)
		end
		var0 = 0
		var0 = var0 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	event.CharaActive(1, 0)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadMotion(5, "event/lm/taxi_ride_c01.gltf", "info", 0)
	event.SetCharaPos(0, 2.0, 0.0, 0.0)
	event.SetCharaRot(0, 0.0, 0.0, 0.0)
	event.SetMotion(0, "タクシー", 5)
	event.LoadChara(5, "event/lm/taxi_ride.gltf", "info", 8)
	event.CharaActive(8)
	event.SetCharaPos(8, 0.0, 0.0, 0.0)
	event.SetCharaRot(8, 0.0, 0.0, 0.0)
	event.ShadowClipOff(8)
	event.SetMotion(8, "歩き", 5)
	event.EohSyncChara(0, 8)
	event.LoadChara(5, "event/lm/kemuri.gltf", "info", 9)
	var0 = 1
	while var0 < 20 do
		event.CopyChara(5, 9, 9 + var0)
		event.CharaActive(9 + var0)
		event.EohSyncChara(1 + var0, 9 + var0)
		event.ObjsInit(1 + var0)
		event.ObjsSyncObj(1 + var0, 1 + var0)
		event.ObjsSetMotion(1 + var0, "煙", 1)
		event.ObjsMotionDelay(1 + var0, var0 * 4)
		event.ObjsSetMotion(1 + var0, "煙", 4)
		event.ObjsPosDelay(1 + var0, var0 * 4)
		event.ObjsSetEohFramePos(1 + var0, 0, "null10")
		event.ObjsAddPos(1 + var0, 0.0, 0.0, -15.0, 66)
		event.ObjsSetEohFramePos(1 + var0, 0, "null10")
		event.ObjsAddPos(1 + var0, 0.0, 0.0, -15.0, 66)
		event.ObjsSetEohFramePos(1 + var0, 0, "null10")
		event.ObjsAddPos(1 + var0, 0.0, 0.0, -15.0, 66)
		var0 = var0 + 1
	end
	event.EohSyncChrobj(27, 8, "null43")
	event.ObjsInit(27)
	event.ObjsSyncObj(27, 27)
	event.ObjsRotation(27, 0.5, 0.0, 0.0, -1)
	event.EohSyncChrobj(28, 8, "null42")
	event.ObjsInit(28)
	event.ObjsSyncObj(28, 28)
	event.ObjsRotation(28, 0.5, 0.0, 0.0, -1)
	event.EohSyncChrobj(29, 8, "null40")
	event.ObjsInit(29)
	event.ObjsSyncObj(29, 29)
	event.ObjsRotation(29, -0.5, 0.0, 0.0, -1)
	event.EohSyncChrobj(30, 8, "null41")
	event.ObjsInit(30)
	event.ObjsSyncObj(30, 30)
	event.ObjsRotation(30, -0.5, 0.0, 0.0, -1)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(80)
	event.CmrsAddPas(-254.12, 158.05, 537.66, -149.78, 133.31, 345.96)
	event.CmrsAddPas(-79.6, 129.85, 505.93, -22.8, 105.11, 294.58)
	event.CmrsAddPas(60.12, 79.21, 475.99, 86.98, 63.38, 252.64)
	event.CmrsAddPas(134.1, 47.23, 375.1, 147.87, 38.33, 161.01)
	event.CmrsAddPas(106.4, 32.81, 164.74, 167.34, 33.34, -19.58)
	event.CmrsAddPas(92.2, 32.81, 138.53, 170.11, 34.94, -37.23)
	event.CmrsAddPas(81.84, 24.85, 92.91, 175.81, 36.59, -74.81)
	event.CmrsAddPas(77.43, 24.85, 58.38, 188.12, 39.2, -115.19)
	event.CmrsAddPas(67.34, 20.59, 18.63, 190.84, 41.62, -141.79)
	event.CmrsStartPas()
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMotion(0, "タクシー", 6)
	event.SetMotion(8, "歩き", 6)
	helper_c1c32f84(70)
	if vm.skipping() then
		return skip(3)
	end
	event.EohSyncChara(1, 0)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CmrsSetPos(194.83, 44.0, -85.18)
	event.CmrsSetRef(207.25, 40.97, -133.77)
	event.CmrsSyncObj(1, 0.0, 20.0, 0.0, 0.0, 5.0, 50.0, "ground", 2)
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	event.ObjsTexAnime(1, 1, "右向き")
	event.ObjsTexAnime(1, 1, "戻り")
	event.ObjsTexaDelay(1, 20)
	event.ObjsTexAnime(1, 0)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(4)
	end
	event.CmrsReleaseObj()
	event.CmrsSetPos(269.01, 71.1, -486.92)
	event.CmrsSetRef(263.41, 40.72, -356.08)
	helper_c1c32f84(20)
	if vm.skipping() then
		return skip(5)
	end
	event.CmrsSetPos(386.76, 16.92, 500.03)
	event.CmrsSetRef(277.73, 31.35, 236.22)
	event.CmrsMove(386.76, 16.92, 500.03, 239.86, 54.62, 255.09, 20)
	event.CmrsPrSlowing(0.96, 30)
	if vm.wait() then
		return skip(6)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(7)
	end
	event.DeleteChara(8)
	var0 = 0
	while var0 < 31 do
		event.DeleteChara(9 + var0)
		var0 = var0 + 1
	end
	event.DelExtMotion(0)
end

return helper_d57cd169
