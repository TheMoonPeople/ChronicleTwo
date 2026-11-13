--!strict
--- Runs the Zelmite Mine floor script: music, monster pack intro, treasure chests, random circles, the geostone and the tutorial guides.

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
local zelmite_mine_s69 = require("@lib/event/zelmite_mine_s69")

--- Starts the floor music, using the boss theme until both treasure chests have been collected.
local function load_floor_music()
	local chest_flags: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8694)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 256) == 0 or bit32.band(chest_flags, 512) == 0 then
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

script.load_floor_music = load_floor_music
script[99] = script.load_floor_music

--- Enters the floor, playing the monster pack intro the first time and spawning the pack until the chests are collected.
function script.default_event()
	local chest_flags: s32 = 0
	local step: number = 0
	return vm.guard(function()
		step = 1
		load_floor_music()
		event.initialize_event()
		step = 2
		vm.wait(2)
		chest_flags = event.get_save_counter(17) or chest_flags
		if bit32.band(chest_flags, 256) == 0 or bit32.band(chest_flags, 512) == 0 then
			chest_flags = event.get_save_counter(20) or chest_flags
			if bit32.band(chest_flags, 8) == 0 then
				step = 3
				zelmite_mine_s69.play_monster_pack_intro()
				chest_flags = event.get_save_counter(20) or chest_flags
				chest_flags = vm.i32(bit32.bor(chest_flags, 8))
				event.set_save_counter(20, chest_flags)
			end
			zelmite_mine_s69.spawn_monster_pack()
		end
		character.place_standing(vm.f32(5.2), 0.0, -790.0, 0.0)
		event.set_camera_look_at(5.2, 30.0, -790.0)
		event.set_camera_position(5.2, 40.0, -910.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if step <= 3 then
			if step <= 2 then
				step = 3
				zelmite_mine_s69.play_monster_pack_intro()
				return vm.continue_with(function()
					chest_flags = event.get_save_counter(20) or chest_flags
					chest_flags = vm.i32(bit32.bor(chest_flags, 8))
					event.set_save_counter(20, chest_flags)
					zelmite_mine_s69.spawn_monster_pack()
					character.place_standing(vm.f32(5.2), 0.0, -790.0, 0.0)
					event.set_camera_look_at(5.2, 30.0, -790.0)
					event.set_camera_position(5.2, 40.0, -910.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			local _ = if bit32.band(chest_flags, 256) == 0 then 1 else 0
			local _ = if bit32.band(chest_flags, 512) == 0 then 1 else 0
			local _ = if bit32.band(chest_flags, 8) == 0 then 1 else 0
			chest_flags = vm.i32(bit32.bor(chest_flags, 8))
			cutscene.noop()
			cutscene.ignore_coordinates(vm.f32(5.2), 0.0, -790.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Waits for the confirm button after a short delay.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(64)
end

--- Plays the monster pack intro and waits for the confirm button.
function script.replay_monster_pack_intro()
	zelmite_mine_s69.play_monster_pack_intro()
	vm.wait(2)
	wait.until_button_pressed(64)
end
script[160] = script.replay_monster_pack_intro

--- Grants the starting items and sets the story flags when the dungeon begins.
function script.grant_dungeon_entry_items()
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
script[200] = script.grant_dungeon_entry_items

--- Asks whether to enter the dungeon and loads the dungeon event script on yes.
function script.ask_to_enter_dungeon()
	local active_character: s32 = 0
	local answer: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_character = event.get_playable_character() or active_character
	if active_character == 2 or active_character == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_character == 2 then
			message.show_and_wait(0, 20, 5, 256, 208)
		else
			message.show_and_wait(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.clear_event_battle_monsters(-1)
		event.set_dungeon_pause_flags(16384, 0)
		event.fade_out_screen(30)
		wait.frames(30)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_to_enter_dungeon

--- Records in the save counter which of the two chests was opened.
function script.treasure_box()
	local chest_item_id: s32 = 0
	local chest_flags: s32 = 0
	chest_item_id = treasure_chest.open_nearest()
	chest_flags = event.get_save_counter(17) or chest_flags
	if chest_item_id == 189 then
		if bit32.band(chest_flags, 256) == 0 then
			chest_flags = event.get_save_counter(17) or chest_flags
			chest_flags = vm.i32(bit32.bor(chest_flags, 256))
			event.set_save_counter(17, chest_flags)
			return
		end
	end
	if chest_item_id == 189 then
		chest_flags = event.get_save_counter(17) or chest_flags
		chest_flags = vm.i32(bit32.bor(chest_flags, 512))
		event.set_save_counter(17, chest_flags)
	end
end

--- Spins a random circle coin and applies a good or bad effect, with a different warning message for the other party members.
function script.random_circle()
	local active_character: s32 = 0
	local character_x: f32 = 0
	local character_y: f32 = 0
	local character_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local yaw: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_yaw: f32 = 0
	local now_party_chara_id: s32 = 0
	local circle_id: s32 = 0
	local frame_counter: s32 = 0
	local spin_speed: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local pos_x_4: f32 = 0
	local pos_y_4: f32 = 0
	local pos_z_4: f32 = 0
	local view_angle: f32 = 0
	local min_spin_frames: s32 = 0
	local angle: f32 = 0
	local random_roll: s32 = 0
	local roll_threshold: s32 = 0
	local bright_rate: f32 = 0
	local effect_id: s32 = 0
	local result: f32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
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
			character_x = out1 or character_x
			character_y = out2 or character_y
			character_z = out3 or character_z
		end
		do
			local out1, out2, out3 = event.get_random_circle_position(-1)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		yaw = event.get_direction_angle(pos_x, pos_y, pos_z, character_x, character_y, character_z) or yaw
		character_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + pos_x)
		character_y = pos_y
		character_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + pos_z)
		event.set_character_position(0, character_x, character_y, character_z)
		event.set_dungeon_pause_flags(513, 0)
		event.finish_event()
		return
	end
	event.start_background_file_loads_1("snd2/sp/sp_011.sound.json")
	vm.wait(3)
	character.reset_action_motion()
	do
		local out1, out2, out3 = event.get_random_circle_position(-1)
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_control_enabled(0)
	event.set_follow_camera_following(1)
	event.set_follow_camera_target_alternate(pos_x_2, pos_y_2 + 30.0, pos_z_2)
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
	motion_frame = event.get_random_circle_motion_frame() or motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, motion_frame)
	event.attach_object_handle_to_character(4, 12)
	event.clear_object_sequence(4)
	event.set_object_sequence_object(4, 4)
	event.queue_object_sequence_next_motion(4, "消滅", 6)
	event.load_character(5, "randomcoin.gltf", "info", 13)
	event.set_character_active(1, 13)
	event.set_character_position(13, pos_x_2, pos_y_2 - 30.0, pos_z_2)
	coin_yaw = event.get_random_number(6.2831855) or coin_yaw
	coin_yaw = vm.f32(coin_yaw - vm.f32(3.1415927))
	coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
	event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
	event.change_directory("")
	now_party_chara_id = event.get_party_npc() or now_party_chara_id
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	event.set_object_sequence_scale(5, 0.0, 0.0, 0.0)
	event.set_object_sequence_scale(5, 1.0, 1.0, 1.0, 40)
	event.move_object_sequence_eased(5, pos_x_2, pos_y_2 + 40.0, pos_z_2, 30, 2, 0.5)
	frame_counter = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		if frame_counter == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if frame_counter == 30 then
			sphida_hint.show_stop_hint()
		end
		if (if frame_counter >= 30 then wait.get_button_state(0) else 0) ~= 0 or frame_counter > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(7)
			break
		else
			frame_counter = frame_counter + 1
			vm.wait(8)
		end
	end
	message.close_second_window()
	event.attach_object_handle_to_character(5, 13)
	event.clear_object_sequence(5)
	event.set_object_sequence_object(5, 5)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x_3 = out1 or pos_x_3
		pos_y_3 = out2 or pos_y_3
		pos_z_3 = out3 or pos_z_3
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_4 = out1 or pos_x_4
		pos_y_4 = out2 or pos_y_4
		pos_z_4 = out3 or pos_z_4
	end
	view_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or view_angle
	min_spin_frames = 0
	min_spin_frames = event.get_random_number_int(10) or min_spin_frames
	min_spin_frames = vm.i32(min_spin_frames + 4)
	frame_counter = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_yaw = out2 or coin_yaw
		end
		coin_yaw = vm.f32(coin_yaw + spin_speed)
		coin_yaw = event.wrap_angle(coin_yaw) or coin_yaw
		event.set_character_rotation(13, 0.0, coin_yaw, 0.0)
		vm.wait(9)
		if frame_counter >= min_spin_frames then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = view_angle
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 0
				break
			end
			angle = vm.f32(view_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_yaw < angle and calc.is_angle_within(coin_yaw, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				circle_id = 1
				break
			end
		end
		frame_counter = vm.i32(frame_counter + 1)
	end
	view_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or view_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, view_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	view_angle = coin_yaw
	wait.frames(20)
	random_roll = event.get_random_number_int(10) or random_roll
	if now_party_chara_id == 24 then
		roll_threshold = 100
	else
		roll_threshold = 6
	end
	if random_roll < roll_threshold then
		random_roll = event.get_random_number_int(10) or random_roll
		if circle_id == 0 then
			if now_party_chara_id == 24 then
				roll_threshold = 0
			else
				roll_threshold = 2
			end
		elseif now_party_chara_id == 24 then
			roll_threshold = 100
		else
			roll_threshold = 4
		end
		if random_roll < roll_threshold then
			view_angle = vm.f32(view_angle + vm.f32(3.14))
			view_angle = event.wrap_angle(view_angle) or view_angle
			event.rotate_object_sequence(5, 0.0, view_angle, 0.0, 8)
			if circle_id == 0 then
				circle_id = 1
			else
				circle_id = 0
			end
			wait.frames(10)
		else
			random_roll = event.get_random_number_int(10) or random_roll
			if random_roll < 1 then
				view_angle = vm.f32(view_angle + vm.f32(3.14))
				view_angle = event.wrap_angle(view_angle) or view_angle
				event.rotate_object_sequence(5, 0.0, view_angle, 0.0, 6)
				view_angle = vm.f32(view_angle + vm.f32(1.57))
				view_angle = event.wrap_angle(view_angle) or view_angle
				event.rotate_object_sequence(5, 0.0, view_angle, 0.0, 3)
				view_angle = vm.f32(view_angle + vm.f32(1.57))
				view_angle = event.wrap_angle(view_angle) or view_angle
				event.rotate_object_sequence(5, 0.0, view_angle, 0.0, 3)
				wait.frames(20)
			end
		end
	end
	view_angle = event.get_direction_angle(pos_x_4, pos_y_4, pos_z_4, pos_x_3, pos_y_3, pos_z_3) or view_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_yaw = out2 or coin_yaw
	end
	if calc.is_angle_within(coin_yaw, view_angle, 1.0) == 0 then
		circle_id = 0
	else
		circle_id = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	bright_rate = 1.0
	frame_counter = 0
	effect_id = event.get_random_circle_effect(circle_id) or effect_id
	if circle_id == 0 then
		event.play_sound_effect(sound_bank, 1)
		while frame_counter < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate + vm.f32(0.03))
			frame_counter = frame_counter + 1
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
			event.place_treasure_box(pos_x_2, pos_y_2, pos_z_2, view_angle, 294)
			message.show_and_wait(0, 2314, 8, 0, 0)
		end
	else
		event.play_sound_effect(sound_bank, 2)
		while frame_counter < 30 do
			event.set_dungeon_brightness_rate(bright_rate)
			bright_rate = vm.f32(bright_rate - vm.f32(0.03))
			frame_counter = frame_counter + 1
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
		event.spawn_pull_items(pos_x_2, pos_y_2, pos_z_2, 1, 10, result / 10.0)
	end
	event.set_dungeon_pause_flags(513, 0)
	event.set_camera_control_enabled(1)
	do
		local out1, out2, out3 = event.get_previous_camera_next_position()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_position(position_x, position_y, position_z)
	do
		local out1, out2, out3 = event.get_previous_camera_next_look_at()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	event.set_camera_look_at(position_x, position_y, position_z)
	event.delete_character(12)
	event.delete_character(13)
	event.start_crossfade(15)
	event.finish_event()
end

--- Plays the geostone use animation, shows its message and records the floor info.
function script.geostone()
	local active_character: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local sound_bank: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local stand_x: f32 = 0
	local stand_y: f32 = 0
	local stand_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local angle: f32 = 0
	local pos_x_3: f32 = 0
	local pos_y_3: f32 = 0
	local pos_z_3: f32 = 0
	local system_sound_bank: s32 = 0
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
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
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
	sound_bank = event.load_sound_effect_file_3(8, "snd2/sp/sp_012.sound.json") or sound_bank
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
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
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	pos_y_2 = vm.f32(stand_y + 18.0)
	event.set_object_handle_position(1, pos_x_2, pos_y_2, pos_z_2)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	angle = event.get_direction_angle(pos_x_2, pos_y_2, pos_z_2, pos_x, pos_y, pos_z) or angle
	angle = event.wrap_angle(angle) or angle
	if active_character == 0 then
		angle = vm.f32(angle + vm.f32(2.9))
	end
	if active_character == 1 then
		angle = vm.f32(angle + vm.f32(2.4))
	end
	angle = event.wrap_angle(angle) or angle
	stand_x = vm.f32(vm.f32(vm.sin(angle) * 14.0) + pos_x_2)
	stand_z = vm.f32(vm.f32(vm.cos(angle) * 14.0) + pos_z_2)
	event.set_character_position(0, stand_x, stand_y, stand_z)
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = event.wrap_angle(angle) or angle
	event.set_character_rotation(0, 0.0, angle, 0.0)
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
		pos_x_3 = vm.f32(vm.f32(vm.sin(angle) * 8.0) + stand_x)
		pos_y_3 = vm.f32(stand_y + 18.0)
		pos_z_3 = vm.f32(vm.f32(vm.cos(angle) * 8.0) + stand_z)
		event.set_character_position(12, pos_x_3, pos_y_3, pos_z_3)
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
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	angle = event.get_direction_angle(stand_x, stand_y, stand_z, pos_x, pos_y, pos_z) or angle
	event.set_character_rotation(12, 0.0, angle, 0.0)
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
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
	event.start_crossfade(10)
	if active_character == 1 then
		event.set_character_motion(0, "取る戻り", 6)
		vm.wait(13)
	end
	event.set_dungeon_pause_flags(529, 0)
	event.set_character_motion(0, "立ち", 4)
	event.set_character_position(0, start_x, start_y, start_z)
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

--- Runs the defeat sequence for the party without a message.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_party_defeated

--- Places the remaining treasure chests, restarts the floor music and records the cleared floor.
function script.floor_clear()
	local chest_flags: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0, 4)
	event.fade_out_music(60)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 256) == 0 then
		event.place_treasure_box(50.0, 0.0, 600.0, 3.14, 189)
	end
	if bit32.band(chest_flags, 512) == 0 then
		event.place_treasure_box(-50.0, 0.0, 600.0, 3.14, 189)
	end
	if bit32.band(chest_flags, 256) == 0 or bit32.band(chest_flags, 512) == 0 then
		event.start_crossfade(30)
		event.set_camera_position(-6.4, 43.21, 329.72)
		event.set_camera_look_at(-3.01, 30.0, 440.22)
		event.set_character_position(0, -3.03, 0.0, 439.67)
		event.set_character_rotation(0, 0.0, 0.03, 0.0)
		wait.frames(30)
		event.reset_follow_camera(0)
	end
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	wait.background_load()
	event.load_music_pack(193)
	event.play_music(0)
	stage_id = event.get_dungeon_stage_id() or stage_id
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 2)
	event.finish_event()
end

--- Shows the guide message for random stones the first time one is examined.
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

--- Shows a guide message and waits for it to be dismissed.
function script.show_dungeon_guide_message()
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
script[2510] = script.show_dungeon_guide_message

--- Shows the level-up guide messages the first time the player levels up.
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

--- Shows the buggy driving instructions the first time the wheels are used.
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

--- Shows the Magic-Absorb Blade instructions the first time the magic sword counter fills.
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
