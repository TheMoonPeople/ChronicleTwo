--!strict
-- Shared event helper used by 45 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c9057fa5(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(arg0, arg1)
end

return helper_c9057fa5
