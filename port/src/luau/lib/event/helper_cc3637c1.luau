--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_cc3637c1()
	event.initialize_event()
	event.fade_out_screen(30)
	wait_frames(30)
	event.jump_to_map_3(-1, "s66", 600)
	vm.wait(2)
end

return helper_cc3637c1
