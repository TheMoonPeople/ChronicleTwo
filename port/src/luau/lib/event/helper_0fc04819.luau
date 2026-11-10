--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_0fc04819()
	event.enter_door_mode()
	vm.wait(1)
	helper_888ab2a3(10)
	event.jump_to_requested_map()
end

return helper_0fc04819
