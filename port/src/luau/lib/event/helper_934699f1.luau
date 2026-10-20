--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_934699f1()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return var0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetAnalyze(505) or var0
	return var0
end

return helper_934699f1
