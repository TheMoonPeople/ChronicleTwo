--!strict
-- map/s/s06/s06c_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2a1e9b48 = require("@lib/event/helper_2a1e9b48")
local helper_5a05ed59 = require("@lib/event/helper_5a05ed59")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_8a5b59a2 = require("@lib/event/helper_8a5b59a2")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local wait_frames = require("@lib/event/wait_frames")

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
local function edit_analyze_changed()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	active_chr_no = event.get_playable_character() or active_chr_no
	event.reset_action_character_motion(0)
	flag = event.get_save_flag(7) or flag
	if flag == 0 then
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		var2 = event.set_party_member(2) or var2
		if var2 ~= 0 then
			var1 = event.get_message_window_frame(0) or var1
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.open_message_window_2(0, "Pas le temps pour [UNI00e7]a !")
			helper_75684dd8(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, var1)
			vm.wait(2)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		else
			event.set_character_motion(0, "立ち")
			var1 = event.get_message_window_frame(0) or var1
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			flag = event.get_save_flag(104) or flag
			if flag == 1 then
				event.open_message_window_2(0, "La porte semble verrouill[UNI00e9]e.\nRemontons pour l'instant.")
			else
				event.open_message_window_2(0, "Pas le temps pour [UNI00e7]a !")
			end
			helper_75684dd8(0, -1, 5, 0, 0)
			event.set_message_window_mode(0, var1)
			vm.wait(4)
			event.set_dungeon_pause_flags(1, 0)
			event.finish_event()
			return
		end
	end
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 2 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.open_message_window_2(0, "On dirait que pour pouvoir\navancer, tu dois descendre du\nRobomobil.")
		helper_75684dd8(0, -1, 8, 256, 208)
		event.finish_event()
		return
	end
	if active_chr_no == 3 then
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		helper_75684dd8(0, 21, 8, 256, 208)
		event.finish_event()
		return
	end
	event.set_message_window_mode(0, 5)
	event.set_message_draw_speed(0, 1)
	var5 = helper_ed4dc120(1, -1)
	if var5 == 0 then
		event.set_save_control_bits(1, 0)
		stage_id = event.get_dungeon_stage_id() or stage_id
		var7 = event.get_dungeon_floor() or var7
		argc = event.get_dungeon_next_floor(var7, 0) or argc
		event.set_dungeon_floor(argc)
		event.set_dungeon_floor_info(stage_id, var7, 5, 2)
		event.set_dungeon_floor_info(stage_id, argc, 5, 1)
		event.fade_out_screen(30)
		wait_frames(30)
		flag = event.get_save_flag(8) or flag
		if flag == 0 then
			event.stop_music(0)
			event.set_save_flag(8, 1)
			event.skip_next_music_load()
			event.go_to_georama_edit(12, 540)
			vm.wait(9)
			return
		end
		event.skip_next_music_load()
		event.go_to_dungeon(0, 5, 1000)
		vm.wait(10)
	end
	event.finish_event()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 300, which map data, a script or the engine runs by number.
script.event_300 = edit_analyze_changed

script.edit_analyze_changed = edit_analyze_changed

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.fade_out_music(15)
		event.fade_out_screen(15)
		at = 1
		wait_frames(15)
		event.set_dungeon_pause_flags(17, 1)
		at = 2
		vm.wait(2)
		event.stop_music(0)
		at = 3
		helper_8a5b59a2()
		event.set_save_control_bits(1, 0)
		event.set_save_data_value(0, 3)
		event.skip_next_music_load()
		event.go_to_georama_edit(10, 530)
		at = 4
		vm.wait(4)
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 2 then
				at = 3
				helper_8a5b59a2()
				return vm.continue_with(function()
					event.set_save_control_bits(1, 0)
					event.set_save_data_value(0, 3)
					event.skip_next_music_load()
					event.go_to_georama_edit(10, 530)
					at = 4
					vm.wait(4)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	event.set_dungeon_pause_flags(17, 1)
	helper_8a5b59a2()
	event.fade_in_screen(30)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			flag = event.get_save_flag(7) or flag
			if flag == 0 then
				event.set_save_flag(6, 1)
				at = 1
				vm.wait(1)
				event.load_event_script("s06/s06.stb", 503)
			else
				at = 2
				helper_2a1e9b48(0)
			end
		else
			at = 3
			helper_2a1e9b48(0)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_5a05ed59(0)
			end
			if at <= 2 then
				helper_5a05ed59(0)
			end
			return 0
		end
		return nil
	end)
end

return script
