--!strict
-- Shared event helper used by 12 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local open_message = require("@lib/event/open_message")
local set_window_mode = require("@lib/event/set_window_mode")

--- Helper function.
local function helper_afbdd04b(arg0: s32)
	event.apply_message_window_preset(2, 4)
	set_window_mode(2, 8)
	open_message(2, vm.i32(1010 + arg0), 4, 0, 0)
end

return helper_afbdd04b
