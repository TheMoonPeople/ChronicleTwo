--!strict
--- Scene object helpers for the dungeon system scripts: the rotating gate map parts.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local dungeon_system_scripts_object = {}

--- Rotates a pair of gate map parts according to the trigger angle and lifts the main part out of the way.
function dungeon_system_scripts_object.open_rotating_gate()
	local sound_effect: s32 = 0
	local map_id: s32 = 0
	local trigger_angle: f32 = 0
	local vector_x: f32 = 0
	local vector_y: f32 = 0
	local vector_z: f32 = 0
	event.initialize_event()
	event.start_background_file_loads_1("snd2/sp/sp_033.sound.json")
	vm.wait(1)
	wait.background_load()
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_033.sound.json") or sound_effect
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	map_id = event.get_triggered_event_data_2(9) or map_id
	trigger_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or trigger_angle
	event.attach_object_handle_to_map_part_3(0, map_id, "d04w10_3-m")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if calc.is_angle_within(trigger_angle, 0.0, 1.0) == 0 or calc.is_angle_within(trigger_angle, vm.f32(3.14), 1.0) == 0 then
		event.attach_object_handle_to_map_part_3(1, map_id, "d04w10_2-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_id, "d04w10_4-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	else
		event.attach_object_handle_to_map_part_3(1, map_id, "d04w10_5-m")
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_handle_to_map_part_3(2, map_id, "d04w10_6-m")
		event.set_object_handle_visible(2, 1)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
	end
	event.play_sound_effect(sound_effect, 2)
	wait.for_frame_count(30)
	event.play_sound_effect(sound_effect, 0)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(1)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	if calc.is_angle_within(trigger_angle, 0.0, 1.0) == 0 then
		vector_z = vm.f32(vector_z + vm.f32(3.1415927))
		vector_z = event.wrap_angle(vector_z) or vector_z
	end
	if calc.is_angle_within(trigger_angle, vm.f32(3.14), 1.0) == 0 then
		vector_z = vm.f32(vector_z - vm.f32(3.1415927))
		vector_z = event.wrap_angle(vector_z) or vector_z
	end
	if calc.is_angle_within(trigger_angle, vm.f32(1.57), 1.0) == 0 then
		vector_x = vm.f32(vector_x + vm.f32(3.1415927))
		vector_x = event.wrap_angle(vector_x) or vector_x
	end
	if calc.is_angle_within(trigger_angle, vm.f32(-1.57), 1.0) == 0 then
		vector_x = vm.f32(vector_x - vm.f32(3.1415927))
		vector_x = event.wrap_angle(vector_x) or vector_x
	end
	event.rotate_object_sequence_eased(1, vector_x, vector_y, vector_z, 40, 0, 0.5)
	event.rotate_object_sequence_eased(2, vector_x, vector_y, vector_z, 40, 0, 0.5)
	object.wait_until_done(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		vector_x = out1 or vector_x
		vector_y = out2 or vector_y
		vector_z = out3 or vector_z
	end
	event.move_object_sequence_eased(0, vector_x, vector_y + 80.0, vector_z, 32, 1, 0.5)
	object.wait_until_done(0)
	event.finish_event()
end

return dungeon_system_scripts_object
