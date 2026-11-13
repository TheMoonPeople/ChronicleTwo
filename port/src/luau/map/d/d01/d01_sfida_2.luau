--!strict
--- Drives the Sphida golf minigame on the first course floor, including the shot simulation, the dungeon guides and the bonus course entry events.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sphida_hint = require("@lib/event/french/sphida_hint")
local underground_water_channel = require("@lib/event/underground_water_channel")
local wait = require("@lib/event/wait")

--- Ends a Sphida shot by restoring the dungeon view, awarding a medal when the goal was reached, and either advancing the bonus course or reporting that no par remains.
local function finish_sphida_shot(reached_goal: s32)
	local is_bonus_course: s32 = 0
	local saved_hole: s32 = 0
	local remaining_shots: s32 = 0
	local reloaded_saved_hole: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local goal_count: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local remaining_shots_now: s32 = 0
	local restore_camera_x: f32 = 0
	local restore_camera_y: f32 = 0
	local restore_camera_z: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	is_bonus_course = event.is_sphida_bonus_course() or is_bonus_course
	saved_hole = event.get_sphida_saved_hole() or saved_hole
	if reached_goal == 1 and is_bonus_course == 1 then
		remaining_shots = event.get_sphida_par() or remaining_shots
		if saved_hole ~= 8 then
			event.set_sphida_hole_score(-1, vm.i32(remaining_shots + 3))
		end
		minigame.delete_sphida_objects()
		reloaded_saved_hole = event.get_sphida_saved_hole() or reloaded_saved_hole
		if reloaded_saved_hole == 8 then
			minigame.open_sphida_menu()
			return
		else
			minigame.load_saved_sphida_hole_script()
		end
		return
	end
	if is_bonus_course == 0 then
		event.show_dungeon_status_bar(1, 0.1)
	end
	event.start_crossfade(15)
	if reached_goal == 1 then
		if is_bonus_course == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			floor_number = event.get_dungeon_floor() or floor_number
			goal_count = event.get_dungeon_floor_info(stage_id, floor_number, 4) or goal_count
			if goal_count == 1 then
				event.set_dungeon_floor_info(stage_id, floor_number, 5, 128)
				event.add_yarikomi_medals(1)
				do
					local out1, out2, out3 = event.get_previous_camera_next_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_camera_position(camera_x, camera_y, camera_z)
				do
					local out1, out2, out3 = event.get_previous_camera_next_look_at()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				event.set_camera_look_at(camera_x, camera_y, camera_z)
				event.set_message_window_mode(0, 4)
				message.show(0, 2010, 8, 0, 0)
				event.reset_follow_camera(0)
			end
		end
	end
	remaining_shots_now = event.get_sphida_par() or remaining_shots_now
	if reached_goal == 0 and remaining_shots_now <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			restore_camera_x = out1 or restore_camera_x
			restore_camera_y = out2 or restore_camera_y
			restore_camera_z = out3 or restore_camera_z
		end
		event.set_camera_position(restore_camera_x, restore_camera_y, restore_camera_z)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			restore_camera_x = out1 or restore_camera_x
			restore_camera_y = out2 or restore_camera_y
			restore_camera_z = out3 or restore_camera_z
		end
		event.set_camera_look_at(restore_camera_x, restore_camera_y, restore_camera_z)
		event.set_message_window_mode(0, 4)
		if is_bonus_course == 0 then
			message.show(0, 2003, 8, 0, 0)
		else
			if saved_hole == 8 then
				message.show(0, 2003, 8, 0, 0)
				minigame.show_sphida_hole_score()
				minigame.delete_sphida_objects()
				minigame.open_sphida_menu()
				return
			else
				event.open_message_window_2(0, "La sph[UNI00e8]re a disparu.\nPasse au parcours suivant.")
				message.show(0, -1, 8, 0, 0)
			end
			event.fade_out_screen(30)
			wait.frames(30)
			minigame.delete_sphida_objects()
			minigame.load_saved_sphida_hole_script()
			return
		end
		event.reset_follow_camera(0)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing because the script needs no load-time preparation.
function script.setup() end

--- Gives the player the Sphida items and a few starting items, sets the progress flags and clears the floor's battle monsters when the floor starts.
function script.grant_sphida_items()
	local owned_count: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	owned_count = event.get_owned_item_count(10) or owned_count
	if owned_count <= 0 then
		event.add_inventory_item(10, 1)
	end
	owned_count = event.get_owned_item_count(302) or owned_count
	if owned_count <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end
script[200] = script.grant_sphida_items

--- Plays the random circle sequence in which a spinning ring stops on a good or bad outcome that is then applied.
function script.random_circle()
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local away_angle: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local sound_id: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local outcome_side: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_look_at_x: f32 = 0
	local camera_look_at_y: f32 = 0
	local camera_look_at_z: f32 = 0
	local target_angle: f32 = 0
	local minimum_spin_frames: s32 = 0
	local stop_angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_result: f32 = 0
	local restore_camera_x: f32 = 0
	local restore_camera_y: f32 = 0
	local restore_camera_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
			message.show(0, 22, 8, 0, 0)
		else
			message.show(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		away_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or away_angle
		player_x = vm.f32(vm.f32(vm.sin(away_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(away_angle) * 25.0) + circle_z)
		event.set_character_position(0, player_x, player_y, player_z)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	character.reset_action_motion()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		ring_x = out1 or ring_x
		ring_y = out2 or ring_y
		ring_z = out3 or ring_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(ring_x, ring_y + 30.0, ring_z)
	event.set_camera_speed(8.0)
	event.set_follow_camera_offset(0.0, 0.0, 0.0)
	event.set_follow_camera_height(0.0)
	event.set_follow_camera_distance(80.0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	wait.background_load()
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_id
	event.change_directory("event/dng/")
	event.start_background_file_loads_2("ring.gltf", "randomcoin.gltf")
	vm.wait(5)
	wait.background_load()
	ring_motion_frame = event.get_random_circle_motion_frame() or ring_motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, ring_x, ring_y, ring_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, ring_motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, ring_x, ring_y - 30.0, ring_z)
	coin_angle = event.get_random_number(6.2831855) or coin_angle
	coin_angle = vm.f32(coin_angle - vm.f32(3.1415927))
	coin_angle = event.wrap_angle(coin_angle) or coin_angle
	event.set_character_rotation(13, 0.0, coin_angle, 0.0)
	event.change_directory("")
	party_npc_id = event.get_party_npc() or party_npc_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, ring_x, ring_y + 40.0, ring_z, 30, 2, 0.5)
	frame_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if frame_count == 10 then
			event.play_sound_effect(sound_id, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_id, 0)
			event.play_sound_effect(sound_id, 3)
			vm.wait(7)
			break
		else
			frame_count = frame_count + 1
			vm.wait(8)
		end
	end
	message.close_second_window()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		camera_look_at_x = out1 or camera_look_at_x
		camera_look_at_y = out2 or camera_look_at_y
		camera_look_at_z = out3 or camera_look_at_z
	end
	target_angle = event.get_direction_angle(camera_look_at_x, camera_look_at_y, camera_look_at_z, camera_x, camera_y, camera_z) or target_angle
	minimum_spin_frames = 0
	minimum_spin_frames = event.get_random_number_int(10) or minimum_spin_frames
	minimum_spin_frames = vm.i32(minimum_spin_frames + 4)
	frame_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if frame_count >= minimum_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			stop_angle = target_angle
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_angle < stop_angle and calc.is_angle_within(coin_angle, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				outcome_side = 0
				break
			end
			stop_angle = vm.f32(target_angle - vm.f32(3.1415927))
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_angle < stop_angle and calc.is_angle_within(coin_angle, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				outcome_side = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	target_angle = event.get_direction_angle(camera_look_at_x, camera_look_at_y, camera_look_at_z, camera_x, camera_y, camera_z) or target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, target_angle, 1.0) == 0 then
		outcome_side = 0
	else
		outcome_side = 1
	end
	target_angle = coin_angle
	wait.frames(20)
	roll = event.get_random_number_int(10) or roll
	if party_npc_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if outcome_side == 0 then
			if party_npc_id == 24 then
				threshold = 0
			else
				threshold = 2
			end
		elseif party_npc_id == 24 then
			threshold = 100
		else
			threshold = 4
		end
		if roll < threshold then
			target_angle = vm.f32(target_angle + vm.f32(3.14))
			target_angle = event.wrap_angle(target_angle) or target_angle
			event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 8)
			if outcome_side == 0 then
				outcome_side = 1
			else
				outcome_side = 0
			end
			wait.frames(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				target_angle = vm.f32(target_angle + vm.f32(3.14))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 6)
				target_angle = vm.f32(target_angle + vm.f32(1.57))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 3)
				target_angle = vm.f32(target_angle + vm.f32(1.57))
				target_angle = event.wrap_angle(target_angle) or target_angle
				event.rotate_object_sequence(5, 0.0, target_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	target_angle = event.get_direction_angle(camera_look_at_x, camera_look_at_y, camera_look_at_z, camera_x, camera_y, camera_z) or target_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, target_angle, 1.0) == 0 then
		outcome_side = 0
	else
		outcome_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(outcome_side) or effect_id
	if outcome_side == 0 then
		event.play_sound_effect(sound_id, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(13)
		end
		message.show(0, 2310, 8, 0, 0)
		effect_result = event.apply_random_circle_effect(effect_id) or effect_result
		if effect_id == 1 then
			message.show(0, 2311, 8, 0, 0)
		end
		if effect_id == 2 then
			message.show(0, 2312, 8, 0, 0)
		end
		if effect_id == 3 then
			message.show(0, 2313, 8, 0, 0)
		end
		if effect_id == 4 then
			event.place_treasure_box(ring_x, ring_y, ring_z, target_angle, 294)
			message.show(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_id, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			frame_count = frame_count + 1
			vm.wait(19)
		end
		message.show(0, 2320, 8, 0, 0)
		effect_result = event.apply_random_circle_effect(effect_id) or effect_result
		if effect_id == 5 then
			if active_character == 0 or active_character == 2 then
				message.show(0, 2321, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_character == 0 then
				message.show(0, 2323, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show(0, 2324, 8, 0, 0)
			end
			if active_character == 2 then
				message.show(0, 2325, 8, 0, 0)
			end
		end
		if effect_id == 8 then
			message.show(0, 2328, 8, 0, 0)
		end
		if effect_id == 9 then
			message.show(0, 2326, 8, 0, 0)
		end
		if effect_id == 10 then
			message.show(0, 2329, 8, 0, 0)
		end
		if effect_id == 11 then
			message.show(0, 2327, 8, 0, 0)
		end
		if effect_id == 12 then
			message.show(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		restore_camera_x = out1 or restore_camera_x
		restore_camera_y = out2 or restore_camera_y
		restore_camera_z = out3 or restore_camera_z
	end
	event.set_camera_position(restore_camera_x, restore_camera_y, restore_camera_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restore_camera_x = out1 or restore_camera_x
		restore_camera_y = out2 or restore_camera_y
		restore_camera_z = out3 or restore_camera_z
	end
	event.set_camera_look_at(restore_camera_x, restore_camera_y, restore_camera_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the sequence in which the player picks up the geostone, activates it and marks it as used on the floor.
function script.geostone()
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local sound_id: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local stand_x: f32 = 0
	local stand_y: f32 = 0
	local stand_z: f32 = 0
	local geostone_x: f32 = 0
	local geostone_y: f32 = 0
	local geostone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound_id: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
			message.show(0, 22, 8, 0, 0)
		else
			message.show(0, 23, 8, 0, 0)
		end
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 0)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.set_dungeon_pause_flags(16, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_save_flag(31, 1)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	if active_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if active_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_id
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_character_position(0)
		stand_x = out1 or stand_x
		stand_y = out2 or stand_y
		stand_z = out3 or stand_z
	end
	event.copy_vector(stand_x, stand_y, stand_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(stand_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if active_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if active_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	stand_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	stand_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, stand_x, stand_y, stand_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if active_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, stand_x, stand_y + 36.0, stand_z)
	end
	if active_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(stand_x, stand_y + 18.0, stand_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + stand_x)
		effect_y = vm.f32(stand_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + stand_z)
		event.set_character_position(12, effect_x, effect_y, effect_z)
	end
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 0)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 0)
	event.start_crossfade(30)
	event.set_object_sequence_motion(0, "取る", 6)
	event.queue_object_sequence_next_motion(0, "取るL", 4)
	wait.frames(16)
	event.play_sound_effect(sound_id, 0)
	wait.frames(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.frames(10)
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	facing_angle = event.get_direction_angle(stand_x, stand_y, stand_z, camera_x, camera_y, camera_z) or facing_angle
	event.set_character_rotation(12, 0.0, facing_angle, 0.0)
	event.set_character_active(1, 12)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.set_object_sequence_motion(4, "発動", 6, 1.2)
	event.wait_object_sequence_motion_end(4)
	event.reset_object_sequence_motion(4)
	event.set_object_sequence_motion(4, "発動", 5)
	wait.frames(20)
	event.play_sound_effect(sound_id, 1)
	object.wait_until_done(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	system_sound_id = event.get_system_sound_id() or system_sound_id
	event.play_sound_effect(system_sound_id, 18)
	message.show(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor_number = event.get_dungeon_floor() or floor_number
	event.set_dungeon_floor_info(stage_id, floor_number, 5, 256)
	event.start_crossfade(10)
	if active_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, player_x, player_y, player_z)
	event.reset_object_handle_dynamic_animation(0)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.detach_geostone_from_character_frame()
	event.set_geostone_placed(0)
	event.set_object_handle_scale(1, 1.0, 1.0, 1.0)
	event.delete_character_extension_packs(0)
	event.delete_character(12)
	event.set_camera_control_enabled(1)
	event.finish_event()
end

--- Shows the tutorial message the first time the player examines a random stone.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.show(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows a tutorial prompt message and waits for the player to dismiss it.
function script.show_tutorial_prompt()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2610, 8, 0, 0)
	wait.frames(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end
script[2510] = script.show_tutorial_prompt

--- Shows the tutorial messages explaining levelling up the first time the player levels up.
function script.level_up_guide()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2620, 8, 0, 0)
	wait.frames(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	message.show(0, 2621, 8, 0, 0)
	message.show(0, 2622, 8, 0, 0)
	message.show(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "Voir Aide (Menu principal) pour infos")
	message.show(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the controls for driving the ridepod buggy the first time its wheels are used.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Conduire le Tout-terrain\n   Acc[UNI00e9]l[UNI00e8]re avec (L)↑ - Ralentis avec (L)↓.\n   Tourne avec (L) ← ou →.\n   Virages serr[UNI00e9]s : [l1] + (L) ← ou →."
	)
	message.show(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the tutorial explaining the magic-absorb blade the first time its counter fills.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Tu ma[UNI00ee]trises d[UNI00e9]sormais la Lame Absomagie.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La Lame Absomagie permet d'absorber\nl'[UNI00e9]nergie des attaques [UNI00e9]l[UNI00e9]mentales\n(ex : feu) en parant. Pour renvoyer\nl'[UNI00e9]nergie, il suffit d'attaquer."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Tu peux sans cesse accumuler de\nl'[UNI00e9]nergie d'un m[UNI00ea]me type [UNI00e9]l[UNI00e9]mental.\nMais si tu absorbes un autre type\nd'[UNI00e9]nergie, ton arme se d[UNI00e9]chargera."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La quantit[UNI00e9] maximale d'[UNI00e9]nergie\n[UNI00e9]l[UNI00e9]mentale absorb[UNI00e9]e par une arme\nd[UNI00e9]pend de la solidit[UNI00e9] de celle-ci."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Pour rel[UNI00e2]cher l'[UNI00e9]nergie [UNI00e9]l[UNI00e9]mentale\naccumul[UNI00e9]e, appuie sur [l1] tout en\nparant avec [r1]."
	)
	message.show(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Runs a whole Sphida shot, from aiming and the power gauge through the ball flight simulation to the hole result.
function script.sphida_shot()
	local bonus_course: s32 = 0
	local texture_bank: s32 = 0
	local sound_id: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local rotation_x: f32 = 0
	local aim_yaw: f32 = 0
	local rotation_z: f32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local spin_factor: f32 = 0
	local level: s32 = 0
	local spin_x: f32 = 0
	local curve_angle: f32 = 0
	local spin_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local reached_goal: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local stop_state: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local probe_x: f32 = 0
	local probe_y: f32 = 0
	local probe_z: f32 = 0
	local remaining_distance: f32 = 0
	local vector_length: f32 = 0
	local hit_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_attribute: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local frame_count: s32 = 0
	local pin_distance: f32 = 0
	local pin_offset_x: f32 = 0
	local pin_offset_y: f32 = 0
	local pin_offset_z: f32 = 0
	local segment_pin_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_yaw: f32 = 0
	local remaining_shots: s32 = 0
	local answer: any = 0
	vm.wait(1)
	event.initialize_event()
	character.reset_action_motion()
	event.set_character_motion(0, "立ち")
	if underground_water_channel.prepare_sphida_club() ~= 0 then
		event.finish_event()
		return
	end
	bonus_course = event.is_sphida_bonus_course() or bonus_course
	if bonus_course == 0 then
		event.show_dungeon_status_bar(0, 0.1)
	end
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_4(
		"dungeon/sphida/c01_golf.gltf",
		"dungeon/chara/c01b_miss.gltf",
		"dungeon/sphida/gool_end.gltf",
		"dungeon/sphida/mizu_eff.gltf"
	)
	vm.wait(3)
	wait.background_load()
	event.load_character_motion_pack(5, "dungeon/sphida/c01_golf.gltf", "info", 0)
	event.load_character_motion_pack(5, "dungeon/chara/c01b_miss.gltf", "info", 0)
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.load_character(5, "dungeon/sphida/gool_end.gltf", "info", 12)
	event.set_character_active(0, 12)
	sound_id = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_id
	event.create_sword_afterimage(5, 64, 16)
	event.set_sword_afterimage_color(128, 128, 128, 80, 128, 128, 128, 80)
	event.initialize_effect_manager(5, 1)
	event.load_effect_base_pack("足水パシャ", "dungeon/sphida/mizu_eff.gltf")
	event.create_effect_work_buffer(5)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 0)
	event.start_crossfade(15)
	event.reset_sphida_power_gauge()
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
	end
	ball_x, ball_y, ball_z, aim_yaw = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_yaw)
	camera.place_behind_player(aim_yaw)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, spin_factor, level = minigame.get_equipped_club_definition(shot_power, spin_factor, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		spin_x = out1 or spin_x
		curve_angle = out2 or curve_angle
		spin_z = out3 or spin_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_yaw, launch_angle = minigame.aim_sphida_shot(aim_yaw, launch_angle, texture_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			finish_sphida_shot(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, shot_power, aim_yaw, curve_angle, spin_x, level = minigame.run_sphida_power_gauge(shot_power, texture_bank, aim_yaw, curve_angle, spin_x, sound_id, level)
		if t1 == 0 then
			break
		else
			vm.wait(8)
		end
	end
	do
		local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	reached_goal = 0
	if level ~= 1 and level ~= -1 and level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if level == 2 or level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if level == 3 or level == -3 then
			event.set_event_sprite_texture_rect(0, 132, 198, 54, 58)
		end
		event.attach_object_handle_to_sprite(18, 0)
		event.clear_object_sequence(18)
		event.set_object_sequence_object(18, 18)
		event.set_object_sequence_color(18, 128, 128, 128, 128, 4)
		event.delay_object_sequence_color_track(18, 20)
		event.set_object_sequence_color(18, 128, 128, 128, 0, 6)
		wait.frames(10)
	end
	if shot_power <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if level ~= 4 then
			event.play_sound_effect(sound_id, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_id, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if level == 0 then
			event.play_sound_effect(sound_id, 12)
		else
			event.play_sound_effect(sound_id, 1)
		end
	end
	if level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_id)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		finish_sphida_shot(0)
		return
	end
	if level == 0 then
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_draw_pass(1, 1)
		event.set_event_sprite_position(1, 256, 278)
		event.set_event_sprite_texture_rect(1, 246, 104, 266, 42)
		event.set_event_sprite_size(1, 266, 42)
		event.set_event_sprite_color(1, 128, 128, 128, 0)
		event.set_event_sprite_scale(1, 10, 10, 10)
		event.attach_object_handle_to_sprite(19, 1)
		event.clear_object_sequence(19)
		event.set_object_sequence_object(19, 19)
		event.jump_object_sequence(19, 256, 138, 0, 3.6, 20)
		event.set_object_sequence_scale(19, 1, 1, 1, 18)
		event.set_object_sequence_color(19, 128, 128, 128, 128, 12)
		event.delay_object_sequence_color_track(19, 30)
		event.set_object_sequence_color(19, 128, 128, 128, 0, 6)
	end
	shot_power = minigame.scale_by_club_power(shot_power)
	launch_angle = vm.f32(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power = vm.f32(shot_power - vm.f32(shot_power * launch_angle))
	velocity_x = vm.f32(vm.sin(aim_yaw) * vm.f32(shot_power * vm.cos(launch_angle)))
	velocity_y = vm.f32(shot_power * vm.sin(launch_angle))
	velocity_z = vm.f32(vm.cos(aim_yaw) * vm.f32(shot_power * vm.cos(launch_angle)))
	curve_angle = vm.f32(vm.f32(curve_angle * vm.f32(3.1415927)) / 2.0)
	spin_z = vm.f32(vm.f32(vm.f32(-velocity_z * spin_factor) * spin_x) * vm.f32(0.4))
	spin_x = vm.f32(vm.f32(vm.f32(-velocity_x * spin_factor) * spin_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	stop_state = 0
	level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
		hit_result = out4 or hit_result
		surface_attribute = out5 or surface_attribute
	end
	if hit_result >= 0 and (surface_attribute == 1 or surface_attribute == 7) then
		print("----------------START_MIZU-------------------\n")
		shot_power = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power = 0.0
	end
	frame_count = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (frame_count + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			hit_result = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or hit_result
			if level == 1 and hit_result >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + spin_x)
				velocity_z = vm.f32(velocity_z + spin_z)
				spin_x = vm.f32(spin_x * vm.f32(0.8))
				spin_z = vm.f32(spin_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (frame_count + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_angle ~= 0.0 then
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + curve_angle)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * spin_factor))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * spin_factor))
		end
		vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
		if vector_length > vm.f32(0.01) then
			speed = event.get_vector_length(spin_x, 0.0, spin_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + spin_x, previous_y, previous_z + spin_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_yaw = out2 or aim_yaw
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_yaw = out2 or aim_yaw
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, launch_angle, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_distance = speed
		launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
		probe_x = vm.f32(vm.sin(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		probe_z = vm.f32(vm.cos(vm.f32(launch_angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - probe_x,
			ball_y,
			ball_z - probe_z,
			vm.f32(ball_x + probe_x) + probe_x,
			ball_y,
			vm.f32(ball_z + probe_z) + probe_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
			probe_x = out1 or probe_x
			probe_y = out2 or probe_y
			probe_z = out3 or probe_z
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 0)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			hit_result = out4 or hit_result
			surface_attribute = out5 or surface_attribute
		end
		if hit_result >= 0 and (surface_attribute == 1 or surface_attribute == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 11)
				sound_cooldown = 10
			end
			if shot_power == 0.0 then
				shot_power = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				spin_x = 0.0
				spin_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				shot_power = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + probe_x, ball_y + probe_y, ball_z + probe_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			hit_result = out7 or hit_result
		end
		if hit_result < 0 then
			if ball_y >= 380.0 and velocity_y > 0.0 then
				do
					local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, -velocity_y, velocity_z)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(normal_x, normal_y, normal_z)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				hit_result = 1
			end
		end
		while hit_result >= 0 do
			curve_angle = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if shot_power ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 6)
				sound_cooldown = 10
			end
			do
				local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.normalize_vector(velocity_x, velocity_y, velocity_z)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.scale_vector(velocity_x, velocity_y, velocity_z, 3.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			do
				local out1, out2, out3 = event.add_vectors(hit_x, hit_y, hit_z, velocity_x, velocity_y, velocity_z)
				hit_x = out1 or hit_x
				hit_y = out2 or hit_y
				hit_z = out3 or hit_z
			end
			do
				local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			vector_length = event.get_vector_length(previous_x, previous_y, previous_z) or vector_length
			vector_length = vm.f32(remaining_distance - vector_length)
			if vector_length <= 0.0 then
				break
			else
				remaining_distance = vector_length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(spin_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(spin_z * 2.0)
					spin_x = vm.f32(spin_x * vm.f32(0.2))
					spin_z = vm.f32(spin_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						spin_x = 0.0
						spin_z = 0.0
					end
					velocity_x = 0.0
					velocity_y = 0.0
					velocity_z = 0.0
				end
				if shot_power == 0.0 then
					velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.9)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.58)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.9)) + velocity_z)
				else
					print("MIZU______1--------------------------------------------------------------------\n")
					velocity_x = vm.f32(vm.f32(vm.f32(normal_x * speed) * vm.f32(0.8)) + velocity_x)
					velocity_y = vm.f32(vm.f32(vm.f32(normal_y * speed) * vm.f32(0.4)) + velocity_y)
					velocity_z = vm.f32(vm.f32(vm.f32(normal_z * speed) * vm.f32(0.8)) + velocity_z)
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				do
					local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(probe_x, probe_y, probe_z)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(probe_x, probe_y, probe_z, 3.0)
					probe_x = out1 or probe_x
					probe_y = out2 or probe_y
					probe_z = out3 or probe_z
				end
				do
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, vector_length)
					normal_x = out1 or normal_x
					normal_y = out2 or normal_y
					normal_z = out3 or normal_z
				end
				do
					local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, normal_x, normal_y, normal_z)
					ball_x = out1 or ball_x
					ball_y = out2 or ball_y
					ball_z = out3 or ball_z
				end
				do
					local out1, out2, out3, out4, out5, out6, out7, out8 = event.get_segment_collision_16(
						12,
						previous_x,
						previous_y,
						previous_z,
						ball_x + probe_x,
						ball_y + probe_y,
						ball_z + probe_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					hit_result = out7 or hit_result
					surface_attribute = out8 or surface_attribute
				end
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7, out8 =
				event.get_segment_collision_16(12, ball_x, ball_y, ball_z, ball_x, ball_y - 3.0, ball_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			hit_result = out7 or hit_result
			surface_attribute = out8 or surface_attribute
		end
		if hit_result >= 0 then
			curve_angle = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			vector_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or vector_length
			if vector_length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				if shot_power == 0.0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(spin_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(spin_z * 2.0))
					spin_x = vm.f32(spin_x * vm.f32(0.2))
					spin_z = vm.f32(spin_z * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					velocity_x = vm.f32(velocity_x * vm.f32(0.8))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.4))
					velocity_z = vm.f32(velocity_z * vm.f32(0.8))
					spin_x = 0.0
					spin_z = 0.0
				end
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if shot_power ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_id, 5)
					sound_cooldown = 10
				end
			end
			vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and vector_length < vm.f32(0.4) then
				if surface_attribute == 6 then
					stop_state = 1
					break
				end
				surface_attribute = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_attribute
				if not (surface_attribute == 1) then
					break
				end
				stop_state = 1
				break
			end
		end
		if ball_y < -500.0 then
			stop_state = 1
			break
		elseif frame_count >= 480 then
			stop_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			pin_offset_x = vm.f32(pin_x - ball_x)
			pin_offset_y = vm.f32(pin_y - ball_y)
			pin_offset_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(pin_offset_x, pin_offset_y, pin_offset_z) or pin_distance
			if ball_color ~= pin_color then
				segment_pin_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or segment_pin_distance
				if segment_pin_distance >= 0.0 and segment_pin_distance <= 30.0 then
					reached_goal = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(vm.f32(0.6), pin_distance))
							pin_offset_x = out1 or pin_offset_x
							pin_offset_y = out2 or pin_offset_y
							pin_offset_z = out3 or pin_offset_z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					reached_goal = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(pin_offset_x, pin_offset_y, pin_offset_z, vm.fdiv(1.0, pin_distance))
						pin_offset_x = out1 or pin_offset_x
						pin_offset_y = out2 or pin_offset_y
						pin_offset_z = out3 or pin_offset_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, pin_offset_x, pin_offset_y, pin_offset_z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, pin_offset_x, pin_offset_y, pin_offset_z)
						velocity_x = out1 or velocity_x
						velocity_y = out2 or velocity_y
						velocity_z = out3 or velocity_z
					end
				end
			end
			event.set_character_position(8, ball_x, ball_y, ball_z)
			event.set_character_position(9, ball_x, ball_y, ball_z)
			do
				local out1, out2, out3 = event.copy_vector(ball_x, ball_y, ball_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			if ball_y <= -50.0 then
				event.set_follow_camera_following(0)
				if stop_state >= 30 then
					if stop_state >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				stop_state = stop_state + 1
			elseif frame_count >= 20 then
				event.set_camera_control_range(20.0, 30.0, 60.0, 200.0)
				event.set_camera_speed(8.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_target(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z
				)
				do
					local out1, out2, out3 = event.get_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				camera_yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or camera_yaw
				event.set_camera_control_rotation(camera_yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			frame_count = frame_count + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if stop_state == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		remaining_shots = event.get_sphida_par() or remaining_shots
		if reached_goal == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_id, 17)
			frame_count = 0
			while frame_count < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			frame_count = 0
			while frame_count < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				frame_count = frame_count + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			pin_color = event.get_dungeon_stage_id() or pin_color
			ball_color = event.get_dungeon_floor() or ball_color
			hit_result = event.get_dungeon_floor_info(pin_color, ball_color, 4) or hit_result
			do
				local out1, out2 = event.get_sphida_prize(hit_result)
				sound_cooldown = out1 or sound_cooldown
				surface_attribute = out2 or surface_attribute
			end
			hit_result = vm.i32(hit_result + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, hit_result)
			if bonus_course == 0 then
				event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, launch_angle, sound_cooldown)
			end
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_id = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_id
			event.stop_music(0)
			event.play_sound_effect(sound_id, 0)
			event.set_character_active(1, 0)
			event.set_follow_camera_following(0)
			event.set_camera_control_enabled(0)
			event.clear_camera_sequence()
			event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
			event.set_object_sequence_motion(0, "カップインポーズ", 6)
			event.set_object_sequence_normal_drive(0)
			event.queue_object_sequence_next_motion(0, "カップインポーズL", 4)
			event.reset_object_sequence_dynamic_animation(0)
			sound_cooldown = event.get_language() or sound_cooldown
			if sound_cooldown == 0 then
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
				event.set_event_sprite_texture_rect(0, 206, 0, 306, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			end
			event.attach_object_handle_to_sprite(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.set_object_sequence_scale(1, 1.0, 1.0, 0.0, 60)
			event.set_object_sequence_color(1, 128, 128, 128, 128, 60)
			object.wait_until_done(0)
			wait.frames(90)
			vm.wait(22)
			event.play_music(0)
			if bonus_course == 1 then
				remaining_shots = vm.i32(remaining_shots + 2)
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "omake_sfida", texture_bank)
				event.set_event_sprite_position(0, 256, 192)
				if sound_cooldown == 3 then
					event.set_event_sprite_texture_rect(0, 162, 38, 100, 34)
					event.set_event_sprite_size(0, 100, 34)
				elseif sound_cooldown == 5 then
					event.set_event_sprite_texture_rect(0, 182, 38, 160, 34)
					event.set_event_sprite_size(0, 160, 34)
				else
					event.set_event_sprite_texture_rect(0, 182, 38, 80, 34)
					event.set_event_sprite_size(0, 80, 34)
				end
				event.set_event_sprite_color(0, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(0, 1)
				event.reset_event_sprite(1)
				event.set_event_sprite_type(1, 0)
				event.set_event_sprite_texture(1, "omake_sfida", texture_bank)
				event.set_event_sprite_texture_rect(1, 280, 96, 28, 32)
				event.set_event_sprite_position(1, 174, 224)
				event.set_event_sprite_size(1, 28, 32)
				event.set_event_sprite_color(1, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(1, 1)
				event.reset_event_sprite(2)
				event.set_event_sprite_type(2, 0)
				event.set_event_sprite_texture(2, "omake_sfida", texture_bank)
				event.set_event_sprite_texture_rect(2, 136, 0, 104, 38)
				event.set_event_sprite_position(2, 296, 224)
				event.set_event_sprite_size(2, 104, 38)
				event.set_event_sprite_color(2, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(2, 1)
				event.reset_event_sprite(3)
				event.set_event_sprite_type(3, 0)
				event.set_event_sprite_texture(3, "omake_sfida", texture_bank)
				event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(remaining_shots, 10) * 28), 96, 28, 32)
				event.set_event_sprite_position(3, 228, 224)
				event.set_event_sprite_size(3, 28, 32)
				event.set_event_sprite_color(3, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(3, 1)
				if vm.idiv(remaining_shots, 10) > 0 then
					event.reset_event_sprite(4)
					event.set_event_sprite_type(4, 0)
					event.set_event_sprite_texture(4, "omake_sfida", texture_bank)
					event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(remaining_shots, 10) * 28), 96, 28, 32)
					event.set_event_sprite_position(4, 204, 224)
					event.set_event_sprite_size(4, 28, 32)
					event.set_event_sprite_color(4, 128, 128, 128, 128)
					event.set_event_sprite_draw_pass(4, 1)
				end
				while true do
					if wait.get_button_state(0) ~= 0 then
						break
					else
						vm.wait(23)
					end
				end
				bonus_course = event.get_sphida_saved_hole() or bonus_course
				if bonus_course == 8 then
					event.set_sphida_hole_score(-1, remaining_shots)
					minigame.show_sphida_hole_score()
				end
				event.fade_out_screen(30)
				wait.frames(30)
				event.set_event_sprite_draw_pass(0, 0)
				event.set_event_sprite_draw_pass(1, 0)
				event.set_event_sprite_draw_pass(2, 0)
			end
			event.release_camera_sequence_follow_object()
			event.set_event_sprite_draw_pass(0, 0)
		elseif remaining_shots >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(27)
			if answer == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					hit_result = out1 or hit_result
					start_x = out2 or start_x
					start_y = out3 or start_y
					start_z = out4 or start_z
				end
				if hit_result == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						start_x = out1 or start_x
						start_y = out2 or start_y
						start_z = out3 or start_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				speed = event.get_distance_between(start_x, start_y, start_z, pin_x, pin_y, pin_z) or speed
				if speed < 40.0 then
					launch_angle = event.get_random_number(6.2831855) or launch_angle
					launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(launch_angle) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(launch_angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						hit_result = out4 or hit_result
					end
					frame_count = 0
					while hit_result >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(start_x, start_y, start_z)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.subtract_vectors(previous_x, previous_y, previous_z, hit_x, hit_y, hit_z)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						previous_x = vm.f32(previous_x + 1.0)
						previous_z = vm.f32(previous_z + 1.0)
						do
							local out1, out2, out3 = event.normalize_vector(previous_x, previous_y, previous_z)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.scale_vector(previous_x, previous_y, previous_z, 30.1)
							previous_x = out1 or previous_x
							previous_y = out2 or previous_y
							previous_z = out3 or previous_z
						end
						do
							local out1, out2, out3 = event.copy_vector(hit_x, hit_y, hit_z)
							start_x = out1 or start_x
							start_y = out2 or start_y
							start_z = out3 or start_z
						end
						do
							local out1, out2, out3 = event.add_vectors(start_x, start_y, start_z, previous_x, previous_y, previous_z)
							start_x = out1 or start_x
							start_y = out2 or start_y
							start_z = out3 or start_z
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							hit_result = out4 or hit_result
						end
						frame_count = frame_count + 1
						if frame_count > 6 then
							break
						end
					end
				end
				aim_yaw = event.get_direction_angle(start_x, start_y, start_z, ball_x, ball_y, ball_z) or aim_yaw
				event.set_character_position(0, start_x, start_y, start_z)
				event.set_character_rotation(0, 0.0, aim_yaw, 0.0)
				event.set_camera_look_at(start_x, start_y + 30.0, start_z)
				aim_yaw = vm.f32(aim_yaw - vm.f32(3.1415927))
				aim_yaw = event.wrap_angle(aim_yaw) or aim_yaw
				start_x = vm.f32(vm.f32(vm.sin(aim_yaw) * 100.0) + start_x)
				start_y = vm.f32(start_y + 30.0)
				start_z = vm.f32(vm.f32(vm.cos(aim_yaw) * 100.0) + start_z)
				event.set_camera_position(start_x, start_y, start_z)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(sound_id, 18)
		event.set_follow_camera_following(0)
		event.set_camera_control_enabled(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_follow_object(0, 0.0, 15.0, 0.0, 0.0, 0.0, 80.0, "", 1)
		event.set_object_sequence_motion(0, "だめだめ", 6)
		event.set_object_sequence_normal_drive(0)
		event.queue_object_sequence_next_motion(0, "立ち", 4)
		event.reset_object_sequence_dynamic_animation(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "sphida_bar", texture_bank)
		event.set_event_sprite_texture_rect(0, 334, 54, 178, 34)
		event.set_event_sprite_position(0, 256, -25)
		event.set_event_sprite_size(0, 160, 50)
		event.set_event_sprite_color(0, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(1, 0)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.2, 16)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 2.0, 12)
		event.jump_object_sequence(1, 256.0, 208.0, 0.0, 1.5, 8)
		object.wait_until_done(0)
		wait.frames(20)
		event.set_event_sprite_draw_pass(0, 0)
		event.set_sphida_ball_position(start_x, start_y, start_z)
		event.set_character_position(8, start_x, start_y, start_z)
		event.set_character_position(9, start_x, start_y, start_z)
		event.release_camera_sequence_follow_object()
	end
	if reached_goal == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_id)
	end
	finish_sphida_shot(reached_goal)
end

--- Asks whether to move the Sphida ball next to the player and moves it when the player agrees.
function script.sphida_near_ball()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	answer = message.ask_choice(0, 2004, 8, 0, 0, 2, 1)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		minigame.consume_sphida_shot(-1)
		event.start_crossfade(15)
	end
	vm.wait(2)
	event.finish_event()
end

--- Warns that this is the last time the Sphida ball can be moved to the player and moves it when the player agrees.
function script.sphida_near_ball_last()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "C'est la derni[UNI00e8]re fois que tu\npeux amener la sph[UNI00e8]re [UNI00e0] toi.")
	message.show(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Amener la sph[UNI00e8]re jusqu'[UNI00e0] toi ?")
	answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
	if answer == 0 then
		do
			local out1, out2, out3 = event.get_character_position(0)
			player_x = out1 or player_x
			player_y = out2 or player_y
			player_z = out3 or player_z
		end
		event.set_sphida_ball_position(player_x, player_y + 3.0, player_z)
		event.set_character_position(8, player_x, player_y + 3.0, player_z)
		event.set_character_position(9, player_x, player_y + 3.0, player_z)
		event.set_sphida_last_challenge(1)
		event.start_crossfade(15)
	end
	vm.wait(3)
	event.finish_event()
end

--- Asks whether to give up the current bonus course hole and either shows the score or skips to the next hole.
function script.sphida_omake_away()
	local answer: any = 0
	local saved_hole: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	saved_hole = event.get_sphida_saved_hole() or saved_hole
	if saved_hole == 8 then
		event.open_message_window_2(0, "C'est le dernier trou. Abandonner ?")
		answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
		if answer == 0 then
			minigame.show_sphida_hole_score()
			event.fade_out_screen(30)
			wait.frames(30)
			minigame.delete_sphida_objects()
			minigame.open_sphida_menu()
			return
		end
	else
		event.open_message_window_2(0, "Abandonner ce trou et passer au\nparcours suivant ?")
		answer = message.ask_choice(0, -1, 8, 0, 0, 2, 1)
		if answer == 0 then
			event.fade_out_screen(30)
			wait.frames(30)
			minigame.load_saved_sphida_hole_script()
		end
	end
	vm.wait(7)
	event.finish_event()
end

--- Opens the bonus course menu and, when the player starts the course, loads the floor and the first Sphida hole.
function script.start_bonus_course_first_hole()
	local music_number: s32 = 0
	local menu_result: s32 = 0
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	music_number = event.get_active_music_number() or music_number
	if music_number ~= 193 then
		event.allow_next_music_load()
		event.stop_music(0)
		wait.frames(4)
		event.load_music(193)
		event.play_music(0)
	end
	event.fade_in_screen(30)
	event.open_event_menu(24)
	vm.wait(4)
	menu_result = event.get_menu_results_1() or menu_result
	if menu_result ~= 18 then
		event.fade_out_screen(0)
		event.set_extra_mode(0)
		event.set_scene_exit_flag(1)
		return
	end
	event.skip_next_music_load()
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d01f01", "mstage0", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	event.show_dungeon_status_bar(0, 1.0)
	minigame.set_up_sphida_course_with_draw_distance(2, 0)
	event.set_sphida_saved_hole(0)
	event.set_character_position(0, 640.0, 0.0, 1280.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(640.0, 30.0, 1280.0)
	event.set_camera_position(640.0, 40.0, 1380.0)
	event.set_event_projection(524.9)
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_event_menu(28)
	vm.wait(6)
	event.reset_follow_camera(0)
	event.finish_event()
end
script[6000] = script.start_bonus_course_first_hole

--- Loads the floor and the last Sphida hole of the bonus course and opens its menu.
function script.start_bonus_course_last_hole()
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	event.skip_next_music_load()
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d01f01", "mstage8", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	event.show_dungeon_status_bar(0, 1.0)
	minigame.set_up_sphida_course_with_draw_distance(2, 8)
	event.set_sphida_saved_hole(8)
	event.set_character_position(0, 4160.0, 0.0, 4480.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(4160.0, 30.0, 4480.0)
	event.set_camera_position(4160.0, 40.0, 4580.0)
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_event_menu(28)
	vm.wait(4)
	event.reset_follow_camera(0)
	event.finish_event()
end
script[6001] = script.start_bonus_course_last_hole

return script
