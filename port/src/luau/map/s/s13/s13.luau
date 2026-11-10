--!strict
-- map/s/s13/s13.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_786b79f1 = require("@lib/event/helper_786b79f1")
local helper_874b82cd = require("@lib/event/helper_874b82cd")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_926d0569 = require("@lib/event/helper_926d0569")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d61bc810 = require("@lib/event/helper_d61bc810")
local helper_e787350a = require("@lib/event/helper_e787350a")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_objects = require("@lib/event/wait_objects")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(2694)
	flag = event.get_save_flag(624) or flag
	if flag == 1 then
		helper_926d0569()
	end
end

--- Helper function.
local function helper_10064()
	local var0: s32 = 0
	local block: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_music(0)
		helper_888ab2a3(4)
		event.load_music(190)
		event.play_music(0)
		var0 = event.load_sound_effect_file_3(5, "snd2/mon/en_281.sound.json") or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.show_dungeon_status_bar(0, 1.0)
		event.load_character(5, "dungeon/monster/e205e.gltf", "e205e", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_handle_sound_bank(2, var0)
		block = event.load_event_image_4(5, "textures/event/e600/e624/e624telop01.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_texture(0, "e624telop01", block)
		event.set_event_sprite_color(0, 128, 128, 128, 0)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 128)
		event.set_event_sprite_size(0, 512, 128)
		event.set_event_sprite_position(0, 256, 312)
		event.set_event_sprite_draw_pass(0, 1)
		event.attach_object_handle_to_sprite(3, 0)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_character_active(0, 0)
		event.set_object_sequence_position(2, 0.0, 0.0, -800.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "待機")
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(0.0, 20.0, 1200.0)
		event.set_camera_sequence_look_at(0.0, -700.0, -800.0)
		event.move_camera_sequence_eased(0.0, 5.0, -590.0, 0.0, 80.0, -800.0, 150, 2, 0.2)
		event.fade_in_screen(30)
		helper_888ab2a3(150)
		event.set_object_sequence_motion(2, "立ち", 2)
		helper_888ab2a3(30)
		wait_objects(2)
		event.set_object_sequence_motion(2, "攻撃１", 2)
		event.queue_object_sequence_next_motion(2, "立ち", 4)
		event.set_object_sequence_color(3, 128, 128, 128, 128, 30)
		helper_888ab2a3(30)
		helper_888ab2a3(30)
		event.set_object_sequence_color(3, 128, 128, 128, 0, 30)
		helper_888ab2a3(30)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(10)
	event.delete_event_image(0)
	event.show_dungeon_status_bar(1, 1.0)
	event.set_character_active(0)
end

--- Helper function.
local function helper_10cc8()
	local var0: s32 = 0
	local var1: s32 = 0
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(624, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_3(8, "snd2/sp/sp_006.sound.json") or var0
		var1 = event.load_sound_effect_file_2(2841) or var1
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.show_dungeon_status_bar(0, 1.0)
		event.change_directory("event/e600/e624/")
		event.load_message_file(0, 5, "e624.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e624_mints.gltf", "info", 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e624_monica.gltf", "info", 0)
		end
		event.set_character_active(0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e624_lapis_tuti.gltf", "info", 8)
		event.set_character_active(0, 8)
		event.attach_object_handle_to_character(1, 8)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.attach_object_sequence_to_object_frame(1, 0, "item", 0.0, 0.0, 0.0, -1)
		event.change_directory("")
		event.load_character(5, "event/itemget_ev/itemget_ev.gltf", "info", 9)
		event.set_character_active(0, 9)
		event.attach_object_handle_to_character(2, 1)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(2, 0)
		event.set_object_handle_visible(3, 0)
		event.set_object_handle_position(0, 0.0, 4.0, -920.0)
		event.set_object_handle_rotation(0, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.reset_object_handle_dynamic_animation(0)
		event.enable_drama_skip()
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-40.26, 20.64, -866.67)
		event.set_camera_sequence_look_at(-1.7, 36.27, -951.09)
		event.move_camera_sequence_eased(-29.36, 23.4, -890.54, -1.7, 36.27, -951.09, 90, 2, 1.0)
		event.play_sound_effect(var1, 0)
		event.fade_in_screen(30)
		helper_888ab2a3(30)
		if active_chr_no == 0 then
			helper_4116e6bb(6240010)
		else
			helper_4116e6bb(6240020)
		end
		event.clear_camera_sequence()
		event.stop_sound_effect(var1, 0)
		event.pause_music()
		event.attach_object_handle_to_map_part_3(30, "p01_s1301-m-m", "s1301_3-m0")
		event.set_object_handle_visible(30, 0)
		event.set_character_active(1, 8)
		event.set_character_active(1, 9)
		if active_chr_no == 0 then
			event.set_camera_sequence_position(0.0, 51.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 28.64, -917.36)
			event.move_camera_sequence_eased(0.0, 46.94, -952.38, 0.0, 28.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, 7.74, 35.0, -918.0)
			event.set_character_rotation(9, 0.2, 0.24, 0.0)
		else
			event.set_camera_sequence_position(0.0, 53.31, -963.58)
			event.set_camera_sequence_look_at(0.0, 30.64, -917.36)
			event.move_camera_sequence_eased(0.0, 48.94, -952.38, 0.0, 30.64, -917.36, 120, 2, 0.4)
			event.set_character_position(9, -4.45, 37.0, -918.0)
			event.set_character_rotation(9, 0.2, -0.24, 0.0)
		end
		event.set_character_motion(9, "発動", 6)
		event.set_object_sequence_motion(0, "ラピスゲット", 4, -1.0, 1)
		helper_888ab2a3(2)
		event.play_sound_effect(var0, 0)
		helper_888ab2a3(120)
		event.play_sound_effect(var1, 1)
		helper_e787350a(365, 1)
		event.fade_out_screen(30)
		helper_888ab2a3(30)
	end)
	vm.entry(9)
	event.cancel_drama_scene_skip()
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.stop_sound_effect(var1, 0)
	event.stop_sound_effect(var0, 0)
	event.play_music(0)
	event.set_object_handle_visible(2, 1)
	event.set_object_handle_visible(3, 1)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	helper_926d0569()
	helper_9dafbc83(0.0, 4.0, -920.0, 0.0)
	event.set_camera_look_at(0.0, 34.0, -920.0)
	event.set_camera_position(0.0, 44.0, -800.0)
	event.reset_follow_camera(0)
	helper_d61bc810(0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event.initialize_event()
	event_99()
	flag = event.get_save_flag(624) or flag
	if flag == 0 then
		helper_10064()
		event.set_function_point_enabled("", "rapis", 0)
		event.load_dungeon_monster(609, 1)
		event.load_dungeon_monster(610, 0)
		event.place_dungeon_monster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.set_save_control_bits(1, if flag == 0 then 1 else 0)
	helper_9dafbc83(0.0, 0.0, 1000.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 1000.0)
	event.set_camera_position(0.0, 40.0, 1120.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_10064

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	vm.wait(1)
	helper_c956b4a2(32)
end

--- Event 161, which map data, a script or the engine runs by number.
function script.event_161()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		at = 1
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
		at = 2
		helper_888ab2a3(6)
		event.set_character_motion(8, "発動", 1)
		event.set_object_sequence_motion(0, "タイムワープ", 6)
		event.queue_object_sequence_next_motion(0, "タイムワープL", 5)
		at = 3
		wait_objects(0)
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
		at = 4
		vm.wait(4)
		at = 5
		helper_c956b4a2(32)
		event.delete_character_extension_packs(0)
		event.delete_character(8)
		event.set_scene_status_flags(1, 0, 256, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				helper_038a2e4d(6)
			end
			if at <= 2 then
				helper_238b5abc(0)
			end
			if at <= 3 then
				print("pos[0]=", vm.float(pos_x), "---------------\n")
				print("pos[1]=", vm.float(pos_y), "---------------\n")
				print("pos[2]=", vm.float(pos_z), "---------------\n")
			end
			if at <= 4 then
				helper_874b82cd(32)
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local var2: any = 0
	event.initialize_event()
	event.reset_action_character_motion(0)
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		if active_chr_no == 2 then
			helper_75684dd8(0, 20, 5, 256, 208)
		else
			helper_75684dd8(0, 21, 5, 256, 208)
		end
		event.finish_event()
		return
	end
	flag = event.get_save_flag(624) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "まだラピスを手に入れてないよ！")
		helper_75684dd8(0, -1, 5, 256, 208)
		event.finish_event()
		return
	end
	var2 = helper_ed4dc120(2, -1)
	if var2 == 0 then
		event.fade_out_screen(15)
		helper_888ab2a3(15)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d02/d02.stb", 1000)
	end
	event.finish_event()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 or active_chr_no == 3 then
			event.set_message_window_mode(0, 1)
			event.set_message_draw_speed(0, 1)
			if active_chr_no == 2 then
				at = 1
				helper_75684dd8(0, 22, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 23, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.add_inventory_item(365, 1)
		event.fade_out_screen(10)
		at = 3
		helper_888ab2a3(10)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var2 = event.get_dungeon_floor() or var2
		event.set_dungeon_floor_info(stage_id, var2, 5, 2)
		at = 4
		helper_10cc8()
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(10)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 23, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				at = 4
				helper_10cc8()
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

--- Event 550, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_550() end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.initialize_event()
	event.clear_event_battle_monsters(-1)
	event.reset_action_character_motion(0)
	event.set_function_point_enabled("", "rapis", 1)
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	helper_479dc9e9()
	event.load_music_pack(193)
	event.play_music(0)
	event.finish_event()
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_786b79f1(0)
end

--- Event 26010, which map data, a script or the engine runs by number.
function script.event_26010()
	event.initialize_event()
	vm.wait(1)
	event.load_dungeon_monster(609, 1)
	event.load_dungeon_monster(610, 0)
	event.place_dungeon_monster(609, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(16384, 1)
	event.stop_music(0)
	helper_888ab2a3(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return script
