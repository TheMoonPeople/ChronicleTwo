--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_642a8d52(arg0: f32, arg1: f32, sp: number)
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 3)
		return arg0
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 3)
	if arg0 > arg1 then
		return arg0
	else
		return arg1
	end
end

return helper_642a8d52
