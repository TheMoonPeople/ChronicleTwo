--!strict
-- Shared event helper used by 438 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local helper_8894386e = require("@lib/event/helper_8894386e")
local wait_message_answer = require("@lib/event/wait_message_answer")

--- Helper function.
local function helper_0ffc2526(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	helper_8894386e(arg0, arg1, arg2, arg3)
	do
		local _: any
		_, var5 = wait_message_answer(arg0, 0, var5)
	end
	close_message(arg0)
end

return helper_0ffc2526
