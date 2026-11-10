--!strict
-- map/s/s54/s54_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_45a6628c = require("@lib/event/helper_45a6628c")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_635196bf = require("@lib/event/helper_635196bf")
local helper_7348fd06 = require("@lib/event/helper_7348fd06")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_e412b50e = require("@lib/event/helper_e412b50e")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8684)
	flag = event.get_save_flag(808) or flag
	if flag == 1 then
		helper_635196bf()
	end
end

--- Event 28010, which map data, a script or the engine runs by number.
local function event_28010()
	event.initialize_event()
	event.fade_out_screen(0)
	vm.wait(1)
	event.stop_music(0)
	wait_frames(6)
	event.load_music(107)
	event.play_music(0)
	event.load_dungeon_monster(628, 1)
	event.load_dungeon_monster(1006, 0)
	event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	helper_7d7eee8f(0.0, 0.0, 300.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 300.0)
	event.set_camera_position(0.0, 40.0, 180.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	helper_7d7eee8f(0.0, 0.0, 0.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, 0.0)
	event.set_camera_position(0.0, 40.0, -120.0)
	event.reset_follow_camera(0)
	flag = event.get_save_flag(808) or flag
	if flag == 0 then
		helper_e412b50e()
		event.set_save_control_bits(1, 1)
		vm.wait(2)
		helper_7d7eee8f(0.0, 0.0, 300.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 300.0)
		event.set_camera_position(0.0, 40.0, 180.0)
		event.reset_follow_camera(0)
		event.load_dungeon_monster(628, 1)
		event.load_dungeon_monster(1006, 0)
		event.place_dungeon_monster(628, 0.0, 0.0, 800.0, 0.0, 3.14, 0.0)
	end
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = event_28010

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
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
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var1 = helper_bac0e30d(0, 10, 8, 256, 208, 2, 1)
	if var1 == 0 then
		event.fade_out_screen(30)
		wait_frames(30)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var3 = event.get_dungeon_floor() or var3
		argc = event.get_dungeon_next_floor(var3, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var3, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		event.stop_music(0)
		event.clear_event_battle_monsters(-1)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		at = 2
		helper_7348fd06()
		event.set_save_control_bits(1, 0)
		helper_635196bf()
		helper_7d7eee8f(0.0, 0.0, 700.0, 0.0)
		event.set_camera_look_at(0.0, 30.0, 700.0)
		event.set_camera_position(0.0, 40.0, 580.0)
		event.reset_follow_camera(0)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_7348fd06()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					helper_635196bf()
					helper_7d7eee8f(0.0, 0.0, 700.0, 0.0)
					event.set_camera_look_at(0.0, 30.0, 700.0)
					event.set_camera_position(0.0, 40.0, 580.0)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					return
				end)
			end
			helper_45a6628c()
			helper_43f02c95(0.0, 0.0, 700.0, 0.0)
			return 0
		end
		return nil
	end)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.get_save_flag(808) or flag
		flag_2 = event.get_save_flag(812) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = 0
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_47084b1b(0, 8590060)
			else
				at = 2
				helper_47084b1b(0, 8590070)
			end
			return
		end
		at = 3
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8590070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 18080, which map data, a script or the engine runs by number.
function script.event_18080()
	event_99()
	helper_e412b50e()
end

--- Event 18120, which map data, a script or the engine runs by number.
function script.event_18120()
	event_99()
	helper_7348fd06()
end

script.event_28010 = event_28010

return script
