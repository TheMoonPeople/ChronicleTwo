--!strict
--- Event script for the Shigura village boss room in Ocean's Roar Cave, covering the entrance scenes, the villager conversations, the boss battle setup and the exit to the georama editor after the boss is defeated.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local character = require("@lib/event/character")
local dungeon = require("@lib/event/dungeon")
local menu = require("@lib/event/menu")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local oceans_roar_cave_boss = require("@lib/event/oceans_roar_cave_boss")
local wait = require("@lib/event/wait")

--- Stops the music, places the townspeople and shows the battleship map part only between the boss introduction and the boss defeat.
local function place_townspeople_and_battleship()
	local boss_introduced: s32 = 0
	local boss_defeated: s32 = 0
	event.stop_music(0)
	oceans_roar_cave_boss.place_townspeople()
	boss_introduced = event.get_save_flag(438) or boss_introduced
	boss_defeated = event.get_save_flag(444) or boss_defeated
	event.attach_object_handle_to_map_part_2(0, "p01_battleship")
	if boss_introduced == 1 and boss_defeated == 0 then
		event.set_object_handle_visible(0, 1)
	else
		event.set_object_handle_visible(0, 0)
	end
end

--- Turns the player and a villager to face each other, frames them with the camera and shows the villager's line of dialogue.
local function converse_with_villager(villager_slot: s32)
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local player_slot: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local villager_x: f32 = 0
	local villager_z: f32 = 0
	local player_yaw: f32 = 0
	local player_target_yaw: f32 = 0
	local player_turn: f32 = 0
	local villager_yaw: f32 = 0
	local villager_target_yaw: f32 = 0
	local villager_turn: f32 = 0
	local camera_angle_near: f32 = 0
	local camera_angle_far: f32 = 0
	local turn_step: f32 = 0
	local turn_step_total: f32 = 0
	local player_step_yaw: f32 = 0
	local villager_step_yaw: f32 = 0
	local random_roll: s32 = 0
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
	player_slot = event.get_player_character_slot() or player_slot
	do
		local out1, out2, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, _, out3 = event.get_character_position(villager_slot)
		villager_x = out1 or villager_x
		villager_z = out3 or villager_z
	end
	do
		local _, out2, _ = event.get_character_rotation(player_slot)
		player_yaw = out2 or player_yaw
	end
	player_target_yaw = event.get_look_angle(villager_x - player_x, villager_z - player_z) or player_target_yaw
	player_turn = vm.f32(player_target_yaw - player_yaw)
	player_turn = event.wrap_angle(player_turn) or player_turn
	do
		local _, out2, _ = event.get_character_rotation(villager_slot)
		villager_yaw = out2 or villager_yaw
	end
	villager_target_yaw = event.get_look_angle(player_x - villager_x, player_z - villager_z) or villager_target_yaw
	villager_turn = vm.f32(villager_target_yaw - villager_yaw)
	villager_turn = event.wrap_angle(villager_turn) or villager_turn
	if -0.5 < player_turn and player_turn < 0.5 then
		event.set_character_motion(player_slot, "立ち")
	else
		event.set_character_motion(player_slot, "歩き")
	end
	if -0.5 < villager_turn and villager_turn < 0.5 then
	else
		event.set_character_motion(villager_slot, "歩き")
	end
	event.clear_camera_sequence()
	if villager_slot == 13 or villager_slot == 14 or villager_slot == 15 then
		event.set_camera_sequence_look_at(player_x, player_y + 63.0, player_z)
		camera_angle_near = vm.f32(villager_target_yaw - vm.f32(0.73))
		camera_angle_near = event.wrap_angle(camera_angle_near) or camera_angle_near
		event.set_camera_sequence_angle_height_distance(camera_angle_near, 41.5, 179.0)
	else
		event.set_camera_sequence_look_at(player_x, player_y + 130.0, player_z)
		camera_angle_far = vm.f32(villager_target_yaw - vm.f32(0.73))
		camera_angle_far = event.wrap_angle(camera_angle_far) or camera_angle_far
		event.set_camera_sequence_angle_height_distance(camera_angle_far, 45.0, 468.0)
	end
	turn_step = 0.0
	turn_step_total = vm.f32(calc.max(calc.absolute(player_turn), calc.absolute(villager_turn)) * 8.0)
	while turn_step < turn_step_total do
		player_step_yaw = calc.interpolate(0.0, player_turn, turn_step, turn_step_total)
		player_step_yaw = vm.f32(player_step_yaw + player_yaw)
		event.set_character_rotation(player_slot, 0.0, player_step_yaw, 0.0)
		villager_step_yaw = calc.interpolate(0.0, villager_turn, turn_step, turn_step_total)
		villager_step_yaw = vm.f32(villager_step_yaw + villager_yaw)
		event.set_character_rotation(villager_slot, 0.0, villager_step_yaw, 0.0)
		turn_step = vm.f32(turn_step + 1.0)
		vm.wait(1)
	end
	event.set_character_rotation(player_slot, 0.0, player_target_yaw, 0.0)
	event.set_character_motion(player_slot, "立ち")
	event.attach_object_handle_to_character(0, villager_slot)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_rotation(0, 0.0, villager_target_yaw, 0.0)
	event.set_object_sequence_motion(0, "会話入り", 6)
	event.queue_object_sequence_next_motion(0, "会話L", 4)
	object.wait_until_done(0)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Hola.\nQu[UNI00e9] buen tiempo, [UNI00bf]no?")
	if villager_slot == 8 then
		event.open_message_window_2(
			0,
			"Eso podr[UNI00ed]a servir tambi[UNI00e9]n\npara mis heridas.\nVenga, [UNI00a1]c[UNI00fa]rame!"
		)
	end
	if villager_slot == 9 then
		event.open_message_window_2(0, "Bienvenido a la aldea Shigura. \nDisfrute de la estancia.")
	end
	if villager_slot == 10 then
		event.open_message_window_2(0, "Este es el anciano de la aldea.\nS[UNI00e9] amable, por favor.")
	end
	if villager_slot == 11 then
		event.open_message_window_2(
			0,
			"Somos una raza migratoria;\ncada a[UNI00f1]o hacemos un largo viaje para venir aqu[UNI00ed]."
		)
	end
	if villager_slot == 12 then
		event.open_message_window_2(
			0,
			"Aqu[UNI00ed] es donde apaciguamos nuestro\ncansancio despu[UNI00e9]s del largo viaje.\nPor eso rogamos silencio."
		)
	end
	if villager_slot == 13 or villager_slot == 14 or villager_slot == 15 then
		random_roll = event.get_random_number_int(10) or random_roll
		if random_roll == 0 then
			event.open_message_window_2(0, "[UNI00a1][UNI00a1]Ay aayyy!!")
		end
		if random_roll == 1 then
			event.open_message_window_2(0, "Aaiiiii")
		end
		if random_roll == 2 then
			event.open_message_window_2(0, "Erraaah")
		end
		if random_roll == 3 then
			event.open_message_window_2(0, "[UNI00a1]Aaaay!")
		end
		if random_roll == 4 then
			event.open_message_window_2(0, "[UNI00a1]Uy uyuyuyuyyy auuuu!")
		end
		if random_roll == 5 then
			event.open_message_window_2(0, "Raaaaaahr")
		end
		if random_roll == 6 then
			event.open_message_window_2(0, "Rooowwwoo")
		end
		if random_roll == 7 then
			event.open_message_window_2(0, "Rooowwww")
		end
		if random_roll == 8 then
			event.open_message_window_2(0, "[UNI00bf]Raaaahr?")
		end
		if random_roll == 9 then
			event.open_message_window_2(0, "[UNI00a1]Raaaahr!")
		end
	end
	message.show_and_wait(0, -1, 6, 170, 0)
	event.set_object_sequence_motion(0, "会話戻り", 2)
	event.queue_object_sequence_next_motion(0, "立ち", 4)
	object.wait_until_done(0)
	event.finish_event()
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.start_crossfade(10)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded and does nothing.
function script.setup() end

script.place_townspeople_and_battleship = place_townspeople_and_battleship
script[99] = script.place_townspeople_and_battleship

--- Chooses the scene played on entering the boss room from the story flags and the memory card load state.
function script.default_event()
	local memory_card_loaded: s32 = 0
	local flag_400: s32 = 0
	local boss_introduced: s32 = 0
	local flag_432: s32 = 0
	local flag_436: s32 = 0
	local boss_defeated: s32 = 0
	local item_count: s32 = 0
	place_townspeople_and_battleship()
	event.fade_out_screen(0)
	event.set_save_control_bits(16, 1)
	memory_card_loaded = event.take_memory_card_load_state() or memory_card_loaded
	if memory_card_loaded == 1 then
		character.place_standing(1900.0, 0.0, -330.0, 0.0)
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
		return
	end
	flag_400 = event.get_save_flag(400) or flag_400
	if flag_400 == 1 then
		boss_introduced = event.get_save_flag(438) or boss_introduced
		flag_432 = event.get_save_flag(432) or flag_432
		flag_436 = event.get_save_flag(436) or flag_436
		boss_defeated = event.get_save_flag(444) or boss_defeated
		if boss_introduced == 0 and (flag_432 == 0 and flag_436 == 0) then
			item_count = event.get_owned_item_count(373) or item_count
			if item_count >= 1 then
				oceans_roar_cave_boss.play_event_432()
				return
			else
				oceans_roar_cave_boss.play_event_436()
				return
			end
		end
		if boss_introduced == 1 and boss_defeated == 0 then
			event.set_save_control_bits(16, 0)
			oceans_roar_cave_boss.play_boss_introduction_scene()
			vm.wait(4)
			event.set_save_control_bits(1, 1)
			event.load_dungeon_monster(514, 1)
			event.load_dungeon_monster(522, 0)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
				0.0,
				0.5235988,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
				0.0,
				1.5707964,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
				0.0,
				2.617994,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
				0.0,
				-2.617994,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
				0.0,
				-1.5707964,
				0.0
			)
			event.place_dungeon_monster(
				514,
				250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
				0.0,
				250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
				0.0,
				-0.5235988,
				0.0
			)
			event.place_dungeon_monster(522, 186.17, 130.0, 141.45)
			character.place_standing_and_reset_cloth(250.0, 0.0, 250.0, 0.0)
			event.set_camera_look_at(250.0, 30.0, 250.0)
			event.set_camera_position(250.0, 40.0, 130.0)
			event.reset_follow_camera(0)
			event.fade_in_screen(30)
			event.finish_event()
			return
		end
	end
	oceans_roar_cave_boss.play_room_entrance()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = oceans_roar_cave_boss.play_event_432

--- Waits a frame and then until the player presses the button.
function script.wait_for_button_press()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[170] = script.wait_for_button_press

--- Asks for confirmation, opens the dungeon floor menu and leaves for the chosen floor or the overworld map.
function script.confirm_leave_to_dungeon()
	local selected_floor: s32 = 0
	if oceans_roar_cave_boss.confirm_exit() ~= 0 then
		event.set_dungeon_stage_id(3)
		event.open_event_menu(3, 3)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			selected_floor = out3 or selected_floor
		end
		if selected_floor == 20 then
			event.fade_in_screen(30)
			return
		end
		oceans_roar_cave_boss.unload_event_characters()
		event.set_save_control_bits(16, 0)
		if selected_floor == 0 then
			event.jump_to_map_3(-1, "g03", 100)
		else
			event.go_to_dungeon(3, selected_floor, 1010)
		end
		vm.wait(3)
		return
	end
end
script[200] = script.confirm_leave_to_dungeon

--- Event 400, which map data, a script or the engine runs by number.
script[400] = menu.open_with_fade

--- Fades out, records the dungeon floor as cleared and sends the player to the georama editor after the boss battle.
function script.start_georama_after_boss()
	local stage_id: s32 = 0
	local floor_number: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(30)
		event.fade_out_screen(30)
		progress_step = 1
		wait.frames(30)
		event.clear_event_battle_monsters(-1)
		stage_id = event.get_dungeon_stage_id() or stage_id
		floor_number = event.get_dungeon_floor() or floor_number
		event.set_dungeon_floor_info(stage_id, floor_number, 5, 2)
		progress_step = 2
		oceans_roar_cave_boss.play_event_444()
		event.remove_item(373)
		event.set_save_control_bits(16, 0)
		event.set_save_control_bits(1, 0)
		event.go_to_georama_edit(2, 520)
		progress_step = 3
		vm.wait(3)
		return
	end, function(received: { any })
		if progress_step <= 3 then
			if progress_step <= 1 then
				progress_step = 2
				oceans_roar_cave_boss.play_event_444()
				return vm.continue_with(function()
					event.remove_item(373)
					event.set_save_control_bits(16, 0)
					event.set_save_control_bits(1, 0)
					event.go_to_georama_edit(2, 520)
					progress_step = 3
					vm.wait(3)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[501] = script.start_georama_after_boss

--- Spawns the boss room monsters, places the player and resets the follow camera.
function script.enter_boss_room()
	oceans_roar_cave_boss.spawn_boss_room_monsters()
	event.set_character_position(0, 400.0, 0.0, 30.0)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end
script[502] = script.enter_boss_room

--- Identifies which villager the player is talking to and plays the matching conversation, or the dejected scene when the player lacks the required item.
function script.talk_to_villager()
	local villager_slot: s32 = 0
	local map_part: s32 = 0
	local compare_result: s32 = 0
	local item_count: s32 = 0
	local flag_434: s32 = 0
	villager_slot = 0
	map_part = event.get_triggered_event_data_2(9) or map_part
	compare_result = event.compare_map_parts_place_name(map_part, "p01_otona") or compare_result
	if compare_result == 0 then
		villager_slot = 8
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_otona-1") or compare_result
	if compare_result == 0 then
		villager_slot = 9
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_otona-2") or compare_result
	if compare_result == 0 then
		villager_slot = 10
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_otona-3") or compare_result
	if compare_result == 0 then
		villager_slot = 11
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_otona-4") or compare_result
	if compare_result == 0 then
		villager_slot = 12
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_kodomo") or compare_result
	if compare_result == 0 then
		villager_slot = 13
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_kodomo-1") or compare_result
	if compare_result == 0 then
		villager_slot = 14
	end
	compare_result = event.compare_map_parts_place_name(map_part, "p01_kodomo-2") or compare_result
	if compare_result == 0 then
		villager_slot = 15
	end
	if villager_slot == 0 then
		return
	end
	item_count = event.get_owned_item_count(373) or item_count
	if item_count <= 0 then
		oceans_roar_cave_boss.play_dejected_scene(villager_slot)
		return
	end
	if villager_slot == 8 then
		flag_434 = event.get_save_flag(434) or flag_434
		if flag_434 == 0 then
			event.add_inventory_item(375)
			oceans_roar_cave_boss.play_event_434()
			return
		end
	end
	converse_with_villager(villager_slot)
end
script[1000] = script.talk_to_villager

--- Plays the defeat dialogue, voiced at random while the boss fight is under way and silent otherwise.
function script.on_player_defeated()
	local flag_440: s32 = 0
	local boss_defeated: s32 = 0
	local random_roll: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		flag_440 = event.get_save_flag(440) or flag_440
		boss_defeated = event.get_save_flag(444) or boss_defeated
		if flag_440 ~= 0 and boss_defeated == 0 then
			random_roll = event.get_random_number_int(100) or random_roll
			if random_roll < 50 then
				progress_step = 1
				dungeon.handle_defeat_with_dialogue_voiced(0, 8620060)
			else
				progress_step = 2
				dungeon.handle_defeat_with_dialogue_voiced(0, 8620070)
			end
			return
		end
		progress_step = 3
		dungeon.handle_defeat_with_dialogue_silent(0)
		return
	end, function(received: { any })
		if progress_step <= 2 then
			if progress_step <= 1 then
				dungeon.skip_defeat_dialogue_sequence_voiced(0, 8620070)
			end
			return 0
		end
		if progress_step <= 3 then
			return 0
		end
		return nil
	end)
end
script[1200] = script.on_player_defeated

--- Marks the boss as introduced, refreshes the room and plays the boss introduction scene.
function script.cutscene_boss_introduction()
	event.set_save_flag(438, 1)
	place_townspeople_and_battleship()
	oceans_roar_cave_boss.play_boss_introduction_scene()
end
script[14400] = script.cutscene_boss_introduction

--- Plays the boss defeat scene and moves on to the georama editor.
function script.cutscene_boss_defeated()
	oceans_roar_cave_boss.play_event_444()
	event.go_to_georama_edit(2, 520)
	vm.wait(2)
end
script[14440] = script.cutscene_boss_defeated

--- Starts the battle music and places the ring of guard monsters and the boss.
function script.load_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(34)
	event.play_music(0)
	event.load_dungeon_monster(514, 1)
	event.load_dungeon_monster(522, 0)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-2.617994)) * 450.0),
		0.0,
		0.5235988,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-1.5707964)) * 450.0),
		0.0,
		1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(-0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(-0.5235988)) * 450.0),
		0.0,
		2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(0.5235988)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(0.5235988)) * 450.0),
		0.0,
		-2.617994,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(1.5707964)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(1.5707964)) * 450.0),
		0.0,
		-1.5707964,
		0.0
	)
	event.place_dungeon_monster(
		514,
		250.0 + vm.f32(vm.sin(vm.f32(2.617994)) * 450.0),
		0.0,
		250.0 + vm.f32(vm.cos(vm.f32(2.617994)) * 450.0),
		0.0,
		-0.5235988,
		0.0
	)
	event.place_dungeon_monster(522, 186.17, 130.0, 141.45)
	vm.wait(3)
	event.finish_event()
end
script[24020] = script.load_boss_battle

return script
