--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_ebb00530()
	local time: f32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_efffcfbb(60)
			end
			if at <= 2 then
				helper_efffcfbb(10)
			end
			if vm.skip_end() then
				return skip(4)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.SetProjection(524.9)
		event.EohSetShow(0, 1)
		event.SetTime(time)
		event.SetTimeStepEnable(1)
		event.CharaActive(0)
	end
	event.SetFlag(540, 1)
	event.Initialize()
	event.SetMesWindowMode(0, 7)
	event.SetProjection(300.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(1)
	end
	event.ChangeDir("event/e500/e540/")
	event.EohSyncObj(0, "p03_s55")
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ChangeDir("")
	time = event.GetTime() or time
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.CmrsInit()
	event.CmrsSetPos(-403.87, 5081.46, 8018.1)
	event.CmrsSetRef(-207.83, 4340.06, 7830.0)
	event.InitDramaScene()
	event.SetFadeIn(0)
	helper_efffcfbb(60)
	if vm.skipping() then
		return skip(2)
	end
	helper_efffcfbb(10)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(0)
	return part2()
end

return helper_ebb00530
