--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_cffd0192()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local block: s32 = 0
	local var6: s32 = 0
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
		do
			local out1, out2, out3 = event.get_character_position(0)
			var2 = out1 or var2
			var3 = out2 or var3
			var4 = out3 or var4
		end
		event.set_character_position(0, 0.0, -500.0, 0.0)
		event.set_character_active(0, 0)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e216d.gltf", "e216d", 8)
		event.copy_character(5, 8, 9)
		event.copy_character(5, 8, 10)
		event.copy_character(5, 8, 11)
		event.copy_character(5, 8, 12)
		event.copy_character(5, 8, 13)
		var0 = 0
		while var0 < 6 do
			event.set_character_active(1, 8 + var0)
			event.attach_object_handle_to_character(0 + var0, 8 + var0)
			event.clear_object_sequence(0 + var0)
			event.set_object_sequence_object(0 + var0, 0 + var0)
			event.set_object_handle_sound_bank(0 + var0, var1)
			var0 = var0 + 1
		end
		event.change_directory("")
		block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari04_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari04", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(7, 0)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_camera_sequence_position(-6.98, 27.91, 53.33)
		event.set_camera_sequence_look_at(-8.01, 27.08, 94.1)
		var0 = 0
		while var0 < 6 do
			event.set_object_sequence_position(0 + var0, -36.58, 0.0, 153.99)
			event.set_object_sequence_rotation(0 + var0, 0.0, 2.92, 0.0)
			event.set_object_sequence_motion(0 + var0, "立ち", 0)
			var0 = var0 + 1
		end
		at = 3
		wait_frames(3)
		var0 = 0
		while var0 < 6 do
			var6 = 0
			var6 = vm.float_bits(event.get_random_number(6)) or var6
			event.delay_object_sequence_motion_track(0 + var0, var6)
			event.set_object_sequence_motion(0 + var0, "攻撃１in", 6)
			event.queue_object_sequence_next_motion(0 + var0, "攻撃１", 0)
			var0 = var0 + 1
		end
		event.set_object_sequence_position(0, -36.79, 0.0, 159.0)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 11.2, 0.0, 157.85)
		event.set_object_sequence_rotation(1, 0.0, -3.0, 0.0)
		event.set_object_sequence_position(2, 32.03, 0.0, 188.36)
		event.set_object_sequence_rotation(2, 0.0, -3.0, 0.0)
		event.set_object_sequence_position(3, 1.69, 0.0, 190.41)
		event.set_object_sequence_rotation(3, 0.0, 3.04, 0.0)
		event.set_object_sequence_position(4, -28.34, 0.0, 194.95)
		event.set_object_sequence_rotation(4, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(5, -59.81, 0.0, 198.15)
		event.set_object_sequence_rotation(5, 0.0, 2.92, 0.0)
		event.set_object_sequence_color(7, 128, 128, 128, 128, 30)
		at = 4
		wait_frames(60)
		event.fade_out_screen(30)
		at = 5
		wait_frames(30)
	end, function(received: { any }): boolean
		if at <= 2 then
			var0 = 0
			local _ = var0 < 6
			var0 = var0 + 1
			var0 = 0
			local _ = var0 < 6
			var0 = var0 + 1
			wait_frames_skipping(3)
		end
		if at <= 3 then
			var0 = 0
			var6 = 0
			local _ = var0 < 6
			var0 = var0 + 1
			wait_frames_skipping(60)
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
	event.set_character_position(0, var2, var3, var4)
	var0 = 0
	while var0 < 6 do
		event.delete_character(8 + var0)
		var0 = var0 + 1
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_cffd0192
