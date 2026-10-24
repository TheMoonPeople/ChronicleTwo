--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5fe8f3bb = require("@lib/event/helper_5fe8f3bb")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")

--- Helper function.
local function helper_6748e9ac()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_b0211f82(200)
			end
			if at <= 2 then
				helper_b0211f82(270)
			end
			if at <= 3 then
				helper_5fe8f3bb()
			end
			if vm.skip_end() then
				return skip(5)
			end
			return part2()
		end
		if at <= 5 then
			helper_b0211f82(4)
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetStatus(1, 0, 8, 0)
		event.StopBgm(0)
		event.StopEnvBgm()
		helper_b0211f82(4)
		if vm.skipping() then
			return skip(6)
		end
		event.SoundLoadCancel()
		event.MapJump(-1, "m06", 152)
	end
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(618.0)
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EohSyncChara(0, 0)
	event.EohSetFootSoundId(0, 2)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, 367.64, 52.0, 143.02)
	event.ObjsSetRot(0, 0.0, 3.14, 0.0)
	event.ObjsSetMotion(0, "走り")
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 430)
	event.ObjsAddPas(0, 367.64, 52.0, 143.02)
	event.ObjsAddPas(0, 437.18, 52.0, 143.7)
	event.ObjsAddPas(0, 525.69, 4.07, 150.85)
	event.ObjsAddPas(0, 592.54, 4.07, 146.54)
	event.ObjsAddPas(0, 662.48, 0.0, 106.25)
	event.ObjsAddPas(0, 724.99, 0.0, 74.39)
	event.ObjsAddPas(0, 815.37, 0.0, 75.89)
	event.ObjsAddPas(0, 949.64, 0.0, 155.14)
	event.ObjsAddPas(0, 1096.43, 0.0, 260.16)
	event.ObjsAddPas(0, 1196.25, 0.0, 375.44)
	event.ObjsAddPas(0, 1279.57, 0.0, 504.31)
	event.ObjsAddPas(0, 1300.41, 0.0, 606.99)
	event.ObjsStartPas(0)
	event.SetStatus(1, 0, 8, 1)
	event.InitDramaScene()
	event.CmrsInit()
	event.CmrsSetPos(665.91, 81.93, -90.96)
	event.CmrsSetRef(496.81, 61.93, 126.47)
	event.CmrsFadeInit()
	event.CmrsFadeIn(30)
	helper_b0211f82(90)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsSetPos(411.47, 70.02, -81.02)
	event.CmrsSetRef(742.24, 61.93, 120.93)
	event.SetStatus(1, 0, 8, 0)
	event.CmrsInitPas()
	event.CmrsSetPasFrm(500)
	event.CmrsAddPas(366.48, 63.99, -74.02, 504.01, 35.91, 19.16)
	event.CmrsAddPas(376.09, 64.39, -74.07, 513.62, 37.39, 19.11)
	event.CmrsAddPas(383.64, 65.08, -76.39, 522.12, 39.72, 18.44)
	event.CmrsAddPas(393.5, 65.72, -75.66, 529.18, 42.2, 17.46)
	event.CmrsAddPas(397.26, 66.22, -77.95, 534.79, 47.76, 15.23)
	event.CmrsAddPas(403.26, 66.95, -79.13, 540.79, 58.7, 14.05)
	event.CmrsAddPas(408.35, 67.87, -80.75, 545.88, 84.01, 12.43)
	event.CmrsAddPas(409.92, 69.25, -82.46, 547.44, 114.61, 10.72)
	event.CmrsAddPas(413.71, 70.4, -82.7, 551.24, 185.45, 10.48)
	event.CmrsStartPas()
	helper_b0211f82(200)
	if vm.skipping() then
		return skip(2)
	end
	helper_b0211f82(270)
	if vm.skipping() then
		return skip(3)
	end
	event.CmrsFadeInit()
	event.CmrsFadeOut(30)
	helper_5fe8f3bb()
	if vm.skipping() then
		return skip(4)
	end
	return part2()
end

return helper_6748e9ac
