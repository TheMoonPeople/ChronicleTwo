--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Helper function.
local function helper_0499eecb()
	event.FunctionDoorMode()
	vm.wait(1)
	helper_25abe6d2(10)
	event.FunctionMapJump()
end

return helper_0499eecb
