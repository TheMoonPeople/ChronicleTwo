--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_fd3a2124(arg0: s32)
	local block: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local pin_col: s32 = 0
	local ball_col: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	block = event.load_event_image_4(4, "textures/dungeon/sphida/sphida_bar.json", 0) or block
	event.set_up_sphida(4, block, arg0)
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
	event.load_character(4, "dungeon/sphida/bball.gltf", "info", 8)
	event.load_character(4, "dungeon/sphida/rball.gltf", "info", 9)
	if ball_col == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_col == 0 then
		event.load_character(4, "dungeon/sphida/rgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/rgool2.gltf", "info", 11)
	else
		event.load_character(4, "dungeon/sphida/bgool.gltf", "info", 10)
		event.load_character(4, "dungeon/sphida/bgool2.gltf", "info", 11)
	end
	event.load_sphida_collision_model(4, "dungeon/sphida/gool_a.gltf")
	event.set_character_active(10)
	event.set_character_active(11)
	event.set_scene_character_type(8, 4)
	event.set_scene_character_type(9, 4)
	event.set_scene_character_type(10, 4)
	event.set_scene_character_type(11, 4)
	event.set_character_position(8, pos_x, pos_y, pos_z)
	event.set_character_position(9, pos_x, pos_y, pos_z)
	event.set_character_position(10, pos_x_2, pos_y_2, pos_z_2)
	event.set_character_position(11, pos_x_2, pos_y_2, pos_z_2)
end

return helper_fd3a2124
