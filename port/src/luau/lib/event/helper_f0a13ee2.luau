--!strict
-- Shared event helper used by 155 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local open_message = require("@lib/event/open_message")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_f0a13ee2(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	event.call_command(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	event.play_voice_stream(1)
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 8, 0, 0)
	helper_917013c0(0, arg1)
	event.set_message_button_prompt(0, var3)
	wait_frames(arg2)
	event.set_message_button_prompt(0, 0)
	event.close_voice_stream(1)
	close_message(0)
end

return helper_f0a13ee2
