--!strict
--- Event script for the Sleeping Earth Chamber boss room, handling the boss intro, the lapis reward and the gate to the next dungeon.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local dungeon = require("@lib/event/dungeon")
local message = require("@lib/event/message")
local object = require("@lib/event/object")
local sleeping_earth_chamber = require("@lib/event/sleeping_earth_chamber")
local wait = require("@lib/event/wait")

--- Stops the music, loads the room sounds and hides the rapis point once the boss is beaten.
local function init_map()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(2694)
	flag = event.get_save_flag(624) or flag
	if flag == 1 then
		object.hide_rapis_point()
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing when the script loads.
function script.setup() end

script.init_map = init_map
script[99] = script.init_map

--- Sets up the boss room on entry, starting the boss intro when the boss is alive, and places the player.
function script.default_event()
	local flag: s32 = 0
	event.initialize_event()
	init_map()
	flag = event.get_save_flag(624) or flag
	if flag == 0 then
		sleeping_earth_chamber.play_boss_intro()
		event.set_function_point_enabled("", "rapis", 0)
		event.load_dungeon_monster(609, 1)
		event.load_dungeon_monster(610, 0)
		event.place_dungeon_monster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.set_save_control_bits(1, if flag == 0 then 1 else 0)
	character.place_standing_and_reset_cloth(0.0, 0.0, 1000.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 1000.0)
	event.set_camera_position(0.0, 40.0, 1120.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = sleeping_earth_chamber.play_boss_intro

--- Waits one frame and then for the confirm button press.
function script.wait_for_confirm_button()
	vm.wait(1)
	wait.until_button_pressed(64)
end
script[160] = script.wait_for_confirm_button

--- Plays the time gate warp effect on the player and waits for the confirm button.
function script.cutscene_time_gate_warp()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		resume_step = 1
		vm.wait(1)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_scene_status_flags(1, 0, 256, 1)
		event.load_character_motion_pack(5, "event/time_gate/blue/c02a_warp.gltf", "info", 0)
		event.set_character_active(1, 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_character_position(0, 91.79, 22.67, -311.8)
		event.set_character_rotation(0, 0.0, 2.52, 0.0)
		event.load_character(5, "event/time_gate/blue/atora_shine2.gltf", "info", 8)
		event.set_character_active(1, 8)
		event.set_character_position(0, 91.79, -0.0, -311.8)
		event.set_character_rotation(0, 0.0, 2.52, 0.0)
		event.set_character_position(8, 93.06, 22.75, -313.0)
		event.set_character_rotation(8, 0.0, 2.44, 0.0)
		event.set_character_motion(8, "発動", 4)
		resume_step = 2
		wait.frames(6)
		event.set_character_motion(8, "発動", 1)
		event.set_object_sequence_motion(0, "タイムワープ", 6)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 5)
		resume_step = 3
		object.wait_until_done(0)
		do
			local out1, out2, out3 = event.get_object_handle_frame_position(0, "atoramiria")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		print("pos[0]=", vm.float(pos_x), "---------------\n")
		print("pos[1]=", vm.float(pos_y), "---------------\n")
		print("pos[2]=", vm.float(pos_z), "---------------\n")
		event.set_character_position(0, 91.79, -0.0, -311.8)
		event.set_character_rotation(0, 0.0, 2.52, 0.0)
		resume_step = 4
		vm.wait(4)
		resume_step = 5
		wait.until_button_pressed(64)
		event.delete_character_extension_packs(0)
		event.delete_character(8)
		event.set_scene_status_flags(1, 0, 256, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step <= 1 then
				wait.frames_skipping(6)
			end
			if resume_step <= 2 then
				cutscene.skip_command(0)
			end
			if resume_step <= 3 then
				print("pos[0]=", vm.float(pos_x), "---------------\n")
				print("pos[1]=", vm.float(pos_y), "---------------\n")
				print("pos[2]=", vm.float(pos_z), "---------------\n")
			end
			if resume_step <= 4 then
				wait.until_button_pressed_skipping(64)
			end
			return 0
		end
		return nil
	end)
end
script[161] = script.cutscene_time_gate_warp

--- Asks whether to enter the dungeon once the boss is beaten, or refuses when the gem is not yet held.
function script.examine_dungeon_gate()
	local active_character: s32 = 0
	local flag: s32 = 0
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
	flag = event.get_save_flag(624) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "Tu n'as pas encore la pierre !")
		message.show_and_wait(0, -1, 5, 256, 208)
		event.finish_event()
		return
	end
	answer = message.ask_yes_no(2, -1)
	if answer == 0 then
		event.fade_out_screen(15)
		wait.frames(15)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d02/d02.stb", 1000)
	end
	event.finish_event()
end
script[200] = script.examine_dungeon_gate

--- Gives the lapis, records the floor result and plays the acquisition scene.
function script.pick_up_lapis()
	local active_character: s32 = 0
	local stage_id: s32 = 0
	local dungeon_floor: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_character = event.get_playable_character() or active_character
		if active_character == 2 or active_character == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_character == 2 then
				resume_step = 1
				message.show_and_wait(0, 22, 5, 256, 208)
			else
				resume_step = 2
				message.show_and_wait(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.add_inventory_item(365, 1)
		event.fade_out_screen(10)
		resume_step = 3
		wait.frames(10)
		stage_id = event.get_dungeon_stage_id() or stage_id
		dungeon_floor = event.get_dungeon_floor() or dungeon_floor
		event.set_dungeon_floor_info(stage_id, dungeon_floor, 5, 2)
		resume_step = 4
		sleeping_earth_chamber.play_lapis_acquired()
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_wait_skipping(0, 23, 5, 256, 208)
			end
			return 0
		end
		if resume_step <= 4 then
			if resume_step <= 3 then
				resume_step = 4
				sleeping_earth_chamber.play_lapis_acquired()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.fade_in_screen(10)
					event.finish_event()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end
script[500] = script.pick_up_lapis

--- Event 550, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing so the engine skips its default handling.
function script.do_nothing() end
script[550] = script.do_nothing

--- Clears the battle monsters, enables the rapis point and starts the victory music after the boss is beaten.
function script.on_boss_defeated()
	event.initialize_event()
	event.clear_event_battle_monsters(-1)
	event.reset_action_character_motion(0)
	event.set_function_point_enabled("", "rapis", 1)
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	wait.background_load()
	event.load_music_pack(193)
	event.play_music(0)
	event.finish_event()
end
script[600] = script.on_boss_defeated

--- Runs the defeat sequence when the party is defeated.
function script.on_party_defeated()
	dungeon.run_defeat_sequence_with_message_silent(0)
end
script[1200] = script.on_party_defeated

--- Loads and places the boss and starts the battle music.
function script.start_boss_battle()
	event.initialize_event()
	vm.wait(1)
	event.load_dungeon_monster(609, 1)
	event.load_dungeon_monster(610, 0)
	event.place_dungeon_monster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(16384, 1)
	event.stop_music(0)
	wait.frames(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.finish_event()
end
script[26010] = script.start_boss_battle

return script
