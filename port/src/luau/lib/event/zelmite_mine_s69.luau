--!strict
--- Cutscene and encounter helpers for Zelmite Mine (s69).

local vm = require("@lib/vm")
local wait = vm.module("@lib/event/wait")

local zelmite_mine_s69 = {}

--- Plays the cutscene showing a pack of six monsters attacking beside a banner image, then restores the player character.
function zelmite_mine_s69.play_monster_pack_intro()
	local index: s32 = 0
	local sound_bank: s32 = 0
	local saved_x: f32 = 0
	local saved_y: f32 = 0
	local saved_z: f32 = 0
	local image_block: s32 = 0
	local start_delay: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.initialize_event()
		step = 2
		vm.wait(2)
		sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_008.sound.json") or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3 = event.get_character_position(0)
			saved_x = out1 or saved_x
			saved_y = out2 or saved_y
			saved_z = out3 or saved_z
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
		index = 0
		while index < 6 do
			event.set_character_active(1, 8 + index)
			event.attach_object_handle_to_character(0 + index, 8 + index)
			event.clear_object_sequence(0 + index)
			event.set_object_sequence_object(0 + index, 0 + index)
			event.set_object_handle_sound_bank(0 + index, sound_bank)
			index = index + 1
		end
		event.change_directory("")
		image_block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari04_1.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari04", image_block)
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
		index = 0
		while index < 6 do
			event.set_object_sequence_position(0 + index, -36.58, 0.0, 153.99)
			event.set_object_sequence_rotation(0 + index, 0.0, 2.92, 0.0)
			event.set_object_sequence_motion(0 + index, "立ち", 0)
			index = index + 1
		end
		step = 3
		wait.frames(3)
		index = 0
		while index < 6 do
			start_delay = 0
			start_delay = event.get_random_number_int(6) or start_delay
			event.delay_object_sequence_motion_track(0 + index, start_delay)
			event.set_object_sequence_motion(0 + index, "攻撃１in", 6)
			event.queue_object_sequence_next_motion(0 + index, "攻撃１", 0)
			index = index + 1
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
		step = 4
		wait.frames(60)
		event.fade_out_screen(30)
		step = 5
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 2 then
			index = 0
			local _ = index < 6
			index = index + 1
			index = 0
			local _ = index < 6
			index = index + 1
			wait.frames_skipping(3)
		end
		if step <= 3 then
			index = 0
			start_delay = 0
			local _ = index < 6
			index = index + 1
			wait.frames_skipping(60)
		end
		if step <= 4 then
			wait.frames_skipping(30)
		end
		return true
	end)
	step = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.set_character_position(0, saved_x, saved_y, saved_z)
	index = 0
	while index < 6 do
		event.delete_character(8 + index)
		index = index + 1
	end
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads dungeon monster 55 and places six of them around the room, then sets the dungeon pause flags.
function zelmite_mine_s69.spawn_monster_pack()
	event.load_dungeon_monster(55, 1)
	event.place_dungeon_monster(55, 50.54, 0.0, 460.31, -2.67)
	event.place_dungeon_monster(55, -117.51, 0.0, 458.13, 2.77)
	event.place_dungeon_monster(55, -144.84, 0.0, 606.65, 2.77)
	event.place_dungeon_monster(55, -73.47, 0.0, 646.59, 3.13)
	event.place_dungeon_monster(55, -16.67, 0.0, 634.86, 3.13)
	event.place_dungeon_monster(55, 133.4, 0.0, 600.46, -2.91)
	event.set_dungeon_pause_flags(16384, 1)
end

return zelmite_mine_s69
