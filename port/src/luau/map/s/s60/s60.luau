--!strict
-- map/s/s60/s60.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0382f327 = require("@lib/event/helper_0382f327")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")

--- Helper function.
local function helper_bf3c()
	local active_chr_no: s32 = 0
	vm.section(function()
		vm.entry(1)
		event.set_save_flag(824, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		active_chr_no = event.get_playable_character() or active_chr_no
		event.set_scene_status_flags(1, 0, 256, 1)
		event.change_directory("event/e800/e824/")
		event.load_message_file(0, 5, "e824.txt")
		if active_chr_no == 0 then
			event.load_character_motion_pack(5, "e824_mints.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
		end
		if active_chr_no == 1 then
			event.load_character_motion_pack(5, "e824_monica.gltf", "info", 0)
			event.set_character_active(0)
			event.attach_object_handle_to_character(1, 0)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
		end
		event.load_character(5, "e824_need.gltf", "info", 10)
		event.set_scene_status_flags(1, 10, 8, 1)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.load_character(5, "e824_hanabi.gltf", "info", 11)
		event.set_character_active(11)
		event.change_directory("")
		if active_chr_no == 1 then
			event.load_character(5, "chara/c01_base.gltf", "info", 8)
			event.load_equipment_model(5, 0, 4, "info", 8)
			event.load_equipment_model(5, 0, 3, "info", 8)
			event.load_equipment_model(5, 0, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e824/e824_mints.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 8)
			event.attach_object_handle_to_character(0, 8)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 0)
		else
			event.load_character(5, "chara/c02_base.gltf", "info", 8)
			event.load_equipment_model(5, 1, 4, "info", 8)
			event.load_equipment_model(5, 1, 3, "info", 8)
			event.load_equipment_model(5, 1, 2, "info", 8, 9)
			event.load_character_motion_pack(5, "event/e800/e824/e824_monica.gltf", "info", 8)
			event.load_character_motion_pack(5, "event/basic_evmot/monica_set.gltf", "info", 8)
			event.attach_object_handle_to_character(1, 8)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			event.load_character_motion_pack(5, "event/basic_evmot/mints_set.gltf", "info", 0)
		end
		event.set_character_active(8)
		event.set_character_active(9)
		event.set_character_visible(1, 0)
		event.set_character_visible(2, 0)
		event.set_character_visible(3, 0)
		event.set_object_handle_position(0, 72.11, -90.0, 76.71)
		event.set_object_handle_rotation(0, 0.0, -3.02, 0.0)
		event.set_object_handle_motion(0, "立ち", 4)
		event.set_object_handle_texture_animation(0, 0)
		event.set_object_handle_texture_animation(0, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(0, 1, "通常目パチ")
		event.set_object_handle_position(1, 54.92, -90.0, 77.88)
		event.set_object_handle_rotation(1, 0.0, 3.14, 0.0)
		event.set_object_handle_motion(1, "立ち", 4)
		event.set_object_handle_texture_animation(1, 0)
		event.set_object_handle_texture_animation(1, 1, "デフォルト顔")
		event.set_object_handle_texture_animation(1, 1, "通常目パチ")
		event.set_object_handle_position(2, 44.14, -49.08, -126.86)
		event.set_object_handle_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_handle_texture_animation(2, 0)
		event.set_object_handle_texture_animation(2, 1, "しんけん顔")
		event.set_object_handle_texture_animation(2, 1, "しんけん目パチ")
		event.enable_drama_skip()
		event.set_scene_status_flags(1, 0, 8, 0)
		event.set_scene_status_flags(1, 8, 8, 0)
		event.set_event_map_visible(1)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(55.46, 200.34, 515.95)
		event.set_camera_sequence_look_at(53.44, 227.2, 372.83)
		event.fade_in_screen(0)
		event.set_event_map_visible(1)
		event.set_camera_sequence_position(44.0, -16.0, -75.76)
		event.set_camera_sequence_look_at(44.0, -29.0, -122.08)
		event.set_object_sequence_motion(0, "立ち", 4, -1.0, 1)
		event.set_object_sequence_motion(1, "立ち", 4, -1.0, 1)
		event.set_object_sequence_texture_animation(2, 1, "通常口パク")
		event.delay_object_sequence_texture_animation_track(2, 300)
		event.set_object_sequence_texture_animation(2, 0, "通常口パク")
		event.set_object_sequence_motion(2, "いつか世界に・・・", 4)
		event.delay_object_sequence_motion_track(2, 60)
		event.queue_object_sequence_next_motion(2, "いつか世界に・・・Ｌ", 4)
		helper_0382f327(8240090, 360)
		event.set_camera_sequence_position(44.2, -3.01, -177.99)
		event.set_camera_sequence_look_at(35.75, -20.84, -125.36)
		event.move_camera_sequence(44.2, -3.01, -177.99, 52.28, -20.84, -125.25, 420)
		event.set_event_map_visible(0)
		event.set_object_sequence_texture_animation(2, 1, "通常口パク")
		event.delay_object_sequence_texture_animation_track(2, 336.0)
		event.set_object_sequence_texture_animation(2, 0, "通常口パク")
		event.set_object_sequence_motion(2, "なぜなら１", 2)
		event.queue_object_sequence_next_motion(2, "なぜなら１Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜならＬ～なぜなら２", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２～なぜなら１", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら１Ｌ", 4)
		event.queue_object_sequence_next_motion(2, "なぜならＬ～なぜなら２", 4)
		event.queue_object_sequence_next_motion(2, "なぜなら２Ｌ", 4)
		helper_0382f327(8240110, 420)
		event.set_event_map_visible(1)
	end)
	vm.entry(4)
	event.cancel_drama_scene_skip()
	event.set_scene_status_flags(1, 0, 256, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	for var1 = 0, 99 do
		event.delete_character(12 + var1)
	end
	event.load_message_file(0, -1)
end

--- Helper function.
local function helper_b8bc()
	local block: s32 = 0
	event.fade_out_screen(0)
	event.stop_all_sounds()
	helper_888ab2a3(6)
	event.fade_in_screen(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.play_movie(5, "movie/end2.mp4")
	vm.wait(2)
	block = event.load_event_image_4(5, "textures/event/e700/e736/e73601.json", 0) or block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_color(0, 0, 0, 0, 128)
	event.set_event_sprite_size(0, 512, 448)
	event.set_event_sprite_position(0, 256, 224)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_type(1, 0)
	event.set_event_sprite_texture(1, "e73601", block)
	event.set_event_sprite_color(1, 128, 128, 128, 128)
	event.set_event_sprite_texture_rect(1, 0, 0, 512, 448)
	event.set_event_sprite_size(1, 512, 448)
	event.set_event_sprite_position(1, 256, 224)
	event.set_event_sprite_draw_pass(1, 1)
	event.fade_in_screen(60)
	helper_888ab2a3(90)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.fade_out_screen(30)
	helper_888ab2a3(30)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	local at: number = 0
	return vm.guard(function()
		event.set_time_of_day(22.0)
		event.set_time_of_day_advancing(0)
		at = 1
		helper_888ab2a3(30)
		at = 2
		helper_bf3c()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				at = 2
				helper_bf3c()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_b8bc()
	event.set_scene_exit_flag(1)
end

return script
