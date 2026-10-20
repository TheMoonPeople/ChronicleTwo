--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ebe6c519 = require("@lib/event/helper_ebe6c519")

--- Helper function.
local function helper_a54ff0eb()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_ebe6c519()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_ebe6c519()
end

return helper_a54ff0eb
