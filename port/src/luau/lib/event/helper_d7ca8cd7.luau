--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a6dae0f = require("@lib/event/helper_2a6dae0f")
local helper_d30340bb = require("@lib/event/helper_d30340bb")
local helper_deb4f28c = require("@lib/event/helper_deb4f28c")

--- Helper function.
local function helper_d7ca8cd7()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d30340bb()
		helper_deb4f28c()
		helper_2a6dae0f()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_d30340bb()
	helper_deb4f28c()
	helper_2a6dae0f()
end

return helper_d7ca8cd7
