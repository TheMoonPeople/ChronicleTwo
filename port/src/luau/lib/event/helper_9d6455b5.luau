--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")

--- Helper function.
local function helper_9d6455b5()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aafd6a80(10)
		end
	end
	event.FunctionDoorMode()
	if vm.wait() then
		return skip(1)
	end
	helper_aafd6a80(10)
	if vm.skipping() then
		return skip(2)
	end
	event.FunctionMapJump()
end

return helper_9d6455b5
