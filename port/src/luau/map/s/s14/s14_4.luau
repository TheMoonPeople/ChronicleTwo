--!strict
-- map/s/s14/s14_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_2f0e8881 = require("@lib/event/helper_2f0e8881")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_926d0569 = require("@lib/event/helper_926d0569")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_d618d1b4 = require("@lib/event/helper_d618d1b4")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(3694)
	flag = event.get_save_flag(628) or flag
	if flag == 1 then
		helper_926d0569()
	end
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
	flag = event.get_save_flag(628) or flag
	if flag == 0 then
		helper_d618d1b4()
		event.set_function_point_enabled("", "rapis", 0)
		event.load_dungeon_monster(611, 1)
		event.place_dungeon_monster(611, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	end
	event.set_save_control_bits(1, if flag == 0 then 1 else 0)
	helper_9dafbc83(0.0, 0.0, 850.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, 850.0)
	event.set_camera_position(0.0, 40.0, 970.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_d618d1b4

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
	flag = event.get_save_flag(628) or flag
	if flag == 0 then
		event.set_message_window_mode(0, 1)
		event.set_message_draw_speed(0, 1)
		event.open_message_window_2(0, "Non hai ancora la gemma!")
		helper_75684dd8(0, -1, 5, 256, 208)
		event.finish_event()
		return
	end
	var2 = helper_ed4dc120(2, -1)
	if var2 == 0 then
		event.fade_out_screen(15)
		wait_frames(15)
		event.clear_event_battle_monsters(-1)
		event.load_event_script("d03/d03.stb", 1000)
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
		event.add_inventory_item(367, 1)
		event.fade_out_screen(10)
		at = 3
		wait_frames(10)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var2 = event.get_dungeon_floor() or var2
		event.set_dungeon_floor_info(stage_id, var2, 5, 2)
		at = 4
		helper_2f0e8881()
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
				helper_2f0e8881()
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

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_2a1e9b48(0)
end

--- The dungeon system event run when every monster on the floor has been defeated.
function script.floor_clear()
	event.initialize_event()
	event.reset_action_character_motion(0)
	event.clear_event_battle_monsters(-1)
	event.set_function_point_enabled("", "rapis", 1)
	event.start_background_file_loads_1("snd2/bgm/bg_193.sound.json")
	helper_479dc9e9()
	event.load_music_pack(193)
	event.play_music(0)
	event.finish_event()
end

--- Event 26020, which map data, a script or the engine runs by number.
function script.event_26020()
	event.initialize_event()
	vm.wait(1)
	event.load_dungeon_monster(611, 1)
	event.place_dungeon_monster(611, 0.0, 0.0, -800.0, 0.0, 0.0, 0.0)
	event.set_dungeon_pause_flags(16384, 1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(190)
	event.play_music(0)
	event.fade_in_screen(30)
	event.finish_event()
end

return script
