--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_261c70db = require("@lib/event/helper_261c70db")

--- Helper function.
local function helper_1a842043(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_261c70db()
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetCameraPos(-393.89, 100.04, -2.57)
	event.SetCameraRef(-194.23, 107.31, -159.8)
	event.CharaActive(0, 0)
	event.CharaActive(0, 9)
	event.CmrsMove2(-393.89, 100.04, -2.57, -266.2, 107.31, 189.14, 150, 0, 0.4)
	helper_261c70db()
	if vm.skipping() then
		return skip(2)
	end
end

return helper_1a842043
