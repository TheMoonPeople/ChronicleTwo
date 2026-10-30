--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_8197b747(arg0: any)
	local block: s32 = 0
	event.clear_camera_sequence()
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_camera_sequence_position(91.52, 19.06, -115.56)
	event.set_camera_sequence_look_at(36.75, 33.39, -130.18)
	event.set_character_active(0, 0)
	event.set_object_sequence_motion(1, "腰に手L", 4)
	block = event.load_event_image_4(5, "textures/event/e100/e105/e105c_2d.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e105c_2d01", block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_alpha_blend(0, 0)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	wait_frames(30)
	event.fade_in_camera_sequence(30, 0.0, 0.0, 0.0)
	wait_camera()
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 10)
	wait_frames(30)
	event.set_object_sequence_motion(1, "腰に手会話", 4)
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050370)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050371)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050380)
	event.reset_mouth_texture_animations()
	event.set_mouth_texture_animations(1, "わらい口パク")
	helper_4116e6bb(1050390)
	event.reset_mouth_texture_animations()
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
end

return helper_8197b747
