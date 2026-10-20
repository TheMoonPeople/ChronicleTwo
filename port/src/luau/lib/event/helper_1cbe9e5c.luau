--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_93a98737 = require("@lib/event/helper_93a98737")

--- Helper function.
local function helper_1cbe9e5c()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_93a98737()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_93a98737()
end

return helper_1cbe9e5c
