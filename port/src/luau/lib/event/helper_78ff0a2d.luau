--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_78ff0a2d(arg0: f32, sp: number)
	local skip: (number) -> ...any
	function skip(at: number)
		vm.stack(sp + 3)
		return vm.f32(-1.0 * arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 2)
	if arg0 < 0 then
		vm.stack(sp + 2)
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

return helper_78ff0a2d
