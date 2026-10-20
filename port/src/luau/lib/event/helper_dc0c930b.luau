--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_dc0c930b(arg0: f32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsMove2(2, 0.0, -24.0, -1000.0 + arg0, arg1, 2, 0.4)
end

return helper_dc0c930b
