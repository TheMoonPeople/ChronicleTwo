--!strict
-- Shared event helper used by 398 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_05ce8bed(arg0: f32)
	if arg0 < 0 then
		return vm.f32(-1.0 * arg0)
	else
		return arg0
	end
end

return helper_05ce8bed
