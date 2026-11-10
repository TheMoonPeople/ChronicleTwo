--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_75684dd8 = require("@lib/event/helper_75684dd8")
local helper_7982ab52 = require("@lib/event/helper_7982ab52")
local helper_7b560508 = require("@lib/event/helper_7b560508")
local helper_c24a11db = require("@lib/event/helper_c24a11db")
local helper_c44453a9 = require("@lib/event/helper_c44453a9")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_6a55557d(arg0: s32)
	local omake_mode: s32 = 0
	local get_now_horl: s32 = 0
	local count: s32 = 0
	local get_now_horl_2: s32 = 0
	local stage_id: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local count_2: s32 = 0
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
	omake_mode = event.is_sphida_bonus_course() or omake_mode
	get_now_horl = event.get_sphida_saved_hole() or get_now_horl
	if arg0 == 1 and omake_mode == 1 then
		count = event.get_sphida_par() or count
		if get_now_horl ~= 8 then
			event.set_sphida_hole_score(-1, vm.i32(count + 3))
		end
		helper_7b560508()
		get_now_horl_2 = event.get_sphida_saved_hole() or get_now_horl_2
		if get_now_horl_2 == 8 then
			helper_c44453a9()
			return
		else
			helper_7982ab52()
		end
		return
	end
	if omake_mode == 0 then
		event.show_dungeon_status_bar(1, 0.1)
	end
	event.start_crossfade(15)
	if arg0 == 1 then
		if omake_mode == 0 then
			stage_id = event.get_dungeon_stage_id() or stage_id
			var6 = event.get_dungeon_floor() or var6
			var7 = event.get_dungeon_floor_info(stage_id, var6, 4) or var7
			if var7 == 1 then
				event.set_dungeon_floor_info(stage_id, var6, 5, 128)
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
				event.reset_follow_camera(0)
			end
		end
	end
	count_2 = event.get_sphida_par() or count_2
	if arg0 == 0 and count_2 <= 0 then
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
		if omake_mode == 0 then
			helper_75684dd8(0, 2003, 8, 0, 0)
		else
			if get_now_horl == 8 then
				helper_75684dd8(0, 2003, 8, 0, 0)
				helper_c24a11db()
				helper_7b560508()
				helper_c44453a9()
				return
			else
				event.open_message_window_2(0, "La sph[UNI00e8]re a disparu.\nPasse au parcours suivant.")
				helper_75684dd8(0, -1, 8, 0, 0)
			end
			event.fade_out_screen(30)
			wait_frames(30)
			helper_7b560508()
			helper_7982ab52()
			return
		end
		event.reset_follow_camera(0)
	end
	event.finish_event()
end

return helper_6a55557d
