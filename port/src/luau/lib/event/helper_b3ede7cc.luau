--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c8c8b790 = require("@lib/event/helper_c8c8b790")

--- Helper function.
local function helper_b3ede7cc(arg0: s32)
	event.apply_message_window_preset(1, 4)
	event.set_message_window_mode(1, 4)
	helper_c8c8b790(1, vm.i32(60 + arg0), 8, 0, 0)
end

return helper_b3ede7cc
