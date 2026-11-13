--!strict
--- Event script for the Sphida golf course map, covering the random circle and geostone events, the tutorial messages and the shot, ball-retrieval and hole-completion logic of the Sphida minigame.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sphida_course = require("@lib/event/spanish/sphida_course")
local sphida_hint = require("@lib/event/spanish/sphida_hint")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Grants the starting items and flags for the course and clears the event battle monsters.
function script.give_starting_items()
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
script[200] = script.give_starting_items

--- Spins a coin above a random circle until the player stops it, then applies a good or bad random circle effect with its message.
function script.random_circle()
	local active_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local exit_circle_x: f32 = 0
	local exit_circle_y: f32 = 0
	local exit_circle_z: f32 = 0
	local yaw: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local sound_id: s32 = 0
	local motion_frame: f32 = 0
	local coin_yaw: f32 = 0
	local party_npc_id: s32 = 0
	local circle_kind: s32 = 0
	local tick: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local camera_facing_angle: f32 = 0
	local minimum_spin_ticks: s32 = 0
	local angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local result: f32 = 0
	local restore_x: f32 = 0
	local restore_y: f32 = 0
	local restore_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
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
			exit_circle_x = out1 or exit_circle_x
			exit_circle_y = out2 or exit_circle_y
			exit_circle_z = out3 or exit_circle_z
		end
		yaw = event.get_direction_angle(exit_circle_x, exit_circle_y, exit_circle_z, player_x, player_y, player_z) or yaw
		player_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + exit_circle_x)
		player_y = exit_circle_y
		player_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + exit_circle_z)
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
		circle_x = out1 or circle_x
		circle_y = out2 or circle_y
		circle_z = out3 or circle_z
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(circle_x, circle_y + 30.0, circle_z)
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
	motion_frame = event.get_random_circle_motion_frame() or motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, circle_x, circle_y, circle_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, circle_x, circle_y - 30.0, circle_z)
	coin_yaw = event.get_random_number(6.2831855) or coin_yaw
	coin_yaw = vm.f32(coin_yaw - vm.f32(3.1415927))
	coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
	event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
	event.change_directory("")
	party_npc_id = event.get_party_npc() or party_npc_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, circle_x, circle_y + 40.0, circle_z, 30, 2, 0.5)
	tick = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		if tick == 10 then
			event.play_sound_effect(sound_id, 0)
		end
		if tick == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if tick >= 30 then wait.get_button_state(0) else 0) ~= 0 or tick > 300 then
			event.stop_sound_effect(sound_id, 0)
			event.play_sound_effect(sound_id, 3)
			vm.wait(7)
			break
		else
			tick = tick + 1
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
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	minimum_spin_ticks = 0
	minimum_spin_ticks = event.get_random_number_int(10) or minimum_spin_ticks
	minimum_spin_ticks = vm.i32(minimum_spin_ticks + 4)
	tick = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		vm.wait(9)
		if tick >= minimum_spin_ticks then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = camera_facing_angle
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_kind = 0
				break
			end
			angle = vm.f32(camera_facing_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_kind = 1
				break
			end
		end
		tick = vm.i32(tick + 1)
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, camera_facing_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	camera_facing_angle = coin_yaw
	wait.frames(20)
	roll = event.get_random_number_int(10) or roll
	if party_npc_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if circle_kind == 0 then
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
			camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
			camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
			event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 8)
			if circle_kind == 0 then
				circle_kind = 1
			else
				circle_kind = 0
			end
			wait.frames(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(3.14))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 6)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				camera_facing_angle = vm.f32(camera_facing_angle + vm.f32(1.57))
				camera_facing_angle = event.wrap_angle(camera_facing_angle) or camera_facing_angle
				event.rotate_object_sequence(5, 0.0, camera_facing_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	camera_facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or camera_facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, camera_facing_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	tick = 0
	effect_id = event.get_random_circle_effect(circle_kind) or effect_id
	if circle_kind == 0 then
		event.play_sound_effect(sound_id, 1)
		while tick < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			tick = tick + 1
			vm.wait(13)
		end
		message.show_and_wait(0, 2310, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 1 then
			message.show_and_wait(0, 2311, 8, 0, 0)
		end
		if effect_id == 2 then
			message.show_and_wait(0, 2312, 8, 0, 0)
		end
		if effect_id == 3 then
			message.show_and_wait(0, 2313, 8, 0, 0)
		end
		if effect_id == 4 then
			event.place_treasure_box(circle_x, circle_y, circle_z, camera_facing_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_id, 2)
		while tick < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			tick = tick + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		result = event.apply_random_circle_effect(effect_id) or result
		if effect_id == 5 then
			if active_character == 0 or active_character == 2 then
				message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if active_character == 0 then
				message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if active_character == 1 or active_character == 3 then
				message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if active_character == 2 then
				message.show_and_wait(0, 2325, 8, 0, 0)
			end
		end
		if effect_id == 8 then
			message.show_and_wait(0, 2328, 8, 0, 0)
		end
		if effect_id == 9 then
			message.show_and_wait(0, 2326, 8, 0, 0)
		end
		if effect_id == 10 then
			message.show_and_wait(0, 2329, 8, 0, 0)
		end
		if effect_id == 11 then
			message.show_and_wait(0, 2327, 8, 0, 0)
		end
		if effect_id == 12 then
			message.show_and_wait(0, 2330, 8, 0, 0)
		end
	end
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_brightness_rate(1.0)
	if effect_id == 1 then
		event.spawn_pull_items(circle_x, circle_y, circle_z, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		restore_x = out1 or restore_x
		restore_y = out2 or restore_y
		restore_z = out3 or restore_z
	end
	event.set_camera_position(restore_x, restore_y, restore_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restore_x = out1 or restore_x
		restore_y = out2 or restore_y
		restore_z = out3 or restore_z
	end
	event.set_camera_look_at(restore_x, restore_y, restore_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the geostone pickup sequence with the playable character and advances the floor's geostone state.
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
	local floor: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if active_character == 2 then
			message.show_and_wait(0, 22, 8, 0, 0)
		else
			message.show_and_wait(0, 23, 8, 0, 0)
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
	message.show_and_wait(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
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

--- Shows the tutorial message the first time a random stone is examined.
function script.random_stone_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.set_save_flag(50, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.show_and_wait(0, 2600, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows a tutorial message window and waits for the player to dismiss it.
function script.show_guide_message()
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
script[2510] = script.show_guide_message

--- Shows the level-up tutorial messages and the pointer to the main menu help.
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
	message.show_and_wait(0, 2621, 8, 0, 0)
	message.show_and_wait(0, 2622, 8, 0, 0)
	message.show_and_wait(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "Consulta Ayuda en el men[UNI00fa] Principal para obtener m[UNI00e1]s informaci[UNI00f3]n.")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the tutorial for driving the ridepod wheels.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Conducci[UNI00f3]n del Buggy\n   Acelerar (L)↑/ Frenar (L)↓\n   Girar (L) ← o →\n   Curvas cerradas [l1] + (L) ← o →"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the tutorial messages explaining the Magic-Absorb Blade skill.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Has aprendido a usar la Hoja de absorci[UNI00f3]n m[UNI00e1]gica.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La Hoja de absorci[UNI00f3]n m[UNI00e1]gica es una habilidad que\nte permite absorber la energ[UNI00ed]a de ataques elementales,\ncomo el Fuego, mientras te defiendes. Al blandir la\nespada, se dispara en forma de magia."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Puedes recargar continuamente\nenerg[UNI00ed]a de un elemental.\nSin embargo, si absorbes\nenerg[UNI00ed]a elemental de otro tipo, pierdes toda la carga."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"La cantidad de energ[UNI00ed]a elemental que puedes absorber\ndepende de la resistencia del arma que est[UNI00e9]s usando."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Para liberar energ[UNI00ed]a elemental absorbida\nen forma de magia, pulsa el bot[UNI00f3]n [l1]\nmientras te defiendes con el bot[UNI00f3]n [r1]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Runs a full Sphida shot: aiming, the power gauge, the ball flight simulation with collisions, and the hole-in, miss or retry outcome.
function script.sphida_shot()
	local bonus_course: s32 = 0
	local tex_bank: s32 = 0
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
	local angle: f32 = 0
	local power_or_water_flag: f32 = 0
	local club_curve: f32 = 0
	local level: s32 = 0
	local spin_x: f32 = 0
	local curve_amount: f32 = 0
	local spin_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local holed_out: s32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local speed: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local out_of_play_counter: s32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local ahead_x: f32 = 0
	local ahead_y: f32 = 0
	local ahead_z: f32 = 0
	local remaining_speed: f32 = 0
	local vector_length: f32 = 0
	local collision_result: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local step: s32 = 0
	local pin_distance: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local pin_segment_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local yaw: f32 = 0
	local count: s32 = 0
	local choice_answer: any = 0
	vm.wait(1)
	event.initialize_event()
	character.reset_action_motion()
	event.set_character_motion(0, "立ち")
	if minigame.check_sphida_club() ~= 0 then
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
	tex_bank = event.get_sphida_texture_bank() or tex_bank
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
	angle = 12.5
	event.set_sphida_carry_angle(vm.f32(angle * vm.f32(3.1415927)) / 180.0)
	power_or_water_flag, club_curve, level = minigame.get_equipped_club_definition(power_or_water_flag, club_curve, level)
	event.set_sphida_power_gauge_safe_level(level)
	do
		local out1, out2, out3 = event.zero_vector()
		spin_x = out1 or spin_x
		curve_amount = out2 or curve_amount
		spin_z = out3 or spin_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_yaw, angle = minigame.aim_sphida_shot(aim_yaw, angle, tex_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(start_x, start_y, start_z)
			event.set_character_position(8, start_x, start_y, start_z)
			event.set_character_position(9, start_x, start_y, start_z)
			sphida_course.finish_hole(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, power_or_water_flag, aim_yaw, curve_amount, spin_x, level = minigame.run_sphida_power_gauge(power_or_water_flag, tex_bank, aim_yaw, curve_amount, spin_x, sound_id, level)
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
	holed_out = 0
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
	if power_or_water_flag <= vm.f32(0.3) then
		event.set_character_motion(0, "小ショット", 2)
		wait.frames(25)
		if level ~= 4 then
			event.play_sound_effect(sound_id, 3)
		end
	elseif power_or_water_flag <= vm.f32(0.6) then
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
		sphida_course.finish_hole(0)
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
	power_or_water_flag = minigame.scale_by_club_power(power_or_water_flag)
	angle = vm.f32(vm.f32(angle * vm.f32(3.1415927)) / 180.0)
	power_or_water_flag = vm.f32(power_or_water_flag - vm.f32(power_or_water_flag * angle))
	velocity_x = vm.f32(vm.sin(aim_yaw) * vm.f32(power_or_water_flag * vm.cos(angle)))
	velocity_y = vm.f32(power_or_water_flag * vm.sin(angle))
	velocity_z = vm.f32(vm.cos(aim_yaw) * vm.f32(power_or_water_flag * vm.cos(angle)))
	curve_amount = vm.f32(vm.f32(curve_amount * vm.f32(3.1415927)) / 2.0)
	spin_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_curve) * spin_x) * vm.f32(0.4))
	spin_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_curve) * spin_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	out_of_play_counter = 0
	level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
		collision_result = out4 or collision_result
		surface_type = out5 or surface_type
	end
	if collision_result >= 0 and (surface_type == 1 or surface_type == 7) then
		print("----------------START_MIZU-------------------\n")
		power_or_water_flag = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		power_or_water_flag = 0.0
	end
	step = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (step + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_result = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_result
			if level == 1 and collision_result >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (step + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + spin_x)
				velocity_z = vm.f32(velocity_z + spin_z)
				spin_x = vm.f32(spin_x * vm.f32(0.8))
				spin_z = vm.f32(spin_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (step + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if curve_amount ~= 0.0 then
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
			angle = vm.f32(angle + curve_amount)
			angle = event.wrap_angle(angle) or angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(angle) / 10.0) * club_curve))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(angle) / 10.0) * club_curve))
		end
		vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
		if vector_length > vm.f32(0.01) then
			speed = event.get_vector_length(spin_x, 0.0, spin_z) or speed
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + spin_x, previous_y, previous_z + spin_z) or angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_yaw = out2 or aim_yaw
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, angle, rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, angle, rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				rotation_x = out1 or rotation_x
				aim_yaw = out2 or aim_yaw
				rotation_z = out3 or rotation_z
			end
			event.set_character_rotation(8, rotation_x, angle, rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, rotation_x, angle, rotation_z)
			event.offset_character_rotation(9, speed / 10.0, 0.0, 0.0)
		end
		speed = event.get_vector_length(velocity_x, velocity_y, velocity_z) or speed
		remaining_speed = speed
		angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or angle
		ahead_x = vm.f32(vm.sin(vm.f32(angle - vm.f32(1.5707964))) * 3.0)
		ahead_z = vm.f32(vm.cos(vm.f32(angle - vm.f32(1.5707964))) * 3.0)
		event.add_sword_afterimage_point(
			ball_x - ahead_x,
			ball_y,
			ball_z - ahead_z,
			vm.f32(ball_x + ahead_x) + ahead_x,
			ball_y,
			vm.f32(ball_z + ahead_z) + ahead_z
		)
		do
			local out1, out2, out3 = event.copy_vector(velocity_x, velocity_y, velocity_z)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2, out3 = event.normalize_vector(ahead_x, ahead_y, ahead_z)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2, out3 = event.scale_vector(ahead_x, ahead_y, ahead_z, 3.0)
			ahead_x = out1 or ahead_x
			ahead_y = out2 or ahead_y
			ahead_z = out3 or ahead_z
		end
		do
			local out1, out2, out3, out4, out5 =
				event.get_segment_collision_13(0, previous_x, previous_y, previous_z, ball_x + ahead_x, ball_y + ahead_y, ball_z + ahead_z, 0)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			collision_result = out4 or collision_result
			surface_type = out5 or surface_type
		end
		if collision_result >= 0 and (surface_type == 1 or surface_type == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_id, 11)
				sound_cooldown = 10
			end
			if power_or_water_flag == 0.0 then
				power_or_water_flag = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				spin_x = 0.0
				spin_z = 0.0
				event.delete_sword_afterimage()
				print("----------------SE OFF-------------------\n")
			else
				power_or_water_flag = 0.0
				print("----------------SE ON-------------------\n")
			end
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				event.get_segment_collision_15(12, previous_x, previous_y, previous_z, ball_x + ahead_x, ball_y + ahead_y, ball_z + ahead_z, 1)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			collision_result = out7 or collision_result
		end
		if collision_result < 0 then
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
				collision_result = 1
			end
		end
		while collision_result >= 0 do
			curve_amount = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
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
			vector_length = vm.f32(remaining_speed - vector_length)
			if vector_length <= 0.0 then
				break
			else
				remaining_speed = vector_length
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
				if power_or_water_flag == 0.0 then
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
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
				end
				do
					local out1, out2, out3 = event.normalize_vector(ahead_x, ahead_y, ahead_z)
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
				end
				do
					local out1, out2, out3 = event.scale_vector(ahead_x, ahead_y, ahead_z, 3.0)
					ahead_x = out1 or ahead_x
					ahead_y = out2 or ahead_y
					ahead_z = out3 or ahead_z
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
						ball_x + ahead_x,
						ball_y + ahead_y,
						ball_z + ahead_z,
						1
					)
					hit_x = out1 or hit_x
					hit_y = out2 or hit_y
					hit_z = out3 or hit_z
					normal_x = out4 or normal_x
					normal_y = out5 or normal_y
					normal_z = out6 or normal_z
					collision_result = out7 or collision_result
					surface_type = out8 or surface_type
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
			collision_result = out7 or collision_result
			surface_type = out8 or surface_type
		end
		if collision_result >= 0 then
			curve_amount = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			vector_length = event.get_vector_length(velocity_x, 0.0, velocity_z) or vector_length
			if vector_length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				level = 1
			else
				if power_or_water_flag == 0.0 then
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
				if power_or_water_flag ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_id, 5)
					sound_cooldown = 10
				end
			end
			vector_length = event.get_vector_length(spin_x, 0.0, spin_z) or vector_length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and vector_length < vm.f32(0.4) then
				if surface_type == 6 then
					out_of_play_counter = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				out_of_play_counter = 1
				break
			end
		end
		if ball_y < -500.0 then
			out_of_play_counter = 1
			break
		elseif step >= 480 then
			out_of_play_counter = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			x = vm.f32(pin_x - ball_x)
			y = vm.f32(pin_y - ball_y)
			z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(x, y, z) or pin_distance
			if ball_color ~= pin_color then
				pin_segment_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_segment_distance
				if pin_segment_distance >= 0.0 and pin_segment_distance <= 30.0 then
					holed_out = 1
					break
				end
				if pin_distance ~= 0.0 then
					if pin_distance <= 120.0 then
						do
							local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(vm.f32(0.6), pin_distance))
							x = out1 or x
							y = out2 or y
							z = out3 or z
						end
						do
							local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, x, y, z)
							ball_x = out1 or ball_x
							ball_y = out2 or ball_y
							ball_z = out3 or ball_z
						end
						do
							local out1, out2, out3 = event.add_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
							velocity_x = out1 or velocity_x
							velocity_y = out2 or velocity_y
							velocity_z = out3 or velocity_z
						end
					end
				else
					holed_out = 1
					break
				end
			elseif pin_distance ~= 0.0 then
				if pin_distance <= 60.0 then
					do
						local out1, out2, out3 = event.scale_vector(x, y, z, vm.fdiv(1.0, pin_distance))
						x = out1 or x
						y = out2 or y
						z = out3 or z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(ball_x, ball_y, ball_z, x, y, z)
						ball_x = out1 or ball_x
						ball_y = out2 or ball_y
						ball_z = out3 or ball_z
					end
					do
						local out1, out2, out3 = event.subtract_vectors(velocity_x, velocity_y, velocity_z, x, y, z)
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
				if out_of_play_counter >= 30 then
					if out_of_play_counter >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				out_of_play_counter = out_of_play_counter + 1
			elseif step >= 20 then
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
				yaw = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or yaw
				event.set_camera_control_rotation(yaw)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			step = step + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if out_of_play_counter == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		count = event.get_sphida_par() or count
		if holed_out == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_id, 17)
			step = 0
			while step < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step = step + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			step = 0
			while step < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				step = step + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			pin_color = event.get_dungeon_stage_id() or pin_color
			ball_color = event.get_dungeon_floor() or ball_color
			collision_result = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_result
			do
				local out1, out2 = event.get_sphida_prize(collision_result)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_result = vm.i32(collision_result + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_result)
			if bonus_course == 0 then
				event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, angle, sound_cooldown)
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
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
				event.set_event_sprite_texture_rect(0, 258, 0, 254, 54)
				event.set_event_sprite_position(0, 256, 208)
				event.set_event_sprite_size(0, 254, 54)
				event.set_event_sprite_color(0, 128, 128, 128, 0)
				event.set_event_sprite_scale(0, 5.0, 5.0)
				event.set_event_sprite_draw_pass(0, 1)
			else
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
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
				count = vm.i32(count + 2)
				event.reset_event_sprite(0)
				event.set_event_sprite_type(0, 0)
				event.set_event_sprite_texture(0, "omake_sfida", tex_bank)
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
				event.set_event_sprite_texture(1, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(1, 280, 96, 28, 32)
				event.set_event_sprite_position(1, 174, 224)
				event.set_event_sprite_size(1, 28, 32)
				event.set_event_sprite_color(1, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(1, 1)
				event.reset_event_sprite(2)
				event.set_event_sprite_type(2, 0)
				event.set_event_sprite_texture(2, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(2, 136, 0, 104, 38)
				event.set_event_sprite_position(2, 296, 224)
				event.set_event_sprite_size(2, 104, 38)
				event.set_event_sprite_color(2, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(2, 1)
				event.reset_event_sprite(3)
				event.set_event_sprite_type(3, 0)
				event.set_event_sprite_texture(3, "omake_sfida", tex_bank)
				event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(count, 10) * 28), 96, 28, 32)
				event.set_event_sprite_position(3, 228, 224)
				event.set_event_sprite_size(3, 28, 32)
				event.set_event_sprite_color(3, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(3, 1)
				if vm.idiv(count, 10) > 0 then
					event.reset_event_sprite(4)
					event.set_event_sprite_type(4, 0)
					event.set_event_sprite_texture(4, "omake_sfida", tex_bank)
					event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(count, 10) * 28), 96, 28, 32)
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
					event.set_sphida_hole_score(-1, count)
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
		elseif count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			choice_answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(27)
			if choice_answer == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_result = out1 or collision_result
					start_x = out2 or start_x
					start_y = out3 or start_y
					start_z = out4 or start_z
				end
				if collision_result == 0 then
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
					angle = event.get_random_number(6.2831855) or angle
					angle = vm.f32(angle - vm.f32(3.1415927))
					start_x = vm.f32(start_x + vm.f32(vm.sin(angle) * 50.0))
					start_z = vm.f32(start_z + vm.f32(vm.cos(angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(start_x, start_y, start_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_result = out4 or collision_result
					end
					step = 0
					while collision_result >= 0 do
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
							collision_result = out4 or collision_result
						end
						step = step + 1
						if step > 6 then
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
		event.set_event_sprite_texture(0, "sphida_bar", tex_bank)
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
	if holed_out == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_id)
	end
	sphida_course.finish_hole(holed_out)
end

--- Offers to move the Sphida ball to the player's position.
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

--- Warns that this is the last time the ball can be moved and offers to move it to the player.
function script.sphida_near_ball_last()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Esta es la [UNI00fa]ltima vez que\npodr[UNI00e1]s mover la Esfera hacia ti.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "[UNI00bf]Acercar la Esfera?")
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

--- Offers to give up the current bonus course hole and skip ahead.
function script.sphida_omake_away()
	local answer: any = 0
	local saved_hole: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	saved_hole = event.get_sphida_saved_hole() or saved_hole
	if saved_hole == 8 then
		event.open_message_window_2(0, "Este es el [UNI00fa]ltimo hoyo. [UNI00bf]Vas a abandonar?")
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
		event.open_message_window_2(0, "[UNI00bf]Abandonar el hoyo y pasar al siguiente?")
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

--- Loads the Sphida course map, sets up the course and opens the event menu.
function script.enter_sphida_course()
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	event.skip_next_music_load()
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d04f01", "mstage3", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	minigame.set_up_sphida_course_with_draw_distance(2, 3)
	event.set_sphida_saved_hole(3)
	event.set_character_position(0, 1280.0, 0.0, 3840.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(1280.0, 30.0, 3840.0)
	event.set_camera_position(1280.0, 40.0, 3940.0)
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_event_menu(28)
	vm.wait(4)
	event.reset_follow_camera(0)
	event.finish_event()
end
script[6000] = script.enter_sphida_course

return script
