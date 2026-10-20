--!strict
-- dungeon/eff_script/hinoko.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local var14: s32 = 0
	local var16: s32 = 0
	var16 = effect.SptAssignSprite_2(8) or var16
	if var16 == 0 then
		return
	end
	effect.SptSetTexname("hinoko")
	effect.SptInitSprite(0, 8)
	effect.SptSetAlphab(0, 2, 8)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 8)
	effect.SptSetPutSize(0, 1.0, 1.0, 8)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 128.0, 8)
	effect.SptSetDrawFlag(0, 1, 8)
	effect.SptSetPos(0, 0.0, -10.0, 0.0, 8)
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	var14 = 0
	while var14 < 8 do
		value = 1.0
		value_2 = 1.0
		value_3 = 1.0
		value = effect.GetRand(360.0) or value
		value_2 = effect.GetRand(15.0) or value_2
		value_3 = effect.GetRand(8.0) or value_3
		value_4 = effect.GetRand(400.0) or value_4
		effect.GetRand(800.0)
		value = vm.f32(vm.f32(value / 180.0) * vm.f32(3.1415927))
		value_4 = vm.f32(value_4 / 100.0)
		value_4 = vm.f32(value_4 + 2.0)
		var6 = vm.f32(vm.f32(vm.f32(var0 + work_vect2_x) / 2.0) + vm.f32(vm.sin(value) * value_2))
		var7 = vm.f32(vm.f32(vm.f32(vm.f32(var1 + work_vect2_y) / 2.0) - value_3) + 4.0)
		var8 = vm.f32(vm.f32(vm.f32(var2 + work_vect2_z) / 2.0) + vm.f32(vm.cos(value) * value_2))
		effect.SptSetScale(var14, value_4, value_4)
		effect.SptSetPos(var14, var6, var7, var8)
		effect.SptSetVeloCol(var14, 0.0, 0.0, 0.0, -8.0)
		var14 = var14 + 1
	end
	var14 = 0
	while var14 < 20 do
		vm.wait()
		for var15 = 0, 7 do
			do
				local out1, out2, out3 = effect.SptGetPos(var15)
				var0 = out1 or var0
				var1 = out2 or var1
				var2 = out3 or var2
			end
			var1 = vm.f32(var1 - vm.f32(-0.8))
			effect.SptSetPos(var15, var0, var1, var2)
		end
		var14 = var14 + 1
	end
	effect.SptSetDrawFlag(0, 0, 8)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
