--!strict
-- dungeon/eff_script/e216ex_kaiten.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local user_id: s32 = 0
	local value: s32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var8: s32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	user_id = effect.GetUserId() or user_id
	print("user id=", user_id, "------------\n")
	do
		local out1, out2, out3 = effect.ScnGetChrPos(user_id)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(user_id)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	value = 0
	value = effect.GetValue(0) or value
	effect.ChrSetPos(pos_x, pos_y, pos_z)
	effect.ChrSetRot(rot_x, rot_y, rot_z)
	effect.ChrSetShow(1, 1, 0.04)
	effect.ChrSetMotion("ループ", -1, 4)
	var8 = 0
	var9 = vm.f32(vm.f32(vm.sin(rot_y) * 30.0) + pos_x)
	var10 = vm.f32(26.0 + pos_y)
	var11 = vm.f32(vm.f32(vm.cos(rot_y) * 30.0) + pos_z)
	do
		local out1, out2, out3 = effect.CopyVector(var9, var10, var11)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.SubVector(var12, var13, var14, pos_x, pos_y, pos_z)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	do
		local out1, out2, out3 = effect.NormalVector(var12, var13, var14)
		var12 = out1 or var12
		var13 = out2 or var13
		var14 = out3 or var14
	end
	while var8 < 20 do
		if var8 == 9 then
			if value ~= 0 then
				effect.ColprimCreate("吹っ飛び攻撃")
				effect.ColprimSetDamage(value)
			end
			if value ~= 0 then
				effect.ColprimSetCoord(var9, var10, var11, 15.0)
			end
		end
		do
			local out1, out2, out3 = effect.ScnGetChrPos(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		var8 = var8 + 1
		vm.wait()
	end
	if value ~= 0 then
		effect.ColprimDelete(-1)
	end
	effect.ChrSetShow(0, 1, 0.04)
	var8 = 0
	while var8 < 25 do
		do
			local out1, out2, out3 = effect.ScnGetChrPos(user_id)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		effect.ChrSetPos(pos_x, pos_y, pos_z)
		var8 = var8 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
