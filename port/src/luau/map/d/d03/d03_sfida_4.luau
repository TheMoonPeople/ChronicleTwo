--!strict
--- Event script for the Sphida minigame course, covering the random circle and geostone events, the first-time guide messages, the ball shot simulation and the bonus course menu events.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local sphida_course = require("@lib/event/italian/sphida_course")
local sphida_hint = require("@lib/event/italian/sphida_hint")
local wait = require("@lib/event/wait")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

--- Adds the Sphida items to the inventory when missing and sets the save flags that go with them.
function script.grant_starting_items()
	local item_count: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	item_count = event.get_owned_item_count(10) or item_count
	if item_count <= 0 then
		event.add_inventory_item(10, 1)
	end
	item_count = event.get_owned_item_count(302) or item_count
	if item_count <= 0 then
		event.add_inventory_item(302, 1)
	end
	event.set_save_flag(220, 1)
	event.set_save_flag(317, 1)
	event.clear_event_battle_monsters(-1)
	event.finish_event()
end
script[200] = script.grant_starting_items

--- Spins a coin above the random circle until the player stops it and applies the light or dark circle effect it lands on, while the other playable characters only get a message and are pushed off the circle.
function script.random_circle()
	local playable_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local push_angle: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local sound_bank: s32 = 0
	local ring_motion_frame: f32 = 0
	local coin_yaw: f32 = 0
	local party_character_id: s32 = 0
	local circle_kind: s32 = 0
	local spin_ticks: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_look_x: f32 = 0
	local camera_look_y: f32 = 0
	local camera_look_z: f32 = 0
	local coin_reference_angle: f32 = 0
	local min_spin_ticks: s32 = 0
	local stop_angle: f32 = 0
	local random_roll: s32 = 0
	local chance_limit: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restore_x: f32 = 0
	local restore_y: f32 = 0
	local restore_z: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if playable_character == 2 then
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
			circle_x = out1 or circle_x
			circle_y = out2 or circle_y
			circle_z = out3 or circle_z
		end
		push_angle = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or push_angle
		player_x = vm.f32(vm.f32(vm.sin(push_angle) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(push_angle) * 25.0) + circle_z)
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
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_011.sound.json") or sound_bank
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
	coin_yaw = event.get_random_number(6.2831855) or coin_yaw
	coin_yaw = vm.f32(coin_yaw - vm.f32(3.1415927))
	coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
	event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
	event.change_directory("")
	party_character_id = event.get_party_npc() or party_character_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, ring_x, ring_y + 40.0, ring_z, 30, 2, 0.5)
	spin_ticks = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		if spin_ticks == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if spin_ticks == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if spin_ticks >= 30 then wait.get_button_state(0) else 0) ~= 0 or spin_ticks > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(7)
			break
		else
			spin_ticks = spin_ticks + 1
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
		camera_look_x = out1 or camera_look_x
		camera_look_y = out2 or camera_look_y
		camera_look_z = out3 or camera_look_z
	end
	coin_reference_angle = event.get_direction_angle(camera_look_x, camera_look_y, camera_look_z, camera_x, camera_y, camera_z) or coin_reference_angle
	min_spin_ticks = 0
	min_spin_ticks = event.get_random_number_int(10) or min_spin_ticks
	min_spin_ticks = vm.i32(min_spin_ticks + 4)
	spin_ticks = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		vm.wait(9)
		if spin_ticks >= min_spin_ticks then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			stop_angle = coin_reference_angle
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_yaw < stop_angle and calc.is_angle_within(coin_yaw, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				circle_kind = 0
				break
			end
			stop_angle = vm.f32(coin_reference_angle - vm.f32(3.1415927))
			stop_angle = event.wrap_angle(stop_angle) or stop_angle
			if coin_yaw < stop_angle and calc.is_angle_within(coin_yaw, stop_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, stop_angle, 0.0)
				circle_kind = 1
				break
			end
		end
		spin_ticks = vm.i32(spin_ticks + 1)
	end
	coin_reference_angle = event.get_direction_angle(camera_look_x, camera_look_y, camera_look_z, camera_x, camera_y, camera_z) or coin_reference_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, coin_reference_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	coin_reference_angle = coin_yaw
	wait.frames(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if party_character_id == 24 then
		chance_limit = 100
	else
		chance_limit = 6
	end
	if random_roll < chance_limit then
		random_roll = event.get_random_number_int(10) or random_roll
		if circle_kind == 0 then
			if party_character_id == 24 then
				chance_limit = 0
			else
				chance_limit = 2
			end
		elseif party_character_id == 24 then
			chance_limit = 100
		else
			chance_limit = 4
		end
		if random_roll < chance_limit then
			coin_reference_angle = vm.f32(coin_reference_angle + vm.f32(3.14))
			coin_reference_angle = event.wrap_angle(coin_reference_angle) or coin_reference_angle
			event.rotate_object_sequence(5, 0.0, coin_reference_angle, 0.0, 8)
			if circle_kind == 0 then
				circle_kind = 1
			else
				circle_kind = 0
			end
			wait.frames(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				coin_reference_angle = vm.f32(coin_reference_angle + vm.f32(3.14))
				coin_reference_angle = event.wrap_angle(coin_reference_angle) or coin_reference_angle
				event.rotate_object_sequence(5, 0.0, coin_reference_angle, 0.0, 6)
				coin_reference_angle = vm.f32(coin_reference_angle + vm.f32(1.57))
				coin_reference_angle = event.wrap_angle(coin_reference_angle) or coin_reference_angle
				event.rotate_object_sequence(5, 0.0, coin_reference_angle, 0.0, 3)
				coin_reference_angle = vm.f32(coin_reference_angle + vm.f32(1.57))
				coin_reference_angle = event.wrap_angle(coin_reference_angle) or coin_reference_angle
				event.rotate_object_sequence(5, 0.0, coin_reference_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	coin_reference_angle = event.get_direction_angle(camera_look_x, camera_look_y, camera_look_z, camera_x, camera_y, camera_z) or coin_reference_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, coin_reference_angle, 1.0) == 0 then
		circle_kind = 0
	else
		circle_kind = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	spin_ticks = 0
	effect_id = event.get_random_circle_effect(circle_kind) or effect_id
	if circle_kind == 0 then
		event.play_sound_effect(sound_bank, 1)
		while spin_ticks < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			spin_ticks = spin_ticks + 1
			vm.wait(13)
		end
		message.show_and_wait(0, 2310, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
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
			event.place_treasure_box(ring_x, ring_y, ring_z, coin_reference_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while spin_ticks < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			spin_ticks = spin_ticks + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		effect_amount = event.apply_random_circle_effect(effect_id) or effect_amount
		if effect_id == 5 then
			if playable_character == 0 or playable_character == 2 then
				message.show_and_wait(0, 2321, 8, 0, 0)
			end
			if playable_character == 1 or playable_character == 3 then
				message.show_and_wait(0, 2322, 8, 0, 0)
			end
		end
		if effect_id == 6 then
			if playable_character == 0 then
				message.show_and_wait(0, 2323, 8, 0, 0)
			end
			if playable_character == 1 or playable_character == 3 then
				message.show_and_wait(0, 2324, 8, 0, 0)
			end
			if playable_character == 2 then
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
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_amount / 10.0)
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

--- Plays the sequence of the player taking and activating the geostone and records it for the dungeon floor, while the other playable characters only get a message.
function script.geostone()
	local playable_character: s32 = 0
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local stone_x: f32 = 0
	local stone_y: f32 = 0
	local stone_z: f32 = 0
	local facing_angle: f32 = 0
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local system_sound_bank: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.set_message_draw_speed(0, 1)
		character.reset_action_motion()
		if playable_character == 2 then
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
		origin_x = out1 or origin_x
		origin_y = out2 or origin_y
		origin_z = out3 or origin_z
	end
	if playable_character == 0 then
		event.start_background_file_loads_3(
			"dungeon/chara/c01_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(3)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c01_gio.gltf", "info", 0)
	end
	if playable_character == 1 then
		event.start_background_file_loads_3(
			"dungeon/chara/c02_gio.gltf",
			"event/itemget_ev/itemget_ev.gltf",
			"snd2/sp/sp_012.sound.json"
		)
		vm.wait(5)
		wait.background_load()
		event.load_character_motion_pack(5, "dungeon/chara/c02_gio.gltf", "info", 0)
	end
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
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
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	event.copy_vector(player_x, player_y, player_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		stone_x = out1 or stone_x
		stone_y = out2 or stone_y
		stone_z = out3 or stone_z
	end
	stone_y = vm.f32(player_y + 18.0)
	event.set_object_handle_position(1, stone_x, stone_y, stone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(stone_x, stone_y, stone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if playable_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if playable_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	player_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + stone_x)
	player_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + stone_z)
	event.set_character_position(0, player_x, player_y, player_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if playable_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, player_x, player_y + 36.0, player_z)
	end
	if playable_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(player_x, player_y + 18.0, player_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + player_x)
		effect_y = vm.f32(player_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + player_z)
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
	event.play_sound_effect(sound_bank, 0)
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
	facing_angle = event.get_direction_angle(player_x, player_y, player_z, camera_x, camera_y, camera_z) or facing_angle
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
	event.play_sound_effect(sound_bank, 1)
	object.wait_until_done(0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	system_sound_bank = event.get_system_sound_id() or system_sound_bank
	event.play_sound_effect(system_sound_bank, 18)
	message.show_and_wait(0, 2400, 8, 0, 0)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor_number = event.get_dungeon_floor() or floor_number
	event.set_dungeon_floor_info(stage_id, floor_number, 5, 256)
	event.start_crossfade(10)
	if playable_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, origin_x, origin_y, origin_z)
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

--- Shows the first-time guide message for random stones.
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

--- Shows a guide message with a question and waits for the player to answer it.
function script.show_guide_prompt()
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
script[2510] = script.show_guide_prompt

--- Shows the first-time level up guide and points to the help menu.
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
	event.open_message_window_2(0, "Sei hai dubbi, vedi Guida da Menu principale.")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the first-time guide for driving the ridepod as a buggy.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Guida del Fuoristrada\n   Accelera con (L)↑; Rallenta con (L)↓.\n   Sterza con (L) ← oppure →.\n   Per le curve strette, [l1] + (L) ← o →."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the first-time guide for the Magic-Absorb Blade skill.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Ora sai usare la Spada Assorbi-magia.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"In guardia, la Spada Assorbi-magia\nassorbe l'energia degli attacchi\nelementali, come Fuoco. In attacco,\nrilascer[UNI00e0] poi l'energia assorbita."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00c8] possibile caricare continuamente\nenergia dello stesso elemento.\nPer[UNI00f2], assorbendo un elemento\ndiverso, si perde l'intera carica."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "L'energia elementale assorbibile\ndipende dalla robustezza dell'arma.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Per usare l'energia elementale\nassorbita come magia, premi\n[l1] mentre sei in guardia con [r1]."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Runs a whole shot of the Sphida minigame, from aiming and the power gauge through the ball flight simulation to the cup-in or miss result.
function script.sphida_shot()
	local is_bonus_course: s32 = 0
	local texture_bank: s32 = 0
	local sound_bank: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local ball_rotation_x: f32 = 0
	local aim_angle: f32 = 0
	local ball_rotation_z: f32 = 0
	local rest_x: f32 = 0
	local rest_y: f32 = 0
	local rest_z: f32 = 0
	local launch_angle: f32 = 0
	local shot_power: f32 = 0
	local club_spin: f32 = 0
	local gauge_level: s32 = 0
	local spin_drift_x: f32 = 0
	local spin_amount: f32 = 0
	local spin_drift_z: f32 = 0
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
	local miss_state: s32 = 0
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
	local length: f32 = 0
	local collision_id: s32 = 0
	local sound_cooldown: s32 = 0
	local surface_type: s32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local index: s32 = 0
	local pin_distance: f32 = 0
	local pin_offset_x: f32 = 0
	local pin_offset_y: f32 = 0
	local pin_offset_z: f32 = 0
	local pin_path_distance: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local camera_angle: f32 = 0
	local par_count: s32 = 0
	local answer: any = 0
	vm.wait(1)
	event.initialize_event()
	character.reset_action_motion()
	event.set_character_motion(0, "立ち")
	if minigame.check_sphida_club() ~= 0 then
		event.finish_event()
		return
	end
	is_bonus_course = event.is_sphida_bonus_course() or is_bonus_course
	if is_bonus_course == 0 then
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
	sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_900.sound.json") or sound_bank
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
		rest_x = out1 or rest_x
		rest_y = out2 or rest_y
		rest_z = out3 or rest_z
	end
	ball_x, ball_y, ball_z, aim_angle = minigame.set_up_sphida_shot(ball_x, ball_y, ball_z, aim_angle)
	camera.place_behind_player(aim_angle)
	event.set_sphida_status_panel_visible(1)
	launch_angle = 12.5
	event.set_sphida_carry_angle(vm.f32(launch_angle * vm.f32(3.1415927)) / 180.0)
	shot_power, club_spin, gauge_level = minigame.get_equipped_club_definition(shot_power, club_spin, gauge_level)
	event.set_sphida_power_gauge_safe_level(gauge_level)
	do
		local out1, out2, out3 = event.zero_vector()
		spin_drift_x = out1 or spin_drift_x
		spin_amount = out2 or spin_amount
		spin_drift_z = out3 or spin_drift_z
	end
	while true do
		event.set_sphida_minimap_scroll_enabled(1)
		event.set_sphida_minimap_shot_line_visible(1)
		local t0: s32
		t0, aim_angle, launch_angle = minigame.aim_sphida_shot(aim_angle, launch_angle, texture_bank)
		if t0 ~= 0 then
			event.set_sphida_minimap_scroll_enabled(0)
			event.set_sphida_minimap_shot_line_visible(0)
			event.set_sphida_ball_position(rest_x, rest_y, rest_z)
			event.set_character_position(8, rest_x, rest_y, rest_z)
			event.set_character_position(9, rest_x, rest_y, rest_z)
			sphida_course.finish_hole(0)
			return
		end
		event.set_sphida_minimap_scroll_enabled(0)
		event.set_sphida_minimap_shot_line_visible(0)
		local t1: s32
		t1, shot_power, aim_angle, spin_amount, spin_drift_x, gauge_level = minigame.run_sphida_power_gauge(shot_power, texture_bank, aim_angle, spin_amount, spin_drift_x, sound_bank, gauge_level)
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
	if gauge_level ~= 1 and gauge_level ~= -1 and gauge_level ~= 4 then
		event.set_event_sprite_type(0, 1)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_size(0, 10.8, 11.6)
		event.set_event_sprite_position(0, ball_x, ball_y + 30.0, ball_z)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		if gauge_level == 0 then
			event.set_event_sprite_texture_rect(0, 78, 198, 54, 58)
		end
		if gauge_level == 2 or gauge_level == -2 then
			event.set_event_sprite_texture_rect(0, 186, 190, 70, 66)
		end
		if gauge_level == 3 or gauge_level == -3 then
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
		if gauge_level ~= 4 then
			event.play_sound_effect(sound_bank, 3)
		end
	elseif shot_power <= vm.f32(0.6) then
		event.set_character_motion(0, "中ショット", 2)
		wait.frames(34)
		event.play_sound_effect(sound_bank, 2)
	else
		event.set_character_motion(0, "大ショット", 2)
		wait.frames(39)
		if gauge_level == 0 then
			event.play_sound_effect(sound_bank, 12)
		else
			event.play_sound_effect(sound_bank, 1)
		end
	end
	if gauge_level == 4 then
		wait.frames(50)
		minigame.consume_sphida_shot(sound_bank)
		event.set_sphida_ball_position(rest_x, rest_y, rest_z)
		event.set_character_position(8, rest_x, rest_y, rest_z)
		event.set_character_position(9, rest_x, rest_y, rest_z)
		sphida_course.finish_hole(0)
		return
	end
	if gauge_level == 0 then
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
	velocity_x = vm.f32(vm.sin(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	velocity_y = vm.f32(shot_power * vm.sin(launch_angle))
	velocity_z = vm.f32(vm.cos(aim_angle) * vm.f32(shot_power * vm.cos(launch_angle)))
	spin_amount = vm.f32(vm.f32(spin_amount * vm.f32(3.1415927)) / 2.0)
	spin_drift_z = vm.f32(vm.f32(vm.f32(-velocity_z * club_spin) * spin_drift_x) * vm.f32(0.4))
	spin_drift_x = vm.f32(vm.f32(vm.f32(-velocity_x * club_spin) * spin_drift_x) * vm.f32(0.4))
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	miss_state = 0
	gauge_level = 0
	sound_cooldown = 0
	do
		local out1, out2, out3, out4, out5 =
			event.get_segment_collision_13(0, ball_x, ball_y + 5.0, ball_z, ball_x, ball_y, ball_z, 0)
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
		collision_id = out4 or collision_id
		surface_type = out5 or surface_type
	end
	if collision_id >= 0 and (surface_type == 1 or surface_type == 7) then
		print("----------------START_MIZU-------------------\n")
		shot_power = 1.0
	else
		print("----------------START_SOTO-------------------\n")
		shot_power = 0.0
	end
	index = 0
	while true do
		if ball_y >= 180.0 then
			velocity_x = vm.f32(velocity_x * vm.f32(0.999))
			velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0098) * (index + 1)))
			velocity_z = vm.f32(velocity_z * vm.f32(0.999))
		else
			collision_id = event.get_segment_collision_9(12, ball_x, ball_y, ball_z, ball_x, vm.f32(ball_y - 3.0) - vm.f32(0.01), ball_z, 0)
				or collision_id
			if gauge_level == 1 and collision_id >= 0 then
				velocity_x = vm.f32(velocity_x * vm.f32(0.94))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.00045) * (index + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.94))
				velocity_x = vm.f32(velocity_x + spin_drift_x)
				velocity_z = vm.f32(velocity_z + spin_drift_z)
				spin_drift_x = vm.f32(spin_drift_x * vm.f32(0.8))
				spin_drift_z = vm.f32(spin_drift_z * vm.f32(0.8))
			else
				velocity_x = vm.f32(velocity_x * vm.f32(0.999))
				velocity_y = vm.f32(velocity_y + vm.f32(vm.f32(-0.0045) * (index + 1)))
				velocity_z = vm.f32(velocity_z * vm.f32(0.999))
			end
		end
		do
			local out1, out2, out3 = event.add_vectors(ball_x, ball_y, ball_z, velocity_x, velocity_y, velocity_z)
			ball_x = out1 or ball_x
			ball_y = out2 or ball_y
			ball_z = out3 or ball_z
		end
		if spin_amount ~= 0.0 then
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			launch_angle = vm.f32(launch_angle + spin_amount)
			launch_angle = event.wrap_angle(launch_angle) or launch_angle
			velocity_x = vm.f32(velocity_x + vm.f32(vm.f32(vm.sin(launch_angle) / 10.0) * club_spin))
			velocity_z = vm.f32(velocity_z + vm.f32(vm.f32(vm.cos(launch_angle) / 10.0) * club_spin))
		end
		length = event.get_vector_length(spin_drift_x, 0.0, spin_drift_z) or length
		if length > vm.f32(0.01) then
			speed = event.get_vector_length(spin_drift_x, 0.0, spin_drift_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, previous_x + spin_drift_x, previous_y, previous_z + spin_drift_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, launch_angle, ball_rotation_z)
			event.offset_character_rotation(8, speed * 12.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, launch_angle, ball_rotation_z)
			event.offset_character_rotation(9, speed * 12.0, 0.0, 0.0)
		else
			speed = event.get_vector_length(velocity_x, 0.0, velocity_z) or speed
			launch_angle = event.get_direction_angle(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z) or launch_angle
			do
				local out1, out2, out3 = event.get_character_rotation(8)
				ball_rotation_x = out1 or ball_rotation_x
				aim_angle = out2 or aim_angle
				ball_rotation_z = out3 or ball_rotation_z
			end
			event.set_character_rotation(8, ball_rotation_x, launch_angle, ball_rotation_z)
			event.offset_character_rotation(8, speed / 10.0, 0.0, 0.0)
			event.set_character_rotation(9, ball_rotation_x, launch_angle, ball_rotation_z)
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
			collision_id = out4 or collision_id
			surface_type = out5 or surface_type
		end
		if collision_id >= 0 and (surface_type == 1 or surface_type == 7) then
			event.create_effect("足水パシャ")
			event.set_effect_first_vector(hit_x, hit_y, hit_z)
			if sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 11)
				sound_cooldown = 10
			end
			if shot_power == 0.0 then
				shot_power = 1.0
				velocity_x = vm.f32(velocity_x * vm.f32(0.4))
				velocity_y = vm.f32(velocity_y * vm.f32(0.4))
				velocity_z = vm.f32(velocity_z * vm.f32(0.4))
				spin_drift_x = 0.0
				spin_drift_z = 0.0
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
			collision_id = out7 or collision_id
		end
		if collision_id < 0 then
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
				collision_id = 1
			end
		end
		while collision_id >= 0 do
			spin_amount = 0.0
			if speed > 8.0 then
				minigame.toggle_sphida_ball_color()
			end
			if shot_power ~= 1.0 and sound_cooldown <= 0 then
				event.play_sound_effect(sound_bank, 6)
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
			length = event.get_vector_length(previous_x, previous_y, previous_z) or length
			length = vm.f32(remaining_distance - length)
			if length <= 0.0 then
				break
			else
				remaining_distance = length
				do
					local out1, out2, out3 = event.copy_vector(-velocity_x, -velocity_y, -velocity_z)
					velocity_x = out1 or velocity_x
					velocity_y = out2 or velocity_y
					velocity_z = out3 or velocity_z
				end
				if velocity_y < 0.0 and normal_y > 0.0 then
					velocity_x = vm.f32(spin_drift_x * 2.0)
					velocity_y = 0.0
					velocity_z = vm.f32(spin_drift_z * 2.0)
					spin_drift_x = vm.f32(spin_drift_x * vm.f32(0.2))
					spin_drift_z = vm.f32(spin_drift_z * vm.f32(0.2))
				else
					if
						velocity_x < 0.0 and normal_x > 0.0
						or velocity_x > 0.0 and normal_x < 0.0
						or velocity_z < 0.0 and normal_z > 0.0
						or velocity_z > 0.0 and normal_z < 0.0
					then
						spin_drift_x = 0.0
						spin_drift_z = 0.0
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
					local out1, out2, out3 = event.scale_vector(normal_x, normal_y, normal_z, length)
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
					collision_id = out7 or collision_id
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
			collision_id = out7 or collision_id
			surface_type = out8 or surface_type
		end
		if collision_id >= 0 then
			spin_amount = 0.0
			ball_y = vm.f32(hit_y + 3.0)
			length = event.get_vector_length(velocity_x, 0.0, velocity_z) or length
			if length < vm.f32(2.6) or velocity_y >= -1.0 and velocity_y <= 0.0 then
				velocity_y = 0.0
				gauge_level = 1
			else
				if shot_power == 0.0 then
					velocity_x = vm.f32(velocity_x * vm.f32(0.9))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.58))
					velocity_z = vm.f32(velocity_z * vm.f32(0.9))
					velocity_x = vm.f32(velocity_x + vm.f32(spin_drift_x * 2.0))
					velocity_z = vm.f32(velocity_z + vm.f32(spin_drift_z * 2.0))
					spin_drift_x = vm.f32(spin_drift_x * vm.f32(0.2))
					spin_drift_z = vm.f32(spin_drift_z * vm.f32(0.2))
				else
					print("MIZU______2--------------------------------------------------------------------\n")
					velocity_x = vm.f32(velocity_x * vm.f32(0.8))
					velocity_y = -vm.f32(velocity_y * vm.f32(0.4))
					velocity_z = vm.f32(velocity_z * vm.f32(0.8))
					spin_drift_x = 0.0
					spin_drift_z = 0.0
				end
				if speed > 8.0 then
					minigame.toggle_sphida_ball_color()
				end
				if shot_power ~= 1.0 and sound_cooldown <= 0 then
					event.play_sound_effect(sound_bank, 5)
					sound_cooldown = 10
				end
			end
			length = event.get_vector_length(spin_drift_x, 0.0, spin_drift_z) or length
			if velocity_y == 0.0 and speed < vm.f32(1.6) and length < vm.f32(0.4) then
				if surface_type == 6 then
					miss_state = 1
					break
				end
				surface_type = event.get_automap_attribute_status(ball_x, ball_y, ball_z) or surface_type
				if not (surface_type == 1) then
					break
				end
				miss_state = 1
				break
			end
		end
		if ball_y < -500.0 then
			miss_state = 1
			break
		elseif index >= 480 then
			miss_state = 1
			break
		else
			pin_color = event.get_sphida_pin_color() or pin_color
			ball_color = event.get_sphida_ball_color() or ball_color
			pin_offset_x = vm.f32(pin_x - ball_x)
			pin_offset_y = vm.f32(pin_y - ball_y)
			pin_offset_z = vm.f32(pin_z - ball_z)
			pin_distance = event.get_vector_length(pin_offset_x, pin_offset_y, pin_offset_z) or pin_distance
			if ball_color ~= pin_color then
				pin_path_distance = event.get_point_to_segment_distance(previous_x, previous_y, previous_z, ball_x, ball_y, ball_z, pin_x, pin_y, pin_z) or pin_path_distance
				if pin_path_distance >= 0.0 and pin_path_distance <= 30.0 then
					holed_out = 1
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
					holed_out = 1
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
				if miss_state >= 30 then
					if miss_state >= 50 then
						break
					end
				else
					event.set_camera_look_at(ball_x, ball_y, ball_z)
				end
				miss_state = miss_state + 1
			elseif index >= 20 then
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
				camera_angle = event.get_direction_angle(
					vm.f32(ball_x + velocity_x) + velocity_x,
					vm.f32(ball_y + velocity_y) + velocity_y,
					vm.f32(ball_z + velocity_z) + velocity_z,
					camera_x,
					camera_y,
					camera_z
				) or camera_angle
				event.set_camera_control_rotation(camera_angle)
				event.move_camera_control_with_pad(8)
				event.step_camera_control()
			end
			event.set_sphida_ball_position(ball_x, ball_y, ball_z)
			vm.wait(15)
			if sound_cooldown > 0 then
				sound_cooldown = sound_cooldown - 1
			end
			index = index + 1
		end
	end
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_sphida_status_panel_visible(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	if miss_state == 0 then
		event.set_sphida_ball_position(ball_x, ball_y, ball_z)
		par_count = event.get_sphida_par() or par_count
		if holed_out == 1 then
			event.set_character_active(0, 0)
			event.set_character_active(0, 8)
			event.set_character_active(0, 9)
			event.set_character_active(1, 12)
			event.set_character_position(12, pin_x, pin_y, pin_z)
			event.set_character_motion(12, "発動", 6)
			event.play_sound_effect(sound_bank, 17)
			index = 0
			while index < 2 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				index = index + 1
				vm.wait(16)
			end
			event.set_character_active(0, 10)
			do
				local out1, out2, out3 = event.get_sphida_pin_position()
				pin_x = out1 or pin_x
				pin_y = out2 or pin_y
				pin_z = out3 or pin_z
			end
			index = 0
			while index < 100 do
				event.set_camera_control_enabled(0)
				event.set_follow_camera_following(1)
				event.set_follow_camera_target_alternate(pin_x, pin_y, pin_z)
				event.set_camera_speed(12.0)
				event.set_follow_camera_offset(0.0, 0.0, 0.0)
				event.set_follow_camera_height(0.0)
				event.set_follow_camera_distance(100.0)
				event.step_follow_camera(1)
				index = index + 1
				vm.wait(17)
			end
			event.set_character_active(0, 11)
			pin_color = event.get_dungeon_stage_id() or pin_color
			ball_color = event.get_dungeon_floor() or ball_color
			collision_id = event.get_dungeon_floor_info(pin_color, ball_color, 4) or collision_id
			do
				local out1, out2 = event.get_sphida_prize(collision_id)
				sound_cooldown = out1 or sound_cooldown
				surface_type = out2 or surface_type
			end
			collision_id = vm.i32(collision_id + 1)
			event.set_dungeon_floor_info(pin_color, ball_color, 4, collision_id)
			if is_bonus_course == 0 then
				event.place_treasure_box(pin_x, pin_y - 30.0, pin_z, launch_angle, sound_cooldown)
			end
			wait.frames(54)
			wait.frames(30)
			event.delete_character(8)
			event.delete_character(9)
			event.delete_character(10)
			event.delete_character(11)
			event.set_sphida_playing(0)
			sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_000.sound.json") or sound_bank
			event.stop_music(0)
			event.play_sound_effect(sound_bank, 0)
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
			if is_bonus_course == 1 then
				par_count = vm.i32(par_count + 2)
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
				event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(par_count, 10) * 28), 96, 28, 32)
				event.set_event_sprite_position(3, 228, 224)
				event.set_event_sprite_size(3, 28, 32)
				event.set_event_sprite_color(3, 128, 128, 128, 128)
				event.set_event_sprite_draw_pass(3, 1)
				if vm.idiv(par_count, 10) > 0 then
					event.reset_event_sprite(4)
					event.set_event_sprite_type(4, 0)
					event.set_event_sprite_texture(4, "omake_sfida", texture_bank)
					event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(par_count, 10) * 28), 96, 28, 32)
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
				is_bonus_course = event.get_sphida_saved_hole() or is_bonus_course
				if is_bonus_course == 8 then
					event.set_sphida_hole_score(-1, par_count)
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
		elseif par_count >= 2 then
			event.set_message_window_mode(0, 5)
			event.set_message_selection_top_line(0, 0)
			answer = message.ask_choice(0, 2002, 8, 256, 208, 2, 0)
			vm.wait(27)
			if answer == 0 then
				do
					local out1, out2, out3, out4 = event.get_nearest_map_parts_function_point_position(ball_x, ball_y, ball_z, 100.0, "point")
					collision_id = out1 or collision_id
					rest_x = out2 or rest_x
					rest_y = out3 or rest_y
					rest_z = out4 or rest_z
				end
				if collision_id == 0 then
					do
						local out1, out2, out3 = event.get_nearest_map_parts_position(ball_x, ball_y, ball_z, 100.0)
						rest_x = out1 or rest_x
						rest_y = out2 or rest_y
						rest_z = out3 or rest_z
					end
				end
				do
					local out1, out2, out3 = event.get_sphida_pin_position()
					pin_x = out1 or pin_x
					pin_y = out2 or pin_y
					pin_z = out3 or pin_z
				end
				speed = event.get_distance_between(rest_x, rest_y, rest_z, pin_x, pin_y, pin_z) or speed
				if speed < 40.0 then
					launch_angle = event.get_random_number(6.2831855) or launch_angle
					launch_angle = vm.f32(launch_angle - vm.f32(3.1415927))
					rest_x = vm.f32(rest_x + vm.f32(vm.sin(launch_angle) * 50.0))
					rest_z = vm.f32(rest_z + vm.f32(vm.cos(launch_angle) * 50.0))
				else
					do
						local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(rest_x, rest_y, rest_z)
						hit_x = out1 or hit_x
						hit_y = out2 or hit_y
						hit_z = out3 or hit_z
						collision_id = out4 or collision_id
					end
					index = 0
					while collision_id >= 0 do
						do
							local out1, out2, out3 = event.copy_vector(rest_x, rest_y, rest_z)
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
							rest_x = out1 or rest_x
							rest_y = out2 or rest_y
							rest_z = out3 or rest_z
						end
						do
							local out1, out2, out3 = event.add_vectors(rest_x, rest_y, rest_z, previous_x, previous_y, previous_z)
							rest_x = out1 or rest_x
							rest_y = out2 or rest_y
							rest_z = out3 or rest_z
						end
						do
							local out1, out2, out3, out4 = event.get_nearest_treasure_box_position(rest_x, rest_y, rest_z)
							hit_x = out1 or hit_x
							hit_y = out2 or hit_y
							hit_z = out3 or hit_z
							collision_id = out4 or collision_id
						end
						index = index + 1
						if index > 6 then
							break
						end
					end
				end
				aim_angle = event.get_direction_angle(rest_x, rest_y, rest_z, ball_x, ball_y, ball_z) or aim_angle
				event.set_character_position(0, rest_x, rest_y, rest_z)
				event.set_character_rotation(0, 0.0, aim_angle, 0.0)
				event.set_camera_look_at(rest_x, rest_y + 30.0, rest_z)
				aim_angle = vm.f32(aim_angle - vm.f32(3.1415927))
				aim_angle = event.wrap_angle(aim_angle) or aim_angle
				rest_x = vm.f32(vm.f32(vm.sin(aim_angle) * 100.0) + rest_x)
				rest_y = vm.f32(rest_y + 30.0)
				rest_z = vm.f32(vm.f32(vm.cos(aim_angle) * 100.0) + rest_z)
				event.set_camera_position(rest_x, rest_y, rest_z)
				event.reset_follow_camera(0)
			end
		end
	else
		event.play_sound_effect(sound_bank, 18)
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
		event.set_sphida_ball_position(rest_x, rest_y, rest_z)
		event.set_character_position(8, rest_x, rest_y, rest_z)
		event.set_character_position(9, rest_x, rest_y, rest_z)
		event.release_camera_sequence_follow_object()
	end
	if holed_out == 1 then
		minigame.consume_sphida_shot(-1)
	else
		minigame.consume_sphida_shot(sound_bank)
	end
	sphida_course.finish_hole(holed_out)
end

--- Asks whether to move the ball to the player and moves it there, using up a shot, when the player agrees.
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

--- Warns that this is the last time the ball can be moved to the player and moves it there when the player agrees.
function script.sphida_near_ball_last()
	local answer: any = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Questa [UNI00e8] l'ultima volta che potrai\navvicinare la Sphera.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	event.open_message_window_2(0, "Avvicinare la Sphera?")
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

--- Asks whether to give up the current bonus course hole, then shows the score and returns to the menu on the last hole or skips to the next hole.
function script.sphida_omake_away()
	local answer: any = 0
	local current_hole: s32 = 0
	event.initialize_event()
	character.reset_action_motion()
	event.set_message_window_mode(0, 5)
	event.set_message_selection_top_line(0, 0)
	current_hole = event.get_sphida_saved_hole() or current_hole
	if current_hole == 8 then
		event.open_message_window_2(0, "Questa [UNI00e8] l'ultima buca. Ci rinunci?")
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
		event.open_message_window_2(0, "Abbandonare buca e passare ad altro percorso?")
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

--- Loads the course map, prepares the Sphida state and opens the course menu.
function script.start_sphida_course()
	event.initialize_event()
	minigame.clear_sphida_state()
	event.fade_out_screen(0)
	vm.wait(1)
	vm.wait(2)
	event.skip_next_music_load()
	event.set_dungeon_floor(0)
	event.load_dungeon_map("d03f01", "mstage2", 64)
	event.add_inventory_item(305, 1)
	event.add_inventory_item(306, 1)
	minigame.set_up_sphida_course_with_draw_distance(2, 2)
	event.set_sphida_saved_hole(2)
	event.set_character_position(0, 1600.0, 2.0, 2880.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(1600.0, 30.0, 2880.0)
	event.set_camera_position(1600.0, 40.0, 2980.0)
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_event_menu(28)
	vm.wait(4)
	event.reset_follow_camera(0)
	event.finish_event()
end
script[6000] = script.start_sphida_course

return script
