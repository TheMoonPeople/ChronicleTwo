--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Helper function.
local function helper_dbb2323a(arg0: s32)
	local count: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.set_sphida_status_panel_visible(0)
		event.delete_character(12)
		event.delete_event_image(1)
		event.clear_effect_manager()
		event.delete_character_extension_packs(0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.set_character_active(1, 13)
		event.set_character_active(1, 14)
		event.attach_object_handle_to_character(0, 1)
		event.set_object_handle_visible(0, 0)
		event.attach_object_handle_to_character(0, 2)
		event.set_object_handle_visible(0, 0)
		event.set_camera_control_enabled(1)
		event.delete_sword_afterimage()
		event.show_dungeon_status_bar(0, 1.0)
		if arg0 ~= 1 then
			event.start_crossfade(15)
		end
		count = event.get_sphida_par() or count
		if arg0 == 0 and count <= 0 then
			do
				local out1, out2, out3 = event.get_previous_camera_next_position()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_position(position_x, position_y, position_z)
			do
				local out1, out2, out3 = event.get_previous_camera_next_look_at()
				position_x = out1 or position_x
				position_y = out2 or position_y
				position_z = out3 or position_z
			end
			event.set_camera_look_at(position_x, position_y, position_z)
			event.set_message_window_mode(0, 4)
			at = 1
			helper_75684dd8(0, 2003, 8, 0, 0)
			event.fade_out_screen(30)
			at = 2
			wait_frames(30)
			arg0 = 2
			event.reset_follow_camera(0)
		end
		event.run_dungeon_event(-1)
		event.clear_event_running_flag()
		event.finish_event()
		return arg0
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				wait_frames_skipping(30)
			end
			local _ = arg0 ~= 1
			local _ = arg0 == 0
			arg0 = 2
			return arg0
		end
		return nil
	end)
end

return helper_dbb2323a
