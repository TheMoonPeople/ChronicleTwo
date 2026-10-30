--!strict
-- Shared event helper used by 350 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local open_message = require("@lib/event/open_message")
local wait_message_answer = require("@lib/event/wait_message_answer")

--- Helper function.
local function helper_75684dd8(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _ = open_message(arg0, arg1, arg2, arg3, arg4)
	do
		local _: any
		_, var6 = wait_message_answer(arg0, 0, var6)
	end
	close_message(arg0)
end

return helper_75684dd8
