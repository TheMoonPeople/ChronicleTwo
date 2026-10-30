--!strict
-- map/s/s08/s08_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_5fbdba13 = require("@lib/event/helper_5fbdba13")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_976e3050 = require("@lib/event/helper_976e3050")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

local global0: s32 = 0

--- Helper function.
local function helper_23d98()
	event.play_sound_effect(global0, 2)
	event.play_sound_effect(global0, 8)
end

--- Helper function.
local function helper_23e54()
	event.initialize_event()
	global0 = 0
	event.load_map_sounds(2200)
	global0 = event.load_sound_effect_file_2(2200) or global0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_character_active(1, 9)
	event.set_character_position(9, 5.62, 36.1, 39.9)
	event.set_character_rotation(9, 0.0, 3.04, 0.0)
	event.set_character_motion(9, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.attach_object_handle_to_character(2, 10)
	event.clear_object_sequence(2)
	event.set_object_sequence_object(2, 2)
	event.set_character_active(1, 10)
	event.set_character_position(10, -38.37, 36.08, 32.88)
	event.set_character_rotation(10, 0.0, 1.48, 0.0)
	event.set_character_motion(10, "立ち", 4)
	event.load_character(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.attach_object_handle_to_character(3, 11)
	event.clear_object_sequence(3)
	event.set_object_sequence_object(3, 3)
	event.set_character_active(1, 11)
	event.set_character_position(11, -1.81, 36.1, 72.51)
	event.set_character_rotation(11, 0.0, -0.48, 0.0)
	event.set_character_motion(11, "立ち", 4)
	event.set_object_handle_sound_bank(3, global0)
	event.register_villager(9, 1)
	event.register_villager(10, 2)
	event.register_villager(11, 13, 65)
	event.set_scene_character_number(9, 1)
	event.set_scene_character_number(10, 2)
	event.set_scene_character_number(11, 13)
	helper_23d98()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	helper_19b130fb()
	helper_8b00b423()
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_7f754b8f(1)
		event.set_save_control_bits(1, 1)
	else
		helper_7f754b8f(0)
	end
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, 38.0, 36.1, -100.0)
		event.set_character_rotation(0, 0.0, 0.0, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
	end
	if flag == 1 and flag_2 == 0 then
		helper_23e54()
	end
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
	show_message(0, 1002, 8, 450, 100)
	event.do_nothing(0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 1)
		event.fade_out_screen(0)
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.set_save_control_bits(1, 0)
		event.set_save_counter(15, 0)
		event.fade_out_screen(0)
		event.stop_music(0)
		helper_5be5f988()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.set_save_control_bits(1, 0)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.set_save_counter(0, 1)
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_character_position(0, 0.0, 36.0, 235.0)
		event.set_character_rotation(0, 0.0, 3.14, 0.0)
		event.jump_to_map_2(-1, "s07")
	end
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.set_save_control_bits(1, 0)
		event.fade_in_screen(30)
		event.stop_sound_effect(global0, 2)
		event.stop_sound_effect(global0, 8)
		event.jump_to_map_3(-1, "s03", 501)
		vm.wait(1)
	end
end

--- Event 205, which map data, a script or the engine runs by number.
function script.event_205()
	local var0: s32 = 0
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 206, which map data, a script or the engine runs by number.
function script.event_206()
	local var0: s32 = 0
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 208, which map data, a script or the engine runs by number.
function script.event_208()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 209, which map data, a script or the engine runs by number.
function script.event_209()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.get_save_flag(203) or flag
	flag_2 = event.get_save_flag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.request_town_edit_event(0)
		vm.wait(1)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.set_save_data_value(3, 1)
	helper_f57795f8()
	event.set_save_data_value(3, 0)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23e54()
	helper_5fbdba13()
	event.set_save_control_bits(1, 1)
	helper_23d98()
	event.fade_in_screen(30)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_976e3050()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	set_window_mode(0, 1)
	if var0 == 9 then
		event.open_message_window_2(0, "Quit stalling.\nHurry up and climb that ladder!")
	end
	if var0 == 10 then
		event.open_message_window_2(
			0,
			"This is no time to be chattering\non about the world! Max, hurry up\nand see what it looks like outside!"
		)
	end
	if var0 == 11 then
		event.open_message_window_2(
			0,
			"Judging by those shocks, I'd say\nthey were pretty small bombs.<page>I just hope they don't hit anything\ncritical."
		)
	end
	helper_1c04a0eb(var0, -1, 0, 0)
end

--- Event 12030, which map data, a script or the engine runs by number.
function script.event_12030()
	helper_23e54()
	helper_5fbdba13()
	helper_23d98()
	event.fade_in_screen(30)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	helper_976e3050()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "s03", 512)
	vm.wait(2)
end

return script
