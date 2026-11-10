--!strict
-- map/f/f03/f03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_08c337b8 = require("@lib/event/helper_08c337b8")
local helper_13ff22fe = require("@lib/event/helper_13ff22fe")
local helper_174a45a0 = require("@lib/event/helper_174a45a0")
local helper_3a1e288a = require("@lib/event/helper_3a1e288a")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_575b46f3 = require("@lib/event/helper_575b46f3")
local helper_65897c2c = require("@lib/event/helper_65897c2c")
local helper_6be25ed2 = require("@lib/event/helper_6be25ed2")
local helper_72334e82 = require("@lib/event/helper_72334e82")
local helper_72cb617b = require("@lib/event/helper_72cb617b")
local helper_7c46eb56 = require("@lib/event/helper_7c46eb56")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_958259d1 = require("@lib/event/helper_958259d1")
local helper_d0e95767 = require("@lib/event/helper_d0e95767")
local helper_fb78ba4a = require("@lib/event/helper_fb78ba4a")
local set_window_mode = require("@lib/event/set_window_mode")
local show_message = require("@lib/event/show_message")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local var0: s32 = 0
	event.attach_object_handle_to_map_part_2(1, "p04_f0301")
	var0 = helper_6be25ed2()
	if var0 == 0 then
		event.set_function_point_enabled("", "event_400", 0)
		event.set_function_point_enabled("", "event_401", 0)
		event.set_function_point_enabled("", "event_402", 0)
		event.set_function_point_enabled("", "event_403", 0)
		event.set_function_point_enabled("", "event_404", 0)
	else
		event.set_object_handle_visible(1, 0)
	end
	if helper_13ff22fe() == 0 then
		event.attach_object_handle_to_map_part_2(1, "p14_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p15_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p16_f0301")
		event.set_object_handle_visible(1, 0)
		event.attach_object_handle_to_map_part_2(1, "p17_f0301")
		event.set_object_handle_visible(1, 0)
	end
	helper_d0e95767()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local var1: s32 = 0
	local old_map_no: s32 = 0
	local var3: s32 = 0
	local old_sub_map_no: s32 = 0
	local get_old_interior_map_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		helper_d0e95767()
		event.get_georama_analysis_percent(2)
		var1 = 0
		if helper_72334e82() ~= 0 then
			var1 = 1
			at = 1
			helper_174a45a0()
		end
		if helper_72cb617b() ~= 0 then
			var1 = 1
			at = 2
			helper_7c46eb56()
		end
		if helper_08c337b8() ~= 0 then
			var1 = 1
			event.skip_next_music_play()
			event.jump_to_map_3(-1, "f03i0301", 504)
			at = 3
			vm.wait(3)
		end
		if var1 == 1 then
			return
		end
		old_map_no = event.get_previous_map() or old_map_no
		if old_map_no == 2 then
			event.initialize_event()
			at = 4
			vm.wait(4)
			helper_7d7eee8f(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			event.reset_follow_camera(1, 3.14, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 110 then
			event.initialize_event()
			at = 5
			vm.wait(5)
			var3 = event.get_save_counter(2) or var3
			if var3 == 0 then
				helper_7d7eee8f(0.0, 360.0, -755.0, 0.0)
			end
			if var3 == 1 then
				helper_7d7eee8f(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
			end
			if var3 == 2 then
				helper_7d7eee8f(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
			end
			if var3 == 3 then
				helper_7d7eee8f(315.0, 280.0, -1515.0, vm.f32(2.3561945))
			end
			if var3 == 4 then
				helper_7d7eee8f(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 113 then
			event.initialize_event()
			at = 6
			vm.wait(6)
			helper_7d7eee8f(1080.0, 190.0, -120.0, vm.f32(-2.355))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 141 then
			event.initialize_event()
			at = 7
			vm.wait(7)
			helper_7d7eee8f(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 142 then
			event.initialize_event()
			at = 8
			vm.wait(8)
			helper_7d7eee8f(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		if old_map_no == 114 then
			event.initialize_event()
			at = 9
			vm.wait(9)
			helper_7d7eee8f(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			event.reset_follow_camera(1, 0.0, 2.0)
			event.fade_in_screen(30)
		end
		old_sub_map_no = event.get_previous_submap() or old_sub_map_no
		get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
		print("map_no=", old_map_no, "##############\n")
		print("old_submap_no=", old_sub_map_no, "##############\n")
		print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				local _ = helper_575b46f3()
				var1 = 1
				at = 2
				helper_7c46eb56()
				return vm.continue_with(function()
					if helper_08c337b8() ~= 0 then
						var1 = 1
						event.skip_next_music_play()
						event.jump_to_map_3(-1, "f03i0301", 504)
						at = 3
						vm.wait(3)
					end
					if var1 == 1 then
						return
					end
					old_map_no = event.get_previous_map() or old_map_no
					if old_map_no == 2 then
						event.initialize_event()
						at = 4
						vm.wait(4)
						helper_7d7eee8f(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
						event.reset_follow_camera(1, 3.14, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 110 then
						event.initialize_event()
						at = 5
						vm.wait(5)
						var3 = event.get_save_counter(2) or var3
						if var3 == 0 then
							helper_7d7eee8f(0.0, 360.0, -755.0, 0.0)
						end
						if var3 == 1 then
							helper_7d7eee8f(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
						end
						if var3 == 2 then
							helper_7d7eee8f(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
						end
						if var3 == 3 then
							helper_7d7eee8f(315.0, 280.0, -1515.0, vm.f32(2.3561945))
						end
						if var3 == 4 then
							helper_7d7eee8f(315.0, 280.0, -885.0, vm.f32(0.7853982))
						end
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 113 then
						event.initialize_event()
						at = 6
						vm.wait(6)
						helper_7d7eee8f(1080.0, 190.0, -120.0, vm.f32(-2.355))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 141 then
						event.initialize_event()
						at = 7
						vm.wait(7)
						helper_7d7eee8f(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 142 then
						event.initialize_event()
						at = 8
						vm.wait(8)
						helper_7d7eee8f(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					if old_map_no == 114 then
						event.initialize_event()
						at = 9
						vm.wait(9)
						helper_7d7eee8f(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
						event.reset_follow_camera(1, 0.0, 2.0)
						event.fade_in_screen(30)
					end
					old_sub_map_no = event.get_previous_submap() or old_sub_map_no
					get_old_interior_map_no = event.get_previous_interior_map() or get_old_interior_map_no
					print("map_no=", old_map_no, "##############\n")
					print("old_submap_no=", old_sub_map_no, "##############\n")
					print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
					return
				end)
			end
			if at <= 2 then
				local _ = helper_fb78ba4a()
				var1 = 1
			end
			return 0
		end
		if at <= 9 then
			if at <= 4 then
				helper_43f02c95(160.0, vm.f32(286.2), 1849.5, vm.f32(-2.87))
			end
			if at <= 5 then
				helper_43f02c95(0.0, 360.0, -755.0, 0.0)
				helper_43f02c95(-315.0, 280.0, -885.0, vm.f32(-0.7853982))
				helper_43f02c95(-315.0, 280.0, -1515.0, vm.f32(-2.3561945))
				helper_43f02c95(315.0, 280.0, -1515.0, vm.f32(2.3561945))
				helper_43f02c95(315.0, 280.0, -885.0, vm.f32(0.7853982))
			end
			if at <= 6 then
				helper_43f02c95(1080.0, 190.0, -120.0, vm.f32(-2.355))
			end
			if at <= 7 then
				helper_43f02c95(vm.f32(-1080.6), 190.0, vm.f32(-2277.9), vm.f32(0.77))
			end
			if at <= 8 then
				helper_43f02c95(vm.f32(1050.1), 190.0, vm.f32(-2249.6), vm.f32(-0.77))
			end
			helper_43f02c95(vm.f32(-1078.3), 190.0, -117.5, vm.f32(2.36))
			print("map_no=", old_map_no, "##############\n")
			print("old_submap_no=", old_sub_map_no, "##############\n")
			print("old_interior_map_no=", get_old_interior_map_no, "##############\n")
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.open_message_window_2(0, "No se abre. Probemos m[UNI00e1]s tarde.")
	show_message(0, -1, 5, 256, 208)
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_65897c2c(160.0, vm.f32(286.2), 1849.5, 0.0)
	event.jump_to_map_2(-1, "g03")
	vm.wait(2)
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	helper_3a1e288a(vm.f32(3.1415927), 1)
	event.set_save_counter(2, 0)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 401, which map data, a script or the engine runs by number.
function script.event_401()
	helper_3a1e288a(vm.f32(0.7853982), 0)
	event.set_save_counter(2, 2)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 402, which map data, a script or the engine runs by number.
function script.event_402()
	helper_3a1e288a(vm.f32(2.3561945), 0)
	event.set_save_counter(2, 1)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 403, which map data, a script or the engine runs by number.
function script.event_403()
	helper_3a1e288a(vm.f32(-2.3561945), 0)
	event.set_save_counter(2, 4)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 404, which map data, a script or the engine runs by number.
function script.event_404()
	helper_3a1e288a(vm.f32(-0.7853982), 0)
	event.set_save_counter(2, 3)
	event.jump_to_map_2(-1, "f03i04")
	vm.wait(2)
end

--- Event 405, which map data, a script or the engine runs by number.
function script.event_405()
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_3a1e288a(vm.f32(0.7853982), 0)
	flag = event.get_save_flag(408) or flag
	flag_2 = event.get_save_flag(412) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.skip_next_music_load()
	end
	event.jump_to_map_3(-1, "f03i0301", 100)
	vm.wait(2)
end

--- Event 406, which map data, a script or the engine runs by number.
function script.event_406()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	flag = event.get_save_flag(400) or flag
	flag_2 = event.get_save_flag(420) or flag_2
	if flag == 1 and flag_2 == 0 then
		event.set_character_motion(0, "立ち")
		set_window_mode(0, 1)
		event.open_message_window_2(0, "No se abre. Probemos m[UNI00e1]s tarde.")
		show_message(0, -1, 5, 256, 208)
		return
	else
		flag_3 = event.get_save_flag(428) or flag_3
		if flag_3 == 0 then
			event.skip_next_music_load()
		end
	end
	helper_3a1e288a(vm.f32(-2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0302", 100)
	vm.wait(3)
end

--- Event 407, which map data, a script or the engine runs by number.
function script.event_407()
	helper_3a1e288a(vm.f32(2.3561945), 0)
	event.jump_to_map_3(-1, "f03i0303", 100)
	vm.wait(2)
end

--- Event 408, which map data, a script or the engine runs by number.
function script.event_408()
	helper_3a1e288a(vm.f32(-0.7853982), 0)
	event.jump_to_map_3(-1, "f03i0304", 100)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_958259d1

--- Event 14560, which map data, a script or the engine runs by number.
function script.event_14560()
	event.set_georama_analyze_flag(2, 2, 0)
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_save_flag(456, 0)
	event.set_save_flag(460, 1)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end

--- Event 14600, which map data, a script or the engine runs by number.
function script.event_14600()
	event.set_georama_analyze_flag(2, 3, 0)
	event.set_georama_analyze_flag(2, 4, 0)
	event.set_georama_analyze_flag(2, 5, 0)
	event.set_georama_analyze_flag(2, 6, 0)
	event.set_georama_analyze_flag(2, 7, 0)
	event.set_georama_analyze_flag(2, 8, 0)
	event.set_georama_analyze_flag(2, 9, 0)
	event.set_georama_analyze_flag(2, 0, 1)
	event.set_georama_analyze_flag(2, 1, 1)
	event.set_georama_analyze_flag(2, 2, 1)
	event.set_save_flag(456, 1)
	event.set_save_flag(460, 0)
	event.jump_to_map_3(-1, 82, 100)
	vm.wait(1)
end

return script
