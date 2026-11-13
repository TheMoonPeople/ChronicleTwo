--!strict
--- Event map staging for the Underground Water Channel event area.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local underground_water_channel_event = {}

--- Asks a confirmation and fades out the screen when the first option is chosen.
function underground_water_channel_event.ask_and_fade_out()
	local answer: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		resume_point = 1
		vm.wait(1)
		resume_point = 2
		answer = message.ask_item_choice(5, 10)
		if answer == 0 then
			event.fade_out_screen(30)
			resume_point = 3
			wait.frames(30)
			return 1
		end
		return 0
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point == 2 then
				answer = received[1] :: number
			end
			if resume_point <= 1 then
				answer = message.ask_prompt_choice(5, 10)
			end
			if resume_point <= 2 then
				wait.frames_skipping(30)
			end
			return 1
		end
		return nil
	end)
end

--- Asks a confirmation question and, when the first option is chosen, runs the player out of view and fades out, otherwise steps the player back while the camera keeps looking at them.
function underground_water_channel_event.ask_and_run_out()
	local answer: any = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		resume_point = 1
		answer = message.ask_item_choice(5, 55)
		if answer == 0 then
			event.set_object_sequence_position(0, 0.0, 0.0, 820.0)
			event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
			event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
			event.set_camera_look_at(0.0, 30.0, 820.0)
			event.set_camera_position(0.0, 40.0, 760.0)
			event.move_object_sequence(0, 0.0, 0.0, 1000.0, 40)
			resume_point = 2
			wait.frames(10)
			event.set_object_handle_footstep_sound(0, 2)
			event.fade_out_screen(30)
			resume_point = 3
			wait.frames(30)
			event.set_object_sequence_motion(0, "立ち")
			resume_point = 4
			wait.frames(2)
			return 1
		else
			do
				local out1, out2, out3 = event.get_character_position(0)
				character_x = out1 or character_x
				character_y = out2 or character_y
				character_z = out3 or character_z
			end
			target_x = vm.f32(vm.f32(vm.sin(vm.f32(3.14)) * 30.0) + character_x)
			target_y = 0.0
			target_z = vm.f32(vm.f32(vm.cos(vm.f32(3.14)) * 30.0) + character_z)
			event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
			event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
			event.set_object_sequence_motion(0, "歩き")
			i = 0
			while i < 30 do
				do
					local out1, out2, out3 = event.get_character_position(0)
					character_x = out1 or character_x
					character_y = out2 or character_y
					character_z = out3 or character_z
				end
				character_y = vm.f32(character_y + 30.0)
				event.set_camera_look_at(character_x, character_y, character_z)
				i = i + 1
				resume_point = 5
				vm.wait(5)
			end
		end
		return 0
	end, function(received: { any })
		if resume_point <= 4 then
			if resume_point == 1 then
				answer = received[1] :: number
			end
			if resume_point <= 1 then
				wait.frames_skipping(10)
			end
			if resume_point <= 2 then
				wait.frames_skipping(30)
			end
			if resume_point <= 3 then
				wait.frames_skipping(2)
			end
			return 1
		end
		if resume_point <= 5 then
			return 0
		end
		return nil
	end)
end

--- Hides the memo object and disables its function point when the memo is owned.
function underground_water_channel_event.hide_memo_if_owned()
	local memo_count: s32 = 0
	memo_count = event.get_owned_item_count(386) or memo_count
	if memo_count >= 1 then
		event.set_function_point_enabled("", "memo", 0)
		event.attach_object_handle_to_map_part_2(0, "memo")
		event.set_object_handle_visible(0, 0)
	end
end

--- Sets save flag 40, places Donnie when save flag 4 is set, then hides the memo if it is owned.
function underground_water_channel_event.initialize_map()
	local save_flag: s32 = 0
	event.set_save_flag(40, 1)
	save_flag = event.get_save_flag(4) or save_flag
	if save_flag == 1 then
		underground_water_channel_event.place_donnie()
	end
	underground_water_channel_event.hide_memo_if_owned()
end

--- Places Donnie in the event area, stops time advancing and starts the music.
function underground_water_channel_event.place_donnie()
	event.set_time_of_day_advancing(0)
	event.set_villager_ai_enabled(0, 8)
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("event/opening/p6/")
	event.load_character(4, "p6_donnie.gltf", "info", 8)
	event.set_character_active(8)
	event.set_character_position(8, 124.7, 104.0, 183.68)
	event.set_character_rotation(8, 0.0, 0.85, 0.0)
	event.set_character_motion(8, "立ち", 4)
	event.change_directory("")
	event.load_music(108)
	event.play_music(0)
end

--- Places the player and camera at the entrance and fades in.
function underground_water_channel_event.place_player_at_entrance()
	event.initialize_event()
	event.set_character_position(0, -380.0, 104.0, 0.0)
	event.set_character_rotation(0, 0.0, 1.57, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.set_camera_look_at(-380.0, 134.0, 0.0)
	event.set_camera_position(-260.0, 134.0, 0.0)
	event.fade_in_screen(30)
end

--- Fades in and runs the player toward the camera along the corridor, then stands them still.
function underground_water_channel_event.run_into_view()
	event.initialize_event()
	event.attach_object_handle_to_character(0, 0)
	event.set_object_handle_footstep_sound(0, 2)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, 0.0, 1000.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(0, "走り", 4, -1.0, 1)
	event.set_camera_look_at(0.0, 30.0, 820.0)
	event.set_camera_position(0.0, 66.0, 700.0)
	event.fade_in_screen(30)
	event.move_object_sequence(0, 0.0, 0.0, 820.0, 40)
	wait.frames(20)
	event.set_object_handle_footstep_sound(0, 6)
	wait.frames(20)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(2)
end

--- Waits 42 frames, which the player can skip.
function underground_water_channel_event.wait_skippable_pause()
	wait.frames_skipping(20)
	wait.frames_skipping(20)
	wait.frames_skipping(2)
end

return underground_water_channel_event
