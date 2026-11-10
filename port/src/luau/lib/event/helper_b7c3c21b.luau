--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0655dfaa = require("@lib/event/helper_0655dfaa")
local helper_9391e829 = require("@lib/event/helper_9391e829")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_b7c3c21b()
	local var0: s32 = 0
	local projection: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(105, 1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(4, 1225) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		projection = event.get_event_projection() or projection
		do
			local out1, out2, out3 = event.get_camera_position()
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = event.get_camera_look_at()
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		event.load_character_motion_pack(5, "event/e100/e105/e105_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 72.86, 57.47, 35.39)
		event.load_character(5, "event/e100/e105/e105_starbre.gltf", "info", 32)
		event.set_character_active(1, 32)
		event.attach_object_handle_to_character(1, 32)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, 67.74, -59.99, 63.26)
		event.set_object_sequence_rotation(1, 0.0, 3.04, 0.0)
		block = event.load_event_image_4(5, "textures/event/e100/e105/e105b_2d.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e105b_2d01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 448)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_event_sprite_alpha_blend(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e105b_2d02", block)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 0)
		event.set_event_sprite_alpha_blend(1, 0)
		event.attach_object_handle_to_sprite(3, 1)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.reset_event_sprite(2)
		event.set_event_sprite_type(2, 0)
		event.set_event_sprite_texture(2, "e105b_2d03", block)
		event.set_event_sprite_color(2, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(2, 0, 0, 512, 448)
		event.set_event_sprite_size(2, 512, 448)
		event.set_event_sprite_position(2, 256, 224)
		event.set_event_sprite_draw_pass(2, 0)
		event.set_event_sprite_alpha_blend(2, 0)
		event.attach_object_handle_to_sprite(4, 2)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.load_message_file(0, 5, "event/e100/e105/e105b_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(1, 1, "通常目パチ")
		helper_9391e829(projection, var0)
		helper_0655dfaa(projection, var0)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(30)
	wait_frames(30)
	event.set_character_active(1, 0)
	event.set_character_active(1, 25)
	event.set_event_projection(projection)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.delete_character_extension_packs(0)
	event.delete_character(32)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_event_sprite_draw_pass(1, 0)
	event.set_event_sprite_draw_pass(2, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
end

return helper_b7c3c21b
