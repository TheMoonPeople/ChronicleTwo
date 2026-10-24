--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_06d6de33(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(60)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMpcharaMotion("p01_train01", "kikan-m0", "機関")
	event.CmrsSetPos(-333.13, 124.81, -2141.66)
	event.CmrsSetRef(-142.51, 84.44, -1891.87)
	event.CharaActive(0, 33)
	event.CharaActive(0, 34)
	event.CharaActive(0, 35)
	event.SndSePlay(arg0, 13)
	event.ObjsMove2(10, -120.0, 0.0, -2100.0, 60, 1, 1.0)
	helper_aafd6a80(60)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_06d6de33
