--!strict
-- Shared event helper used by 33 scripts, translated by tools/luau/stb2luau.

local helper_61e5dba6 = require("@lib/event/helper_61e5dba6")
local helper_9cbdc640 = require("@lib/event/helper_9cbdc640")

--- Helper function.
local function helper_6d287af3(arg0: any, arg1: s32)
	event.open_voice_stream_wave(1, arg0)
	helper_9cbdc640(1)
	event.play_voice_stream(1)
	helper_61e5dba6(0, arg1)
	event.close_voice_stream(1)
end

return helper_6d287af3
