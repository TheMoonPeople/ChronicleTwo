--!strict
--- Helpers for the Zelmite Mine floors: automap doors, wall parts and door transitions.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local dungeon = vm.module("@lib/event/dungeon")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local zelmite_mine = {}

--- Initializes the event, attaches the door's two d07w10 wall parts and shows the first while hiding the second.
function zelmite_mine.attach_wall_parts()
	local door_parts: s32 = 0
	event.initialize_event()
	vm.wait(1)
	door_parts = event.get_triggered_event_data_2(9) or door_parts
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07w10_5-m0")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(1, door_parts, "d07w10_4-m0")
	event.set_object_handle_visible(1, 0)
	event.finish_event()
end

--- Counts from zero to sixteen with an empty loop body.
function zelmite_mine.count_to_sixteen()
	local index: s32 = 0
	index = 0
	local _ = index < 16
	index = index + 1
end

--- Does nothing.
function zelmite_mine.do_nothing() end

--- Opens the triggered automap door: raises its three panels, swings the camera to the door's facing angle, swaps in the opened door parts and disables the door function point.
function zelmite_mine.open_automap_door()
	local door_parts: s32 = 0
	local sound_effect: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local camera_angle: f32 = 0
	local index: s32 = 0
	local part_a_x: f32 = 0
	local part_a_y: f32 = 0
	local part_a_z: f32 = 0
	local part_b_x: f32 = 0
	local part_b_y: f32 = 0
	local part_b_z: f32 = 0
	local part_c_x: f32 = 0
	local part_c_y: f32 = 0
	local part_c_z: f32 = 0
	door_parts = event.get_triggered_event_data_2(9) or door_parts
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_047.sound.json") or sound_effect
	event.attach_object_handle_to_map_part_2(0, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	camera_angle = vm.bits_float(event.get_triggered_event_data_2(11)) or camera_angle
	camera_angle = vm.f32(camera_angle - vm.f32(3.1415927))
	camera_angle = event.wrap_angle(camera_angle) or camera_angle
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07d05_3-m0")
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_map_part_3(1, door_parts, "d07d05_1-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, door_parts, "d07d05_1-m1")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		part_a_x = out1 or part_a_x
		part_a_y = out2 or part_a_y
		part_a_z = out3 or part_a_z
	end
	part_a_y = vm.f32(part_a_y + 100.0)
	event.move_object_sequence_eased(0, part_a_x, part_a_y, part_a_z, 40, 0, 0.6)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		part_b_x = out1 or part_b_x
		part_b_y = out2 or part_b_y
		part_b_z = out3 or part_b_z
	end
	part_b_y = vm.f32(part_b_y + 100.0)
	event.move_object_sequence_eased(1, part_b_x, part_b_y, part_b_z, 40, 0, 0.6)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		part_c_x = out1 or part_c_x
		part_c_y = out2 or part_c_y
		part_c_z = out3 or part_c_z
	end
	part_c_y = vm.f32(part_c_y + 100.0)
	event.move_object_sequence_eased(2, part_c_x, part_c_y, part_c_z, 40, 0, 0.6)
	event.play_sound_effect(sound_effect, 0)
	index = 0
	while index < 30 do
		event.swing_camera_control_to_angle(camera_angle)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		index = index + 1
		vm.wait(1)
	end
	object.wait_until_done(0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07da05a-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07dv05a-c")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07da05b-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07dv05b-c")
	event.set_object_handle_visible(0, 1)
	event.set_function_point_enabled(door_parts, "door01", 0)
	event.reset_follow_camera(0)
end

--- Returns the given door position and rotation unchanged.
function zelmite_mine.pass_through_door_coordinate(x: f32, y: f32, z: f32, rotation: f32)
	return x, y, z, rotation
end

--- Places the opened-state parts of an already unlocked automap door, hides the closed ones and disables the door function point.
function zelmite_mine.place_opened_door()
	local door_parts: s32 = 0
	local is_door_visible: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local part_a_x: f32 = 0
	local part_a_y: f32 = 0
	local part_a_z: f32 = 0
	local part_b_x: f32 = 0
	local part_b_y: f32 = 0
	local part_b_z: f32 = 0
	local part_c_x: f32 = 0
	local part_c_y: f32 = 0
	local part_c_z: f32 = 0
	event.initialize_event()
	door_parts = event.get_automap_door_parts() or door_parts
	event.attach_object_handle_to_function_point(0, door_parts, "door01")
	is_door_visible = event.is_object_handle_visible(0) or is_door_visible
	if door_parts < 0 or is_door_visible == 0 then
		return
	end
	event.attach_object_handle_to_map_part_2(0, door_parts)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		door_x = out1 or door_x
		door_y = out2 or door_y
		door_z = out3 or door_z
	end
	event.open_minimap_door(door_x, door_y, door_z)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07d05_3-m0")
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		part_a_x = out1 or part_a_x
		part_a_y = out2 or part_a_y
		part_a_z = out3 or part_a_z
	end
	part_a_y = vm.f32(part_a_y + 100.0)
	event.attach_object_handle_to_map_part_3(1, door_parts, "d07d05_1-m0")
	event.attach_object_handle_to_map_part_3(2, door_parts, "d07d05_1-m1")
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		part_b_x = out1 or part_b_x
		part_b_y = out2 or part_b_y
		part_b_z = out3 or part_b_z
	end
	part_b_y = vm.f32(part_b_y + 100.0)
	do
		local out1, out2, out3 = event.get_object_handle_position(2)
		part_c_x = out1 or part_c_x
		part_c_y = out2 or part_c_y
		part_c_z = out3 or part_c_z
	end
	part_c_y = vm.f32(part_c_y + 100.0)
	event.set_object_handle_position(0, part_a_x, part_a_y, part_a_z)
	event.set_object_handle_position(1, part_b_x, part_b_y, part_b_z)
	event.set_object_handle_position(2, part_c_x, part_c_y, part_c_z)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07da05a-a")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07dv05a-c")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07da05b-a")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, door_parts, "d07dv05b-c")
	event.set_object_handle_visible(0, 1)
	event.set_function_point_enabled(door_parts, "door01", 0)
end

--- Plays the door entry scene: crossfades in, places the party and the door parts at the triggered door, slides the parts along the door's facing axis and fades to black.
function zelmite_mine.play_door_entry()
	local sound_effect: s32 = 0
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_rotation: f32 = 0
	local door_parts: s32 = 0
	event.initialize_event()
	event.start_crossfade(30)
	sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_048.sound.json") or sound_effect
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	door_x, door_y, door_z, door_rotation =
		object.get_trigger_placement(door_x, door_y, door_z, door_rotation)
	event.set_event_world_coordinate(door_x, door_y, door_z, door_rotation)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	door_parts = event.get_triggered_event_data_2(9) or door_parts
	event.attach_object_handle_to_map_part_3(1, door_parts, "d07w10_2-m0")
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.attach_object_handle_to_map_part_3(2, door_parts, "d07w10_5-m0")
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.attach_object_handle_to_map_part_3(3, door_parts, "d07w10_4-m0")
	event.set_object_handle_visible(3, 0)
	event.set_object_handle_position(0, 0.0, 11.0, 23.0)
	event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_handle_motion(0, "バトル立ち", 4)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.set_object_handle_position(2, 0.0, 0.0, 0.0)
	event.play_sound_effect(sound_effect, 0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-96.52, 68.45, 152.82)
	event.set_camera_sequence_look_at(-32.44, 32.28, 0.35)
	event.move_object_sequence_eased(0, 0.0, 11.0, -177.0, 40, 1, 1.0)
	if calc.is_angle_within(door_rotation, 0.0, 1.0) == 0 then
		print("\n\n\nROT_0.0\n\n\n")
		event.move_object_sequence_eased(1, 0.0, 0.0, -200.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, -200.0, 40, 1, 1.0)
	end
	if calc.is_angle_within(door_rotation, vm.f32(3.14), 1.0) == 0 then
		print("\n\n\nROT_3.14\n\n\n")
		event.move_object_sequence_eased(1, 0.0, 0.0, 200.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 0.0, 0.0, 200.0, 40, 1, 1.0)
	end
	if calc.is_angle_within(door_rotation, vm.f32(1.57), 1.0) == 0 then
		print("\n\n\nROT_1.57\n\n\n")
		event.move_object_sequence_eased(1, -200.0, 0.0, 0.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, -200.0, 0.0, 0.0, 40, 1, 1.0)
	end
	if calc.is_angle_within(door_rotation, vm.f32(-1.57), 1.0) == 0 then
		print("\n\n\nROT_-1.57\n\n\n")
		event.move_object_sequence_eased(1, 200.0, 0.0, 0.0, 40, 1, 1.0)
		event.move_object_sequence_eased(2, 200.0, 0.0, 0.0, 40, 1, 1.0)
	end
	wait.frames(30)
	event.fade_out_screen(30)
	wait.frames(60)
	event.set_character_motion(0, "立ち")
	event.finish_event()
end

--- Runs one empty sixteen-iteration loop.
function zelmite_mine.run_empty_loop()
	zelmite_mine.count_to_sixteen()
end

--- Runs an empty sixteen-iteration loop and then calls an empty two-argument handler with zero values.
function zelmite_mine.run_empty_loop_with_handler()
	local first_value: s32 = 0
	local second_value: s32 = 0
	zelmite_mine.run_empty_loop()
	dungeon.increment_floor_counter_skipping(first_value, second_value)
end

--- Runs an empty loop, waits six frames skippably and runs the empty loop with its handler.
function zelmite_mine.wait_between_empty_loops()
	zelmite_mine.run_empty_loop()
	wait.frames_skipping(6)
	zelmite_mine.run_empty_loop_with_handler()
end

--- Waits two skippable twenty-frame delays while the door exit plays out; the mode argument and rotation checks have no effect.
function zelmite_mine.wait_through_door_exit(unused_mode: s32)
	local door_rotation: f32 = 0
	print(vm.float(door_rotation), "\n")
	print(vm.float(door_rotation), "\n")
	print(vm.float(door_rotation), "\n")
	local _ = character.check_move_skipping(door_rotation, 0.0, 1.0) == 0
	local _ = character.check_move_skipping(door_rotation, vm.f32(1.57), 1.0) == 0
	local _ = character.check_move_skipping(door_rotation, vm.f32(3.14), 1.0) == 0
	local _ = character.check_move_skipping(door_rotation, vm.f32(-1.57), 1.0) == 0
	cutscene.skip_command(0)
	wait.frames_skipping(20)
	wait.frames_skipping(20)
	wait.background_load_skipping()
	wait.background_load_skipping()
	wait.background_load_skipping()
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
end

--- Waits thirty and then sixty frames skippably for the door transition to pass, logging the door's facing direction.
function zelmite_mine.wait_through_door_transition()
	local door_x: f32 = 0
	local door_y: f32 = 0
	local door_z: f32 = 0
	local door_rotation: f32 = 0
	door_x, door_y, door_z, door_rotation = zelmite_mine.pass_through_door_coordinate(door_x, door_y, door_z, door_rotation)
	local _ = character.check_move_skipping(door_rotation, 0.0, 1.0) == 0
	print("\n\n\nROT_0.0\n\n\n")
	local _ = character.check_move_skipping(door_rotation, vm.f32(3.14), 1.0) == 0
	print("\n\n\nROT_3.14\n\n\n")
	local _ = character.check_move_skipping(door_rotation, vm.f32(1.57), 1.0) == 0
	print("\n\n\nROT_1.57\n\n\n")
	local _ = character.check_move_skipping(door_rotation, vm.f32(-1.57), 1.0) == 0
	print("\n\n\nROT_-1.57\n\n\n")
	wait.frames_skipping(30)
	wait.frames_skipping(60)
end

return zelmite_mine
