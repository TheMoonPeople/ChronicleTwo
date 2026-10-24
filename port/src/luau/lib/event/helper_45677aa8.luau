--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23369a5e = require("@lib/event/helper_23369a5e")

--- Helper function.
local function helper_45677aa8()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_23369a5e(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_23369a5e(1)
end

return helper_45677aa8
