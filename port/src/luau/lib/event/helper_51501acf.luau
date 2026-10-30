--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_344d6cd8 = require("@lib/event/helper_344d6cd8")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_51501acf()
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
		var1 = event.load_sound_effect_file_3(5, "snd2/mon/en_008.sound.json") or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e202d.gltf", "e202d", 8)
		event.copy_character(5, 8, 9)
		for var0_i = 0, 1 do
			event.set_character_active(1, 8 + var0_i)
			event.attach_object_handle_to_character(0 + var0_i, 8 + var0_i)
			event.clear_object_sequence(0 + var0_i)
			event.set_object_sequence_object(0 + var0_i, 0 + var0_i)
			event.set_object_handle_sound_bank(0 + var0_i, var1)
		end
		event.change_directory("")
		block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari01_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari01", block)
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
		event.set_object_sequence_position(0, -36.58, 0.0, 153.99)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 30.72, 0.0, 154.46)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_camera_sequence_position(-6.83, 70.86, -98.29)
		event.set_camera_sequence_look_at(-5.15, 18.65, -28.34)
		event.move_camera_sequence_eased(-3.71, 16.94, 31.66, -2.03, 28.09, 101.61, 30, 0, 0.4)
		at = 3
		wait_camera()
		event.set_object_sequence_motion(0, "攻撃１", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "攻撃１", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 30)
		at = 4
		wait_frames(30)
		at = 5
		wait_objects(0)
		at = 6
		wait_objects(1)
		at = 7
		wait_frames(30)
		event.fade_out_screen(30)
		at = 8
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 2 then
			var0 = 0
			local _ = var0 < 2
			var0 = var0 + 1
			helper_344d6cd8()
		end
		if at <= 3 then
			wait_frames_skipping(30)
		end
		if at <= 4 then
			helper_238b5abc(0)
		end
		if at <= 5 then
			helper_238b5abc(1)
		end
		if at <= 6 then
			wait_frames_skipping(30)
		end
		if at <= 7 then
			wait_frames_skipping(30)
		end
		return true
	end)
	at = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_51501acf
