--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_6b0b98a6(arg0: s32)
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
	event.AssignStack(4)
	event.ClearStack(4)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(4, "textures/dungeon/sphida/sphida_bar.json", 0) or block
	else
		block = event.LoadImg_4(4, "textures/dungeon/sphida/sphida_bar_1.json", 0) or block
	end
	event.SphidaSetUp(4, block, arg0)
	do
		local out1, out2, out3 = event.SphidaGetPinPos()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	do
		local out1, out2, out3 = event.SphidaGetBallPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	pin_col = event.SphidaGetPinCol() or pin_col
	ball_col = event.SphidaGetBallCol() or ball_col
	event.LoadChara(4, "dungeon/sphida/bball.gltf", "info", 8)
	event.LoadChara(4, "dungeon/sphida/rball.gltf", "info", 9)
	if ball_col == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 8)
		event.CharaActive(0, 9)
	end
	if pin_col == 0 then
		event.LoadChara(4, "dungeon/sphida/rgool.gltf", "info", 10)
		event.LoadChara(4, "dungeon/sphida/rgool2.gltf", "info", 11)
	else
		event.LoadChara(4, "dungeon/sphida/bgool.gltf", "info", 10)
		event.LoadChara(4, "dungeon/sphida/bgool2.gltf", "info", 11)
	end
	event.SphidaSetColModel(4, "dungeon/sphida/gool_a.gltf")
	event.CharaActive(10)
	event.CharaActive(11)
	event.SetCharaType(8, 4)
	event.SetCharaType(9, 4)
	event.SetCharaType(10, 4)
	event.SetCharaType(11, 4)
	event.SetCharaPos(8, pos_x, pos_y, pos_z)
	event.SetCharaPos(9, pos_x, pos_y, pos_z)
	event.SetCharaPos(10, pos_x_2, pos_y_2, pos_z_2)
	event.SetCharaPos(11, pos_x_2, pos_y_2, pos_z_2)
end

return helper_6b0b98a6
