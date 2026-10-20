--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7443da3d = require("@lib/event/helper_7443da3d")

--- Helper function.
local function helper_83fcba7a()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_7443da3d(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_7443da3d(1)
end

return helper_83fcba7a
