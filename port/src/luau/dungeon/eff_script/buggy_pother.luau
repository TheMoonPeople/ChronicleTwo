--!strict
-- dungeon/eff_script/buggy_pother.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var4: f32 = 0
	local var5: s32 = 0
	local var6: s32 = 0
	local var7: s32 = 0
	local var8: s32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: s32 = 0
	user_id = effect.GetUserId() or user_id
	effect.SptSetTexname("base_eff2")
	effect.SptAssignSprite_1(64)
	effect.SptInitSprite(0, 64)
	effect.SptSetAlphab(0, 1, 64)
	effect.SptSetDrawFlag(0, 1, 64)
	effect.SptSetPutSize(0, 10.24, 8.32, 64)
	effect.SptSetUvSize(0, 65.0, 1.0, 62.0, 62.0, 64)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 64)
	var5 = 0
	var6 = 0
	var7 = 0
	while true do
		if vm.imod(var5, 2) == 0 then
			var8 = 0
			do
				local out1, out2, out3 = effect.ScnGetChrPos(user_id)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			var4 = effect.ScnGetChrRot_2(user_id) or var4
			var4 = effect.AngleLimit(var4) or var4
			if var7 == 1 then
				pos_x = vm.f32(vm.f32(vm.sin(vm.f32(var4 + vm.f32(1.57))) * 35.0) + pos_x)
				pos_z = vm.f32(vm.f32(vm.cos(vm.f32(var4 + vm.f32(1.57))) * 35.0) + pos_z)
				var7 = 0
			else
				pos_x = vm.f32(vm.f32(vm.sin(vm.f32(var4 - vm.f32(1.57))) * 35.0) + pos_x)
				pos_z = vm.f32(vm.f32(vm.cos(vm.f32(var4 - vm.f32(1.57))) * 35.0) + pos_z)
				var7 = 1
			end
			while var8 < 4 do
				value = effect.GetRand(10.0) or value
				value = vm.f32(vm.f32(value - 5.0) + pos_x)
				value_2 = effect.GetRand(5.0) or value_2
				value_2 = vm.f32(vm.f32(value_2 + pos_y) + 14.0)
				value_3 = effect.GetRand(10.0) or value_3
				value_3 = vm.f32(vm.f32(value_3 - 5.0) + pos_z)
				effect.SptSetPos(var6, value, value_2, value_3)
				value = effect.GetRand(0.6) or value
				value = vm.f32(value - vm.f32(0.3))
				value_2 = effect.GetRand(0.6) or value_2
				value_2 = vm.f32(value_2 - vm.f32(0.3))
				effect.SptSetVeloPos(var6, 0.0, 0.0, -20.0)
				effect.SptSetAccPos(var6, value, value_2, 0.0)
				value_4 = effect.GetRand(6.2831855) or value_4
				value_4 = vm.f32(value_4 - vm.f32(3.1415927))
				effect.SptSetRotz(var6, value_4)
				value_5 = effect.GetRandInt(100) or value_5
				if value_5 < 50 then
					value_4 = vm.f32(0.2)
				else
					value_4 = vm.f32(-0.2)
				end
				effect.SptSetVeloRotz(var6, value_4)
				effect.SptSetAccRotz(var6, -vm.f32(value_4 * vm.f32(0.02)))
				effect.SptSetColor(var6, 128.0, 128.0, 128.0, 16.0)
				effect.SptSetVeloCol(var6, 0.0, 0.0, 0.0, 10.24)
				effect.SptSetAccCol(var6, 0.0, 0.0, 0.0, -0.8)
				effect.SptSetScale(var6, 10.0, 10.0)
				effect.SptScaleConv(var6, 40.0, 40.0, 20.0)
				var8 = var8 + 1
				var6 = var6 + 1
				if var6 >= 64 then
					var6 = 0
				end
			end
		end
		var5 = vm.i32(var5 + 1)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
