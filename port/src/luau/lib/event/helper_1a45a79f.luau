--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_e5f78c9b = require("@lib/event/helper_e5f78c9b")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_1a45a79f(arg0: s32, arg1: s32, arg2: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.open_voice_stream_wave(1, arg0)
	while true do
		stream_open_state = event.get_voice_stream_open_state() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.ready_voice_stream(1)
	while true do
		stream_open_state_2 = event.get_voice_stream_open_state() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	event.open_message_window_2(0, arg0)
	open_message(0, -1, 8, 0, 0)
	event.play_voice_stream(1)
	helper_e5f78c9b(0, arg1, arg2)
	close_message(0)
	event.close_voice_stream(1)
	event.set_message_bubble_screen_slot(0, 0)
end

return helper_1a45a79f
