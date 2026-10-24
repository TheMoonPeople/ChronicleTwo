--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_377e162e = require("@lib/event/helper_377e162e")
local helper_daa12212 = require("@lib/event/helper_daa12212")

--- Helper function.
local function helper_ddd6201f(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_377e162e(1, 4)
			helper_daa12212(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_377e162e(1, 4)
	helper_daa12212(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_ddd6201f
