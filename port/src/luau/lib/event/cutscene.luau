--!strict
--- Holds staging helpers that fit no other topic.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local npc = vm.module("@lib/event/npc")
local object = vm.module("@lib/event/object")
local sindain_station = vm.module("@lib/event/sindain_station")
local wait = vm.module("@lib/event/wait")
local zelmite_mine = vm.module("@lib/event/zelmite_mine")

local cutscene = {}

--- Passes slots 2, 1, 0 and 3 in that order to the placeholder that ignores its value.
function cutscene.apply_to_slots_in_order()
	cutscene.ignore_value(2)
	cutscene.ignore_value(1)
	cutscene.ignore_value(0)
	cutscene.ignore_value(3)
end

--- Prepares a talk, asks the player a choice in a bubble message and ends the talk, returning the choice.
function cutscene.ask_character_choice(subject_character: s32, text: s32, option_count: s32, selection: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local player_character: s32 = 0
	local selection_result: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		resume_point = 1
		saved_rotation = cutscene.begin_talk_with_camera_flag(subject_character, use_camera, restore_rotation)
		player_character = event.get_player_character_slot() or player_character
		resume_point = 2
		selection_result = message.ask_choice_bubble(0, text, subject_character, player_character, option_count, selection)
		resume_point = 3
		cutscene.end_talk_with_stub_turn(subject_character, saved_rotation, use_camera, restore_rotation)
		return selection_result
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point == 1 then
				saved_rotation = received[1] :: number
			end
			if resume_point == 2 then
				selection_result = received[1] :: number
			end
			if resume_point <= 1 then
				selection_result = message.ask_choice_bubble_stub(0, text, subject_character, player_character, option_count, selection)
			end
			if resume_point <= 2 then
				character.restore_facing_alt(subject_character, saved_rotation, use_camera, restore_rotation)
			end
			return selection_result
		end
		return nil
	end)
end

--- Runs a stubbed talk with a choice and returns the result.
function cutscene.ask_choice_talk_stub(subject_character: s32, text: s32, option_count: s32, selection: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local player_character: s32 = 0
	local selection_result: s32 = 0
	saved_rotation = cutscene.begin_talk_stub_with_camera_flag(subject_character, use_camera, restore_rotation)
	selection_result = message.ask_choice_bubble_stub(0, text, subject_character, player_character, option_count, selection)
	character.restore_facing_alt(subject_character, saved_rotation, use_camera, restore_rotation)
	return selection_result
end

--- Asks two questions and then offsets a position along a circle of radius 100.
function cutscene.ask_two_questions_then_orbit()
	local index: s32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local elapsed_a: f32 = 0
	local elapsed_b: f32 = 0
	local angle: f32 = 0
	local _ = message.ask_choice_skipping(0, 2002, 8, 256, 208, 2, 1)
	local _ = message.ask_choice_skipping(0, -1, 8, 256, 208, 2, 1)
	index = 0
	elapsed_a = vm.f32(elapsed_a + 1.0)
	elapsed_b = vm.f32(elapsed_b + 1.0)
	index = index + 1
	angle = vm.f32(angle - vm.f32(3.1415927))
	x = vm.f32(vm.f32(vm.sin(angle) * 100.0) + x)
	y = vm.f32(y + 30.0)
	z = vm.f32(vm.f32(vm.cos(angle) * 100.0) + z)
end

--- Faces the player and a character toward each other and returns the original rotation of the character.
function cutscene.begin_talk(character_slot: any, use_camera: any, save_rotation: any)
	local saved_rotation: f32 = 0
	local player_slot: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		if save_rotation ~= 0 then
			event.attach_object_handle_to_character(0, character_slot)
			do
				local _, out2, _ = event.get_object_handle_rotation(0)
				saved_rotation = out2 or saved_rotation
			end
		end
		player_slot = event.get_player_character_slot() or player_slot
		resume_point = 1
		cutscene.face_each_other(player_slot, character_slot, use_camera)
		return saved_rotation
	end, function(received: { any })
		if resume_point <= 1 then
			return saved_rotation
		end
		return nil
	end)
end

--- Stands in for beginning a talk by running a stub interpolation with player slot zero and returns a zero saved rotation.
function cutscene.begin_talk_stub(character_slot: any, use_camera: s32, save_rotation: s32)
	local saved_rotation: f32 = 0
	local player_slot: s32 = 0
	character.interpolate_between_points(player_slot, character_slot, use_camera)
	return saved_rotation
end

--- Starts a talk using the stubbed turn routine and returns an empty rotation. Takes the camera flag as an integer.
function cutscene.begin_talk_stub_with_camera_flag(subject_character: any, use_camera: any, save_rotation: any)
	local saved_rotation: f32 = 0
	local unused_value: s32 = 0
	character.interpolate_between_points(unused_value, subject_character, use_camera)
	return saved_rotation
end

--- Optionally saves a character's rotation, then turns the player and character to face each other and returns the saved rotation. Takes the camera flag as an integer.
function cutscene.begin_talk_with_camera_flag(subject_character: s32, use_camera: s32, save_rotation: s32)
	local original_rotation_y: f32 = 0
	local player_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		if save_rotation ~= 0 then
			event.attach_object_handle_to_character(0, subject_character)
			do
				local _, out2, _ = event.get_object_handle_rotation(0)
				original_rotation_y = out2 or original_rotation_y
			end
		end
		player_character = event.get_player_character_slot() or player_character
		resume_point = 1
		cutscene.face_each_other_with_camera_flag(player_character, subject_character, use_camera)
		return original_rotation_y
	end, function(received: { any })
		if resume_point <= 1 then
			return original_rotation_y
		end
		return nil
	end)
end

--- Calls the empty placeholder step.
function cutscene.call_do_nothing()
	cutscene.placeholder_step()
end

--- Calls the Zelmite mine slot loop step.
function cutscene.call_slot_loop()
	zelmite_mine.run_empty_loop()
end

--- Accepts a value and does nothing with it.
function cutscene.discard_value(value: s32) end

--- Does nothing; placeholder hook called by event scripts.
function cutscene.do_nothing() end

--- Returns a character to the saved rotation, ends the event and fades back from the talk camera.
function cutscene.end_talk(character_slot: any, saved_rotation: f32, used_camera: any, restore_rotation: any)
	if restore_rotation ~= 0 then
		character.turn_to_angle(character_slot, saved_rotation)
	end
	event.set_character_motion(character_slot, "立ち")
	event.finish_event()
	if used_camera ~= 0 then
		event.start_crossfade(10)
	end
end

--- Optionally restores a character's rotation, sets the standing motion, finishes the event and optionally crossfades. It turns using the stubbed turn.
function cutscene.end_talk_with_stub_turn(subject_character: s32, saved_rotation: f32, used_camera: s32, restore_rotation: s32)
	if restore_rotation ~= 0 then
		character.turn_to_angle(subject_character, saved_rotation)
	end
	event.set_character_motion(subject_character, "立ち")
	event.finish_event()
	if used_camera ~= 0 then
		event.start_crossfade(10)
	end
end

--- Turns two characters toward each other, optionally framing them with the talk camera.
function cutscene.face_each_other(character_slot: s32, other_slot: any, set_camera: any)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local rotation_y: f32 = 0
	local other_rotation_y: f32 = 0
	local angle_to_other: f32 = 0
	local angle_from_other: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_x: f32 = 0
	local look_y: f32 = 0
	local look_z: f32 = 0
	local start_rotation: f32 = 0
	local target_rotation: f32 = 0
	local turn_angle: f32 = 0
	local other_start_rotation: f32 = 0
	local other_target_rotation: f32 = 0
	local other_turn_angle: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	local blended_rotation: f32 = 0
	local other_blended_rotation: f32 = 0
	do
		local out1, out2, out3 = event.get_character_position(character_slot)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local _, out2, _ = event.get_character_rotation(character_slot)
		rotation_y = out2 or rotation_y
	end
	do
		local out1, out2, out3 = event.get_character_position(other_slot)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	do
		local _, out2, _ = event.get_character_rotation(other_slot)
		other_rotation_y = out2 or other_rotation_y
	end
	angle_to_other = event.get_look_angle(other_x - x, other_z - z) or angle_to_other
	angle_from_other = event.get_look_angle(x - other_x, z - other_z) or angle_from_other
	if set_camera ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(x, y, z, other_x, other_y, other_z, angle_to_other)
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
			look_x = out4 or look_x
			look_y = out5 or look_y
			look_z = out6 or look_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_x, look_y, look_z)
		event.start_crossfade(10)
	end
	start_rotation = rotation_y
	target_rotation = angle_to_other
	turn_angle = vm.f32(target_rotation - start_rotation)
	turn_angle = event.wrap_angle(turn_angle) or turn_angle
	other_start_rotation = other_rotation_y
	other_target_rotation = angle_from_other
	other_turn_angle = vm.f32(other_target_rotation - other_start_rotation)
	other_turn_angle = event.wrap_angle(other_turn_angle) or other_turn_angle
	if -0.5 < turn_angle and turn_angle < 0.5 then
		event.set_character_motion(character_slot, "立ち")
	else
		event.set_character_motion(character_slot, "歩き")
	end
	if -0.5 < other_turn_angle and other_turn_angle < 0.5 then
	else
		event.set_character_motion(other_slot, "歩き")
	end
	frame = 0.0
	frame_count = vm.f32(calc.max(calc.absolute(turn_angle), calc.absolute(other_turn_angle)) * 8.0)
	while frame < frame_count do
		blended_rotation = calc.interpolate(0.0, turn_angle, frame, frame_count)
		blended_rotation = vm.f32(blended_rotation + start_rotation)
		event.set_character_rotation(character_slot, 0.0, blended_rotation, 0.0)
		other_blended_rotation = calc.interpolate(0.0, other_turn_angle, frame, frame_count)
		other_blended_rotation = vm.f32(other_blended_rotation + other_start_rotation)
		event.set_character_rotation(other_slot, 0.0, other_blended_rotation, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.set_character_rotation(character_slot, 0.0, angle_to_other, 0.0)
	event.set_character_motion(character_slot, "立ち")
	event.set_character_rotation(other_slot, 0.0, angle_from_other, 0.0)
	event.set_character_motion(other_slot, "会話")
end

--- Turns two characters toward each other with an optional talk camera and sets their talking motions. Takes the camera flag as an integer.
function cutscene.face_each_other_with_camera_flag(first_character: s32, second_character: any, use_talk_camera: s32)
	local first_x: f32 = 0
	local first_y: f32 = 0
	local first_z: f32 = 0
	local second_x: f32 = 0
	local second_y: f32 = 0
	local second_z: f32 = 0
	local first_rotation_y: f32 = 0
	local second_rotation_y: f32 = 0
	local first_look_angle: f32 = 0
	local second_look_angle: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local first_start_angle: f32 = 0
	local first_target_angle: f32 = 0
	local first_delta: f32 = 0
	local second_start_angle: f32 = 0
	local second_target_angle: f32 = 0
	local second_delta: f32 = 0
	local step: f32 = 0
	local step_count: f32 = 0
	local first_step_rotation: f32 = 0
	local second_step_rotation: f32 = 0
	do
		local out1, out2, out3 = event.get_character_position(first_character)
		first_x = out1 or first_x
		first_y = out2 or first_y
		first_z = out3 or first_z
	end
	do
		local _, out2, _ = event.get_character_rotation(first_character)
		first_rotation_y = out2 or first_rotation_y
	end
	do
		local out1, out2, out3 = event.get_character_position(second_character)
		second_x = out1 or second_x
		second_y = out2 or second_y
		second_z = out3 or second_z
	end
	do
		local _, out2, _ = event.get_character_rotation(second_character)
		second_rotation_y = out2 or second_rotation_y
	end
	first_look_angle = event.get_look_angle(second_x - first_x, second_z - first_z) or first_look_angle
	second_look_angle = event.get_look_angle(first_x - second_x, first_z - second_z) or second_look_angle
	if use_talk_camera ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(first_x, first_y, first_z, second_x, second_y, second_z, first_look_angle)
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
			look_at_x = out4 or look_at_x
			look_at_y = out5 or look_at_y
			look_at_z = out6 or look_at_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.start_crossfade(10)
	end
	first_start_angle = first_rotation_y
	first_target_angle = first_look_angle
	first_delta = vm.f32(first_target_angle - first_start_angle)
	first_delta = event.wrap_angle(first_delta) or first_delta
	second_start_angle = second_rotation_y
	second_target_angle = second_look_angle
	second_delta = vm.f32(second_target_angle - second_start_angle)
	second_delta = event.wrap_angle(second_delta) or second_delta
	if -0.5 < first_delta and first_delta < 0.5 then
		event.set_character_motion(first_character, "立ち")
	else
		event.set_character_motion(first_character, "歩き")
	end
	if -0.5 < second_delta and second_delta < 0.5 then
	else
		event.set_character_motion(second_character, "歩き")
	end
	step = 0.0
	step_count = vm.f32(calc.max(calc.absolute(first_delta), calc.absolute(second_delta)) * 8.0)
	while step < step_count do
		first_step_rotation = calc.interpolate(0.0, first_delta, step, step_count)
		first_step_rotation = vm.f32(first_step_rotation + first_start_angle)
		event.set_character_rotation(first_character, 0.0, first_step_rotation, 0.0)
		second_step_rotation = calc.interpolate(0.0, second_delta, step, step_count)
		second_step_rotation = vm.f32(second_step_rotation + second_start_angle)
		event.set_character_rotation(second_character, 0.0, second_step_rotation, 0.0)
		step = vm.f32(step + 1.0)
		vm.wait(1)
	end
	event.set_character_rotation(first_character, 0.0, first_look_angle, 0.0)
	event.set_character_motion(first_character, "立ち")
	event.set_character_rotation(second_character, 0.0, second_look_angle, 0.0)
	event.set_character_motion(second_character, "会話")
end

--- Returns the fixed number 112.
function cutscene.get_fixed_value_skipping()
	local value: s32 = 0
	value = 0
	value = 110
	value = 111
	value = 112
	return value
end

--- Prints the talk character ids, runs a default-message talk and waits through a series of frame delays.
function cutscene.go_shop_up()
	local talk_character: s32 = 0
	local talk_character_id: s32 = 0
	print("IN go_shop_up()\n")
	print("talk_chara=", talk_character, "talk_chara_id=", talk_character_id, "\n")
	cutscene.talk_skipping(talk_character_id, -1, 0, 0)
	menu.resume_shop_menu(15)
	menu.resume_shop_menu(1)
	menu.resume_shop_menu(6)
	menu.resume_shop_menu(0)
	menu.resume_shop_menu(4)
	menu.resume_shop_menu(31)
	menu.resume_shop_menu(35)
	menu.resume_shop_menu(36)
	menu.resume_shop_menu(37)
end

--- Prints the talk character ids, runs a stubbed default-message talk and waits through a series of skippable delays.
function cutscene.go_shop_up_skippable()
	local talk_character: s32 = 0
	local talk_character_id: s32 = 0
	print("IN go_shop_up()\n")
	print("talk_chara=", talk_character, "talk_chara_id=", talk_character_id, "\n")
	cutscene.talk_to_character_stub_message(talk_character_id, -1, 0, 0)
	wait.pause_skippable(15)
	wait.pause_skippable(1)
	wait.pause_skippable(6)
	wait.pause_skippable(0)
	wait.pause_skippable(4)
	wait.pause_skippable(31)
	wait.pause_skippable(35)
	wait.pause_skippable(36)
	wait.pause_skippable(37)
end

--- Forwards to the logged skippable shop-up sequence.
function cutscene.go_shop_up_skippable_forwarded()
	cutscene.log_and_go_shop_up_skippable()
end

--- Moves event sprite 0 off the foreground draw pass.
function cutscene.hide_event_sprite()
	event.set_event_sprite_draw_pass(0, 0)
end

--- Accepts an argument and does nothing.
function cutscene.ignore_argument(unused_value: any) end

--- Accepts a position and rotation and does nothing.
function cutscene.ignore_coordinates(unused_x: f32, unused_y: f32, unused_z: f32, unused_rotation: f32) end

--- Passes the opposite of the given flag to the placeholder that ignores its value.
function cutscene.ignore_inverted_flag(enabled: s32)
	cutscene.ignore_value(if enabled == 0 then 1 else 0)
end

--- Accepts a value and does nothing.
function cutscene.ignore_value(unused_value: s32) end

--- Loads the five e209 event actors and the e209_1 message file.
function cutscene.load_e209_actors()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e209/e209_minchu.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e209/e209_eina.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e209/e209_pai_b.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e209/e209_pai_s.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e209/e209_osara.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e200/e209/e209_1.txt")
	event.set_character_active(0, 0)
end

--- Loads the five e209 event actors and the e209 message file.
function cutscene.load_e209_actors_primary()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e200/e209/e209_minchu.gltf", "info", 32)
	event.attach_object_handle_to_character(0, 32)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_character_active(0, 32)
	event.load_character(5, "event/e200/e209/e209_eina.gltf", "info", 33)
	event.attach_object_handle_to_character(1, 33)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(0, 33)
	event.load_character(5, "event/e200/e209/e209_pai_b.gltf", "info", 34)
	event.attach_object_handle_to_character(2, 34)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(0, 34)
	event.load_character(5, "event/e200/e209/e209_pai_s.gltf", "info", 36)
	event.attach_object_handle_to_character(4, 36)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_character_active(0, 36)
	event.load_character(5, "event/e200/e209/e209_osara.gltf", "info", 35)
	event.attach_object_handle_to_character(3, 35)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(0, 35)
	event.load_message_file(0, 5, "event/e200/e209/e209.txt")
	event.set_character_active(0, 0)
end

--- Loads the rock thrower and two rock models and binds them to object sequences.
function cutscene.load_rock_throw_actors()
	event.set_message_window_mode(0, 7)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "event/e600/e616/e616_toryon.gltf", "info", 39)
	event.set_character_active(0, 39)
	event.attach_object_handle_to_character(3, 39)
	event.clear_object_sequence(3, 39)
	event.set_object_sequence_object(3, 3)
	event.load_character(5, "event/e600/e616/e616_iwa.gltf", "info", 40)
	event.set_character_active(0, 40)
	event.attach_object_handle_to_character(4, 40)
	event.clear_object_sequence(4, 40)
	event.set_object_sequence_object(4, 4)
	event.copy_character(5, 40, 41)
	event.set_character_active(0, 41)
	event.attach_object_handle_to_character(5, 41)
	event.clear_object_sequence(5, 41)
	event.set_object_sequence_object(5, 5)
end

--- Prints the talk character ids and runs the shop-up sequence.
function cutscene.log_and_go_shop_up()
	local talk_character_id: s32 = 0
	local talk_character: s32 = 0
	print("talk_chara_id=", talk_character_id, "talk_chara=", talk_character, "\n")
	cutscene.go_shop_up()
end

--- Prints the talk character ids and runs the skippable shop-up sequence.
function cutscene.log_and_go_shop_up_skippable()
	local talk_character_id: s32 = 0
	local talk_character: s32 = 0
	print("talk_chara_id=", talk_character_id, "talk_chara=", talk_character, "\n")
	cutscene.go_shop_up_skippable()
end

--- Does nothing.
function cutscene.noop() end

--- Does nothing.
function cutscene.noop_2() end

--- Does nothing and ignores both arguments.
function cutscene.noop_with_arguments(unused_a: s32, unused_b: s32) end

--- Returns its first argument unchanged.
function cutscene.pass_through_value(value: f32, unused_value: f32)
	return value
end

--- Runs skip-mode waits of 40 and 15 frames and then passes a fixed map point and rotation to the placement placeholder.
function cutscene.pause_then_move_to_point()
	wait.frames_skipping(40)
	wait.frames_skipping(15)
	cutscene.ignore_coordinates(vm.f32(2358.3), 0.0, vm.f32(1357.7), vm.f32(0.06))
end

--- Placeholder step that does nothing.
function cutscene.placeholder_step() end

--- Plays the event e522 scene in which the party member touches Atlamillia at the given world coordinate and rotation.
function cutscene.play_atlamillia_touch_scene(
	x: f32,
	y: f32,
	z: f32,
	rotation_y: f32
)
	local sound_effect_id: s32 = 0
	local party_npc_id: s32 = 0
	local language: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(522, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_effect_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or sound_effect_id
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(x, y, z, rotation_y)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		event.load_character_motion_pack(5, "event/e500/e522/e522_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 0)
		party_npc_id = event.get_party_npc() or party_npc_id
		if party_npc_id ~= -1 then
			event.load_npc_character(0, 5, party_npc_id, 33)
			event.set_character_active(0, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.set_scene_character_type(34, 4)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		language = event.get_language() or language
		if language == 0 then
			event.load_message_file(0, 5, "event/e500/e522/e522.txt")
		else
			event.load_message_file(0, 5, "event/e500/e522/e522_1.txt")
		end
		event.fade_out_screen(30)
		wait.frames(30)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_effect_id, 0)
		event.enable_drama_skip()
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(5.32, 62.92, -97.07)
		event.set_camera_sequence_look_at(11.48, 61.6, -39.43)
		event.set_object_sequence_position(0, 39.64, -0.0, 9.33)
		event.set_object_sequence_rotation(0, 0.0, -2.33, 0.0)
		event.set_object_sequence_position(1, 34.65, 0.0, 29.92)
		event.set_object_sequence_rotation(1, 0.0, -2.36, 0.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 0)
		event.move_camera_sequence_eased(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
		camera.wait_until_done()
		event.set_character_active(0, 33)
		event.set_camera_sequence_position(25.53, 21.33, -15.17)
		event.set_camera_sequence_look_at(32.72, 21.29, -3.29)
		event.set_object_sequence_rotation(0, 0.0, -2.69, 0.0)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_character_active(1, 34)
		event.get_object_handle_frame_position(0, "atoramiria")
		event.attach_character_to_frame(0, "atoramiria", 34)
		event.set_character_position(34, 0.04, -1.42988, 0.89)
		event.delay_object_sequence_sound_track(2, 25)
		event.play_object_sequence_sound(2, sound_effect_id, 1)
		event.set_object_sequence_motion(2, "発動", 6)
		event.queue_object_sequence_next_motion(2, "発動L", 0)
		event.set_object_sequence_motion(0, "アトラ見る", 6)
		event.queue_object_sequence_next_motion(0, "アトラ見るL", 0)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "アトラさわる", 6)
		event.queue_object_sequence_next_motion(0, "アトラさわるL", 6)
		message.show_voiced(5220010)
		message.show_voiced(5220015)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect_id, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
end

--- Plays the rock-throwing cutscene as a drama-skippable section using for_frame_count waits, fading out at the end.
function cutscene.play_rock_throwing()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(7202) or sound_bank
		event.set_character_active(0, 0)
		cutscene.load_rock_throw_actors()
		event.enable_drama_skip()
		event.set_object_sequence_position(3, 418.95, 294.2, 1072.8)
		event.set_object_sequence_rotation(3, 0.0, -2.72, 0.0)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "手を上げる", 6)
		event.play_sound_effect(sound_bank, 3)
		event.play_sound_effect(sound_bank, 4)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(255.67, 441.0, 685.71)
		event.set_camera_sequence_look_at(418.95, 461.85, 1072.8)
		wait.for_frame_count(60)
		event.set_camera_sequence_position(-1039.68, 1120.44, 3017.49)
		event.set_camera_sequence_look_at(-375.04, 936.38, 1696.66)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_object_sequence_motion(3, "岩を投げる", 4)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.for_frame_count(30)
		event.play_sound_effect(sound_bank, 6)
		event.fade_out_screen(30)
		wait.for_frame_count(35)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	cutscene.unload_rock_throw_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Plays the rock-throwing cutscene as a drama-skippable section using wait_frames, fading out at the end.
function cutscene.play_rock_throwing_2()
	local sound_bank: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_bank = event.load_sound_effect_file_2(7202) or sound_bank
		event.set_character_active(0, 0)
		cutscene.load_rock_throw_actors()
		event.enable_drama_skip()
		event.set_object_sequence_position(3, 418.95, 294.2, 1072.8)
		event.set_object_sequence_rotation(3, 0.0, -2.72, 0.0)
		event.attach_object_handle_to_character_frame(20, 39, "puropera")
		event.clear_object_sequence(20)
		event.set_object_sequence_object(20, 20)
		event.rotate_object_sequence(20, 0.0, -0.08, 0.0, -1)
		event.set_character_active(1, 39)
		event.set_object_sequence_motion(3, "手を上げる", 6)
		event.play_sound_effect(sound_bank, 3)
		event.play_sound_effect(sound_bank, 4)
		event.fade_in_screen(30)
		event.set_camera_sequence_position(255.67, 441.0, 685.71)
		event.set_camera_sequence_look_at(418.95, 461.85, 1072.8)
		wait.frames(60)
		event.set_camera_sequence_position(-1039.68, 1120.44, 3017.49)
		event.set_camera_sequence_look_at(-375.04, 936.38, 1696.66)
		event.set_character_active(1, 40)
		event.set_character_active(1, 41)
		event.set_object_sequence_motion(3, "岩を投げる", 4)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(4, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(4, -200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.play_sound_effect(sound_bank, 5)
		event.set_object_sequence_position(5, 418.95, 500.0, 1072.8)
		event.jump_object_sequence(5, 200.0, 500.0, -1000.0, -1.2, 60)
		wait.frames(30)
		event.play_sound_effect(sound_bank, 6)
		event.fade_out_screen(30)
		wait.frames(35)
	end)
	event.cancel_drama_scene_skip()
	event.skip_next_music_load()
	event.stop_port_sound_effects(4)
	cutscene.unload_rock_throw_actors()
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Runs the stubbed talk sequences for default characters, then the skippable shop-up sequence.
function cutscene.play_talk_sequence_default()
	local subject_character: s32 = 0
	local player_character: s32 = 0
	cutscene.play_talk_sequence_stub(subject_character, player_character)
	cutscene.go_shop_up_skippable_forwarded()
end

--- Runs the stubbed talk sequences and a stubbed choice talk for a character.
function cutscene.play_talk_sequence_stub(subject_character: s32, player_character: s32)
	cutscene.show_bubble_then_talk_forwarded(subject_character, player_character)
	cutscene.show_two_default_messages_stub_forwarded(subject_character, player_character)
	local _ = cutscene.ask_choice_talk_stub(subject_character, -1, 2, 0, 0, 0)
end

--- Plays the time gate scene with the blue or red gate and the Atla effect that sends the party to the future.
function cutscene.play_time_gate_jump_to_future(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32,
	use_red_gate: s32,
	show_both_characters: s32
)
	local flag_612: s32 = 0
	local party_npc_id: s32 = 0
	local playable_character: s32 = 0
	local flagged_sound_effect: s32 = 0
	local default_sound_effect: s32 = 0
	local frame_x: f32 = 0
	local frame_y: f32 = 0
	local frame_z: f32 = 0
	vm.section(function()
		vm.entry(1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		flag_612 = event.get_save_flag(612) or flag_612
		event.set_character_motion(0, "立ち")
		if use_red_gate ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
		wait.background_load()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		if use_red_gate ~= 0 then
			event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.load_character(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
		else
			event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.load_character(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
		end
		event.set_character_active(35)
		event.set_scene_character_type(35, 4)
		event.attach_object_handle_to_character(3, 35)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
		event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
		event.set_character_active(36)
		event.set_scene_character_type(36, 4)
		event.attach_object_handle_to_character(4, 36)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		party_npc_id = event.get_party_npc() or party_npc_id
		if party_npc_id ~= -1 then
			event.load_npc_character(0, 5, party_npc_id, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 49.73999, 0.0, 8.969971)
			event.set_object_handle_rotation(2, 0.0, -1.76, 0.0)
		end
		if show_both_characters ~= 0 then
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if playable_character == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if playable_character == 0 then
				if flag_612 ~= 0 then
					event.load_character_motion_pack(5, "event/e00/e80/e80_mints.gltf", "info", 0)
				else
					event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
				end
				event.set_character_active(0)
				event.attach_object_handle_to_character(0, 0)
				event.load_character(5, "chara/c02_base.gltf", "info", 33)
				event.set_character_active(33)
				event.attach_object_handle_to_character(1, 33)
				event.load_equipment_model(5, 1, 4, "info", 33)
				event.load_equipment_model(5, 1, 3, "info", 33)
				event.load_equipment_model(5, 1, 2, "info", 33, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_object_handle_visible(5, 1)
			end
			if playable_character == 1 then
				event.load_character(5, "chara/c01_base.gltf", "info", 32)
				if flag_612 ~= 0 then
					event.load_character_motion_pack(5, "event/e00/e80/e80_mints.gltf", "info", 32)
				else
					event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 32)
				end
				event.set_character_active(32)
				event.attach_object_handle_to_character(0, 32)
				event.load_equipment_model(5, 0, 4, "info", 32)
				event.load_equipment_model(5, 0, 3, "info", 32)
				event.load_equipment_model(5, 0, 2, "info", 32, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_object_handle_visible(5, 1)
				event.set_character_active(0)
				event.attach_object_handle_to_character(1, 0)
			end
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 38.0, 0.0, 22.0)
			event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_handle_position(1, 18.619995, 0.0, 35.179993)
			event.set_object_handle_rotation(1, 0.0, -2.48, 0.0)
			event.set_object_handle_motion(1, "立ち", 0.02)
			event.reset_object_handle_dynamic_animation(1)
		else
			event.get_equipped_item(1, 2)
			event.get_equipped_item(1, 3)
			event.get_equipped_item(1, 4)
			event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
			event.load_character_motion_pack(5, "event/e500/e523/e523_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 38.0, 0.0, 22.0)
			event.set_object_sequence_rotation(0, 0.0, -2.12, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4)
			event.set_object_sequence_texture_animation(0, 0)
		end
		if flag_612 ~= 0 then
			flagged_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or flagged_sound_effect
		else
			default_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or default_sound_effect
		end
		if use_red_gate ~= 0 then
			event.start_background_file_loads_2("event/time_gate/red/atora_shine.gltf", "event/time_gate/red/atora_glare.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		end
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(0, "旧・立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		if flag_612 ~= 0 then
			event.play_sound_effect(flagged_sound_effect, 0)
		else
			event.play_sound_effect(default_sound_effect, 0)
			wait.for_frame_count(30)
		end
		event.fade_in_screen(30)
		if flag_612 ~= 0 then
			event.set_camera_sequence_position(-56.29, 15.74, 3.56)
			event.set_camera_sequence_look_at(-12.65, 16.48, 2.06)
		else
			event.set_camera_sequence_position(-48.179993, 19.61, -28.70996)
			event.set_camera_sequence_look_at(-0.789978, 16.48, -0.05999756)
		end
		if show_both_characters == 0 and use_red_gate == 0 and flag_612 == 0 then
			event.set_camera_sequence_position(-30.09, 19.5, 4.41)
			event.set_camera_sequence_look_at(-14.63, 21.71, 1.0)
		end
		event.set_object_sequence_motion(0, "タイムワープ", 6, 0.45)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 4)
		event.set_object_sequence_texture_animation(0, 1, "開閉口")
		object.wait_until_done(0)
		wait.background_load()
		if use_red_gate ~= 0 then
			event.load_character(5, "event/time_gate/red/atora_shine.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		end
		if flag_612 ~= 0 then
			event.set_character_active(0, 38)
		else
			event.set_character_active(1, 38)
		end
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			frame_x = out1 or frame_x
			frame_y = out2 or frame_y
			frame_z = out3 or frame_z
		end
		if use_red_gate ~= 0 then
			event.set_object_sequence_position(6, frame_x, frame_y, frame_z)
		else
			event.set_object_sequence_position(6, -3.54, 17.04, -1.46)
		end
		event.set_object_sequence_rotation(6, -0.45, -2.12, 0.0)
		event.set_camera_sequence_position(-21.5, 23.92, -12.580017)
		event.set_camera_sequence_look_at(-0.789978, 16.17, -0.05999756)
		event.set_object_sequence_texture_animation(0, 0, "開閉口")
		event.set_object_sequence_texture_animation(0, 1, "開き口")
		event.set_object_sequence_motion(0, "タイムワープL", 5)
		event.set_object_sequence_motion(6, "発動", 6)
		event.queue_object_sequence_next_motion(6, "発動L", 4)
		if flag_612 == 0 then
			object.wait_until_done(6)
		else
			event.play_sound_effect(flagged_sound_effect, 2)
		end
		if use_red_gate ~= 0 then
			event.load_character(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		else
			event.load_character(5, "event/time_gate/red/atora_glare.gltf", "info", 39)
		end
		event.set_character_active(39)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(7, 0.0, -2.12, 0.0)
		event.set_camera_sequence_position(-40.590027, 19.47, -24.339966)
		event.set_camera_sequence_look_at(13.950012, 15.23, 9.190002)
		event.move_camera_sequence_eased(-128.31, 19.47, -78.22998, 13.950012, 48.35, 9.190002, 90, 0, 0.4)
		event.set_object_sequence_scale(3, 2.8, 2.8, 2.8, 90)
		event.set_object_sequence_scale(4, 2.0, 2.0, 2.0, 90)
		event.set_object_sequence_scale(7, 2.0, 2.0, 2.0, 90)
		wait.for_frame_count(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		wait.for_frame_count(60)
		cutscene.show_time_jump_message(1)
	end)
	vm.entry(11)
	event.cancel_drama_scene_skip()
	if flag_612 ~= 0 then
		event.stop_sound_effect(flagged_sound_effect, 0)
	else
		event.stop_sound_effect(default_sound_effect, 0)
	end
	event.fade_out_music(30)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if playable_character == 1 then
		event.delete_character(32)
	end
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(37)
	event.delete_character(38)
	event.delete_character(39)
end

--- Plays the time gate scene with the blue or red gate and the Atla effect that returns the party to the present.
function cutscene.play_time_gate_return_to_present(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32,
	use_red_gate: s32,
	show_both_characters: s32
)
	local party_npc_id: s32 = 0
	local playable_character: s32 = 0
	local flag_612: s32 = 0
	local flagged_sound_effect: s32 = 0
	local default_sound_effect: s32 = 0
	local frame_x: f32 = 0
	local frame_y: f32 = 0
	local frame_z: f32 = 0
	local equipped_item: s32 = 0
	local final_playable_character: s32 = 0
	local resume_step: number = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_character_motion(0, "立ち")
		if use_red_gate == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/tg_maru_blue.gltf", "event/time_gate/blue/tg_sita_blue.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/tg_maru_red.gltf", "event/time_gate/red/tg_sita_red.gltf")
		end
		event.clear_camera_sequence()
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		resume_step = 1
		camera.wait_until_done()
		event.enable_drama_skip()
		event.set_drama_skip_button(20)
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		event.set_character_visible(120, 0)
		event.set_character_visible(121, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		resume_step = 2
		wait.background_load()
		if use_red_gate == 0 then
			event.load_character(5, "event/time_gate/blue/tg_maru_blue.gltf", "info", 35)
			event.set_character_active(35)
			event.set_scene_character_type(35, 4)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.load_character(5, "event/time_gate/blue/tg_sita_blue.gltf", "info2", 36)
			event.set_character_active(36)
			event.set_scene_character_type(36, 4)
			event.attach_object_handle_to_character(4, 36)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.88, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		else
			event.load_character(5, "event/time_gate/red/tg_maru_red.gltf", "info", 35)
			event.set_character_active(35)
			event.set_scene_character_type(35, 4)
			event.attach_object_handle_to_character(3, 35)
			event.clear_object_sequence(3)
			event.set_object_sequence_object(3, 3)
			event.set_object_sequence_position(3, 0.0, 70.0, 0.0)
			event.set_object_sequence_rotation(3, 0.0, 0.0, 0.0)
			event.load_character(5, "event/time_gate/red/tg_sita_red.gltf", "info2", 36)
			event.set_character_active(36)
			event.set_scene_character_type(36, 4)
			event.attach_object_handle_to_character(4, 36)
			event.clear_object_sequence(4)
			event.set_object_sequence_object(4, 4)
			event.set_object_sequence_position(4, 0.0, 0.88, 0.0)
			event.set_object_sequence_rotation(4, 0.0, 0.0, 0.0)
		end
		party_npc_id = event.get_party_npc() or party_npc_id
		if party_npc_id ~= -1 then
			event.load_npc_character(0, 5, party_npc_id, 34)
			event.set_character_active(34)
			event.attach_object_handle_to_character(2, 34)
			event.set_object_handle_position(2, 23.24, 0.0, -46.31)
			event.set_object_handle_rotation(2, 0.0, -0.44, 0.0)
			event.set_object_handle_texture_animation(2, 0)
		end
		if show_both_characters ~= 0 then
			playable_character = event.get_playable_character() or playable_character
			if playable_character == 1 then
				event.get_equipped_item(0, 2)
				event.get_equipped_item(0, 3)
				event.get_equipped_item(0, 4)
			end
			if playable_character == 0 then
				event.get_equipped_item(1, 2)
				event.get_equipped_item(1, 3)
				event.get_equipped_item(1, 4)
			end
			if playable_character == 1 then
				event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
				event.set_character_active(0)
				event.attach_object_handle_to_character(0, 0)
				event.load_character(5, "chara/c01_base.gltf", "info", 33)
				event.set_character_active(33)
				event.attach_object_handle_to_character(1, 33)
				event.load_equipment_model(5, 0, 4, "info", 33)
				event.load_equipment_model(5, 0, 3, "info", 33)
				event.load_equipment_model(5, 0, 2, "info", 33, 37)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
			end
			if playable_character == 0 then
				event.load_character(5, "chara/c02_base.gltf", "info", 32)
				event.set_character_active(32)
				event.attach_object_handle_to_character(0, 32)
				event.load_equipment_model(5, 1, 4, "info", 32)
				event.load_equipment_model(5, 1, 3, "info", 32)
				event.load_equipment_model(5, 1, 2, "info", 32, 37)
				event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 32)
				event.set_character_active(37)
				event.attach_object_handle_to_character(5, 37)
				event.set_character_active(0)
				event.attach_object_handle_to_character(1, 0)
			end
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 3.19, 0.0, -55.28)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, 0.02)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
			event.set_object_handle_position(1, -23.79, 0.0, -39.77)
			event.set_object_handle_rotation(1, 0.0, 0.64, 0.0)
			event.set_object_handle_motion(1, "立ち", 0.02)
		else
			event.get_equipped_item(1, 2)
			event.get_equipped_item(1, 3)
			event.get_equipped_item(1, 4)
			event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.set_object_sequence_position(0, 3.19, 0.0, -55.28)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "立ち", 4, 0.02)
			event.reset_object_sequence_dynamic_animation(0)
			event.set_object_sequence_texture_animation(0, 0)
		end
		flag_612 = event.get_save_flag(612) or flag_612
		if flag_612 ~= 0 then
			flagged_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or flagged_sound_effect
		else
			default_sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_013.sound.json") or default_sound_effect
		end
		if use_red_gate == 0 then
			event.start_background_file_loads_2("event/time_gate/blue/atora_shine2.gltf", "event/time_gate/blue/atora_glare2.gltf")
		else
			event.start_background_file_loads_2("event/time_gate/red/atora_shine2.chr", "event/time_gate/red/atora_glare2.chr")
		end
		event.set_object_sequence_motion(0, "立ち", 4)
		event.set_object_sequence_position(0, 0.0, 0.0, 0.0)
		event.reset_object_sequence_dynamic_animation(0)
		if flag_612 ~= 0 then
			event.play_sound_effect(flagged_sound_effect, 0)
		else
			event.play_sound_effect(default_sound_effect, 0)
			resume_step = 3
			wait.for_frame_count(20)
		end
		event.fade_in_screen(30)
		if flag_612 ~= 0 then
			event.set_camera_sequence_position(21.59, 19.4, 49.13)
			event.set_camera_sequence_look_at(3.27, 21.44, 1.91)
		else
			event.set_camera_sequence_position(-1.62, 25.82, 35.3)
			event.set_camera_sequence_look_at(-0.26, 22.33, -0.02)
		end
		event.set_object_sequence_motion(0, "タイムワープ", 6)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 5)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "目を閉じる")
		event.set_object_sequence_texture_animation(0, 1, "すまし口")
		resume_step = 4
		object.wait_until_done(0)
		resume_step = 5
		wait.background_load()
		if use_red_gate == 0 then
			event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 38)
		else
			event.load_character(5, "event/time_gate/red/atora_shine2.chr", "info", 38)
		end
		if flag_612 ~= 0 then
			event.set_character_active(0, 38)
		else
			event.set_character_active(1, 38)
		end
		event.set_scene_character_type(38, 4)
		event.attach_object_handle_to_character(6, 38)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			frame_x = out1 or frame_x
			frame_y = out2 or frame_y
			frame_z = out3 or frame_z
		end
		event.set_object_sequence_position(6, frame_x + vm.f32(0.18), frame_y + vm.f32(0.02), frame_z + vm.f32(0.3))
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		equipped_item = event.get_equipped_item(1, 4) or equipped_item
		if equipped_item == 263 then
			print("pumpkin---------------------------\n")
			event.set_object_sequence_position(6, -0.35, 22.68, 1.67)
			event.set_object_sequence_rotation(6, 0.0, -6.33, 0.0)
		end
		if equipped_item == 264 then
			print("stripte -----------------------------\n")
			event.set_object_sequence_position(6, -0.48, 22.78, 2.07)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 265 then
			event.set_object_sequence_position(6, -0.33, 22.73, 1.95)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 266 then
			print("princess-----------------------------\n")
			event.set_object_sequence_position(6, -0.42, 22.89, 1.99)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		if equipped_item == 267 then
			print("separate----------------------------\n")
			event.set_object_sequence_position(6, -0.23, 23.26, 2.52)
			event.set_object_sequence_rotation(6, 0.0, -6.4, 0.0)
		end
		event.set_object_sequence_motion(0, "タイムワープL", 5)
		event.set_object_sequence_motion(6, "発動", 6)
		event.queue_object_sequence_next_motion(6, "発動L", 4)
		event.set_object_sequence_texture_animation(0, 0, "目を閉じる")
		event.set_object_sequence_texture_animation(0, 1, "閉じたまま")
		event.set_object_sequence_texture_animation(0, 1, "すまし口")
		if flag_612 ~= 0 then
			event.play_sound_effect(flagged_sound_effect, 2)
		end
		resume_step = 6
		object.wait_until_done(6)
		if use_red_gate == 0 then
			event.load_character(5, "event/time_gate/blue/atora_glare2.gltf", "info", 39)
		else
			event.load_character(5, "event/time_gate/red/atora_glare2.chr", "info", 39)
		end
		event.set_character_active(39)
		event.set_scene_character_type(39, 4)
		event.attach_object_handle_to_character(7, 39)
		event.clear_object_sequence(7)
		event.set_object_sequence_object(7, 7)
		event.set_object_sequence_position(7, 0.0, 0.88, 0.0)
		event.set_object_sequence_rotation(7, 0.0, 0.0, 0.0)
		event.set_camera_sequence_position(-2.99, 25.82, 71.15)
		event.set_camera_sequence_look_at(-0.26, 22.33, 0.02)
		event.move_camera_sequence_eased(-7.1, 25.8, 178.24, -0.26, 45.36, 0.02, 90, 0, 0.4)
		event.set_object_sequence_scale(3, 2.8, 2.8, 2.8, 90)
		event.set_object_sequence_scale(4, 2.0, 2.0, 2.0, 90)
		event.set_object_sequence_scale(7, 2.0, 2.0, 2.0, 90)
		resume_step = 7
		wait.for_frame_count(60)
		event.fade_out_screen(60, 255.0, 255.0, 255.0)
		resume_step = 8
		wait.for_frame_count(60)
		resume_step = 9
		cutscene.show_time_jump_message(0)
	end, function(received: { any }): boolean
		if resume_step <= 1 then
			wait.background_load_skipping()
		end
		if resume_step <= 2 then
			wait.skip_frame_count(20)
		end
		if resume_step <= 3 then
			cutscene.skip_command(0)
		end
		if resume_step <= 4 then
			wait.background_load_skipping()
		end
		if resume_step <= 5 then
			print("pumpkin---------------------------\n")
			print("stripte -----------------------------\n")
			print("princess-----------------------------\n")
			print("separate----------------------------\n")
			cutscene.skip_command(6)
		end
		if resume_step <= 6 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 7 then
			wait.skip_frame_count(60)
		end
		if resume_step <= 8 then
			cutscene.ignore_argument(0)
		end
		return true
	end)
	resume_step = 10
	vm.entry(10)
	event.cancel_drama_scene_skip()
	if flag_612 ~= 0 then
		event.stop_sound_effect(flagged_sound_effect, 0)
	end
	event.fade_out_music(30)
	event.stop_sound_effect(default_sound_effect, 0)
	party_npc_id = event.get_party_npc() or party_npc_id
	final_playable_character = event.get_playable_character() or final_playable_character
	event.delete_character(37)
	if final_playable_character == 1 then
		event.delete_character_extension_packs(0)
		event.delete_character(33)
	end
	if final_playable_character == 0 then
		event.delete_character(32)
	end
	if party_npc_id ~= -1 then
		event.delete_character(34)
	end
	event.delete_character(35)
	event.delete_character(36)
	event.delete_character(38)
	event.delete_character(39)
end

--- Plays the scene in which the character touches Atla at the time gate and sets save flag 522.
function cutscene.play_time_gate_touch_scene(
	world_x: f32,
	world_y: f32,
	world_z: f32,
	world_rotation: f32
)
	local sound_effect: s32 = 0
	local party_npc_id: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(522, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		sound_effect = event.load_sound_effect_file_3(8, "snd2/sp/sp_043.sound.json") or sound_effect
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_event_world_coordinate(world_x, world_y, world_z, world_rotation)
		event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		event.load_character_motion_pack(5, "event/e500/e522/e522_mints.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_motion(0, "立ち", 0)
		party_npc_id = event.get_party_npc() or party_npc_id
		if party_npc_id ~= -1 then
			event.load_npc_character(0, 5, party_npc_id, 33)
			event.set_character_active(0, 33)
			event.attach_object_handle_to_character(1, 33)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 34)
		event.set_character_active(0, 34)
		event.set_scene_character_type(34, 4)
		event.attach_object_handle_to_character(2, 34)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_message_file(0, 5, "event/e500/e522/e522.txt")
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.fade_in_screen(30)
		event.play_sound_effect(sound_effect, 0)
		event.enable_drama_skip()
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(5.32, 62.92, -97.07)
		event.set_camera_sequence_look_at(11.48, 61.6, -39.43)
		event.set_object_sequence_position(0, 39.64, -0.0, 9.33)
		event.set_object_sequence_rotation(0, 0.0, -2.33, 0.0)
		event.set_object_sequence_position(1, 34.65, 0.0, 29.92)
		event.set_object_sequence_rotation(1, 0.0, -2.36, 0.0)
		event.set_object_sequence_motion(0, "上向く", 6)
		event.queue_object_sequence_next_motion(0, "上向くL", 0)
		event.move_camera_sequence_eased(5.32, 24.78, -97.07, 11.48, 29.98, -39.43, 90, 2, 0.4)
		camera.wait_until_done()
		event.set_character_active(0, 33)
		event.set_camera_sequence_position(25.53, 21.33, -15.17)
		event.set_camera_sequence_look_at(32.72, 21.29, -3.29)
		event.set_object_sequence_rotation(0, 0.0, -2.69, 0.0)
		event.set_character_cloth_animation_enabled(0, 0)
		event.set_character_active(1, 34)
		event.get_object_handle_frame_position(0, "atoramiria")
		event.attach_character_to_frame(0, "atoramiria", 34)
		event.set_character_position(34, 0.04, -1.42988, 0.89)
		event.delay_object_sequence_sound_track(2, 25)
		event.play_object_sequence_sound(2, sound_effect, 1)
		event.set_object_sequence_motion(2, "発動", 6)
		event.queue_object_sequence_next_motion(2, "発動L", 0)
		event.set_object_sequence_motion(0, "アトラ見る", 6)
		event.queue_object_sequence_next_motion(0, "アトラ見るL", 0)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "アトラさわる", 6)
		event.queue_object_sequence_next_motion(0, "アトラさわるL", 6)
		message.show_voiced(5220010)
		message.show_voiced(5220015)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
	end)
	vm.entry(8)
	event.cancel_drama_scene_skip()
	event.stop_sound_effect(sound_effect, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(33)
	event.delete_character(34)
end

--- Selects the party member, plays the red time gate travel scene at the given world coordinate and resets the world coordinate.
function cutscene.play_time_gate_travel(x: f32, y: f32, z: f32, rotation: f32)
	local party_result: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		party_result = event.set_party_member(1) or party_result
		if party_result == 1 then
			resume_point = 1
			cutscene.play_time_gate_jump_to_future(x, y, z, rotation, 1, 1)
		else
			resume_point = 2
			cutscene.play_time_gate_jump_to_future(x, y, z, rotation, 1, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				resume_point = 2
				cutscene.play_time_gate_jump_to_future(x, y, z, rotation, 1, 0)
				return vm.continue_with(function()
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the return to the present when character 1 is a party member, otherwise the Atla touch scene once followed by the jump to the future.
function cutscene.play_time_gate_warp(world_x: f32, world_y: f32, world_z: f32, world_rotation: f32)
	local is_party_member: s32 = 0
	local flag_520: s32 = 0
	local flag_532: s32 = 0
	local flag_522: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		is_party_member = event.set_party_member(1) or is_party_member
		if is_party_member == 1 then
			resume_step = 1
			cutscene.play_time_gate_return_to_present(world_x, world_y, world_z, world_rotation, 0, 1)
		else
			flag_520 = event.get_save_flag(520) or flag_520
			flag_532 = event.get_save_flag(532) or flag_532
			if flag_520 ~= 0 and flag_532 == 0 then
				flag_522 = event.get_save_flag(522) or flag_522
				if flag_522 == 0 then
					resume_step = 2
					cutscene.play_time_gate_touch_scene(world_x, world_y, world_z, world_rotation)
				end
			end
			resume_step = 3
			cutscene.play_time_gate_jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
		end
		event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
		return
	end, function(received: { any })
		if resume_step <= 3 then
			if resume_step <= 1 then
				resume_step = 2
				cutscene.play_time_gate_touch_scene(world_x, world_y, world_z, world_rotation)
				return vm.continue_with(function()
					resume_step = 3
					cutscene.play_time_gate_jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			if resume_step <= 2 then
				resume_step = 3
				cutscene.play_time_gate_jump_to_future(world_x, world_y, world_z, world_rotation, 0, 0)
				return vm.continue_with(function()
					event.set_event_world_coordinate(0.0, 0.0, 0.0, 0.0)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Disables slope handling, skips the crossfade, runs skip-mode waits totalling 91 frames and passes a fixed map point and rotation to the placement placeholder.
function cutscene.reset_then_move_to_point()
	sindain_station.log_slope_off()
	cutscene.skip_command(1)
	sindain_station.skip_crossfade_step()
	wait.frames_skipping(30)
	wait.frames_skipping(46)
	wait.frames_skipping(15)
	cutscene.ignore_coordinates(vm.f32(2155.3), 0.0, vm.f32(1707.1), vm.f32(2.46))
end

--- Resumes a speech bubble followed by a talk with the player.
function cutscene.resume_say_bubble_then_talk(speaker: any, player_character: any)
	cutscene.say_bubble_then_talk_skipping(speaker, player_character)
end

--- Resumes the pages of a shop villager's conversation and the shop-up sequence with default character slots.
function cutscene.resume_shop_talk()
	local character_slot: s32 = 0
	local player_slot: s32 = 0
	npc.resume_talk_steps(character_slot, player_slot)
	npc.resume_talk_end()
end

--- Runs a skipped speech bubble followed by a skipped talk with the player.
function cutscene.say_bubble_then_talk_skipping(speaker: any, player_character: any)
	message.say_bubble_skipping(0, -1, speaker, player_character, 0)
	cutscene.talk_skipping(speaker, -1, 0, 0)
end

--- Multiplies a value by a scale factor.
function cutscene.scale_value(value: f32)
	local scale_factor: f32 = 0
	value = vm.f32(value * scale_factor)
	return value
end

--- Steps through a 48 by 32 grid of cells while stepping two accumulated values.
function cutscene.scan_grid(first_value: f32, second_value: f32, mode: any)
	local index: s32 = 0
	local run_counter: s32 = 0
	local accumulator_a: f32 = 0
	local accumulator_b: f32 = 0
	local countdown_value: f32 = 0
	local step_size: f32 = 0
	local reduced_step: f32 = 0
	index = 0
	local _ = index < 48
	index = index + 1
	index = 0
	local _ = index < 32
	index = index + 1
	local _ = run_counter == 0
	local _ = run_counter == 2
	run_counter = 0
	accumulator_a = vm.f32(accumulator_a + 3.0)
	accumulator_b = vm.f32(accumulator_b + 3.0)
	countdown_value = 600.0
	index = 1
	countdown_value = vm.f32(countdown_value - step_size)
	reduced_step = vm.f32(20.0 - step_size)
	local _ = countdown_value <= 0.0
	countdown_value = vm.f32(countdown_value - reduced_step)
	run_counter = run_counter + 1
	local _ = vm.imod(index, 6) == 0
	index = index + 1
	run_counter = run_counter + 1
	local _ = index >= 31
	local _ = index >= 31
	local _ = vm.imod(index, 6) == 0
	index = index + 1
	run_counter = run_counter + 1
	local _ = index >= 31
	local _ = index < 31
	local _ = vm.imod(index, 6) == 0
	index = index + 1
end

--- Shows the default bubble message for a character, then runs the stubbed talk with the default message.
function cutscene.show_bubble_then_talk(subject_character: s32, player_character: s32)
	message.show_bubble_and_close(0, -1, subject_character, player_character, 0)
	cutscene.talk_to_character_stub_message(subject_character, -1, 0, 0)
end

--- Forwards to the bubble-then-talk sequence for a character.
function cutscene.show_bubble_then_talk_forwarded(subject_character: s32, player_character: s32)
	cutscene.show_bubble_then_talk(subject_character, player_character)
end

--- Shows the bubble message twice at the given screen slot with a default horizontal position.
function cutscene.show_bubble_twice_default_x(screen_slot: s32)
	local bubble_x: s32 = 0
	message.show_bubble_twice(screen_slot, bubble_x)
end

--- Shows the whiteout message announcing a jump to the future or a return to the present when save flag 612 is set.
function cutscene.show_time_jump_message(to_future: s32)
	local flag_612: s32 = 0
	flag_612 = event.get_save_flag(612) or flag_612
	if flag_612 == 0 then
		return
	end
	event.set_message_window_mode(0, 12)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 255, 255, 255, 255)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.set_event_sprite_draw_pass(0, 1)
	event.fade_in_screen(0)
	vm.wait(1)
	if to_future ~= 0 then
		event.open_message_window_2(0, "イクシオンの時空転移装置で\nボクたちは未来へとジャンプした。")
	else
		event.open_message_window_2(0, "イクシオンの時空転移装置で\n私たちは現在に戻ってきた。")
	end
	vm.wait(2)
	message.show(0, -1, 5, 0, 0)
	vm.wait(4)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(5)
	cutscene.hide_event_sprite()
end

--- Starts the stubbed talk with a character and shows the default bubble message twice.
function cutscene.show_two_default_messages(subject_character: any, player_character: any)
	cutscene.begin_talk_stub(subject_character, 0, 0)
	message.say_bubble_skipping(0, -1, subject_character, player_character, 0)
	message.say_bubble_skipping(0, -1, subject_character, player_character, 0)
end

--- Starts the stubbed talk with a character and shows the default bubble message twice, using a duplicate of the same routines.
function cutscene.show_two_default_messages_alt(subject_character: any, player_character: any)
	cutscene.begin_talk_stub(subject_character, 0, 0)
	message.say_bubble_skipping(0, -1, subject_character, player_character, 0)
	message.say_bubble_skipping(0, -1, subject_character, player_character, 0)
end

--- Forwards to the two-message talk for a character.
function cutscene.show_two_default_messages_forwarded(subject_character: any, player_character: any)
	cutscene.show_two_default_messages(subject_character, player_character)
end

--- Forwards to the two-message talk for a character, in a duplicate copy.
function cutscene.show_two_default_messages_forwarded_alt(subject_character: any, player_character: any)
	cutscene.show_two_default_messages(subject_character, player_character)
end

--- Forwards to the two-message talk built on the stubbed bubble routines.
function cutscene.show_two_default_messages_stub_forwarded(subject_character: s32, player_character: s32)
	message.show_bubble_twice(subject_character, player_character)
end

--- Accepts a value and does nothing; this stands in for a command that is not run while an event is skipped.
function cutscene.skip_command(value: s32) end

--- Does nothing; placeholder step called by event scripts.
function cutscene.skip_step() end

--- Accepts one value and does nothing; this stands in for a command that is not run while an event is skipped.
function cutscene.skip_value_command(value: any) end

--- Raises a base value by 0.2 and sets an offset value 0.5 below the result.
function cutscene.step_value_with_offset(unused_first: f32, unused_second: f32, unused_third: f32, base_value: f32, offset_value: f32)
	local _ = offset_value ~= base_value
	offset_value = vm.f32(base_value + 0.5)
	base_value = vm.f32(base_value + vm.f32(0.2))
	offset_value = vm.f32(base_value - 0.5)
end

--- Stages a conversation line with a character: faces both toward each other, says the text and restores the staging.
function cutscene.talk(character_slot: s32, text: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local player_slot: s32 = 0
	saved_rotation = cutscene.begin_talk(character_slot, use_camera, restore_rotation)
	player_slot = event.get_player_character_slot() or player_slot
	message.say_bubble(0, text, character_slot, player_slot, 0)
	cutscene.end_talk(character_slot, saved_rotation, use_camera, restore_rotation)
end

--- Stands in for cutscene.talk on the resumed path, running its begin, speech bubble and restore steps without showing anything.
function cutscene.talk_skipping(talking_character: any, text: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local listener: s32 = 0
	saved_rotation = cutscene.begin_talk_stub(talking_character, use_camera, restore_rotation)
	message.say_bubble_skipping(0, text, talking_character, listener, 0)
	character.restore_facing(talking_character, saved_rotation, use_camera, restore_rotation)
end

--- Stands in for cutscene.talk when events are skipped, running its begin, speech bubble and restore steps without showing anything.
function cutscene.talk_skipping_variant(talking_character: s32, text: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local listener: s32 = 0
	saved_rotation = character.interpolate_path(talking_character, use_camera, restore_rotation)
	message.show_then_close_variant(0, text, talking_character, listener, 0)
	character.restore_facing_skipping(talking_character, saved_rotation, use_camera, restore_rotation)
end

--- Prepares a talk, shows a message between the player and a character, then ends the talk.
function cutscene.talk_to_character(subject_character: s32, text: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local player_character: s32 = 0
	saved_rotation = cutscene.begin_talk_with_camera_flag(subject_character, use_camera, restore_rotation)
	player_character = event.get_player_character_slot() or player_character
	message.say_bubble(0, text, subject_character, player_character, 0)
	cutscene.end_talk_with_stub_turn(subject_character, saved_rotation, use_camera, restore_rotation)
end

--- Runs a talk with a character using the stubbed message routines and restores their facing.
function cutscene.talk_to_character_stub_message(subject_character: s32, text: s32, use_camera: s32, restore_rotation: s32)
	local saved_rotation: f32 = 0
	local player_character: s32 = 0
	saved_rotation = cutscene.begin_talk_stub_with_camera_flag(subject_character, use_camera, restore_rotation)
	message.show_bubble_and_close(0, text, subject_character, player_character, 0)
	character.restore_facing_alt(subject_character, saved_rotation, use_camera, restore_rotation)
end

--- Runs a talk with a character using the default message and no camera or rotation options.
function cutscene.talk_with_default_message(subject_character: any, player_character: any)
	cutscene.talk_skipping(subject_character, -1, 0, 0)
end

--- Forwards to the default-message talk for a character.
function cutscene.talk_with_default_message_forwarded(subject_character: any, player_character: any)
	cutscene.talk_with_default_message(subject_character, player_character)
end

--- Runs a talk with a character using the default message, ignoring the extra option.
function cutscene.talk_with_default_message_ignoring_option(subject_character: any, player_character: any, unused_option: s32)
	cutscene.talk_skipping(subject_character, -1, 0, 0)
end

--- Runs a talk with a character using the default message and a zero option.
function cutscene.talk_with_default_message_zero_option(subject_character: any, player_character: any)
	cutscene.talk_with_default_message_ignoring_option(subject_character, player_character, 0)
end

--- Toggles a state flag between 0 and 1.
function cutscene.toggle_state()
	local state_flag: s32 = 0
	local _ = state_flag == 0
	state_flag = 1
	state_flag = 0
end

--- Deletes the five e209 event actors and reactivates the player.
function cutscene.unload_e209_actors()
	event.delete_character(32)
	event.delete_character(33)
	event.delete_character(34)
	event.delete_character(35)
	event.delete_character(36)
	event.set_character_active(1, 0)
end

--- Deletes the rock thrower and rock characters loaded for the rock throwing scene.
function cutscene.unload_rock_throw_actors()
	event.set_character_active(1, 0)
	event.delete_character(39)
	event.delete_character(40)
	event.delete_character(41)
end

--- Walks the player character into the area from the entrance while the screen fades in.
function cutscene.walk_in_at_entrance()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 1858.52, -189.52, 1308.84)
	event.set_object_sequence_rotation(0, 0.0, -2.22, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.set_camera_sequence_position(1910.24, -159.5, 1350.91)
	event.set_camera_sequence_look_at(1816.64, -159.5, 1274.78)
	event.move_object_sequence(0, 1816.64, -189.5, 1274.78, 60)
	event.fade_in_screen(30)
	wait.for_frame_count(60)
	event.set_object_handle_footstep_sound(0, -1)
	event.reset_follow_camera(0)
	event.finish_event()
end

--- Walks the player character into the area from the entrance while the screen fades in, waiting with wait_frames.
function cutscene.walk_in_at_entrance_variant()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 1858.52, -189.52, 1308.84)
	event.set_object_sequence_rotation(0, 0.0, -2.22, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4, -1.0, 1)
	event.set_camera_sequence_position(1910.24, -159.5, 1350.91)
	event.set_camera_sequence_look_at(1816.64, -159.5, 1274.78)
	event.move_object_sequence(0, 1816.64, -189.5, 1274.78, 60)
	event.fade_in_screen(30)
	wait.frames(60)
	event.set_object_handle_footstep_sound(0, -1)
	event.reset_follow_camera(0)
	event.finish_event()
end

return cutscene
