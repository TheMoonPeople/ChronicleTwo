--!strict
--- Event helpers specific to the Zelmite Mine s62 map.

local vm = require("@lib/vm")
local wait = vm.module("@lib/event/wait")

local zelmite_mine_s62 = {}

--- Plays the cutscene in which two monsters stand idle under the d07domari02 title banner while the player is moved out of sight, then restores the player position.
function zelmite_mine_s62.play_monster_idle_intro_scene()
	local saved_x: f32 = 0
	local saved_y: f32 = 0
	local saved_z: f32 = 0
	local block: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		vm.wait(2)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			saved_x = out1 or saved_x
			saved_y = out2 or saved_y
			saved_z = out3 or saved_z
		end
		event.set_character_position(0, 0.0, -500.0, 0.0)
		block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari02_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari02", block)
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
		event.set_camera_sequence_position(71.12, 56.2, 96.2)
		event.set_camera_sequence_look_at(64.46, 54.73, 103.13)
		event.move_camera_sequence_eased(71.12, 56.2, 96.2, 73.0, 54.73, 105.94, 180, 2, 0.4)
		event.set_object_sequence_position(0, -36.58, 0.0, 153.99)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 30.72, 0.0, 154.46)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 60)
		wait.frames(150)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(5)
	event.cancel_drama_scene_skip()
	event.clear_camera_sequence()
	event.set_character_active(1, 0)
	event.set_character_position(0, saved_x, saved_y, saved_z)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.reset_follow_camera(1, 0.0, 20.0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Loads dungeon monster 183, places five of them and sets the dungeon pause flags.
function zelmite_mine_s62.spawn_dungeon_monsters()
	event.load_dungeon_monster(183, 1)
	event.place_dungeon_monster(183, 229.6, 0.0, 306.1, -3.06)
	event.place_dungeon_monster(183, 46.6, 0.0, 179.0, -3.06)
	event.place_dungeon_monster(183, -141.7, 0.0, 349.5, -3.06)
	event.place_dungeon_monster(183, 72.77, 0.0, 460.22, -2.28)
	event.place_dungeon_monster(183, -58.27, 0.0, 484.43, 3.06)
	event.set_dungeon_pause_flags(16384, 1)
end

return zelmite_mine_s62
