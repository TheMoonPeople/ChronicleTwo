--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c7a8094f(arg0: s32, arg1: s32)
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
	local skip: (number) -> ...any
	function skip(at: number)
		var13 = 1300.0
		var13 = 2000.0
		var13 = 16000.0
		var13 = 1500.0
		var13 = 1800.0
		var13 = 2100.0
		var13 = 2000.0
	end
	if vm.skipping() then
		return skip(1)
	end
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("dungeon/sphida/")
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		block = event.LoadImg_4(4, "sphida_bar.json", 0) or block
	else
		block = event.LoadImg_4(4, "sphida_bar_1.json", 0) or block
	end
	event.SphidaSetUp(4, block, arg0, arg1)
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
	event.LoadChara(4, "bball.gltf", "info", 8)
	event.LoadChara(4, "rball.gltf", "info", 9)
	if ball_col == 0 then
		event.CharaActive(0, 8)
		event.CharaActive(1, 9)
	else
		event.CharaActive(1, 8)
		event.CharaActive(0, 9)
	end
	if pin_col == 0 then
		event.LoadChara(4, "rgool.gltf", "info", 10)
		event.LoadChara(4, "rgool2.gltf", "info", 11)
	else
		event.LoadChara(4, "bgool.gltf", "info", 10)
		event.LoadChara(4, "bgool2.gltf", "info", 11)
	end
	event.SphidaSetColModel(4, "gool_a.gltf")
	event.ChangeDir("")
	event.CharaActive(10)
	event.CharaActive(11)
	event.SetCharaType(10, 4)
	event.SetCharaType(11, 4)
	stage_id = event.DngGetStageId() or stage_id
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
	event.SetCharaFarDist(8, var13)
	event.SetCharaShow(8, 1, 1, 1.0)
	event.SetCharaFarDist(9, var13)
	event.SetCharaShow(9, 1, 1, 1.0)
	event.SetCharaFarDist(10, var13)
	event.SetCharaShow(10, 1, 1, 1.0)
	event.SetCharaFarDist(11, var13)
	event.SetCharaShow(11, 1, 1, 1.0)
	event.SetCharaPos(8, pos_x, pos_y, pos_z)
	event.SetCharaPos(9, pos_x, pos_y, pos_z)
	event.SetCharaPos(10, pos_x_2, pos_y_2, pos_z_2)
	event.SetCharaPos(11, pos_x_2, pos_y_2, pos_z_2)
end

return helper_c7a8094f
