--!strict
-- Shared event helper used by 45 scripts, translated by tools/luau/stb2luau.

local helper_917013c0 = require("@lib/event/helper_917013c0")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_4bd79732(arg0: s32, arg1: s32)
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	event.play_voice_stream(1)
	helper_917013c0(0, arg1)
	event.close_voice_stream(1)
end

return helper_4bd79732
