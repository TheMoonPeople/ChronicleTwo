--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_baf4fdf4()
	local time: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(4)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(39)
	event.PlayBgm(0)
	time = event.GetTime() or time
	event.SetCnt(10, time)
	event.SetTime(24.0)
	event.SetTimeStepEnable(0)
	event.LoadMonsterFile(621, 1)
	event.LoadMonsterFile(622, 0)
	event.AutoSetMonster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.AutoSetMonster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
	event.Stopwatch(3, 350, 370, 1)
	event.Stopwatch(2, 18000)
	event.Stopwatch_1(0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(30)
	event.Finish()
end

return helper_baf4fdf4
