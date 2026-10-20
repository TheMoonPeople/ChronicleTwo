--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6f70f976 = require("@lib/event/helper_6f70f976")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e5dca676 = require("@lib/event/helper_e5dca676")

--- Helper function.
local function helper_d2316041()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e5dca676()
		end
		if at <= 2 then
			helper_6f70f976(64)
		end
	end
	event.Initialize()
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetPos(0, -215.0, 12.66, 60.0)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.ObjsSetMotion(0, "走り")
	event.ObjsTexAnime(0, 0)
	event.EohSyncObj(1, "p01_train01")
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.ObjsSetPos(1, 0.0, -24.0, -1800.0)
	event.ObjsSetRot(1, 0.0, 0.0, 0.0)
	event.SetTime(7.0)
	event.SetTimeStepEnable(1)
	event.CmrsInit()
	event.CmrsSetPos(-746.57, 16.36, 156.44)
	event.CmrsSetRef(-199.21, 142.65, 471.29)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	event.CmrsMove(-701.67, 16.36, 428.3, -154.32, 142.65, 743.14, 400)
	event.ObjsMove(0, -215.0, 12.66, 1700.0, 460)
	event.ObjsMove(1, 0.0, -24.0, 5000.0, 260)
	helper_e5dca676()
	if vm.skipping() then
		return skip(2)
	end
	helper_6f70f976(64)
	if vm.skipping() then
		return skip(3)
	end
end

return helper_d2316041
