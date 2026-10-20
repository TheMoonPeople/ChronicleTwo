--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bb40725 = require("@lib/event/helper_0bb40725")

--- Helper function.
local function helper_b55b8632()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_0bb40725()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_0bb40725()
end

return helper_b55b8632
