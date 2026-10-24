--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_184013af = require("@lib/event/helper_184013af")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_53d6cf91(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(4)
		end
	end
	event.SetCrossfade(1, 1, 60)
	event.CmrsSetPos(14.46, 268.16, 737.45)
	event.CmrsSetRef(-30.4, 237.84, 510.02)
	event.CmrsMove2(-72.53, 268.16, 754.61, -117.4, 237.84, 527.18, 120, 2, 0.4)
	helper_184013af()
	if vm.skipping() then
		return skip(1)
	end
	event.StopBgm(0)
	helper_aafd6a80(4)
	if vm.skipping() then
		return skip(2)
	end
	event.LoadBgm(193)
end

return helper_53d6cf91
