--!strict
-- map/s/s42/s42_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_17043bf1 = require("@lib/event/helper_17043bf1")
local helper_387dadc7 = require("@lib/event/helper_387dadc7")
local helper_51dafe33 = require("@lib/event/helper_51dafe33")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_9e60b8f3 = require("@lib/event/helper_9e60b8f3")
local helper_bac0e30d = require("@lib/event/helper_bac0e30d")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_e94c()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local yaw: f32 = 0
	local var14: s32 = 0
	local var15: s32 = 0
	event.initialize_event()
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, 9)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local _, out2, _ = event.get_character_rotation(0)
		var4 = out2 or var4
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	event.get_character_rotation(9)
	yaw = event.get_direction_angle(var0, var1, var2, var6, var7, var8) or yaw
	event.get_direction_angle(var6, var7, var8, var0, var1, var2)
	var14 = 0
	var15 = event.compare_angles(var4, yaw, 0.1) or var15
	if var15 ~= 0 then
		event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
		event.set_object_sequence_motion(0, "歩き")
		event.delay_object_sequence_motion_track(0, 10)
		var14 = 20
	end
	event.set_object_sequence_motion(0, "立ち")
	wait_frames(var14)
	event.open_message_window_2(0, "Il est sur le bureau, en bas.\nMets-toi au travail.")
	helper_0ffc2526(0, -1, 9, 0, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_387dadc7()
	event.take_memory_card_load_state()
	event.set_time_of_day_advancing(0)
	event.set_character_position(0, 49.9, 24.7, -68.2)
	event.set_character_rotation(0, 0.0, 0.0, 0.0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "Tu n'as pas encore fini le travail\nque t'a demand[UNI00e9] C[UNI00e9]dric.")
	show_message(0, -1, 5, 0, 0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.set_save_counter(5, 0)
	helper_9e60b8f3()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	local var0: s32 = 0
	local argc: s32 = 0
	local var2: any = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.set_character_motion(0, "立ち")
		var0 = 0
		event.set_message_window_mode(0, 1)
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		argc = event.get_owned_item_count(382) or argc
		if argc <= 0 then
			event.open_message_window_2(0, "Voyons voir... Les outils [UNI00e9]taient\ndans le cabinet, au fond...")
			at = 1
			show_message(0, -1, 5, 0, 0)
		else
			event.set_message_selection_top_line(0, 1)
			event.set_message_window_option(0, 0, 1)
			event.set_message_window_option(0, 1, 1)
			argc = event.get_owned_item_count(386) or argc
			if argc <= 0 then
				event.open_message_window_2(
					0,
					"[UNI00c7]a doit [UNI00ea]tre l'aspirateur de Gable.\nIl n'a pas l'air encore termin[UNI00e9].\nBon je ferais mieux de m'y mettre !"
				)
				at = 2
				var2 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var2 == 2 then
					var0 = 1
				end
			else
				event.open_message_window_2(
					0,
					"[UNI00c7]a doit [UNI00ea]tre l'aspirateur de Gable.\nOK ! Il est temps de le r[UNI00e9]parer !\nJe m'y mettrai un peu plus tard."
				)
				at = 3
				var2 = helper_bac0e30d(0, -1, 5, 256, 208, 2, 1)
				if var2 == 1 then
					var0 = 1
				end
			end
			event.set_message_window_option(0, 0, 0)
			event.set_message_window_option(0, 1, 0)
			event.set_message_selection_top_line(0, 0)
		end
		event.set_message_bubble_tail(0, 1)
		if var0 == 1 then
			at = 4
			helper_17043bf1()
			event.jump_to_map_3(-1, "m06", 151)
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 2 then
				var2 = received[1] :: number
			end
			if at == 3 then
				var2 = received[1] :: number
			end
			if at <= 1 then
				var2 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 2 then
				var0 = 1
				var2 = helper_7d54f41c(0, -1, 5, 256, 208, 2, 1)
			end
			if at <= 3 then
				local _ = var2 == 2
				var0 = 1
				at = 4
				helper_17043bf1()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "m06", 151)
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_51dafe33()
	event.jump_to_map_3(-1, "m08", 151)
end

--- Event 510, which map data, a script or the engine runs by number.
script.event_510 = helper_e94c

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var0, var1, var2, 10)
	wait_frames(10)
	helper_f38eabca(382, 1)
	event.add_inventory_item(382)
	event.set_function_point_enabled("", "item1", 0)
end

--- Event 521, which map data, a script or the engine runs by number.
function script.event_521()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	event.initialize_event()
	do
		local out1, out2, out3 = event.get_triggered_event_data_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.delay_object_sequence_motion_track(0, 10)
	event.set_object_sequence_motion(0, "立ち")
	event.turn_object_sequence_toward(0, var0, var1, var2, 10)
	wait_frames(10)
	event.attach_object_handle_to_map_part_2(1, "memo")
	event.set_object_handle_visible(1, 0)
	helper_f38eabca(386, 1)
	event.add_inventory_item(386)
	event.set_function_point_enabled("", "item2", 0)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 0)
	event.open_message_window_2(0, "On dirait qu'il y a un livre assez\nint[UNI00e9]ressant, mais difficile d'en dire plus...")
	show_message(0, -1, 5, 0, 0)
end

return script
