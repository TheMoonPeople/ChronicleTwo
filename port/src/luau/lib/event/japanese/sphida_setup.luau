--!strict
--- Japanese-version Sphida course setup.


local sphida_setup = {}

--- Loads the Sphida course models and places the ball and pin characters for the current stage.
function sphida_setup.load_course(setup_kind: s32, course: s32)
	local block: s32 = 0
	local language_code: s32 = 0
	local ball_x: f32 = 0
	local ball_y: f32 = 0
	local ball_z: f32 = 0
	local pin_x: f32 = 0
	local pin_y: f32 = 0
	local pin_z: f32 = 0
	local pin_color: s32 = 0
	local ball_color: s32 = 0
	local stage: s32 = 0
	local draw_distance: f32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.change_directory("dungeon/sphida/")
	language_code = event.get_language() or language_code
	if language_code == 0 then
		block = event.load_event_image_4(4, "sphida_bar.json", 0) or block
	else
		block = event.load_event_image_4(4, "eng_sphida_bar.img", 0) or block
	end
	event.set_up_sphida(4, block, setup_kind, course)
	do
		local out1, out2, out3 = event.get_sphida_pin_position()
		pin_x = out1 or pin_x
		pin_y = out2 or pin_y
		pin_z = out3 or pin_z
	end
	do
		local out1, out2, out3 = event.get_sphida_ball_position()
		ball_x = out1 or ball_x
		ball_y = out2 or ball_y
		ball_z = out3 or ball_z
	end
	pin_color = event.get_sphida_pin_color() or pin_color
	ball_color = event.get_sphida_ball_color() or ball_color
	event.load_character(4, "bball.gltf", "info", 8)
	event.load_character(4, "rball.gltf", "info", 9)
	if ball_color == 0 then
		event.set_character_active(0, 8)
		event.set_character_active(1, 9)
	else
		event.set_character_active(1, 8)
		event.set_character_active(0, 9)
	end
	if pin_color == 0 then
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
	stage = event.get_dungeon_stage_id() or stage
	if stage == 0 then
		draw_distance = 1300.0
	end
	if stage == 1 then
		draw_distance = 2000.0
	end
	if stage == 2 then
		draw_distance = 16000.0
	end
	if stage == 3 then
		draw_distance = 1500.0
	end
	if stage == 4 then
		draw_distance = 1800.0
	end
	if stage == 5 then
		draw_distance = 2100.0
	end
	if stage == 6 then
		draw_distance = 2000.0
	end
	event.set_character_draw_distance(8, draw_distance)
	event.set_character_visible(8, 1, 1, 1.0)
	event.set_character_draw_distance(9, draw_distance)
	event.set_character_visible(9, 1, 1, 1.0)
	event.set_character_draw_distance(10, draw_distance)
	event.set_character_visible(10, 1, 1, 1.0)
	event.set_character_draw_distance(11, draw_distance)
	event.set_character_visible(11, 1, 1, 1.0)
	event.set_character_position(8, ball_x, ball_y, ball_z)
	event.set_character_position(9, ball_x, ball_y, ball_z)
	event.set_character_position(10, pin_x, pin_y, pin_z)
	event.set_character_position(11, pin_x, pin_y, pin_z)
end

return sphida_setup
