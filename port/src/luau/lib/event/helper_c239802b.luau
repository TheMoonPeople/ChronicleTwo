--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bf3cde9 = require("@lib/event/helper_0bf3cde9")
local helper_b055e396 = require("@lib/event/helper_b055e396")

--- Helper function.
local function helper_c239802b(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0bf3cde9(1, 4)
			helper_b055e396(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_0bf3cde9(1, 4)
	helper_b055e396(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_c239802b
