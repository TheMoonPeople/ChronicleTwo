--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d37bf983 = require("@lib/event/helper_d37bf983")

--- Helper function.
local function helper_480b3a21()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d37bf983()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_d37bf983()
end

return helper_480b3a21
