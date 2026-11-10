--!strict
-- Shared event helper used by 343 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local open_message = require("@lib/event/open_message")
local wait_message_answer = require("@lib/event/wait_message_answer")

--- Opens a message window, waits for it to be read and closes it.
local function show_message(window: s32, text: any, position: s32, x: s32, y: s32)
	local var6: s32 = 0
	local _ = open_message(window, text, position, x, y)
	do
		local _: any
		_, var6 = wait_message_answer(window, 0, var6)
	end
	close_message(window)
end

return show_message
