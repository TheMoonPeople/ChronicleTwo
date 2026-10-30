--!strict
-- Shared event helper used by 30 scripts, translated by tools/luau/stb2luau.

local helper_921947c2 = require("@lib/event/helper_921947c2")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_6bc9eefc(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32)
	local _ = open_message(arg0, arg1, arg2, arg3, arg4)
	local _ = helper_921947c2(arg0, arg5)
	event.set_message_bubble_screen_slot(arg0, 0)
end

return helper_6bc9eefc
