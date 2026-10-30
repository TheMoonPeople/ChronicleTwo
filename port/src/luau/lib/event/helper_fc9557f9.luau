--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_238b5abc = require("@lib/event/helper_238b5abc")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_fc9557f9(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local language_code: s32 = 0
	local at: number = 0
	vm.section(function()
		at = 1
		vm.entry(1)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_dungeon_pause_flags(1, 1)
		event.stop_environment_music()
		event.load_map_sounds(4682)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
			var4 = out4 or var4
		end
		var1 = vm.f32(var1 + 80.0)
		event.set_event_world_coordinate(var1, var2, var3, var4)
		event.attach_object_handle_to_character(0, 0)
		event.set_object_handle_footstep_sound(0, 18)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 0.0, 3200.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
		if arg0 ~= 0 then
			var5 = event.get_dungeon_floor() or var5
			var6 = event.get_dungeon_previous_floor() or var6
			event.load_dungeon_map_display(5, 0, 3, var5, var6)
			event.fade_dungeon_map(1, 30)
			event.set_dungeon_map_piece_moving(1)
		else
			language_code = event.get_language() or language_code
			if language_code == 0 then
				event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d03.json", 0)
			else
				event.load_event_image_3(5, "textures/dungeon/image/s_title/logo_d03_1.json", 0)
			end
			event.set_event_image_texture(0, "logo_d03")
			event.set_event_image_source_rect(0, 0, 0, 384, 128)
			event.set_event_image_screen_rect(0, -24, 300, 384, 128)
			event.set_event_image_color(0, 128, 128, 128, 0)
			event.set_event_image_visible(1, 0)
			event.fade_event_image(0, 1, 30)
		end
		event.set_camera_sequence_look_at(0.0, 3230.0, 120.0)
		event.set_camera_sequence_position(0.0, 3250.0, 0.0)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		event.set_object_sequence_motion(0, "歩き", 4)
		event.move_object_sequence(0, 0.0, 3200.0, 120.0, 90)
		event.fade_in_screen(30)
		at = 2
		wait_frames(40)
		event.show_dungeon_status_bar(1)
		at = 3
		wait_frames(30)
		if arg0 ~= 0 then
			event.fade_dungeon_map(0, 20)
		else
			event.fade_event_image(0, 0, 20)
		end
		at = 4
		wait_objects(0)
		event.set_object_sequence_motion(0, "立ち")
		at = 5
		wait_frames(4)
	end, function(received: { any }): boolean
		if at <= 1 then
			var1 = vm.f32(var1 + 80.0)
			wait_frames_skipping(40)
		end
		if at <= 2 then
			wait_frames_skipping(30)
		end
		if at <= 3 then
			helper_238b5abc(0)
		end
		if at <= 4 then
			wait_frames_skipping(4)
		end
		return true
	end)
	at = 6
	vm.entry(6)
	event.cancel_drama_scene_skip()
	event.show_dungeon_status_bar(1, 1.0)
	if arg0 ~= 0 then
		event.set_dungeon_map_active(0)
		event.delete_dungeon_map_textures()
	else
		event.delete_event_image(0)
	end
	event.set_object_handle_footstep_sound(0, 0)
	event.set_object_handle_position(0, 0.0, 3200.0, 120.0)
	at = 7
	vm.wait(7)
	event.reset_object_handle_dynamic_animation(0)
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.fade_in_screen(0)
	event.reset_follow_camera(0)
	event.set_dungeon_pause_flags(1, 0)
end

return helper_fc9557f9
