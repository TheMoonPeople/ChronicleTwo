--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_96c5d43c = require("@lib/event/helper_96c5d43c")
local helper_a77b24cf = require("@lib/event/helper_a77b24cf")

--- Helper function.
local function helper_42c015b5(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_96c5d43c(1, 4)
			helper_a77b24cf(1, vm.i32(60 + arg0), 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(1, 4)
	helper_96c5d43c(1, 4)
	helper_a77b24cf(1, vm.i32(60 + arg0), 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_42c015b5
