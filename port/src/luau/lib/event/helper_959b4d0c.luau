--!strict
-- Shared event helper used by 260 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_959b4d0c(arg0: s32)
	event.apply_message_window_preset(1, 4)
	set_window_mode(1, 4)
	helper_75684dd8(1, vm.i32(60 + arg0), 8, 0, 0)
end

return helper_959b4d0c
