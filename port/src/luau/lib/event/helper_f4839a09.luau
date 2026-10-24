--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f4839a09()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.FuncPointShow("", "rapis", 0)
	event.EohSyncObj(30, "p01_s1301-m-m", "s1301_3-m0")
	event.EohSetShow(30, 0)
end

return helper_f4839a09
