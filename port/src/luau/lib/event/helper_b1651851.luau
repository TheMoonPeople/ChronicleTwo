--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ac9d5b12 = require("@lib/event/helper_ac9d5b12")
local helper_d355d559 = require("@lib/event/helper_d355d559")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_b1651851(arg0: s32)
	local world_coord_pos: f32 = 0
	local world_coord_pos_2: f32 = 0
	local world_coord_pos_3: f32 = 0
	local world_coord_rot: f32 = 0
	local battle_bgm_vol: f32 = 0
	local var6: s32 = 0
	local battle_bgm_vol_2: f32 = 0
	local var8: s32 = 0
	event.start_crossfade(10)
	vm.wait(1)
	world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot =
		helper_d355d559(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.set_event_world_coordinate(world_coord_pos, world_coord_pos_2, world_coord_pos_3, world_coord_rot)
	event.attach_object_handle_to_character(0, 0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "走り", 4)
	if arg0 == 0 then
		event.set_object_handle_footstep_sound(0, 16)
		event.set_camera_sequence_position(71.85, 16.72, -238.11)
		event.set_camera_sequence_look_at(10.53, 73.66, -36.93)
		event.set_object_sequence_position(0, 0.0, 30.68, -72.59)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 82.86, -9.67, 30)
		wait_frames(15)
		event.fade_out_screen(15)
		wait_frames(15)
		wait_objects(0)
		event.set_object_handle_footstep_sound(0, 14)
		event.stop_all_sound_effects()
		event.load_map_sounds(4682)
		helper_ac9d5b12()
		battle_bgm_vol = vm.bits_float(event.get_battle_music_volume()) or battle_bgm_vol
		var6 = event.get_event_sound_bank(4) or var6
		if battle_bgm_vol <= 0.0 then
			event.stop_sound_effect(var6, 0)
		else
			event.play_sound_effect(var6, 0)
			event.set_sound_effect_volume(var6, 0, battle_bgm_vol)
		end
		event.fade_in_screen(15)
		event.set_camera_sequence_position(0.0, 3253.14, -28.11)
		event.set_camera_sequence_look_at(0.0, 3230.0, 130.0)
		event.set_map_lighting(0)
		event.set_object_sequence_position(0, 0.0, 3157.0, 45.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 3200.0, 95.0, 20)
		event.move_object_sequence(0, 0.0, 3200.0, 130.0, 10)
		wait_objects(0)
	else
		event.set_object_handle_footstep_sound(0, 14)
		event.set_camera_sequence_position(0.0, 3239.0, 220.74)
		event.set_camera_sequence_look_at(0.0, 3234.0, 130.0)
		event.set_object_sequence_position(0, 0.0, 3200.0, 94.0)
		event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 3147.0, 53.0, 30)
		wait_frames(15)
		event.fade_out_screen(15)
		wait_frames(15)
		wait_objects(0)
		event.set_object_handle_footstep_sound(0, 16)
		event.stop_all_sound_effects()
		event.load_map_sounds(4600)
		helper_ac9d5b12()
		battle_bgm_vol_2 = vm.bits_float(event.get_battle_music_volume()) or battle_bgm_vol_2
		var8 = event.get_event_sound_bank(4) or var8
		if battle_bgm_vol_2 <= 0.0 then
			event.stop_sound_effect(var8, 0)
		else
			event.play_sound_effect(var8, 0)
			event.set_sound_effect_volume(var8, 0, battle_bgm_vol_2)
		end
		event.fade_in_screen(15)
		event.set_camera_sequence_position(-56.2, 52.61, -305.55)
		event.set_camera_sequence_look_at(1.04, 57.84, -87.81)
		event.set_map_lighting(8)
		event.set_object_sequence_position(0, 0.0, 50.06, -39.81)
		event.reset_object_sequence_dynamic_animation(0)
		event.move_object_sequence(0, 0.0, 20.0, -73.92, 16)
		event.move_object_sequence(0, 0.0, 5.0, -130.0, 16)
		wait_objects(0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_follow_camera(0)
	event.finish_event()
end

return helper_b1651851
