--!strict
--- Shared building blocks for the dungeon system scripts that fit no single topic.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local dungeon_system_scripts_item = vm.module("@lib/event/dungeon_system_scripts_item")
local dungeon_system_scripts_message = vm.module("@lib/event/dungeon_system_scripts_message")
local inventory = vm.module("@lib/event/inventory")
local wait = vm.module("@lib/event/wait")

local dungeon_system_scripts = {}

--- Fades the dungeon status bar out when show is 0 and in otherwise over a number of frames.
function dungeon_system_scripts.fade_status_bar(show: s32, frames: s32)
	local alpha: f32 = 0
	local i: s32 = 0
	if frames == 0 then
		frames = 1
	end
	i = 0
	if show == 0 then
		alpha = 1.0
		while i < frames do
			alpha = vm.f32(alpha - vm.f32(vm.fdiv(1.0, frames)))
			if alpha < 0.0 then
				alpha = 0.0
			end
			event.show_dungeon_status_bar(alpha)
			i = i + 1
			vm.wait(1)
		end
	else
		alpha = 0.0
		while i < frames do
			alpha = vm.f32(alpha + vm.f32(vm.fdiv(1.0, frames)))
			if alpha > 1.0 then
				alpha = 1.0
			end
			event.show_dungeon_status_bar(alpha)
			i = i + 1
			vm.wait(2)
		end
	end
end

--- Returns the pressed buttons that match a button mask.
function dungeon_system_scripts.get_pressed_buttons(button_mask: any)
	local pressed_buttons: s32 = 0
	pressed_buttons = event.get_buttons_pressed() or pressed_buttons
	return vm.i32(bit32.band(pressed_buttons, button_mask))
end

--- Accepts two arguments, does nothing and returns 0.
function dungeon_system_scripts.ignore_arguments(unused_first: any, unused_second: any)
	return 0
end

--- Plays the treasure chest opening and item-get cutscene for an item, adds it to the inventory and shows the received-item message.
function dungeon_system_scripts.play_treasure_get(item_id: s32)
	local point_x: f32 = 0
	local point_y: f32 = 0
	local point_z: f32 = 0
	local point_rotation_y: f32 = 0
	local lid_open: f32 = 0
	local item_scale: f32 = 0
	event.set_dungeon_pause_flags(23, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		point_x = out1 or point_x
		point_y = out2 or point_y
		point_z = out3 or point_z
		point_rotation_y = out4 or point_rotation_y
	end
	event.set_event_world_coordinate(point_x, point_y, point_z, point_rotation_y)
	vm.wait(1)
	event.add_inventory_item(item_id, 1)
	event.start_background_file_loads_3(item_id, 1, "effect/itemget.gltf")
	event.set_nearest_treasure_box_lid_open(0.0)
	event.set_nearest_treasure_box_state(2)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait.for_frame_count(15)
	dungeon_system_scripts_item.open_treasure_lid(0)
	wait.for_frame_count(5)
	wait.background_load()
	event.load_character(5, "effect/itemget.gltf", "info", 12)
	event.set_character_active(12)
	event.attach_object_handle_to_character(1, 12)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "ゲット", 5)
	event.set_object_sequence_motion(1, "ゲット", 2)
	wait.for_frame_count(5)
	lid_open = dungeon_system_scripts_item.open_treasure_lid_fast(lid_open)
	event.load_item_model(5, item_id, "info", 13, 1)
	event.set_character_active(1, 13)
	event.attach_object_handle_to_character(0, 13)
	item_scale = inventory.get_weapon_display_scale(13, item_id, item_scale)
	event.set_object_handle_scale(0, item_scale, item_scale, item_scale)
	event.set_object_handle_rotation(0, 0.0, 0.0, 0.0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 0.0, -5.0, 0.0)
	event.delay_object_sequence_position_track(0, 4)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.3, 20)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.4, 8)
	event.jump_object_sequence(0, 0.0, 17.0, 0.0, -0.2, 5)
	lid_open = inventory.open_treasure_box_lid(lid_open)
	camera.wait_until_done()
	dungeon_system_scripts_message.show_item_obtained(item_id, 1)
	event.start_crossfade(10)
	event.set_dungeon_pause_flags(23, 0)
	event.set_character_active(1, 0)
	event.delete_character(12)
	event.delete_character(13)
	event.set_nearest_treasure_box_lid_open(1.0)
	event.finish_event()
end

--- Handles button input and mouth animation for a message window and returns 1 when the page is confirmed, 2 when cancelled, otherwise 0.
function dungeon_system_scripts.poll_message_input(window: any, allow_cancel: s32)
	local window_frame: s32 = 0
	local can_play_sound: s32 = 0
	local stream_playing: s32 = 0
	local window_state: s32 = 0
	local button_0_pressed: s32 = 0
	local button_1_pressed: s32 = 0
	local button_2_pressed: s32 = 0
	window_frame = event.get_message_window_frame(window) or window_frame
	can_play_sound = 1
	if window_frame == 7 then
		can_play_sound = 0
	end
	if window_frame == 0 then
		can_play_sound = 0
	end
	stream_playing = event.is_voice_stream_playing() or stream_playing
	window_state = event.get_message_window_state(window) or window_state
	if window_state == 0 then
		return 0
	end
	if window_state == 1 then
		return 0
	end
	if window_state == 3 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	if window_state == 4 then
		return 0
	end
	if window_state == 5 then
		if stream_playing == 0 then
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
		end
	end
	button_0_pressed = event.is_event_button_pressed(0) or button_0_pressed
	button_1_pressed = event.is_event_button_pressed(1) or button_1_pressed
	button_2_pressed = event.is_event_button_pressed(2) or button_2_pressed
	if (if (if button_0_pressed ~= 0 then 1 else button_1_pressed) ~= 0 then 1 else if allow_cancel ~= 0 then button_2_pressed else 0) ~= 0 then
		if can_play_sound ~= 0 then
			if button_1_pressed ~= 0 then
				event.play_message_sound(0)
			end
			if button_0_pressed ~= 0 then
				event.play_message_sound(1)
			end
			if (if allow_cancel ~= 0 then button_2_pressed else 0) ~= 0 then
				event.play_message_sound(0)
			end
		end
		if window_state == 5 then
			event.advance_message_page(window)
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(1)
				event.trigger_mouth_motion(0)
			end
		end
		if window_state == 3 then
			if stream_playing == 0 then
				event.trigger_mouth_texture_animation(0)
				event.trigger_mouth_motion(2)
			end
			if (if allow_cancel ~= 0 then button_2_pressed else 0) ~= 0 then
				return 2
			else
				return 1
			end
		end
		if window_state ~= 5 and window_state ~= 3 then
			event.set_message_draw_speed(window, 0.0)
			event.trigger_mouth_texture_animation(0)
			event.trigger_mouth_motion(1)
			if stream_playing ~= 0 then
				event.stop_voice_stream(1)
			end
		end
	end
	return 0
end

--- Checks that the player can swing a Sphida club, returning 1 after showing a refusal message if not, otherwise equipping the club and returning 0.
function dungeon_system_scripts.prepare_sphida_club()
	local playable_character: s32 = 0
	local equipped_item: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		playable_character = event.get_playable_character() or playable_character
		if playable_character ~= 0 then
			event.set_message_window_mode(0, 4)
			stage = 1
			dungeon_system_scripts_message.show_and_wait(0, 2000, 8, 0, 0)
			return 1
		end
		equipped_item = event.get_equipped_item(0, 0) or equipped_item
		if equipped_item ~= 10 and equipped_item ~= 11 and equipped_item ~= 12 and equipped_item ~= 13 and equipped_item ~= 14 then
			event.set_message_window_mode(0, 4)
			stage = 2
			dungeon_system_scripts_message.show_and_wait(0, 2001, 8, 0, 0)
			return 1
		end
		event.set_message_window_mode(0, 1)
		event.set_sphida_club(equipped_item)
		event.disable_pad_auto_repeat()
		return 0
	end, function(received: { any })
		if stage <= 1 then
			return 1
		end
		if stage <= 2 then
			return 1
		end
		return nil
	end)
end

--- Steps a ratio down from one to zero and up from zero to one in increments of one over the step count without producing any effect.
function dungeon_system_scripts.ramp_ratio(unused_value: s32, step_count: s32)
	local ratio: f32 = 0
	local step: s32 = 0
	local _ = step_count == 0
	step_count = 1
	step = 0
	ratio = 1.0
	ratio = vm.f32(ratio - vm.f32(vm.fdiv(1.0, step_count)))
	local _ = ratio < 0.0
	ratio = 0.0
	local _ = step < step_count
	step = step + 1
	ratio = 0.0
	ratio = vm.f32(ratio + vm.f32(vm.fdiv(1.0, step_count)))
	local _ = ratio > 1.0
	ratio = 1.0
	local _ = step < step_count
	step = step + 1
end

return dungeon_system_scripts
