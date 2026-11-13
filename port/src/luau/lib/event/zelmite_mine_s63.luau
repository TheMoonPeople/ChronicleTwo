--!strict
--- Event helpers specific to the Zelmite Mine s63 map.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local wait = vm.module("@lib/event/wait")

local zelmite_mine_s63 = {}

--- Plays the cutscene in which two e212d dungeon monsters attack the camera while the d07domari03 title banner fades in.
function zelmite_mine_s63.play_monster_attack_close_scene()
	local loop_counter: s32 = 0
	local sound_bank: s32 = 0
	local block: s32 = 0
	local step: number = 0
	vm.section(function()
		step = 1
		vm.entry(1)
		event.initialize_event()
		step = 2
		vm.wait(2)
		sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_044.sound.json") or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e212d.gltf", "e212d", 8)
		event.copy_character(5, 8, 9)
		for i = 0, 1 do
			event.set_character_active(1, 8 + i)
			event.attach_object_handle_to_character(0 + i, 8 + i)
			event.clear_object_sequence(0 + i)
			event.set_object_sequence_object(0 + i, 0 + i)
			event.set_object_handle_sound_bank(0 + i, sound_bank)
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
		step = 3
		camera.wait_until_done()
		step = 4
		wait.frames(15)
		event.fade_out_screen(30)
		step = 5
		wait.frames(30)
	end, function(received: { any }): boolean
		if step <= 2 then
			loop_counter = 0
			local _ = loop_counter < 2
			loop_counter = loop_counter + 1
			wait.background_load_skipping()
		end
		if step <= 3 then
			wait.frames_skipping(15)
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
	event.delete_character(8)
	event.delete_character(9)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads dungeon monster 43, places two of them and sets the dungeon pause flags.
function zelmite_mine_s63.spawn_dungeon_monsters()
	event.load_dungeon_monster(43, 1)
	event.place_dungeon_monster(43, 256.8, 0.0, 230.3, -3.06)
	event.place_dungeon_monster(43, -147.9, 0.0, 624.8, -3.06)
	event.set_dungeon_pause_flags(16384, 1)
end

return zelmite_mine_s63
