--!strict
-- Shared event helper used by 70 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_c3f198dd(arg0: s32, arg1: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	local stage_id: s32 = 0
	local var13: f32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("dungeon/sphida/")
	language_code = event.get_language() or language_code
	if language_code == 0 then
		block = event.load_event_image_4(4, "sphida_bar.json", 0) or block
	else
		block = event.load_event_image_4(4, "sphida_bar_1.json", 0) or block
	end
	event.set_up_sphida(4, block, arg0, arg1)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pin_col = event.get_sphida_pin_color() or pin_col
	ball_col = event.get_sphida_ball_color() or ball_col
	event.load_character(4, "bball.gltf", "info", 8)
	event.load_character(4, "rball.gltf", "info", 9)
	if ball_col == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_col == 0 then
		event.load_character(4, "rgool.gltf", "info", 10)
		event.load_character(4, "rgool2.gltf", "info", 11)
	else
		event.load_character(4, "bgool.gltf", "info", 10)
		event.load_character(4, "bgool2.gltf", "info", 11)
	end
	event.load_sphida_collision_model(4, "gool_a.gltf")
	event.change_directory("")
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_scene_character_type(10, 4)
	event.set_scene_character_type(11, 4)
	stage_id = event.get_dungeon_stage_id() or stage_id
	if stage_id == 0 then
		var13 = 1300.0
	end
	if stage_id == 1 then
		var13 = 2000.0
	end
	if stage_id == 2 then
		var13 = 16000.0
	end
	if stage_id == 3 then
		var13 = 1500.0
	end
	if stage_id == 4 then
		var13 = 1800.0
	end
	if stage_id == 5 then
		var13 = 2100.0
	end
	if stage_id == 6 then
		var13 = 2000.0
	end
	event.set_character_draw_distance(8, var13)
	event.set_character_visible(8, 1, 1, 1.0)
	event.set_character_draw_distance(9, var13)
	event.set_character_visible(9, 1, 1, 1.0)
	event.set_character_draw_distance(10, var13)
	event.set_character_visible(10, 1, 1, 1.0)
	event.set_character_draw_distance(11, var13)
	event.set_character_visible(11, 1, 1, 1.0)
	event.set_character_position(8, pos_x, pos_y, pos_z)
	event.set_character_position(9, pos_x, pos_y, pos_z)
	event.set_character_position(10, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_position(11, pos_x_2, pos_y_2, pos_z_2)
end

return helper_c3f198dd
