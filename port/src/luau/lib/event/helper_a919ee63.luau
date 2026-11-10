--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_a919ee63(arg0: any)
	event.set_event_sprite_size(3, 512.0, 416.0)
	event.set_event_sprite_draw_pass(3, 1)
	event.set_object_sequence_position(13, 256.0, 208.0, 0.0)
	event.set_object_sequence_color(13, 128.0, 128.0, 128.0, 128.0, 15)
	wait_frames(15)
	event.set_event_sprite_draw_pass(2, 0)
	helper_4116e6bb(2030080)
	helper_4116e6bb(2030083)
end

return helper_a919ee63
