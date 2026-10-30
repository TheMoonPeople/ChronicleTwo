--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_camera = require("@lib/event/wait_camera")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_f4832f7a()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 0 then
		event.start_background_file_loads_2("dungeon/chara/mints_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	if active_chr_no == 1 then
		event.start_background_file_loads_2("dungeon/chara/monica_01in.gltf", "snd2/sp/sp_031.sound.json")
	end
	vm.wait(1)
	helper_479dc9e9()
	var1 = event.load_sound_effect_file_3(8, "snd2/sp/sp_031.sound.json") or var1
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 183.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_handle_footstep_sound(0, 3)
	if active_chr_no == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/mints_01in.gltf", "info", 0)
	end
	if active_chr_no == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/monica_01in.gltf", "info", 0)
	end
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-32.1, 44.57, 270.0)
	event.set_camera_sequence_look_at(7.73, 34.2, 52.8)
	event.move_camera_sequence_eased(-23.76, 44.57, 224.57, 7.73, 34.2, 52.8, 90, 1, 1.0)
	event.set_object_sequence_motion(0, "ジャンプ", 6)
	event.queue_object_sequence_next_motion(0, "ジャンプ中", 6, 0.3)
	event.queue_object_sequence_next_motion(0, "d01着地", 6)
	if active_chr_no == 0 then
		event.queue_object_sequence_next_motion(0, "旧・立ち", 4)
	else
		event.queue_object_sequence_next_motion(0, "立ち", 4)
	end
	wait_frames(8)
	event.play_sound_effect(var1, 2)
	event.jump_object_sequence(0, 0.0, 29.88, 127.4, -0.2, 26)
	wait_frames(26)
	event.play_sound_effect(var1, 3)
	wait_objects(0)
	wait_frames(5)
	event.move_object_sequence(0, 0.0, 27.83, 35.0, 90)
	event.set_object_sequence_motion(0, "歩き")
	wait_frames(60)
	event.mark_camera_sequence_fade_track()
	event.fade_out_camera_sequence(30)
	event.set_object_handle_footstep_sound(0, -1)
	wait_camera()
end

return helper_f4832f7a
