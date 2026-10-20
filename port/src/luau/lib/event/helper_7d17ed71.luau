--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9e35d629 = require("@lib/event/helper_9e35d629")

--- Helper function.
local function helper_7d17ed71(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9e35d629(arg0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_9e35d629(arg0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_7d17ed71
