--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local close_message = require("@lib/event/close_message")
local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_3375c1c1(arg0: s32, arg1: s32)
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 5, 0, 0)
	event.play_voice_stream(1)
	helper_917013c0(0, arg1)
	close_message(0)
	event.close_voice_stream(1)
end

return helper_3375c1c1
