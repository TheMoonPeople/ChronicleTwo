--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_73d6f64a = require("@lib/event/helper_73d6f64a")
local helper_7a5e82c7 = require("@lib/event/helper_7a5e82c7")

--- Helper function.
local function helper_585b7236(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7a5e82c7(1, 4)
			helper_73d6f64a(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7a5e82c7(1, 4)
	helper_73d6f64a(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_585b7236
