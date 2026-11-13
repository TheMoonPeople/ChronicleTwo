--!strict
--- Moves and poses a single character.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local character = {}

--- Returns 0 for a target, angle and amount; this stands in for a movement check when events are skipped.
function character.check_move_skipping(target: f32, angle: f32, amount: f32)
	local result: s32 = 0
	return result
end

--- Deletes the characters and villagers in slots 8 to 19, waiting one frame per slot.
function character.delete_extra_slots()
	local index: s32 = 0
	index = 8
	while index < 20 do
		event.delete_character(index)
		event.delete_villager(index)
		index = index + 1
		vm.wait(1)
	end
end

--- Turns the player and a character toward each other, plays a conversation and turns the character back.
function character.face_each_other_and_talk(character_slot: s32, unused_value: any)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local player_current_yaw: f32 = 0
	local character_current_yaw: f32 = 0
	local player_target_yaw: f32 = 0
	local character_target_yaw: f32 = 0
	local needs_turn: s32 = 0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, character_slot)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		player_current_yaw = out2 or player_current_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(character_slot)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	do
		local _, out2, _ = event.get_character_rotation(character_slot)
		character_current_yaw = out2 or character_current_yaw
	end
	player_target_yaw = event.get_direction_angle(player_x, player_y, player_z, character_x, character_y, character_z) or player_target_yaw
	character_target_yaw = event.get_direction_angle(character_x, character_y, character_z, player_x, player_y, player_z) or character_target_yaw
	needs_turn = event.compare_angles(player_current_yaw, player_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(0, 0.0, player_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	needs_turn = event.compare_angles(character_current_yaw, character_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, character_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(20)
	event.set_mouth_motions(1, "会話", 0, "立ち", 0)
	message.say_bubble(0, -1, character_slot, 0, 0)
	needs_turn = event.compare_angles(character_current_yaw, character_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, character_current_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(11)
end

--- Turns the player and a character toward each other, plays a conversation and turns the character back.
function character.face_each_other_and_talk_primary(character_slot: s32, unused_value: any)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local player_current_yaw: f32 = 0
	local character_current_yaw: f32 = 0
	local player_target_yaw: f32 = 0
	local character_target_yaw: f32 = 0
	local needs_turn: s32 = 0
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, character_slot)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		player_current_yaw = out2 or player_current_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(character_slot)
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	do
		local _, out2, _ = event.get_character_rotation(character_slot)
		character_current_yaw = out2 or character_current_yaw
	end
	player_target_yaw = event.get_direction_angle(player_x, player_y, player_z, character_x, character_y, character_z) or player_target_yaw
	character_target_yaw = event.get_direction_angle(character_x, character_y, character_z, player_x, player_y, player_z) or character_target_yaw
	needs_turn = event.compare_angles(player_current_yaw, player_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(0, 0.0, player_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	needs_turn = event.compare_angles(character_current_yaw, character_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, character_target_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.for_frame_count(20)
	event.set_mouth_motions(1, "会話", 0, "立ち", 0)
	message.say_bubble(0, -1, character_slot, 0, 0)
	needs_turn = event.compare_angles(character_current_yaw, character_target_yaw, 0.1) or needs_turn
	if needs_turn ~= 0 then
		event.rotate_object_sequence(1, 0.0, character_current_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.for_frame_count(11)
end

--- Turns a character to look at another character and sets the standing motion.
function character.face_toward(subject_character: s32, target_character: s32)
	local subject_x: f32 = 0
	local subject_z: f32 = 0
	local target_x: f32 = 0
	local target_z: f32 = 0
	local angle: f32 = 0
	do
		local out1, _, out3 = event.get_character_position(subject_character)
		subject_x = out1 or subject_x
		subject_z = out3 or subject_z
	end
	do
		local out1, _, out3 = event.get_character_position(target_character)
		target_x = out1 or target_x
		target_z = out3 or target_z
	end
	angle = event.get_look_angle(target_x - subject_x, target_z - subject_z) or angle
	character.turn_to_angle(subject_character, angle)
	event.set_character_rotation(subject_character, 0.0, angle, 0.0)
	event.set_character_motion(subject_character, "立ち")
end

--- Computes interpolated x and z coordinates between two points over a number of steps scaled by their distance.
function character.interpolate_between_points(unused_value: s32, subject_character: any, use_camera: any)
	local start_x: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_z: f32 = 0
	local origin_x: f32 = 0
	local target_x: f32 = 0
	local delta_x: f32 = 0
	local origin_z: f32 = 0
	local target_z: f32 = 0
	local delta_z: f32 = 0
	local index: f32 = 0
	local total_steps: f32 = 0
	local interpolated_x: f32 = 0
	local interpolated_z: f32 = 0
	origin_x = start_x
	target_x = end_x
	delta_x = vm.f32(target_x - origin_x)
	origin_z = start_z
	target_z = end_z
	delta_z = vm.f32(target_z - origin_z)
	index = 0.0
	total_steps = vm.f32(cutscene.pass_through_value(calc.negate(delta_x), calc.negate(delta_z)) * 8.0)
	interpolated_x = calc.interpolate(0.0, delta_x, index, total_steps)
	interpolated_x = vm.f32(interpolated_x + origin_x)
	interpolated_z = calc.interpolate(0.0, delta_z, index, total_steps)
	interpolated_z = vm.f32(interpolated_z + origin_z)
	local _ = index < total_steps
	index = vm.f32(index + 1.0)
end

--- Interpolates between two path points with a helper that has no effect and returns an unused result.
function character.interpolate_path(path_start: s32, path_end: s32, unused_value: s32)
	local result: f32 = 0
	local unused_slot: s32 = 0
	character.interpolate_between_points(unused_slot, path_start, path_end)
	return result
end

--- Loads the station NPC model into character slot 8, activates it at its fixed position and tags it as scene character 301.
function character.load_station_npc()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "chara/p00_31a.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, -300.0, 0.0, 4360.0)
	event.set_character_rotation(8, 0.0, 3.1415927, 0.0)
	event.set_scene_character_number(8, 301)
end

--- Places the player character at a position and rotation in the standing pose.
function character.place_standing(x: f32, y: f32, z: f32, rotation_y: f32)
	event.set_character_position(0, x, y, z)
	event.set_character_rotation(0, 0.0, rotation_y, 0.0)
	event.set_character_motion(0, "立ち")
end

--- Places the player character at a position and rotation in the standing pose and resets cloth and hair.
function character.place_standing_and_reset_cloth(x: f32, y: f32, z: f32, rotation_y: f32)
	event.set_character_position(0, x, y, z)
	event.set_character_rotation(0, 0.0, rotation_y, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- Resets the action motion of the player character.
function character.reset_action_motion()
	event.reset_action_character_motion(0)
end

--- Eases a character back to a zero facing angle after a talk.
function character.restore_default_facing(subject_character: s32, unused_option: any)
	local target_angle: f32 = 0
	character.turn_to_angle_stub(subject_character, target_angle)
end

--- Eases a character back to a saved facing angle after a talk.
function character.restore_facing(subject_character: any, target_angle: f32, use_camera: s32, restore_rotation: s32)
	character.turn_to_angle_stub(subject_character, target_angle)
end

--- Eases a character back to a saved facing angle after a talk using the second turn routine.
function character.restore_facing_alt(subject_character: any, target_angle: f32, use_camera: any, restore_rotation: any)
	character.turn_to_angle_stub(subject_character, target_angle)
end

--- Eases a character back to a saved facing angle without applying it; this stands in for character.restore_facing when events are skipped.
function character.restore_facing_skipping(subject_character: s32, target_angle: f32, use_camera: s32, restore_rotation: s32)
	character.turn_to_angle_skipping(subject_character, target_angle)
end

--- Resume-path counterpart of shake_head that does nothing.
function character.resume_shake_head() end

--- Enables or disables the scene character that matches a character number.
function character.set_active_by_number(character_number: s32, enabled: s32)
	local scene_character: s32 = 0
	scene_character = event.get_character_slot_by_number(character_number) or scene_character
	event.set_character_active(enabled, scene_character)
end

--- Sets the player's standing motion to match the playable character and its movement type.
function character.set_idle_motion()
	local playable_character: s32 = 0
	local move_type: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 then
		move_type = event.get_player_move_type() or move_type
		if move_type == 1 then
			event.set_character_motion(0, "立ち-足")
		end
		if move_type == 2 then
			event.set_character_motion(0, "立ち-キャタピラ")
		end
	else
		event.set_character_motion(0, "立ち")
	end
end

--- Makes the playable character turn toward the camera and shake the head in refusal.
function character.shake_head()
	local playable_character: s32 = 0
	local shake_frames: s32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
		shake_frames = 86
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
		shake_frames = 64
	end
	if playable_character == 2 or playable_character == 3 then
		vm.wait(1)
		event.finish_event()
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.delay_object_sequence_rotation_track(0, shake_frames)
	event.rotate_object_sequence(0, rotation_x, rotation_y, rotation_z, 6)
	object.wait_until_done(0)
	if playable_character == 0 or playable_character == 1 then
		event.delete_character_extension_packs(0)
	end
	event.finish_event()
end

--- Makes the player character turn to the camera and shake their head, then ends the event.
function character.shake_head_at_camera()
	local playable_character: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	event.initialize_event()
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.load_character_motion_pack(5, "dungeon/chara/c02a_miss.gltf", "info", 0)
	end
	if playable_character == 2 or playable_character == 3 then
		vm.wait(1)
		event.finish_event()
		return
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	event.turn_object_sequence_toward(0, camera_x, camera_y, camera_z, 6)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "だめだめ", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	object.wait_until_done(0)
	if playable_character == 0 or playable_character == 1 then
		event.delete_character_extension_packs(0)
	end
	event.finish_event()
end

--- Places a villager's character at the train seat assigned to that villager, turned half a turn and set to the idle motion.
function character.sit_at_train_seat(character_slot: s32, villager_id: s32)
	local seat_id: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local lateral_distance: s32 = 0
	seat_id = event.get_villager_training_value(1, villager_id) or seat_id
	do
		local out1, out2, out3, _ = event.get_train_seat_position(seat_id)
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	lateral_distance = event.get_villager_training_value(2, villager_id) or lateral_distance
	if position_x < 0 then
		position_x = vm.f32(lateral_distance * -1.0)
	else
		position_x = lateral_distance
	end
	event.set_character_position(character_slot, position_x, position_y, position_z)
	event.set_character_rotation(character_slot, 0.0, 3.1415927, 0.0)
	event.set_character_motion(character_slot, "待機", 4)
end

--- Runs the skip-mode path of a character conversation that turns the character, shows the line and restores its facing, using the second message helper.
function character.talk_to_skipped_variant(character_slot: s32, text_id: s32, use_camera: s32, restore_rotation: s32)
	local original_angle: f32 = 0
	local player_slot: s32 = 0
	original_angle = character.interpolate_path(character_slot, use_camera, restore_rotation)
	message.show_then_close(0, text_id, character_slot, player_slot, 0)
	character.restore_facing_skipping(character_slot, original_angle, use_camera, restore_rotation)
end

--- Rotates the player to the given rotation over a time scaled by the turn angle while playing the walk motion, then stands and ends the event.
function character.turn_player_to_rotation(target_rotation: f32)
	local current_rotation: f32 = 0
	local target_wrapped: f32 = 0
	local current_wrapped: f32 = 0
	local rotation_difference: f32 = 0
	do
		local _, out2, _ = event.get_character_rotation(0)
		current_rotation = out2 or current_rotation
	end
	target_wrapped = vm.f32(target_rotation + vm.f32(6.2831855))
	current_wrapped = vm.f32(current_rotation + vm.f32(6.2831855))
	rotation_difference = vm.f32(target_wrapped - current_wrapped)
	if rotation_difference < 0 then
		rotation_difference = vm.f32(rotation_difference * -1.0)
	end
	if vm.f32(3.1415927) < rotation_difference then
		rotation_difference = vm.f32(rotation_difference - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < rotation_difference then
		rotation_difference = vm.f32(rotation_difference - vm.f32(3.1415927))
	end
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, target_rotation, 0.0, vm.ftoi(vm.f32(rotation_difference * 10.0)))
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	event.finish_event()
end

--- Turns a character to a target angle over ten interpolation steps, using a walking or standing motion by the size of the turn.
function character.turn_to_angle(character_slot: any, target_angle: f32)
	local handle_rotation_y: f32 = 0
	local start_rotation: f32 = 0
	local target_rotation: f32 = 0
	local turn_angle: f32 = 0
	local blended_rotation: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	event.attach_object_handle_to_character(0, character_slot)
	event.get_object_handle_position(0)
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		handle_rotation_y = out2 or handle_rotation_y
	end
	start_rotation = handle_rotation_y
	target_rotation = target_angle
	turn_angle = vm.f32(target_rotation - start_rotation)
	turn_angle = event.wrap_angle(turn_angle) or turn_angle
	if -0.5 < turn_angle and turn_angle < 0.5 then
		event.set_character_motion(character_slot, "立ち")
	else
		event.set_character_motion(character_slot, "歩き")
	end
	frame = 0.0
	frame_count = 10.0
	while frame <= frame_count do
		blended_rotation = calc.interpolate(0.0, turn_angle, frame, frame_count)
		blended_rotation = vm.f32(blended_rotation + start_rotation)
		event.set_object_handle_rotation(0, 0.0, blended_rotation, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.set_object_handle_rotation(0, 0.0, target_angle, 0.0)
end

--- Computes the interpolated angles of a smooth turn without applying them; this stands in for turning a character to a target angle when events are skipped.
function character.turn_to_angle_skipping(character_slot: s32, target_angle: f32)
	local current_angle: f32 = 0
	local start_angle: f32 = 0
	local end_angle: f32 = 0
	local angle_difference: f32 = 0
	local interpolated_angle: f32 = 0
	local step: f32 = 0
	local step_count: f32 = 0
	start_angle = current_angle
	end_angle = target_angle
	angle_difference = vm.f32(end_angle - start_angle)
	step = 0.0
	step_count = 10.0
	interpolated_angle = calc.interpolate(0.0, angle_difference, step, step_count)
	interpolated_angle = vm.f32(interpolated_angle + start_angle)
	local _ = step <= step_count
	step = vm.f32(step + 1.0)
end

--- Computes the interpolated facing angle toward a target angle over ten steps without applying it to the character.
function character.turn_to_angle_stub(subject_character: any, target_angle: f32)
	local initial_angle: f32 = 0
	local start_angle: f32 = 0
	local end_angle: f32 = 0
	local angle_delta: f32 = 0
	local current_angle: f32 = 0
	local step: f32 = 0
	local step_count: f32 = 0
	start_angle = initial_angle
	end_angle = target_angle
	angle_delta = vm.f32(end_angle - start_angle)
	step = 0.0
	step_count = 10.0
	current_angle = calc.interpolate(0.0, angle_delta, step, step_count)
	current_angle = vm.f32(current_angle + start_angle)
	local _ = step <= step_count
	step = vm.f32(step + 1.0)
end

--- Smoothly turns a character to the target rotation, playing the walk motion for turns larger than a small threshold.
function character.turn_to_rotation(character_slot: any, target_rotation: f32)
	local start_rotation: f32 = 0
	local rotation_delta: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	local rotation_y: f32 = 0
	do
		local _, out2, _ = event.get_character_rotation(character_slot)
		start_rotation = out2 or start_rotation
	end
	rotation_delta = vm.f32(target_rotation - start_rotation)
	if rotation_delta < vm.f32(-3.1415927) then
		rotation_delta = vm.f32(rotation_delta + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < rotation_delta then
		rotation_delta = vm.f32(rotation_delta - vm.f32(6.2831855))
	end
	if -0.5 < rotation_delta and rotation_delta < 0.5 then
	else
		event.set_character_motion(character_slot, "歩き")
	end
	frame = 0.0
	frame_count = vm.f32(calc.absolute(rotation_delta) * 8.0)
	while frame < frame_count do
		rotation_y = calc.interpolate(0.0, rotation_delta, frame, frame_count)
		rotation_y = vm.f32(rotation_y + start_rotation)
		event.set_character_rotation(character_slot, 0.0, rotation_y, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.get_character_rotation(character_slot, 0.0, target_rotation, 0.0)
	event.set_character_motion(character_slot, "立ち")
end

--- Smoothly turns a character toward a target angle over several frames.
function character.turn_toward_angle(target_character: s32, target_angle: f32)
	local current_angle: f32 = 0
	local angle_delta: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	local interpolated_angle: f32 = 0
	angle_delta = vm.f32(target_angle - current_angle)
	local _ = angle_delta < vm.f32(-3.1415927)
	angle_delta = vm.f32(angle_delta + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < angle_delta
	angle_delta = vm.f32(angle_delta - vm.f32(6.2831855))
	frame = 0.0
	frame_count = vm.f32(calc.negate(angle_delta) * 8.0)
	interpolated_angle = calc.interpolate(0.0, angle_delta, frame, frame_count)
	interpolated_angle = vm.f32(interpolated_angle + current_angle)
	local _ = frame < frame_count
	frame = vm.f32(frame + 1.0)
end

--- Smoothly turns a character toward a target yaw and pitch over several frames.
function character.turn_toward_angles(target_character: s32, unused_yaw: any, unused_pitch: any)
	local target_yaw: f32 = 0
	local target_pitch: f32 = 0
	local current_yaw: f32 = 0
	local current_pitch: f32 = 0
	local start_yaw: f32 = 0
	local end_yaw: f32 = 0
	local yaw_delta: f32 = 0
	local interpolated_yaw: f32 = 0
	local start_pitch: f32 = 0
	local end_pitch: f32 = 0
	local pitch_delta: f32 = 0
	local interpolated_pitch: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	start_yaw = current_yaw
	end_yaw = target_yaw
	yaw_delta = vm.f32(end_yaw - start_yaw)
	local _ = yaw_delta < vm.f32(-3.1415927)
	yaw_delta = vm.f32(yaw_delta + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < yaw_delta
	yaw_delta = vm.f32(yaw_delta - vm.f32(6.2831855))
	start_pitch = current_pitch
	end_pitch = target_pitch
	pitch_delta = vm.f32(end_pitch - start_pitch)
	local _ = pitch_delta < vm.f32(-3.1415927)
	pitch_delta = vm.f32(pitch_delta + vm.f32(6.2831855))
	local _ = vm.f32(3.1415927) < pitch_delta
	pitch_delta = vm.f32(pitch_delta - vm.f32(6.2831855))
	frame = 0.0
	frame_count = vm.f32(cutscene.pass_through_value(calc.negate(yaw_delta), calc.negate(pitch_delta)) * 8.0)
	interpolated_yaw = calc.interpolate(0.0, yaw_delta, frame, frame_count)
	interpolated_yaw = vm.f32(interpolated_yaw + start_yaw)
	interpolated_pitch = calc.interpolate(0.0, pitch_delta, frame, frame_count)
	interpolated_pitch = vm.f32(interpolated_pitch + start_pitch)
	local _ = frame < frame_count
	frame = vm.f32(frame + 1.0)
end

return character
