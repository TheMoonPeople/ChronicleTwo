--!strict
-- dungeon/eff_script/mj_beam_l2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f8ea8a52 = require("@lib/effect/helper_f8ea8a52")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var6: f32 = 0
	local yaw: f32 = 0
	local var8: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local value: f32 = 0
	local dir_x: f32 = 0
	local dir_y: f32 = 0
	local dir_z: f32 = 0
	local pos_y_2: f32 = 0
	local user_id: s32 = 0
	local var30: s32 = 0
	local value_2: s32 = 0
	local handle: s32 = 0
	local value_3: s32 = 0
	local var34: f32 = 0
	local var36: f32 = 0
	local var37: f32 = 0
	local var38: f32 = 0
	value_3 = 0
	value = 0.0
	user_id = effect.GetUserId() or user_id
	value_3 = effect.GetValue(0) or value_3
	value = effect.GetValueFloat(2) or value
	effect.ChrSetScale(value, value, value * 2.0)
	effect.ChrSetFrameShow("hamon", 0, 1)
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.ChrSetMotion("攻撃２入り", 6)
	while var30 < 13 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "dcol2")
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(var6, yaw, var8)
		vm.wait()
		var30 = var30 + 1
		value_2 = effect.GetValue(1) or value_2
		if value_2 == 1 then
			break
		end
	end
	handle = effect.EsCreate_2("魔人ビームＨ２") or handle
	effect.EsSetValue(handle, 0, value_3)
	effect.EsSetValue(handle, 2, 0)
	effect.ColprimCreate("通常攻撃")
	do
		local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol2")
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "dcol2")
		var6 = out1 or var6
		yaw = out2 or yaw
		var8 = out3 or var8
	end
	effect.ChrSetPos(pos_x, pos_y, pos_z)
	effect.ChrSetMotion("攻撃２ループ", 0)
	while true do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.ScnGetChrFrmRot(user_id, "dcol2")
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.GetWorkVect1()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		yaw = helper_f8ea8a52(work_vect1_x, work_vect1_y, work_vect1_z, yaw)
		effect.DistVector2(work_vect1_x, work_vect1_y, work_vect1_z, pos_x, pos_y, pos_z)
		do
			local _, out2, _ = effect.ChrGetPos()
			pos_y_2 = out2 or pos_y_2
		end
		do
			local out1, out2, out3 = effect.ChrGetRot()
			rot_x = out1 or rot_x
			rot_y = out2 or rot_y
			rot_z = out3 or rot_z
		end
		do
			local out1, out2, out3 = effect.GetDirVector(rot_x, rot_y, rot_z)
			dir_x = out1 or dir_x
			dir_y = out2 or dir_y
			dir_z = out3 or dir_z
		end
		var34 = pos_y_2
		do
			local out1, out2, out3 = effect.CopyVector(dir_x, dir_y, dir_z)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var36, var37, var38, var34)
			var36 = out1 or var36
			var37 = out2 or var37
			var38 = out3 or var38
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		effect.EsSetVect1(handle, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.EsSetValueFloat(handle, 1, value)
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(var6, yaw, var8)
		vm.wait()
		value_2 = effect.GetValue(1) or value_2
		if value_2 == 2 then
			break
		end
	end
	effect.ColprimDelete(-1)
	print("hit eff end-----------------------------\n")
	effect.EsSetValue(handle, 2, 1)
	effect.ChrSetMotion("攻撃２戻り", 6)
	while var30 < 40 do
		do
			local out1, out2, out3 = effect.ScnGetChrFrmPos(user_id, "dcol2")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.ChrGetRefRot(work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			yaw = out2 or yaw
			var8 = out3 or var8
		end
		effect.EsSetVect1(handle, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		effect.ChrSetRot(var6, yaw, var8)
		vm.wait()
		var30 = var30 + 1
		value_2 = effect.GetValue(1) or value_2
		if value_2 == 3 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
