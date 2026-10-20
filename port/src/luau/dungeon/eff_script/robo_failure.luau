--!strict
-- dungeon/eff_script/robo_failure.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

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
	local value: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	do
		local out1, out2, out3 = effect.ScnGetChrPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	effect.ChrSetPos(pos_x, pos_y, pos_z)
	effect.ChrSetMotion("ループ", -1, 4)
	effect.SptSetTexname("kosyou")
	effect.SptAssignSprite_1(20)
	effect.SptInitSprite(0, 20)
	effect.SptSetDrawFlag(0, 1, 20)
	effect.SptSetAlphab(0, 1, 20)
	effect.SptSetUvSize(0, 1.0, 1.0, 30.0, 30.0, 20)
	effect.SptSetPutSize(0, 8.0, 8.0, 20)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 20)
	value = effect.GetRand(4.0) or value
	value = vm.f32(value + 6.0)
	var4 = effect.GetRand(6.2831855) or var4
	var4 = vm.f32(var4 - vm.f32(3.1415927))
	var4 = effect.AngleLimit(var4) or var4
	pos_x = vm.f32(vm.f32(vm.sin(var4) * value) + pos_x)
	pos_y = vm.f32(20.0 + pos_y)
	pos_z = vm.f32(vm.f32(vm.cos(var4) * value) + pos_z)
	var5 = 0
	var6 = 0
	while true do
		if vm.imod(var5, 4) == 0 then
			effect.SptSetPos(var6, pos_x, pos_y, pos_z)
			effect.SptSetVeloPos(var6, 0.0, 0.8, 0.0)
			value_2 = effect.GetRand(0.01) or value_2
			value_2 = vm.f32(value_2 - vm.f32(0.005))
			value_3 = effect.GetRand(0.01) or value_3
			value_3 = vm.f32(value_3 - vm.f32(0.005))
			effect.SptSetAccPos(var6, value_2, -0.00615, value_3)
			effect.SptSetColor(var6, 128.0, 128.0, 128.0, 16.0)
			effect.SptSetVeloCol(var6, 0.0, 0.0, 0.0, 8.0)
			effect.SptSetAccCol(var6, 0.0, 0.0, 0.0, -0.2)
			effect.SptSetScale(var6, 0.1, 0.1)
			effect.SptSetVeloScl(var6, 0.04, 0.04)
			effect.SptSetAccScl(var6, 0.0005, 0.0005)
			var4 = effect.GetRand(6.2831855) or var4
			var4 = vm.f32(var4 - vm.f32(3.1415927))
			var4 = effect.AngleLimit(var4) or var4
			effect.SptSetRotz(var6, var4)
			var6 = var6 + 1
			if var6 >= 20 then
				var6 = 0
			end
		end
		var5 = var5 + 1
		if var5 >= 20 then
			var5 = 0
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
