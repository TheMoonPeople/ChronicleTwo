--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")

--- Helper function.
local function helper_14c603be()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e2203e72(10)
		end
	end
	event.FunctionDoorMode()
	if vm.wait() then
		return skip(1)
	end
	helper_e2203e72(10)
	if vm.skipping() then
		return skip(2)
	end
	event.FunctionMapJump()
end

return helper_14c603be
