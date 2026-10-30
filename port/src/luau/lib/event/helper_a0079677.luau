--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4116e6bb = require("@lib/event/helper_4116e6bb")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_a0079677()
	local flag: s32 = 0
	vm.section(function()
		event.initialize_event()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_character(5, "event/e300/e372/e372_waku2.gltf", "info", 32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_message_file(0, 5, "event/e300/e372/e372_1.txt")
		flag = event.get_save_flag(43) or flag
		if flag ~= 0 then
			event.stop_music(0)
			wait_frames(4)
			event.load_music(59)
			event.play_music(0)
			event.set_save_flag(43, 0)
		end
		event.enable_drama_skip()
		event.set_character_active(0, 0)
		event.set_character_active(1, 32)
		event.start_crossfade(0, 0, 90)
		event.set_camera_sequence_position(-178.53, 128.12, 2185.49)
		event.set_camera_sequence_look_at(-546.76, 268.24, 1697.27)
		event.set_object_sequence_position(0, -546.76, 268.24, 1697.27)
		event.keep_character_in_front_of_camera_sequence(32, 608.78, 99999999)
		event.move_camera_sequence_eased(1177.44, 128.12, 1162.78, 809.21, 268.24, 674.57, 600, 2, 0.4)
		helper_4116e6bb(3720190)
		helper_4116e6bb(3720200)
		helper_4116e6bb(3720210)
		helper_4116e6bb(3720220)
		event.clear_camera_sequence()
		event.fade_out_screen(30)
		wait_frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.delete_character(32)
end

return helper_a0079677
