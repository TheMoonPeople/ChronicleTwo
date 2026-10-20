--!strict
-- dungeon/eff_script/spore_sub.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var10: f32 = 0
	local var11: { s32 } = table.create(10, 0)
	local var21: s32 = 0
	local value: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local var30: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value_2: f32 = 0
	var21 = 0
	while var21 < 10 do
		var0[var21 + 1] = 0.0
		var11[var21 + 1] = 0
		var21 = var21 + 1
	end
	var10 = 128.0
	effect.SptAssignSprite_1(11)
	effect.SptSetTexname("b02maphousi01")
	value = effect.GetRand(10.0) or value
	value = vm.f32(value + 25.0)
	effect.SptInitSprite(0)
	effect.SptSetAlphab(0, 2)
	effect.SptSetDrawFlag(0, 1)
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.SptSetPutSize(0, value, value)
	effect.SptSetUvSize(0, 0.0, 64.0, 64.0, 64.0)
	value = vm.f32(value + 6.0)
	effect.SptInitSprite(1, 10)
	effect.SptSetAlphab(1, 2, 10)
	effect.SptSetDrawFlag(1, 1, 10)
	effect.SptSetPos(1, 0.0, 0.0, 0.0, 10)
	effect.SptSetPutSize(1, value, value, 10)
	effect.SptSetUvSize(1, 0.0, 0.0, 64.0, 64.0, 10)
	effect.SptSetColor(1, 128.0, 128.0, 128.0, 0.0, 10)
	var26 = effect.GetRand(360.0) or var26
	var27 = effect.GetRand(360.0) or var27
	var26 = vm.f32(vm.f32(vm.f32(var26 / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
	var27 = vm.f32(vm.f32(vm.f32(var27 / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
	var21 = 0
	while true do
		var26 = vm.f32(var26 + vm.f32(0.04))
		var27 = vm.f32(var27 + vm.f32(0.04))
		var26 = effect.AngleLimit(var26) or var26
		var27 = effect.AngleLimit(var27) or var27
		var28 = vm.f32(vm.sin(var26) * 1.5)
		var29 = vm.f32(3.4)
		var30 = vm.f32(vm.cos(var27) * 1.5)
		effect.SptAddPos(0, var28, var29, var30)
		if vm.imod(var21, 2) == 0 then
			for var31 = 0, 9 do
				if var11[var31 + 1] == 0 then
					var0[var31 + 1] = vm.f32(var10 - 20.0)
					var11[var31 + 1] = 1
					do
						local out1, out2, out3 = effect.SptGetPos(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					effect.SptSetPos(var31 + 1, pos_x, pos_y, pos_z)
					effect.SptSetUvSize(var31 + 1, 0.0, 0.0, 64.0, 64.0)
					value_2 = effect.GetRand(360.0) or value_2
					value_2 = vm.f32(vm.f32(vm.f32(var26 / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
					effect.SptSetRotz(var31 + 1, value_2)
					break
				end
			end
		end
		for var36 = 0, 9 do
			if var11[var36 + 1] ~= 0 then
				var0[var36 + 1] = vm.f32(var0[var36 + 1] - 6.0)
				if var0[var36 + 1] < 48.0 then
					effect.SptSetUvSize(var36 + 1, 64.0, 64.0, 64.0, 64.0)
				end
				if var0[var36 + 1] <= 0.0 then
					effect.SptSetColor(var36 + 1, 128.0, 128.0, 128.0, 0.0)
					var0[var36 + 1] = 0.0
					var11[var36 + 1] = 0
				end
				effect.SptSetColor(var36 + 1, 128.0, 128.0, 128.0, var0[var36 + 1])
			end
		end
		if var21 >= 90 then
			var10 = vm.f32(var10 - vm.f32(4.4))
			if var10 <= 0.0 then
				var10 = 0.0
			end
		end
		effect.SptSetColor(0, 128.0, 128.0, 128.0, var10)
		if var21 >= 120 then
			break
		else
			var21 = var21 + 1
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
