--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local close_message = require("@lib/event/close_message")
local helper_89af82b2 = require("@lib/event/helper_89af82b2")
local open_message = require("@lib/event/open_message")

--- Helper function.
local function helper_ddb81958(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: f32)
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
	helper_89af82b2(0, arg1, arg2, arg3, arg4)
	close_message(0)
	event.close_voice_stream(1)
end

return helper_ddb81958
