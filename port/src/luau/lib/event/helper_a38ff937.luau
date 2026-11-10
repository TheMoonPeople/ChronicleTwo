--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_a38ff937(arg0: any)
	event.set_character_active(0, 11)
	event.set_character_active(1, 33)
	event.set_event_sprite_size(1, 512.0, 416.0)
	event.set_event_sprite_draw_pass(1, 1)
	event.set_object_sequence_position(11, 256.0, 208.0, 10.0)
	event.set_object_sequence_color(11, 128.0, 128.0, 128.0, 128.0, 15)
	wait_frames(15)
	event.set_event_sprite_draw_pass(0, 0)
	helper_4116e6bb(2030060)
end

return helper_a38ff937
