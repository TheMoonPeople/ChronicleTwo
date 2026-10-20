--!strict
-- dungeon/eff_script/smoke_tore.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: { f32 } = table.create(10, 0)
	local var10: s32 = 0
	local var12: s32 = 0
	local user_id: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var23: f32 = 0
	local value: f32 = 0
	local var25: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local color_w: f32 = 0
	user_id = effect.GetUserId() or user_id
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.ScnGetChrRot_4(user_id)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = effect.GetDirVector(rot_x, rot_y, rot_z)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.NormalVector(var17, var18, var19)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	do
		local out1, out2, out3 = effect.ScaleVector(var17, var18, var19, 25.0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	effect.SptSetTexname("smoke_tore")
	effect.SptAssignSprite_1(10)
	effect.SptInitSprite(0, 10)
	effect.SptSetAlphab(0, 2, 10)
	effect.SptSetDrawFlag(0, 0, 10)
	effect.SptSetPutSize(0, 32.0, 32.0, 10)
	effect.SptSetUvSize(0, 0.0, 0.0, 128.0, 128.0, 10)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 10)
	effect.SptSetDrawFlag(0, 1, 10)
	var12 = 0
	while var12 < 10 do
		var0[var12 + 1] = 56.0
		var12 = var12 + 1
	end
	var12 = 0
	var10 = 0
	while var12 < 90 do
		if var12 > 4 * var10 and var10 < 10 then
			value = effect.GetRand(25.0) or value
			value_2 = effect.GetRand(360.0) or value_2
			value_3 = effect.GetRand(10.0) or value_3
			effect.SptSetDrawFlag(var10, 1)
			value_3 = vm.f32(value_3 + 5.0)
			var23 = vm.f32(
				vm.f32(work_vect1_x + var17)
					+ vm.f32(value_3 * vm.sin(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))))
			)
			value = vm.f32(vm.f32(work_vect1_y + var18) + -12.5)
			var25 = vm.f32(
				vm.f32(work_vect1_z + var19)
					+ vm.f32(value_3 * vm.cos(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))))
			)
			effect.SptSetPos(var10, var23, value + 10.0, var25)
			var10 = var10 + 1
		end
		for var11 = 0, var10 - 1 do
			do
				local _, _, _, out4 = effect.SptGetColor(var11)
				color_w = out4 or color_w
			end
			if color_w < var0[var11 + 1] then
				effect.SptAddColor(var11, 128.0, 128.0, 128.0, 7.5)
			else
				effect.SptAddColor(var11, 128.0, 128.0, 128.0, -3.5)
				var0[var11 + 1] = -1.0
			end
		end
		vm.wait()
		var12 = var12 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
