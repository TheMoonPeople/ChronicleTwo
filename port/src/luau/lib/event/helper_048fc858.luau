--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a7469b08 = require("@lib/event/helper_a7469b08")

--- Helper function.
local function helper_048fc858()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a7469b08(10)
		end
	end
	event.FunctionDoorMode()
	if vm.wait() then
		return skip(1)
	end
	helper_a7469b08(10)
	if vm.skipping() then
		return skip(2)
	end
	event.FunctionMapJump()
end

return helper_048fc858
