--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_e9655638()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.ActchrSetDefMotion(0)
end

return helper_e9655638
