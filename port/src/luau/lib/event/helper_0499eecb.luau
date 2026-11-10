--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_0499eecb()
	event.enter_door_mode()
	vm.wait(1)
	wait_frames(10)
	event.jump_to_requested_map()
end

return helper_0499eecb
