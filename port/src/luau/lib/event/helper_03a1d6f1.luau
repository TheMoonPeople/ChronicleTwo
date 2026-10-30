--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

local helper_75684dd8 = require("@lib/event/helper_75684dd8")

--- Helper function.
local function helper_03a1d6f1(arg0: s32)
	local stage_id: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count: s32 = 0
	local position_x_2: f32 = 0
	local position_y_2: f32 = 0
	local position_z_2: f32 = 0
	event.set_sphida_status_panel_visible(0)
	event.delete_character(12)
	event.clear_effect_manager()
	event.delete_character_extension_packs(0)
	event.set_character_motion(0, "立ち", 4)
	event.update_character_motion(0)
	event.reset_character_cloth_and_hair(0)
	event.attach_object_handle_to_character(0, 2)
	event.set_object_handle_visible(0, 1)
	event.set_camera_control_enabled(1)
	event.delete_sword_afterimage()
	event.show_dungeon_status_bar(1, 0.1)
	event.start_crossfade(15)
	if arg0 == 1 then
		stage_id = event.get_dungeon_stage_id() or stage_id
		var2 = event.get_dungeon_floor() or var2
		var3 = event.get_dungeon_floor_info(stage_id, var2, 4) or var3
		if var3 == 1 then
			var3 = event.get_system_sound_id() or var3
			event.play_sound_effect(var3, 18)
			event.set_dungeon_floor_info(stage_id, var2, 5, 128)
			event.add_yarikomi_medals(1)
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
			helper_75684dd8(0, 2010, 8, 0, 0)
			event.set_active_camera_slot(1)
			event.set_previous_camera_slot(0)
			event.set_follow_camera_offset(0.0, 30.0, 0.0)
			event.set_follow_camera_height(5.0)
			event.set_follow_camera_distance(160.0)
			event.set_camera_speed(6.0)
			event.set_camera_rotation_cancel_mask(1)
			event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
			event.reset_follow_camera(0)
		end
	end
	count = event.get_sphida_par() or count
	if arg0 == 0 and count <= 0 then
		do
			local out1, out2, out3 = event.get_previous_camera_next_position()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_position(position_x_2, position_y_2, position_z_2)
		do
			local out1, out2, out3 = event.get_previous_camera_next_look_at()
			position_x_2 = out1 or position_x_2
			position_y_2 = out2 or position_y_2
			position_z_2 = out3 or position_z_2
		end
		event.set_camera_look_at(position_x_2, position_y_2, position_z_2)
		event.set_message_window_mode(0, 4)
		helper_75684dd8(0, 2003, 8, 0, 0)
		event.reset_follow_camera(0)
	end
	event.finish_event()
end

return helper_03a1d6f1
