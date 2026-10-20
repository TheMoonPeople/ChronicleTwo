--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e8f3e3fb(arg0: f32)
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.f32(-1.0 * arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg0 < 0 then
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

return helper_e8f3e3fb
