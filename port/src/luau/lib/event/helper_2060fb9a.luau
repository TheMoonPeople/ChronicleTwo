--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")

--- Helper function.
local function helper_2060fb9a(arg0: s32, arg1: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(arg1, "立ち")
	event.open_message_window_2(0, "Hmm, this tree... It doesn't look\ngood. I've got to do something.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Looks like you have to talk to\n   Gordon to get his attention.")
	helper_75684dd8(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

return helper_2060fb9a
