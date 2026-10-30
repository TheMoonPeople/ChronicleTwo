--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_c5c603a3()
	local var0: s32 = 0
	local var1: s32 = 0
	local block: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		at = 2
		vm.wait(2)
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_044.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e212d.gltf", "e212d", 8)
		event.copy_character(5, 8, 9)
		for var0_i = 0, 1 do
			event.set_character_active(1, 8 + var0_i)
			event.attach_object_handle_to_character(0 + var0_i, 8 + var0_i)
			event.clear_object_sequence(0 + var0_i)
			event.set_object_sequence_object(0 + var0_i, 0 + var0_i)
			event.set_object_handle_sound_bank(0 + var0_i, var1)
		end
		event.change_directory("")
		block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari03_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari03", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(6, 0)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_camera_sequence_position(44.56, 7.49, 76.26)
		event.set_camera_sequence_look_at(28.14, 56.99, 228.85)
		event.set_object_sequence_position(0, -17.27, 15.9, 293.48)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 68.43, 7.66, 313.99)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.delay_object_sequence_motion_track(1, 3)
		event.set_object_sequence_motion(0, "攻撃１", 0)
		event.set_object_sequence_motion(1, "攻撃１", 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 30)
		event.move_camera_sequence_eased(34.58, 26.49, 163.31, 28.14, 56.99, 228.85, 30, 0, 0.2)
		at = 3
		wait_camera()
		at = 4
		wait_frames(15)
		event.fade_out_screen(30)
		at = 5
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 2 then
			var0 = 0
			local _ = var0 < 2
			var0 = var0 + 1
			helper_344d6cd8()
		end
		if at <= 3 then
			wait_frames_skipping(15)
		end
		if at <= 4 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_c5c603a3
