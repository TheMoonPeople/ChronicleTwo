--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9f55fd46()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetDioramaPercent(4) or var0
	if var0 < 100 then
		return 0
	end
	return 1
end

return helper_9f55fd46
