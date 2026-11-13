--!strict
--- Event script for the Palm Brinks circus night map, with the ticket gate guard, bystander dialogue and the opening ticket chase scenes.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local palm_brinks_m06 = require("@lib/event/palm_brinks_m06")
local sound = require("@lib/event/sound")
local wait = require("@lib/event/wait")

--- Turns the player toward the seated character, who remarks on the starry sky.
local function comment_on_starry_sky()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local player_yaw: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local angle_check: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
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
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	event.get_character_rotation(9)
	direction_to_other = event.get_direction_angle(player_x, player_y, player_z, other_x, other_y, other_z) or direction_to_other
	direction_to_player = event.get_direction_angle(other_x, other_y, other_z, player_x, player_y, player_z) or direction_to_player
	angle_check = event.compare_angles(direction_to_player, 1.94, 1.5) or angle_check
	if angle_check ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(14)
	event.set_mouth_motions(1, "会話", 0, "座り", 0)
	event.open_message_window_2(0, "Che magnifico cielo stellato!")
	message.say_bubble(0, -1, 9, 0, 0)
	event.reset_mouth_motions()
end

--- Has the player ask the seated character about the red-haired kid and plays the voiced replies.
local function ask_seated_character_about_boy()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local player_yaw: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local angle_check: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
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
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	event.get_character_rotation(9)
	direction_to_other = event.get_direction_angle(player_x, player_y, player_z, other_x, other_y, other_z) or direction_to_other
	direction_to_player = event.get_direction_angle(other_x, other_y, other_z, player_x, player_y, player_z) or direction_to_player
	angle_check = event.compare_angles(direction_to_player, 1.94, 1.5) or angle_check
	if angle_check ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(14)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "Avete visto passare un ragazzino\ncoi capelli rossi?")
	palm_brinks_m06.play_voiced_message(10350, 100)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "座り", 4)
	event.open_message_window_2(0, "No. Visto niente?")
	palm_brinks_m06.play_voiced_message(10360, 60)
	event.open_message_window_2(0, "[UNI00c8] andato verso il Municipio.")
	palm_brinks_m06.play_voiced_message(10370, 80)
	event.close_voice_stream(1)
end

--- Hides the street lamps and freezes the time of day at midnight.
local function set_midnight_scene()
	event.attach_object_handle_to_map_part_2(31, "街灯-14")
	event.set_object_handle_visible(31, 0)
	event.attach_object_handle_to_map_part_2(31, "街灯-15")
	event.set_object_handle_visible(31, 0)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
end

--- Has the guard demand a ticket and checks the item the player offers, either starting the ticket scene or turning the player away.
local function talk_to_ticket_guard(is_direct_talk: s32)
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_yaw: f32 = 0
	local guard_x: f32 = 0
	local guard_y: f32 = 0
	local guard_z: f32 = 0
	local guard_yaw: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local needs_guard_reset: s32 = 0
	local turn_wait_frames: s32 = 0
	local angle_check: s32 = 0
	local has_greeted: s32 = 0
	local dialogue_stage: s32 = 0
	local answer: s32 = 0
	local item: s32 = 0
	local ticket_used_flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	needs_guard_reset = 0
	has_greeted = 0
	dialogue_stage = event.get_triggered_event_data_2(6) or dialogue_stage
	if dialogue_stage == 1 or is_direct_talk == 1 then
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.attach_object_handle_to_character(1, 8)
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
			player_yaw = out2 or player_yaw
		end
		do
			local out1, out2, out3 = event.get_character_position(8)
			guard_x = out1 or guard_x
			guard_y = out2 or guard_y
			guard_z = out3 or guard_z
		end
		do
			local _, out2, _ = event.get_character_rotation(8)
			guard_yaw = out2 or guard_yaw
		end
		direction_to_other = event.get_direction_angle(player_x, player_y, player_z, guard_x, guard_y, guard_z) or direction_to_other
		direction_to_player = event.get_direction_angle(guard_x, guard_y, guard_z, player_x, player_y, player_z) or direction_to_player
		turn_wait_frames = 0
		angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
		if angle_check ~= 0 then
			event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
			event.set_object_sequence_motion(0, "歩き")
			event.delay_object_sequence_motion_track(0, 10)
			turn_wait_frames = 20
		end
		event.set_object_sequence_motion(0, "立ち")
		angle_check = event.compare_angles(guard_yaw, direction_to_player, 0.1) or angle_check
		if angle_check ~= 0 then
			event.rotate_object_sequence(1, 0.0, direction_to_player, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
			turn_wait_frames = 20
		end
		event.set_object_sequence_motion(1, "立ち")
		wait.frames(turn_wait_frames)
		event.open_voice_stream_wave(1, 10665)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, "Ti serve un biglietto per entrare.\n(Premi (#) per accedere al Menu.)")
		message.open(0, -1, 8, 0, 0)
		do
			local _: any
			_, answer = message.wait_answer(0, 1, answer)
		end
		message.close(0)
		event.set_message_bubble_screen_slot(0, 0)
		event.close_voice_stream(1)
		if answer == 1 then
			dialogue_stage = 2
		else
			event.close_voice_stream(1)
		end
		has_greeted = 1
		needs_guard_reset = 1
	end
	if dialogue_stage == 2 then
		event.open_use_item_menu(353)
		vm.wait(4)
		item = vmhost.used_item() or item
		if item == 353 then
			ticket_used_flag = event.get_save_flag(1) or ticket_used_flag
			if ticket_used_flag == 0 then
				event.set_save_flag(1, 1)
				event.load_event_script("m06/m06b.stb", 153)
				return
			else
				palm_brinks_m06.play_ticket_gate_scene()
				event.skip_next_music_load()
				event.skip_next_map_sound_load()
				event.remove_item(382)
				event.add_inventory_item(387)
				event.equip_character_item(0, 387)
				event.go_to_dungeon(0, 21, 1010)
				return
			end
		elseif item <= 0 then
		else
			if has_greeted ~= 1 then
				event.attach_object_handle_to_character(0, 0)
				event.clear_object_sequence(0)
				event.set_object_sequence_object(0, 0)
				event.attach_object_handle_to_character(1, 8)
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
					player_yaw = out2 or player_yaw
				end
				do
					local out1, out2, out3 = event.get_character_position(8)
					guard_x = out1 or guard_x
					guard_y = out2 or guard_y
					guard_z = out3 or guard_z
				end
				do
					local _, out2, _ = event.get_character_rotation(8)
					guard_yaw = out2 or guard_yaw
				end
				direction_to_other = event.get_direction_angle(player_x, player_y, player_z, guard_x, guard_y, guard_z) or direction_to_other
				direction_to_player = event.get_direction_angle(guard_x, guard_y, guard_z, player_x, player_y, player_z) or direction_to_player
				turn_wait_frames = 0
				angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
				if angle_check ~= 0 then
					event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
					event.set_object_sequence_motion(0, "歩き")
					event.delay_object_sequence_motion_track(0, 10)
					turn_wait_frames = 20
				end
				event.set_object_sequence_motion(0, "立ち")
				angle_check = event.compare_angles(guard_yaw, direction_to_player, 0.1) or angle_check
				if angle_check ~= 0 then
					event.rotate_object_sequence(1, 0.0, direction_to_player, 0.0, 10)
					event.set_object_sequence_motion(1, "歩き")
					event.delay_object_sequence_motion_track(1, 10)
					turn_wait_frames = 20
				end
				event.set_object_sequence_motion(1, "立ち")
				wait.frames(turn_wait_frames)
			end
			event.set_object_sequence_motion(1, "帰ってくれ", 2)
			event.queue_object_sequence_next_motion(1, "立ち", 4)
			event.open_message_window_2(0, "Non puoi entrare senza biglietto!")
			palm_brinks_m06.play_voiced_message(10670, 90)
			object.wait_until_done(1)
			event.close_voice_stream(1)
			needs_guard_reset = 1
		end
	end
	if needs_guard_reset ~= 0 then
		angle_check = event.compare_angles(guard_yaw, direction_to_player, 0.1) or angle_check
		if angle_check ~= 0 then
			event.rotate_object_sequence(1, 0.0, guard_yaw, 0.0, 10)
			event.set_object_sequence_motion(1, "歩き")
			event.delay_object_sequence_motion_track(1, 10)
			wait.frames(10)
		end
		event.set_object_sequence_motion(1, "立ち")
		object.wait_until_done(1)
	end
end

--- Walks the player forward while the camera follows and then comments on the circus.
local function walk_forward_and_comment()
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local i: s32 = 0
	local ticket_count: s32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	target_x = vm.f32(vm.f32(vm.sin(0.0) * 30.0) + x)
	target_y = y
	target_z = vm.f32(vm.f32(vm.cos(0.0) * 30.0) + z)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.move_object_sequence(0, target_x, target_y, target_z, 30, 1)
	event.turn_object_sequence_toward(0, target_x, target_y, target_z, 10)
	event.set_object_sequence_motion(0, "歩き")
	i = 0
	while i < 30 do
		do
			local out1, out2, out3 = event.get_character_position(0)
			x = out1 or x
			y = out2 or y
			z = out3 or z
		end
		y = vm.f32(y + 30.0)
		event.set_camera_look_at(x, y, z)
		i = i + 1
		vm.wait(1)
	end
	event.set_object_sequence_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	ticket_count = event.get_owned_item_count(353) or ticket_count
	if ticket_count >= 1 then
		event.open_message_window_2(0, "Sbrigati o il circo\nfinir[UNI00e0]!")
	else
		event.open_message_window_2(0, "Non credo che il ragazzo dai\ncapelli rossi sia passato di qui.")
	end
	message.show_and_wait(0, -1, 5, 256, 208)
end

--- Has the bystander say the circus has already started.
local function say_circus_has_started()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Il circo rende tutto\ncos[UNI00ec] allegro!")
	character.face_each_other_and_talk(10, 9000050)
end

--- Asks the first bystander about the red-haired boy and plays the voiced reply.
local function ask_bystander_about_red_haired_boy()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local player_yaw: f32 = 0
	local other_yaw: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local angle_check: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 10)
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
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(10)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	do
		local _, out2, _ = event.get_character_rotation(10)
		other_yaw = out2 or other_yaw
	end
	direction_to_other = event.get_direction_angle(player_x, player_y, player_z, other_x, other_y, other_z) or direction_to_other
	direction_to_player = event.get_direction_angle(other_x, other_y, other_z, player_x, player_y, player_z) or direction_to_player
	angle_check = event.compare_angles(direction_to_player, 3.14, 1.5) or angle_check
	if angle_check ~= 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_character_motion(0, "立ち")
		event.open_message_window_2(0, "[UNI00c8] da maleducati parlare a qualcuno\nstandogli dietro le spalle.")
		message.show_and_wait(0, -1, 5, 0, 0)
		event.set_message_bubble_tail(0, 1)
		return
	end
	angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, direction_to_player, 0.0, 16)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 16)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "[UNI00c8] passato di qui un bambino coi capelli rossi?")
	palm_brinks_m06.play_voiced_message(10380, 80)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "Oh, s[UNI00ec]! Proprio ora.")
	palm_brinks_m06.play_voiced_message(10390, 100)
	object.wait_until_done(1)
	angle_check = event.compare_angles(3.14, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 16)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 16)
		direction_to_player = vm.f32(3.14)
	else
		event.delay_object_sequence_motion_track(1, 16)
	end
	event.set_object_sequence_motion(1, "あっちの方に", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "Non ho dubbi: correva da quella parte!")
	palm_brinks_m06.play_voiced_message(10400, 150)
	event.close_voice_stream(1)
	object.wait_until_done(1)
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, other_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(11)
end

--- Has the bystander praise Palm Brinks.
local function praise_palm_brinks()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Cosa stai facendo?")
	character.face_each_other_and_talk(11, 9000060)
end

--- Asks the second bystander about the red-haired boy and plays the voiced reply.
local function ask_second_bystander_about_boy()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local player_yaw: f32 = 0
	local other_yaw: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local angle_check: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 11)
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
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(11)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	do
		local _, out2, _ = event.get_character_rotation(11)
		other_yaw = out2 or other_yaw
	end
	direction_to_other = event.get_direction_angle(player_x, player_y, player_z, other_x, other_y, other_z) or direction_to_other
	direction_to_player = event.get_direction_angle(other_x, other_y, other_z, player_x, player_y, player_z) or direction_to_player
	angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, direction_to_player, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(20)
	event.set_object_sequence_motion(0, "会話", 6)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	event.open_message_window_2(0, "Ehi, ehi, hai visto\nun ragazzo coi capelli rossi?")
	palm_brinks_m06.play_voiced_message(10420, 90)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	wait.frames(10)
	event.open_message_window_2(0, "Chi io? No, mi spiace.")
	palm_brinks_m06.play_voiced_message(10430, 90)
	event.close_voice_stream(1)
	object.wait_until_done(1)
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, other_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(11)
end

--- Has the bystander wish she could have seen the circus.
local function wish_to_see_circus()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "C'[UNI00e8] qualcosa che non va?")
	character.face_each_other_and_talk(13, 9000070)
end

--- Has the bystander remark on the view of the moon and shows the first-person view hint once.
local function talk_about_moon_view()
	local flag: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Si riesce a vedere la\nluna da qui!")
	character.face_each_other_and_talk(14, 9000080)
	flag = event.get_save_flag(32) or flag
	if flag == 0 then
		event.set_save_flag(32, 1)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(0, "[(!)]Premi il [r2] per la\n   visuale in soggettiva.")
		message.show_and_wait(0, -1, 8, 256, 208)
	end
end

--- Has the bystander ask if anything is wrong.
local function ask_if_anything_is_wrong()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Avrei voluto vedere il circo!")
	character.face_each_other_and_talk(15, 9000090)
end

--- Turns the camera and characters together and has the character explain she is heading to City Hall.
local function talk_to_city_hall_bound_character()
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local other_x: f32 = 0
	local other_y: f32 = 0
	local other_z: f32 = 0
	local player_yaw: f32 = 0
	local other_yaw: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local direction_to_other: f32 = 0
	local direction_to_player: f32 = 0
	local angle_check: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 7)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 16)
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
		player_yaw = out2 or player_yaw
	end
	do
		local out1, out2, out3 = event.get_character_position(16)
		other_x = out1 or other_x
		other_y = out2 or other_y
		other_z = out3 or other_z
	end
	do
		local _, out2, _ = event.get_character_rotation(16)
		other_yaw = out2 or other_yaw
	end
	camera_x = vm.f32(vm.f32(vm.sin(2.5) * 140) + player_x)
	camera_y = vm.f32(player_y + 10.0)
	camera_z = vm.f32(vm.f32(vm.cos(2.5) * 140) + player_z)
	event.clear_camera_sequence()
	event.move_camera_sequence_eased(camera_x, camera_y, camera_z, player_x, player_y + 50.0, player_z, 14, 2, 1.0)
	direction_to_other = event.get_direction_angle(player_x, player_y, player_z, other_x, other_y, other_z) or direction_to_other
	direction_to_player = event.get_direction_angle(other_x, other_y, other_z, player_x, player_y, player_z) or direction_to_player
	angle_check = event.compare_angles(player_yaw, direction_to_other, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(0, 0.0, direction_to_other, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
	end
	event.set_object_sequence_motion(0, "立ち")
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, direction_to_player, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(20)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち", 4)
	event.open_message_window_2(0, "Mi spiace, devo andare al Municipio!")
	palm_brinks_m06.play_voiced_message(10410, 80)
	event.close_voice_stream(1)
	object.wait_until_done(1)
	angle_check = event.compare_angles(other_yaw, direction_to_player, 0.1) or angle_check
	if angle_check ~= 0 then
		event.rotate_object_sequence(1, 0.0, other_yaw, 0.0, 10)
		event.set_object_sequence_motion(1, "歩き")
		event.delay_object_sequence_motion_track(1, 10)
	end
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(11)
end

--- Has the bystander ask what the player is doing.
local function ask_what_player_is_doing()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Vallecatini [UNI00e8] una citt[UNI00e0] magnifica!")
	character.face_each_other_and_talk(17, 9000100)
end

--- Has the bystander remark on how lively the circus is.
local function chat_about_circus_liveliness()
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.open_message_window_2(0, "Il circo [UNI00e8] gi[UNI00e0] iniziato!")
	character.face_each_other_and_talk(18, 9000110)
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Has the player talk to the seated character, who comments on the sky when the player owns the ticket and otherwise is asked about the red-haired kid.
function script.talk_to_seated_character()
	local ticket_count: s32 = 0
	ticket_count = event.get_owned_item_count(353) or ticket_count
	if ticket_count >= 1 then
		comment_on_starry_sky()
	else
		event.set_save_flag(2, 1)
		ask_seated_character_about_boy()
	end
end
script[1] = script.talk_to_seated_character

script.set_midnight_scene = set_midnight_scene
script[99] = script.set_midnight_scene

--- Loads and places the opening characters and sets up the midnight scene and the starting camera.
function script.default_event()
	event.initialize_event()
	palm_brinks_m06.load_opening_characters()
	palm_brinks_m06.place_opening_characters()
	set_midnight_scene()
	event.take_memory_card_load_state()
	event.set_character_position(0, 2100.0, 0.0, 2200.0)
	event.set_character_rotation(0, 0.0, 3.14, 0.0)
	event.set_camera_look_at(2100.0, 30.0, 2200.0)
	event.set_camera_position(2100.0, 30.0, 2080.0)
end

--- Starts the ticket chase scene at midnight.
function script.key_open()
	event.initialize_event()
	vm.wait(1)
	event.set_time_of_day(24.0)
	event.load_event_script("m06/m06b.stb", 154)
end

--- Loads the Polcurse speech scene from the companion script.
function script.cutscene_polcurse_speech()
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 151)
end
script[151] = script.cutscene_polcurse_speech

--- Marks the progress counter and loads the hero run scene from the companion script.
function script.cutscene_hero_run()
	event.set_save_counter(5, 1)
	event.initialize_event()
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 152)
end
script[152] = script.cutscene_hero_run

--- Fades out and loads the Halloween jump scene from the companion script.
function script.cutscene_halloween_jump_with_fade()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.load_event_script("m06/m06b.stb", 155)
end
script[153] = script.cutscene_halloween_jump_with_fade

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Runs the ticket guard dialogue for the gate area trigger.
function script.approach_ticket_gate()
	talk_to_ticket_guard(0)
end
script[500] = script.approach_ticket_gate

--- Event 510, which map data, a script or the engine runs by number.
script.walk_forward_and_comment = walk_forward_and_comment
script[510] = script.walk_forward_and_comment

--- Says that City Hall appears to be closed.
function script.examine_city_hall_door()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Il Municipio sembra chiuso.")
	message.show_and_wait(0, -1, 5, 0, 0)
end
script[520] = script.examine_city_hall_door

--- Runs the dialogue of the triggered character according to its slot.
function script.talk_to_villager()
	local character_slot: s32 = 0
	local ticket_count: s32 = 0
	local asked_seated_character_flag: s32 = 0
	local asked_bystander_flag: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	event.get_triggered_event_data_2(14)
	if character_slot == 8 then
		talk_to_ticket_guard(1)
		return
	end
	ticket_count = event.get_owned_item_count(353) or ticket_count
	if character_slot == 10 then
		if ticket_count >= 1 then
			say_circus_has_started()
		else
			event.set_save_flag(3, 1)
			ask_bystander_about_red_haired_boy()
		end
		return
	end
	if character_slot == 11 then
		if ticket_count >= 1 then
			praise_palm_brinks()
		else
			asked_seated_character_flag = event.get_save_flag(2) or asked_seated_character_flag
			asked_bystander_flag = event.get_save_flag(3) or asked_bystander_flag
			if asked_seated_character_flag == 1 and asked_bystander_flag == 1 then
				do
					local out1, out2, out3 = event.get_previous_camera_position()
					camera_x = out1 or camera_x
					camera_y = out2 or camera_y
					camera_z = out3 or camera_z
				end
				do
					local out1, out2, out3 = event.get_previous_camera_look_at()
					look_at_x = out1 or look_at_x
					look_at_y = out2 or look_at_y
					look_at_z = out3 or look_at_z
				end
				event.set_camera_position(camera_x, camera_y, camera_z)
				event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
				event.initialize_event()
				vm.wait(5)
				event.load_event_script("m06/m06b.stb", 154)
			else
				ask_second_bystander_about_boy()
			end
		end
		return
	end
	if character_slot == 13 then
		wish_to_see_circus()
		return
	end
	if character_slot == 14 then
		talk_about_moon_view()
		return
	end
	if character_slot == 15 then
		ask_if_anything_is_wrong()
		return
	end
	if character_slot == 16 then
		talk_to_city_hall_bound_character()
		return
	end
	if character_slot == 17 then
		ask_what_player_is_doing()
		return
	end
	if character_slot == 18 then
		chat_about_circus_liveliness()
		return
	end
end
script[1000] = script.talk_to_villager

--- Clears the ticket flags, gives the ticket and loads the hero run scene.
function script.cutscene_hero_run_with_ticket()
	event.initialize_event()
	vm.wait(1)
	event.set_save_flag(1, 0)
	event.set_save_flag(2, 0)
	event.set_save_flag(3, 0)
	event.add_inventory_item(353)
	event.load_event_script("m06/m06b.stb", 152)
end
script[10020] = script.cutscene_hero_run_with_ticket

--- Stops the music and loads the Halloween jump scene.
function script.cutscene_halloween_jump_after_music_stop()
	event.stop_music(0)
	event.stop_environment_music()
	wait.frames(6)
	event.load_event_script("m06/m06b.stb", 155)
end
script[10060] = script.cutscene_halloween_jump_after_music_stop

return script
