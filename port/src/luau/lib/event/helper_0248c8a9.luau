--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3351c0e9 = require("@lib/event/helper_3351c0e9")

--- Helper function.
local function helper_0248c8a9()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_3351c0e9()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3351c0e9()
end

return helper_0248c8a9
