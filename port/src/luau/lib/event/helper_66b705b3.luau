--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5307b95a = require("@lib/event/helper_5307b95a")

--- Helper function.
local function helper_66b705b3()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_5307b95a()
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_5307b95a()
end

return helper_66b705b3
