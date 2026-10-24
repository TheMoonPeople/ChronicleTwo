--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")

--- Helper function.
local function helper_ffe53b10()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f3577a67(10)
		end
	end
	event.FunctionDoorMode()
	if vm.wait() then
		return skip(1)
	end
	helper_f3577a67(10)
	if vm.skipping() then
		return skip(2)
	end
	event.FunctionMapJump()
end

return helper_ffe53b10
