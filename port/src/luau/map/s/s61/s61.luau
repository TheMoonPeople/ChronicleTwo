--!strict
--- Runs a Zelmite mine floor: the monster attack intro, treasure chests, random circles, the geostone, floor clear and tutorial messages.

local vm = require("@lib/vm")
local calc = require("@lib/event/calc")
local camera = require("@lib/event/camera")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local minigame = require("@lib/event/minigame")
local object = require("@lib/event/object")
local wait = require("@lib/event/wait")
local zelmite_mine_s61 = require("@lib/event/zelmite_mine_s61")

--- Loads the floor's sounds and starts the music that matches which treasure chests have been opened.
local function start_floor_music()
	local chest_flags: s32 = 0
	event.load_map_sounds(8694)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 1) == 0 or bit32.band(chest_flags, 2) == 0 then
		event.stop_music(0)
		wait.for_frame_count(4)
		event.load_music(190)
		event.play_music(0)
	else
		event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
		wait.background_load()
		event.load_music_pack(193)
		event.play_music(0)
	end
end

--- Plays the cutscene in which two e202d dungeon monsters attack while the d07domari title banner fades in.
local function play_monster_attack_intro_scene()
	local loop_counter: s32 = 0
	local sound_bank: s32 = 0
	local image_block: s32 = 0
	local checkpoint: number = 0
	vm.section(function()
		checkpoint = 1
		vm.entry(1)
		event.initialize_event()
		checkpoint = 2
		vm.wait(2)
		sound_bank = event.load_sound_effect_file_3(5, "snd2/mon/en_008.sound.json") or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("dungeon/monster/")
		event.load_character(5, "e202d.gltf", "e202d", 8)
		event.copy_character(5, 8, 9)
		for var0_i = 0, 1 do
			event.set_character_active(1, 8 + var0_i)
			event.attach_object_handle_to_character(0 + var0_i, 8 + var0_i)
			event.clear_object_sequence(0 + var0_i)
			event.set_object_sequence_object(0 + var0_i, 0 + var0_i)
			event.set_object_handle_sound_bank(0 + var0_i, sound_bank)
		end
		event.change_directory("")
		image_block = event.load_event_image_4(5, "textures/event/e800/d07domari/d07domari01.json", 0) or image_block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "d07domari01", image_block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(6, 0)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_object_sequence_position(0, -36.58, 0.0, 153.99)
		event.set_object_sequence_rotation(0, 0.0, 2.92, 0.0)
		event.set_object_sequence_position(1, 30.72, 0.0, 154.46)
		event.set_object_sequence_rotation(1, 0.0, -2.88, 0.0)
		event.set_object_sequence_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "立ち", 0)
		event.set_camera_sequence_position(-6.83, 70.86, -98.29)
		event.set_camera_sequence_look_at(-5.15, 18.65, -28.34)
		event.move_camera_sequence_eased(-3.71, 16.94, 31.66, -2.03, 28.09, 101.61, 30, 0, 0.4)
		checkpoint = 3
		camera.wait_until_done()
		event.set_object_sequence_motion(0, "攻撃１", 6)
		event.queue_object_sequence_next_motion(0, "立ち", 0)
		event.set_object_sequence_motion(1, "攻撃１", 6)
		event.queue_object_sequence_next_motion(1, "立ち", 0)
		event.set_object_sequence_color(6, 128, 128, 128, 128, 30)
		checkpoint = 4
		wait.for_frame_count(30)
		checkpoint = 5
		object.wait_until_done(0)
		checkpoint = 6
		object.wait_until_done(1)
		checkpoint = 7
		wait.for_frame_count(30)
		event.fade_out_screen(30)
		checkpoint = 8
		wait.for_frame_count(30)
	end, function(received: { any }): boolean
		if checkpoint <= 2 then
			loop_counter = 0
			local _ = loop_counter < 2
			loop_counter = loop_counter + 1
			wait.background_load_skipping()
		end
		if checkpoint <= 3 then
			wait.skip_frame_count(30)
		end
		if checkpoint <= 4 then
			cutscene.skip_command(0)
		end
		if checkpoint <= 5 then
			cutscene.skip_command(1)
		end
		if checkpoint <= 6 then
			wait.skip_frame_count(30)
		end
		if checkpoint <= 7 then
			wait.skip_frame_count(30)
		end
		return true
	end)
	checkpoint = 9
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.set_character_active(1, 0)
	event.delete_character(8)
	event.delete_character(9)
	event.set_event_sprite_draw_pass(0, 0)
	event.delete_event_image(0)
	event.fade_in_screen(30)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.start_floor_music = start_floor_music
script[99] = script.start_floor_music

--- Plays the monster attack intro on the first visit and spawns the monsters before the player enters.
function script.default_event()
	local counter_value: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		checkpoint = 1
		start_floor_music()
		event.initialize_event()
		checkpoint = 2
		vm.wait(2)
		counter_value = event.get_save_counter(17) or counter_value
		if bit32.band(counter_value, 1) == 0 or bit32.band(counter_value, 2) == 0 then
			counter_value = event.get_save_counter(20) or counter_value
			if bit32.band(counter_value, 1) == 0 then
				checkpoint = 3
				play_monster_attack_intro_scene()
				counter_value = event.get_save_counter(20) or counter_value
				counter_value = vm.i32(bit32.bor(counter_value, 1))
				event.set_save_counter(20, counter_value)
			end
			zelmite_mine_s61.spawn_dungeon_monsters()
		end
		character.place_standing(0.0, 0.0, -800.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, -800.0)
		event.set_camera_position(0.0, 40.0, -920.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 2 then
				checkpoint = 3
				play_monster_attack_intro_scene()
				return vm.continue_with(function()
					counter_value = event.get_save_counter(20) or counter_value
					counter_value = vm.i32(bit32.bor(counter_value, 1))
					event.set_save_counter(20, counter_value)
					zelmite_mine_s61.spawn_dungeon_monsters()
					character.place_standing(0.0, 0.0, -800.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, -800.0)
					event.set_camera_position(0.0, 40.0, -920.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			local _ = if bit32.band(counter_value, 1) == 0 then 1 else 0
			local _ = if bit32.band(counter_value, 2) == 0 then 1 else 0
			local _ = if bit32.band(counter_value, 1) == 0 then 1 else 0
			counter_value = vm.i32(bit32.bor(counter_value, 1))
			cutscene.noop()
			cutscene.ignore_coordinates(0.0, 0.0, -800.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Waits a frame and then waits for a button press.
function script.key_open()
	vm.wait(1)
	wait.until_button_pressed(32)
end

--- Plays the monster attack intro and then waits for a button press.
function script.cutscene_monster_attack_intro()
	play_monster_attack_intro_scene()
	vm.wait(2)
	wait.until_button_pressed(32)
end
script[160] = script.cutscene_monster_attack_intro

--- Waits a frame and then waits for a button press.
function script.wait_for_button_press()
	vm.wait(1)
	wait.until_button_pressed(32)
end
script[170] = script.wait_for_button_press

--- Gives the floor's items, sets two save flags and clears the event battle monsters.
function script.give_items_and_set_flags()
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
script[200] = script.give_items_and_set_flags

--- Asks whether to leave for dungeon d07 and does so on a yes.
function script.ask_to_go_to_next_floor()
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
		event.set_dungeon_pause_flags(16384, 0)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end
script[300] = script.ask_to_go_to_next_floor

--- Opens the nearest chest and records which of the two floor chests has been opened.
function script.treasure_box()
	local item_id: s32 = 0
	local chest_flags: s32 = 0
	local chest_flags_2: s32 = 0
	item_id = inventory.open_treasure_box()
	if item_id == 207 then
		chest_flags = event.get_save_counter(17) or chest_flags
		chest_flags = vm.i32(bit32.bor(chest_flags, 1))
		event.set_save_counter(17, chest_flags)
	end
	if item_id == 198 then
		chest_flags_2 = event.get_save_counter(17) or chest_flags_2
		chest_flags_2 = vm.i32(bit32.bor(chest_flags_2, 2))
		event.set_save_counter(17, chest_flags_2)
	end
end

--- Runs the random circle: a spinning coin chooses a good or bad effect, then shows the effect's message.
function script.random_circle()
	local playable_character: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local circle_x: f32 = 0
	local circle_y: f32 = 0
	local circle_z: f32 = 0
	local yaw: f32 = 0
	local ring_x: f32 = 0
	local ring_y: f32 = 0
	local ring_z: f32 = 0
	local sound_bank: s32 = 0
	local motion_frame: f32 = 0
	local coin_angle: f32 = 0
	local party_npc_id: s32 = 0
	local coin_side: s32 = 0
	local step_count: s32 = 0
	local spin_speed: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local facing_angle: f32 = 0
	local minimum_spin_steps: s32 = 0
	local angle: f32 = 0
	local roll: s32 = 0
	local threshold: s32 = 0
	local brightness_rate: f32 = 0
	local effect_id: s32 = 0
	local effect_result: f32 = 0
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
		yaw = event.get_direction_angle(circle_x, circle_y, circle_z, player_x, player_y, player_z) or yaw
		player_x = vm.f32(vm.f32(vm.sin(yaw) * 25.0) + circle_x)
		player_y = circle_y
		player_z = vm.f32(vm.f32(vm.cos(yaw) * 25.0) + circle_z)
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
	motion_frame = event.get_random_circle_motion_frame() or motion_frame
	event.deactivate_random_circle(-1)
	event.load_character(5, "ring.gltf", "info", 12)
	event.set_character_active(1, 12)
	event.set_character_position(12, ring_x, ring_y, ring_z)
	event.set_character_motion(12, "ループ", 6)
	event.update_character_motion(12)
	event.set_character_motion_frame(12, motion_frame)
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
	step_count = 0
	spin_speed = vm.f32(0.6)
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		if step_count == 10 then
			event.play_sound_effect(sound_bank, 0)
		end
		if step_count == 30 then
			minigame.show_stop_hint()
		end
		if (if step_count >= 30 then wait.get_button_state(0) else 0) ~= 0 or step_count > 300 then
			event.stop_sound_effect(sound_bank, 0)
			event.play_sound_effect(sound_bank, 3)
			vm.wait(7)
			break
		else
			step_count = step_count + 1
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
	minimum_spin_steps = 0
	minimum_spin_steps = event.get_random_number_int(10) or minimum_spin_steps
	minimum_spin_steps = vm.i32(minimum_spin_steps + 4)
	step_count = 0
	while true do
		do
			local _, out2, _ = event.get_character_rotation(13)
			coin_angle = out2 or coin_angle
		end
		coin_angle = vm.f32(coin_angle + spin_speed)
		coin_angle = event.wrap_angle(coin_angle) or coin_angle
		event.set_character_rotation(13, 0.0, coin_angle, 0.0)
		vm.wait(9)
		if step_count >= minimum_spin_steps then
			if spin_speed > vm.f32(0.08) then
				spin_speed = vm.f32(spin_speed * vm.f32(0.9))
			end
			angle = facing_angle
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				coin_side = 0
				break
			end
			angle = vm.f32(facing_angle - vm.f32(3.1415927))
			angle = event.wrap_angle(angle) or angle
			if coin_angle < angle and calc.is_angle_within(coin_angle, angle, vm.f32(0.08)) == 0 then
				event.set_character_rotation(13, 0.0, angle, 0.0)
				coin_side = 1
				break
			end
		end
		step_count = vm.i32(step_count + 1)
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	facing_angle = coin_angle
	wait.for_frame_count(20)
	roll = event.get_random_number_int(10) or roll
	if party_npc_id == 24 then
		threshold = 100
	else
		threshold = 6
	end
	if roll < threshold then
		roll = event.get_random_number_int(10) or roll
		if coin_side == 0 then
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
			facing_angle = vm.f32(facing_angle + vm.f32(3.14))
			facing_angle = event.wrap_angle(facing_angle) or facing_angle
			event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 8)
			if coin_side == 0 then
				coin_side = 1
			else
				coin_side = 0
			end
			wait.for_frame_count(10)
		else
			roll = event.get_random_number_int(10) or roll
			if roll < 1 then
				facing_angle = vm.f32(facing_angle + vm.f32(3.14))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 6)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				facing_angle = vm.f32(facing_angle + vm.f32(1.57))
				facing_angle = event.wrap_angle(facing_angle) or facing_angle
				event.rotate_object_sequence(5, 0.0, facing_angle, 0.0, 3)
				wait.for_frame_count(20)
			end
		end
	end
	facing_angle = event.get_direction_angle(look_at_x, look_at_y, look_at_z, camera_x, camera_y, camera_z) or facing_angle
	do
		local _, out2, _ = event.get_character_rotation(13)
		coin_angle = out2 or coin_angle
	end
	if calc.is_angle_within(coin_angle, facing_angle, 1.0) == 0 then
		coin_side = 0
	else
		coin_side = 1
	end
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	brightness_rate = 1.0
	step_count = 0
	effect_id = event.get_random_circle_effect(coin_side) or effect_id
	if coin_side == 0 then
		event.play_sound_effect(sound_bank, 1)
		while step_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate + vm.f32(0.03))
			step_count = step_count + 1
			vm.wait(13)
		end
		message.show_and_wait(0, 2310, 8, 0, 0)
		effect_result = event.apply_random_circle_effect(effect_id) or effect_result
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
		while step_count < 30 do
			event.set_dungeon_brightness_rate(brightness_rate)
			brightness_rate = vm.f32(brightness_rate - vm.f32(0.03))
			step_count = step_count + 1
			vm.wait(19)
		end
		message.show_and_wait(0, 2320, 8, 0, 0)
		effect_result = event.apply_random_circle_effect(effect_id) or effect_result
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
		event.spawn_pull_items(ring_x, ring_y, ring_z, 1, 10, effect_result / 10.0)
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

--- Plays the scene in which the character picks up and activates the geostone and marks the floor.
function script.geostone()
	local playable_character: s32 = 0
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
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
	local floor: s32 = 0
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
		start_x = out1 or start_x
		start_y = out2 or start_y
		start_z = out3 or start_z
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
	wait.for_frame_count(16)
	event.play_sound_effect(sound_bank, 0)
	wait.for_frame_count(2)
	event.set_object_handle_position(1, 0.0, 0.0, 0.0)
	event.attach_geostone_to_character_frame(0, "item")
	wait.for_frame_count(10)
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
	wait.for_frame_count(20)
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
	floor = event.get_dungeon_floor() or floor
	event.set_dungeon_floor_info(stage_id, floor, 5, 256)
	event.start_crossfade(10)
	if playable_character == 1 then
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

--- Runs the defeat sequence with a silent message when the party is defeated.
function script.on_player_defeated()
	dungeon.run_defeat_sequence_silent(0)
end
script[1200] = script.on_player_defeated

--- Places the unopened treasure chests, restarts the floor music and marks the floor cleared.
function script.floor_clear()
	local chest_flags: s32 = 0
	local stage_id: s32 = 0
	local floor: s32 = 0
	event.initialize_event()
	vm.wait(1)
	event.reset_action_character_motion(0, 4)
	event.fade_out_music(60)
	chest_flags = event.get_save_counter(17) or chest_flags
	if bit32.band(chest_flags, 1) == 0 then
		event.place_treasure_box(50.0, 0.0, 600.0, 3.14, 207)
	end
	if bit32.band(chest_flags, 2) == 0 then
		event.place_treasure_box(-50.0, 0.0, 600.0, 3.14, 198)
	end
	if bit32.band(chest_flags, 1) == 0 or bit32.band(chest_flags, 2) == 0 then
		event.start_crossfade(30)
		event.set_camera_position(-6.54, 68.0, 251.52)
		event.set_camera_look_at(-1.83, 30.0, 381.43)
		event.set_character_position(0, -1.83, 0.0, 381.43)
		event.set_character_rotation(0, 0.0, 0.08, 0.0)
		wait.for_frame_count(30)
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

--- Shows the guide message the first time a random stone is examined.
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

--- Shows a guide message and waits for the player's answer.
function script.show_guide_prompt()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2610, 8, 0, 0)
	wait.for_frame_count(30)
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

--- Shows the level up guide messages and points to the help menu.
function script.level_up_guide()
	local answer: s32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	message.open(0, 2620, 8, 0, 0)
	wait.for_frame_count(30)
	do
		local _: any
		_, answer = message.wait_answer(0, 0, answer)
	end
	message.close(0)
	message.show_and_wait(0, 2621, 8, 0, 0)
	message.show_and_wait(0, 2622, 8, 0, 0)
	message.show_and_wait(0, 2623, 8, 0, 0)
	event.open_message_window_2(0, "詳しくは、メインメニューの\n『ヘルプ』を参照してください。")
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(7)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

--- Shows the buggy driving controls the first time the ridepod's wheels are used.
function script.robo_bike_guide()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.set_dungeon_pause_flags(513, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(
		0,
		"[(!)]「バギー」パーツでの移動方法\n   (L)↑で加速、(L)↓で減速。\n   (L)←→でハンドル、[l1]＋(L)←→でクイックターン。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(2)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

--- Explains the Magic-Absorb Blade the first time it is learned.
function script.magic_sword_guide()
	event.initialize_event()
	event.set_dungeon_pause_flags(515, 1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	event.open_message_window_2(0, "[(!)]「吸収魔法剣」を使えるようになった。")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"「吸収魔法剣」とは、炎などの属性を持った攻撃を\nガードすることによって吸収し、剣の振りと共に\n魔法として放出する技です。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"同じ属性なら連続して吸収することが可能で\n途中一度でも違う属性を吸収すると\nそれまで吸収した属性は無効になります。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"一度に吸収できる量は装備している\n武器の耐久力によって変化します。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"吸収した属性を魔法として放つには、\n[r1]でガード中に[l1]を押して放出します。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	vm.wait(6)
	event.set_message_window_mode(0, 1)
	event.set_message_draw_speed(0, 0)
	event.set_dungeon_pause_flags(515, 0)
	event.finish_event()
end

return script
