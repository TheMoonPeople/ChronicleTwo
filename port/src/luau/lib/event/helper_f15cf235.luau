--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f15cf235(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

return helper_f15cf235
