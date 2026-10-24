--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5716569e = require("@lib/event/helper_5716569e")

--- Helper function.
local function helper_4be0af40()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_5716569e(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_5716569e(1)
end

return helper_4be0af40
