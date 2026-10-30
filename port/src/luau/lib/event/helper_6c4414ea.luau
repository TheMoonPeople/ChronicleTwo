--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_ac9d5b12 = require("@lib/event/helper_ac9d5b12")
local helper_ae753a51 = require("@lib/event/helper_ae753a51")

--- Helper function.
local function helper_6c4414ea()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	vm.section(function()
		event.set_save_flag(102, 1)
		event.initialize_event()
		event.set_dungeon_pause_flags(1, 1)
		event.set_message_window_mode(0, 7)
		var0 = event.load_sound_effect_file_2(1807) or var0
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		do
			local out1, out2, out3, out4 = event.get_dungeon_event_point(2)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
			var4 = out4 or var4
		end
		var4 = vm.f32(var4 + vm.f32(1.5707964))
		if var4 > vm.f32(3.1415927) then
			var4 = vm.f32(var4 - vm.f32(6.2831855))
		end
		event.set_event_world_coordinate(var1, var2, var3, var4)
		event.load_character_motion_pack(5, "event/e100/e102/e102_mints.gltf", "info", 0)
		event.attach_object_handle_to_character(0, 0)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 130.0, 100.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "立ち", 4)
		event.load_item_model(5, 359, "info", 8)
		event.set_character_active(0, 8)
		event.attach_character_to_frame(0, "ef00", 8)
		event.attach_object_handle_to_character(2, 1)
		event.set_object_handle_visible(2, 0)
		event.attach_object_handle_to_character(3, 2)
		event.set_object_handle_visible(3, 0)
		event.load_message_file(0, 5, "event/e100/e102/e102_1.txt")
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "無表情")
		event.set_object_sequence_texture_animation(0, 1, "通常目パチ")
		vm.wait(1)
		event.show_dungeon_status_bar(0, 1.0)
		event.enable_drama_skip()
		helper_ae753a51(var0)
	end)
	event.cancel_drama_scene_skip()
	event.load_message_file(0, -1)
	event.show_dungeon_status_bar(1, 1.0)
	helper_ac9d5b12()
	event.stop_sound_effect(var0, 0)
	event.delete_character_extension_packs(0)
	event.delete_character(8)
	event.attach_object_handle_to_character(2, 1)
	event.set_object_handle_visible(2, 1)
	event.attach_object_handle_to_character(3, 2)
	event.set_object_handle_visible(3, 1)
	event.set_dungeon_pause_flags(1, 0)
	event.set_object_handle_position(0, -175.0, 0.0, 0.0)
	event.set_object_handle_rotation(0, 0.0, -1.57, 0.0)
	event.set_object_handle_motion(0, "立ち", 4)
	event.set_camera_position(-15.0, 77.61, 0.13)
	event.set_camera_look_at(-175.0, 30.0, 0.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

return helper_6c4414ea
