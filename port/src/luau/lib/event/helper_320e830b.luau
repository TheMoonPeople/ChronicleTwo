--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_320e830b(arg0: f32, arg1: f32, arg2: f32)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	var3 = event.AngleCmp(arg0, arg1, arg2) or var3
	return var3
end

return helper_320e830b
