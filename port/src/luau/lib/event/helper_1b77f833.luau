--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04f0a514 = require("@lib/event/helper_04f0a514")
local helper_644574d8 = require("@lib/event/helper_644574d8")

--- Helper function.
local function helper_1b77f833(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_644574d8(1, 4)
			helper_04f0a514(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_644574d8(1, 4)
	helper_04f0a514(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_1b77f833
