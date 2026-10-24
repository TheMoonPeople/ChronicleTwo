--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7bc99d2c = require("@lib/event/helper_7bc99d2c")
local helper_f3a90693 = require("@lib/event/helper_f3a90693")

--- Helper function.
local function helper_db452556(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7bc99d2c(1, 4)
			helper_f3a90693(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_7bc99d2c(1, 4)
	helper_f3a90693(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_db452556
