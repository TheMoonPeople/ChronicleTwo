--!strict
-- map/d/d07/b01/d07b01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38cda040 = require("@lib/event/helper_38cda040")
local helper_43f02c95 = require("@lib/event/helper_43f02c95")
local helper_47084b1b = require("@lib/event/helper_47084b1b")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7c656a4f = require("@lib/event/helper_7c656a4f")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_80ad60c2 = require("@lib/event/helper_80ad60c2")
local helper_8e1771b9 = require("@lib/event/helper_8e1771b9")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_dac13067 = require("@lib/event/helper_dac13067")
local helper_dbff9fb6 = require("@lib/event/helper_dbff9fb6")
local helper_ed4dc120 = require("@lib/event/helper_ed4dc120")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_f0ee9a01 = require("@lib/event/helper_f0ee9a01")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local flag: s32 = 0
	event.stop_music(0)
	event.load_map_sounds(8693)
	flag = event.get_save_flag(820) or flag
	if flag == 1 then
		event.attach_object_handle_to_map_part_2(0, "p04")
		event.set_object_handle_visible(0, 0)
		event.set_function_point_enabled("p04", "func", 0)
	end
end

--- Event 28020, which map data, a script or the engine runs by number.
local function event_28020()
	event.initialize_event()
	event.fade_out_screen(0)
	event.attach_object_handle_to_map_part_2(0, "p06")
	event.set_object_handle_visible(0, 1)
	event.stop_music(0)
	wait_frames(6)
	event.load_music(40)
	event.play_music(0)
	event.load_dungeon_monster(629, 1)
	event.load_dungeon_monster(630, 0)
	event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
	helper_7d7eee8f(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
	event.set_camera_look_at(438.61, 30.0, 192.19)
	event.set_camera_position(590.29, 39.11, 243.1)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	vm.wait(2)
	event.finish_event()
end

--- Helper function.
local function helper_17348()
	local language_code: s32 = 0
	local block: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.fade_out_screen(0)
		event.stop_all_sounds()
		at = 1
		wait_frames(6)
		event.fade_in_screen(0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		language_code = event.get_language() or language_code
		print("GET_LANGUAGE=", language_code, "\n")
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
			event.set_movie_caption(1, 2, vm.ftoi(vm.f32(109.8)), "Gut, das reicht jetzt.", vm.ftoi(vm.f32(50.7)))
			event.set_movie_caption(
				1,
				4,
				vm.ftoi(vm.f32(241.80002)),
				"Heute startet die Blackstone-Bahn \neine Reise durch die gesamte Region.",
				vm.ftoi(vm.f32(160.20001))
			)
			event.set_movie_caption(
				1,
				5,
				vm.ftoi(vm.f32(555.9)),
				"Ich hoffe, die Welt folgt diesem Beispiel\nund strebt nach neuem Fortschritt.",
				vm.ftoi(vm.f32(143.40001))
			)
			event.set_movie_caption(
				1,
				6,
				vm.ftoi(vm.f32(788.4)),
				"Mann, der B[UNI00fc]rgermeister zeigt W[UNI00fc]rde.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(1, 7, vm.ftoi(vm.f32(897.3)), "Ja, stimmt.", vm.ftoi(vm.f32(33.6)))
			event.set_movie_caption(
				1,
				8,
				vm.ftoi(937.5),
				"Es liegen schwere Zeiten vor uns,\naber wenn wir zusammenhalten,\nstehen wir das durch!",
				vm.ftoi(vm.f32(234.6))
			)
			event.set_movie_caption(
				1,
				10,
				vm.ftoi(1294.5),
				"Ihr, die B[UNI00fc]rger von Palm Brinks, habt so \nviel durchgemacht, euch allen geh[UNI00f6]rt\nder heutige Jubeltag!!",
				vm.ftoi(vm.f32(311.1))
			)
			event.set_movie_caption(
				1,
				12,
				vm.ftoi(vm.f32(1611.6001)),
				"Einst lag unsere ganze Welt im Dunkeln.",
				vm.ftoi(vm.f32(96.6))
			)
			event.set_movie_caption(
				1,
				13,
				vm.ftoi(vm.f32(1820.7)),
				"Doch die Menschen wehrten sich und erk[UNI00e4]mpften sich\nihre Zukunft.",
				vm.ftoi(vm.f32(99.299995))
			)
			event.set_movie_caption(
				1,
				14,
				vm.ftoi(vm.f32(2121.6)),
				"Leider durften die folgenden Generationen nie \nvon der Geschichte ihres Kampfes erfahren.",
				vm.ftoi(vm.f32(128.40001))
			)
			event.set_movie_caption(
				1,
				15,
				vm.ftoi(vm.f32(2328.6)),
				"Ist diese unglaubliche Geschichte wirklich passiert?\nMan wird es nie wissen.",
				vm.ftoi(vm.f32(209.09999))
			)
			event.set_movie_caption(
				1,
				16,
				vm.ftoi(vm.f32(2623.2002)),
				"Aber ...\nWenn ihr den Mond fragen k[UNI00f6]nntet, der [UNI00fc]ber allem wacht,\nh[UNI00e4]tte er euch einiges von unserem seltsamen\nAbenteuer zu erz[UNI00e4]hlen.",
				vm.ftoi(vm.f32(242.70001))
			)
			event.set_movie_caption(0, 1)
		end
		event.play_movie(5, "movie/end2.mp4")
		at = 2
		vm.wait(2)
		if language_code ~= 1 then
			event.set_movie_caption(0, 0)
		end
		event.set_pause_enabled(0)
		block = event.load_event_image_4(5, "textures/event/e800/e824/e82401_1.json", 0) or block
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_size(0, 512, 448)
		event.set_event_sprite_position(0, 256, 224)
		event.set_event_sprite_draw_pass(0, 1)
		event.reset_event_sprite(1)
		event.set_event_sprite_type(1, 0)
		event.set_event_sprite_texture(1, "e82401", block)
		event.set_event_sprite_color(1, 128, 128, 128, 128)
		event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
		event.set_event_sprite_size(1, 512, 448)
		event.set_event_sprite_position(1, 256, 224)
		event.set_event_sprite_draw_pass(1, 1)
		event.fade_in_screen(60)
		at = 3
		wait_frames(90)
		while true do
			if helper_581cb30c(0) ~= 0 then
				break
			else
				at = 4
				vm.wait(4)
			end
		end
		event.fade_out_screen(30)
		at = 5
		wait_frames(30)
		return
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				print("GET_LANGUAGE=", language_code, "\n")
			end
			if at <= 2 then
				wait_frames_skipping(90)
			end
			if at <= 4 then
				wait_frames_skipping(30)
			end
			local _ = helper_dbff9fb6(0)
			return 0
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	helper_7d7eee8f(vm.f32(972.08), vm.f32(-72.14), vm.f32(1770.23), vm.f32(-2.36))
	event.set_camera_look_at(972.08, -42.14, 1770.23)
	event.set_camera_position(1061.01, -40.06, 1860.38)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	event.finish_event()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = event_28020

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	event.set_camera_look_at(0.0, 0.0, 0.0)
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local active_chr_no: s32 = 0
	local var1: any = 0
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
	var1 = helper_ed4dc120(2, -1)
	if var1 == 0 then
		event.fade_out_screen(30)
		wait_frames(30)
		event.load_event_script("d07/d07.stb", 1000)
	else
		event.finish_event()
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local item: s32 = 0
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
				helper_75684dd8(0, 20, 5, 256, 208)
			else
				at = 2
				helper_75684dd8(0, 21, 5, 256, 208)
			end
			event.finish_event()
			return
		end
		event.reset_action_character_motion(0)
		var1 = event.get_triggered_event_data_2(6) or var1
		if var1 == 1 then
			event.set_message_window_mode(0, 1)
			event.set_message_bubble_tail(0, 0)
			event.set_message_draw_speed(0, 1)
			event.open_message_window_2(0, "Ein Felsen liegt im Weg.\n(Men[UNI00fc] [UNI00f6]ffnen mit (#).)")
			at = 3
			var2 = helper_c292fa16(0, -1, 5, 256, 208, var2)
			event.set_message_bubble_tail(0, 1)
			event.set_message_draw_speed(0, 0)
			if var2 == 1 then
				var1 = 2
			end
		end
		if var1 == 2 then
			event.show_dungeon_status_bar(0, 0.16666667)
			at = 4
			wait_frames(6)
			event.open_use_item_menu(173)
			at = 5
			vm.wait(5)
			item = vmhost.used_item() or item
			if item == 173 then
				event.fade_out_music(20)
				event.fade_out_screen(20)
				at = 6
				wait_frames(20)
				event.set_function_point_enabled("p04", "func", 0)
				at = 7
				helper_dac13067()
				at = 8
				vm.wait(8)
				event.initialize_event()
				event.attach_object_handle_to_map_part_2(0, "p05")
				event.set_object_handle_visible(0, 1)
				event.attach_object_handle_to_map_part_2(1, "p06")
				event.set_object_handle_visible(1, 1)
				event.set_save_control_bits(1, 1)
				event.load_dungeon_monster(629, 1)
				event.load_dungeon_monster(630, 0)
				event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
				helper_7d7eee8f(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				event.set_camera_look_at(438.61, 30.0, 192.19)
				event.set_camera_position(590.29, 39.11, 243.1)
				event.reset_follow_camera(0)
				event.fade_in_screen(30)
				event.finish_event()
			elseif item <= 0 then
			else
				at = 9
				helper_5fb66cb1()
			end
			event.show_dungeon_status_bar(1, 0.16666667)
			at = 10
			wait_frames(6)
		end
		event.set_dungeon_pause_flags(1, 0)
		event.finish_event()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_ee1c51d0(0, 21, 5, 256, 208)
			end
			return 0
		end
		if at <= 10 then
			if at == 3 then
				var2 = received[2] :: number
			end
			if at <= 3 then
				local _ = var1 == 1
				var1 = 2
				wait_frames_skipping(6)
			end
			if at <= 5 then
				wait_frames_skipping(20)
			end
			if at <= 6 then
				at = 7
				helper_dac13067()
				return vm.continue_with(function()
					at = 8
					vm.wait(8)
					event.initialize_event()
					event.attach_object_handle_to_map_part_2(0, "p05")
					event.set_object_handle_visible(0, 1)
					event.attach_object_handle_to_map_part_2(1, "p06")
					event.set_object_handle_visible(1, 1)
					event.set_save_control_bits(1, 1)
					event.load_dungeon_monster(629, 1)
					event.load_dungeon_monster(630, 0)
					event.place_dungeon_monster(629, -513.2, 9.0, -127.2, 0.0, 1.25, 0.0)
					helper_7d7eee8f(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
					event.set_camera_look_at(438.61, 30.0, 192.19)
					event.set_camera_position(590.29, 39.11, 243.1)
					event.reset_follow_camera(0)
					event.fade_in_screen(30)
					event.finish_event()
					event.show_dungeon_status_bar(1, 0.16666667)
					at = 10
					wait_frames(6)
					event.set_dungeon_pause_flags(1, 0)
					event.finish_event()
					return
				end)
			end
			if at <= 8 then
				helper_43f02c95(vm.f32(438.61), 0.0, vm.f32(192.19), vm.f32(-1.89))
				helper_7c656a4f()
			end
			if at <= 9 then
				wait_frames_skipping(6)
			end
			return 0
		end
		return nil
	end)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local active_chr_no: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		event.reset_action_character_motion(0)
		event.fade_out_music(20)
		event.fade_out_screen(20)
		at = 1
		wait_frames(20)
		event.clear_event_battle_monsters(-1)
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no == 2 then
			event.switch_dungeon_main_character(0)
		end
		if active_chr_no == 3 then
			event.switch_dungeon_main_character(1)
		end
		event.attach_object_handle_to_map_part_2(0, "p05")
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_map_part_2(1, "p06")
		event.set_object_handle_visible(1, 0)
		event.set_save_control_bits(1, 0)
		at = 2
		helper_38cda040()
		at = 3
		helper_17348()
		event.set_scene_exit_flag(1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				at = 2
				helper_38cda040()
				return vm.continue_with(function()
					at = 3
					helper_17348()
					event.set_scene_exit_flag(1)
					return
				end)
			end
			if at <= 2 then
				helper_8e1771b9()
			end
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
		flag = event.get_save_flag(816) or flag
		flag_2 = event.get_save_flag(820) or flag_2
		if flag ~= 0 and flag_2 == 0 then
			var2 = 0
			var2 = vm.float_bits(event.get_random_number(100)) or var2
			if var2 < 50 then
				at = 1
				helper_47084b1b(0, 8600060)
			else
				at = 2
				helper_47084b1b(0, 8600070)
			end
			return
		end
		at = 3
		helper_f0ee9a01(0)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_80ad60c2(0, 8600070)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		return nil
	end)
end

--- Event 18160, which map data, a script or the engine runs by number.
script.event_18160 = helper_dac13067

--- Event 18200, which map data, a script or the engine runs by number.
function script.event_18200()
	local at: number = 0
	return vm.guard(function()
		at = 1
		helper_38cda040()
		at = 2
		helper_17348()
		event.set_scene_exit_flag(1)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_8e1771b9()
			end
			return 0
		end
		return nil
	end)
end

script.event_28020 = event_28020

return script
