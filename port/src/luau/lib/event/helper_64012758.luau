--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d7edb234 = require("@lib/event/helper_d7edb234")

--- Helper function.
local function helper_64012758()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d7edb234()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_d7edb234()
end

return helper_64012758
