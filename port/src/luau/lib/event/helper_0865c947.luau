--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_0865c947(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	if vm.wait() then
		return skip(2)
	end
	event.EohSyncObj(0, "p01_s19", "s19_02-a0")
	event.EohSetShow(0, arg0)
	event.Finish()
end

return helper_0865c947
