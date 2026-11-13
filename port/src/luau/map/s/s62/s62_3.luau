--!strict
--- Dungeon floor script for a Zelmite Mine checkpoint room, covering the floor music, treasure chests, random circles, the geostone and the tutorial messages.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sphida_hint = require("@lib/event/german/sphida_hint")
local treasure_chest = require("@lib/event/german/treasure_chest")
local wait = require("@lib/event/wait")
local zelmite_mine_s62 = require("@lib/event/zelmite_mine_s62")

--- Stops the music, loads the floor sounds, then plays the floor theme while any special chest is unopened and the cleared-floor theme once all are opened.
local function play_floor_music()
	local chest_flags: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8694)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 4) == 0 or bit32.band(chest_flags, 8) == 0 then
		event.stop_music(0)
		wait.frames(4)
		event.load_music(190)
		event.play_music(0)
	else
		event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
		wait.background_load()
		event.load_music_pack(193)
		event.play_music(0)
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.play_floor_music = play_floor_music
script[99] = script.play_floor_music

--- Plays the floor music, spawns the monsters and the first-visit monster scene while special chests remain unopened, then places the player and fades in.
function script.default_event()
	local save_counter: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		resume_point = 1
		play_floor_music()
		event.initialize_event()
		resume_point = 2
		vm.wait(2)
		save_counter = event.get_save_counter(17) or save_counter
		if bit32.band(save_counter, 4) == 0 or bit32.band(save_counter, 8) == 0 then
			zelmite_mine_s62.spawn_dungeon_monsters()
			save_counter = event.get_save_counter(20) or save_counter
			if bit32.band(save_counter, 2) == 0 then
				resume_point = 3
				zelmite_mine_s62.play_monster_idle_intro_scene()
				save_counter = event.get_save_counter(20) or save_counter
				save_counter = vm.i32(bit32.bor(save_counter, 2))
				event.set_save_counter(20, save_counter)
			end
		end
		character.place_standing(320.0, 0.0, -700.0, 0.0)
		event.set_camera_look_at(320.0, 30.0, -700.0)
		event.set_camera_position(320.0, 40.0, -820.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 2 then
				cutscene.noop()
				resume_point = 3
				zelmite_mine_s62.play_monster_idle_intro_scene()
				return vm.continue_with(function()
					save_counter = event.get_save_counter(20) or save_counter
					save_counter = vm.i32(bit32.bor(save_counter, 2))
					event.set_save_counter(20, save_counter)
					character.place_standing(320.0, 0.0, -700.0, 0.0)
					event.set_camera_look_at(320.0, 30.0, -700.0)
					event.set_camera_position(320.0, 40.0, -820.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			local _ = if bit32.band(save_counter, 4) == 0 then 1 else 0
			local _ = if bit32.band(save_counter, 8) == 0 then 1 else 0
			local _ = if bit32.band(save_counter, 2) == 0 then 1 else 0
			save_counter = vm.i32(bit32.bor(save_counter, 2))
			cutscene.ignore_coordinates(320.0, 0.0, -700.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Waits a frame and then until the player presses the button.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
end

--- Plays the scene of the monsters idling in the room and then waits until the player presses the button.
function script.cutscene_monster_idle_intro()
	zelmite_mine_s62.play_monster_idle_intro_scene()
	vm.wait(2)
	wait.until_button_pressed(64)
end
script[160] = script.cutscene_monster_idle_intro

--- Waits a frame and then until the player presses the button.
function script.wait_for_button_press()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[170] = script.wait_for_button_press

--- Gives the player the starting items and sets the story flags for entering the floor.
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

--- Asks whether to leave the floor and loads the dungeon map when the player agrees, while the other playable characters only get a message.
function script.ask_to_leave_floor()
	local playable_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 2 or playable_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if playable_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(30)
		wait.frames(30)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_to_leave_floor

--- Opens the nearest treasure chest and records in the save counter which of the floor's special chests was taken.
function script.treasure_box()
	local item_id: s32 = 0
	local first_chest_flags: s32 = 0
	local second_chest_flags: s32 = 0
	item_id = treasure_chest.open_nearest()
	if item_id == 206 then
		first_chest_flags = event.get_save_counter(17) or first_chest_flags
		first_chest_flags = vm.i32(bit32.bor(first_chest_flags, 4))
		event.set_save_counter(17, first_chest_flags)
	end
	if item_id == 199 then
		second_chest_flags = event.get_save_counter(17) or second_chest_flags
		second_chest_flags = vm.i32(bit32.bor(second_chest_flags, 8))
		event.set_save_counter(17, second_chest_flags)
	end
end

--- Plays the random circle sequence, spinning a coin over the circle until the player stops it and then applying the good or bad effect it lands on.
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
	local party_npc_id: s32 = 0
	local circle_side: s32 = 0
	local frame_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local facing_angle: f32 = 0
	local min_spin_frames: s32 = 0
	local candidate_angle: f32 = 0
	local random_roll: s32 = 0
	local chance_threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_amount: f32 = 0
	local restored_x: f32 = 0
	local restored_y: f32 = 0
	local restored_z: f32 = 0
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
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		if frame_count == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if frame_count == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_count > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
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
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	min_spin_frames = 0
	min_spin_frames = event.get_random_number_int(10) or min_spin_frames
	min_spin_frames = vm.i32(min_spin_frames + 4)
	frame_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		vm.wait(9)
		if frame_count >= min_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			candidate_angle = facing_angle
			candidate_angle = event.wrap_angle(candidate_angle) or candidate_angle
			if coin_yaw < candidate_angle and calc.is_angle_within(coin_yaw, candidate_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, candidate_angle, 0.0)
				circle_side = 0
				break
			end
			candidate_angle = vm.f32(facing_angle - vm.f32(3.1415927))
			candidate_angle = event.wrap_angle(candidate_angle) or candidate_angle
			if coin_yaw < candidate_angle and calc.is_angle_within(coin_yaw, candidate_angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, candidate_angle, 0.0)
				circle_side = 1
				break
			end
		end
		frame_count = vm.i32(frame_count + 1)
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, facing_angle, 1.0) == 0 then
		circle_side = 0
	else
		circle_side = 1
	end
	facing_angle = coin_yaw
	wait.frames(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if party_npc_id == 24 then
		chance_threshold = 100
	else
		chance_threshold = 6
	end
	if random_roll < chance_threshold then
		random_roll = event.get_random_number_int(10) or random_roll
		if circle_side == 0 then
			if party_npc_id == 24 then
				chance_threshold = 0
			else
				chance_threshold = 2
			end
		elseif party_npc_id == 24 then
			chance_threshold = 100
		else
			chance_threshold = 4
		end
		if random_roll < chance_threshold then
			facing_angle = vm.f32(facing_angle + vm.f32(3.14))
			facing_angle = event.wrap_angle(facing_angle) or facing_angle
			event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 8)
			if circle_side == 0 then
				circle_side = 1
			else
				circle_side = 0
			end
			wait.frames(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				facing_angle = vm.f32(facing_angle + vm.f32(3.14))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 6)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, facing_angle, 1.0) == 0 then
		circle_side = 0
	else
		circle_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	frame_count = 0
	effect_id = event.get_random_circle_effect(circle_side) or effect_id
	if circle_side == 0 then
		event.play_sound_effect(sound_bank, 1)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			frame_count = frame_count + 1
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
			event.place_treasure_box(ring_x, ring_y, ring_z, facing_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while frame_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			frame_count = frame_count + 1
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
		restored_x = out1 or restored_x
		restored_y = out2 or restored_y
		restored_z = out3 or restored_z
	end
	event.set_camera_position(restored_x, restored_y, restored_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		restored_x = out1 or restored_x
		restored_y = out2 or restored_y
		restored_z = out3 or restored_z
	end
	event.set_camera_look_at(restored_x, restored_y, restored_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the geostone sequence, where the character reaches for the geostone, reads its message and updates the floor information.
function script.geostone()
	local playable_character: s32 = 0
	local saved_x: f32 = 0
	local saved_y: f32 = 0
	local saved_z: f32 = 0
	local sound_bank: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
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
		saved_x = out1 or saved_x
		saved_y = out2 or saved_y
		saved_z = out3 or saved_z
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
		character_x = out1 or character_x
		character_y = out2 or character_y
		character_z = out3 or character_z
	end
	event.copy_vector(character_x, character_y, character_z)
	event.stop_geostone_animation()
	event.attach_object_handle_to_geostone(1)
	do
		local out1, out2, out3 = event.get_object_handle_position(1)
		geostone_x = out1 or geostone_x
		geostone_y = out2 or geostone_y
		geostone_z = out3 or geostone_z
	end
	geostone_y = vm.f32(character_y + 18.0)
	event.set_object_handle_position(1, geostone_x, geostone_y, geostone_z)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	facing_angle = event.get_direction_angle(geostone_x, geostone_y, geostone_z, camera_x, camera_y, camera_z) or facing_angle
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	if playable_character == 0 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.9))
	end
	if playable_character == 1 then
		facing_angle = vm.f32(facing_angle + vm.f32(2.4))
	end
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	character_x = vm.f32(vm.f32(vm.sin(facing_angle) * 14.0) + geostone_x)
	character_z = vm.f32(vm.f32(vm.cos(facing_angle) * 14.0) + geostone_z)
	event.set_character_position(0, character_x, character_y, character_z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	event.set_character_rotation(0, 0.0, facing_angle, 0.0)
	event.reset_object_handle_dynamic_animation(0)
	event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 12)
	event.set_character_active(0, 12)
	if playable_character == 0 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 6.0, 0.0)
		event.set_follow_camera_height(-14.0)
		event.set_follow_camera_distance(54.0)
		event.set_character_position(12, character_x, character_y + 36.0, character_z)
	end
	if playable_character == 1 then
		event.set_camera_control_enabled(0)
		event.set_follow_camera_following(1)
		event.set_follow_camera_target_alternate(character_x, character_y + 18.0, character_z)
		event.set_camera_speed(16.0)
		event.set_follow_camera_offset(0.0, 0.0, 0.0)
		event.set_follow_camera_height(-5.0)
		event.set_follow_camera_distance(34.0)
		effect_x = vm.f32(vm.f32(vm.sin(facing_angle) * 8.0) + character_x)
		effect_y = vm.f32(character_y + 18.0)
		effect_z = vm.f32(vm.f32(vm.cos(facing_angle) * 8.0) + character_z)
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
	facing_angle = event.get_direction_angle(character_x, character_y, character_z, camera_x, camera_y, camera_z) or facing_angle
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
	system_sound_id = event.get_system_sound_id() or system_sound_id
	event.play_sound_effect(system_sound_id, 18)
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
	event.set_character_position(0, saved_x, saved_y, saved_z)
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

--- Runs the defeat sequence with its message when the player is defeated on this floor.
function script.run_defeat_sequence()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.run_defeat_sequence

--- Places the treasure chests that are still unopened, plays the cleared-floor music and records the floor as cleared.
function script.floor_clear()
	local chest_flags: s32 = 0
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0, 4)
	event.fade_out_music(60)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 4) == 0 then
		event.place_treasure_box(50.0, 0.0, 600.0, 3.14, 206)
	end
	if bit32.band(chest_flags, 8) == 0 then
		event.place_treasure_box(-50.0, 0.0, 600.0, 3.14, 199)
	end
	if bit32.band(chest_flags, 4) == 0 or bit32.band(chest_flags, 8) == 0 then
		event.start_crossfade(30)
		event.set_camera_position(-6.54, 68.0, 251.52)
		event.set_camera_look_at(-1.83, 30.0, 381.43)
		event.set_character_position(0, 6.1, 19.66, 328.52)
		event.set_character_rotation(0, 0.0, 0.01, 0.0)
		wait.frames(30)
		event.reset_follow_camera(0)
	end
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	wait.background_load()
	event.load_music_pack(193)
	event.play_music(0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor_number = event.get_dungeon_floor() or floor_number
	event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
	event.finish_event()
end

--- Shows the tutorial message explaining random stones the first time one is examined.
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

--- Shows a tip message and waits for the player to answer it.
function script.show_dungeon_tip()
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
script[2510] = script.show_dungeon_tip

--- Shows the level-up tutorial messages and points the player to the help menu.
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
	event.open_message_window_2(0, 'Mehr erf[UNI00e4]hrst du unter\n"Hilfe" im Hauptmen[UNI00fc].')
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the instructions for driving the ridepod's buggy mode.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]Lenken des Buggys\n   Beschleunige mit (L)↑, bremse mit (L)↓.\n   lenke mit (L) ← oder →.\n   Scharfe Kurven: [l1] + (L) ← oder →."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Shows the tutorial messages explaining how to absorb and release elemental energy with the sword.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]Du kannst die Magie-Raub-\nKlinge jetzt verwenden.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Die Fertigkeit Magie-Raub-Klinge\nerlaubt es dir, die Energie von\nElementarangriffen wie Feuer beim\nAbwehren aufzunehmen.<page>Beim Angriff verwandelt\nsie sich in Magie."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Die Energie eines Elements kannst\ndu immer weiter aufladen.\nNimmst du aber einen anderen Elementar-\nTyp auf, verlierst du die ganze Ladung."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Wie viel Elementarenergie du\nabsorbieren kannst, h[UNI00e4]ngt von der\nHaltbarkeit deiner Waffe ab."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"Um absorbierte Elementarenergie als\nMagie abzugeben, dr[UNI00fc]cke [l1]\n w[UNI00e4]hrend du mit [r1] abwehrst."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

return script
