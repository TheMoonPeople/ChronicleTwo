--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_0fc04819()
	event.FunctionDoorMode()
	vm.wait(1)
	helper_888ab2a3(10)
	event.FunctionMapJump()
end

return helper_0fc04819
