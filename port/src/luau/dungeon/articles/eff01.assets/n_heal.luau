--!strict
-- dungeon/articles/eff01.assets/n_heal.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local target_id: s32 = 0
	local var1: s32 = 0
	local value: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: { f32 } = table.create(3, 0)
	local var11: { f32 } = table.create(3, 0)
	local var14: { f32 } = table.create(5, 0)
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local value_2: f32 = 0
	local var23: f32 = 0
	local var24: s32 = 0
	local var25: { s32 } = table.create(3, 0)
	local var28: { s32 } = table.create(3, 0)
	local var34: { f32 } = table.create(3, 0)
	local var37: s32 = 0
	local var38: f32 = 0
	local var39: f32 = 0
	local var40: f32 = 0
	local var41: f32 = 0
	local var42: f32 = 0
	local var43: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var50: s32 = 0
	local var51: s32 = 0
	local var52: f32 = 0
	local var53: s32 = 0
	target_id = effect.GetTargetId() or target_id
	do
		local out1, out2, out3 = effect.ScnGetChrPos(target_id)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	value = 0
	value = effect.GetValue(0) or value
	effect.SptSetTexname("n_heal")
	effect.SptAssignSprite_1(132)
	effect.SptInitSprite(0, 3)
	effect.SptSetAlphab(0, 2, 3)
	effect.SptSetUvSize(0, 0.0, 0.0, 64.0, 64.0, 3)
	if value == 0 then
		effect.SptSetColor(0, 96.0, 210.0, 250.0, 0.0, 3)
	end
	if value == 1 then
		effect.SptSetColor(0, 225.0, 220.0, 0.0, 0.0, 3)
	end
	effect.SptSetDrawFlag(0, 0, 3)
	effect.SptSetPutSize(0, 20.0, 20.0, 3)
	effect.SptSetPos(0, 0.0, 0.0, 0.0, 3)
	effect.SptSetScale(0, 0.5, 0.46, 3)
	effect.SptInitSprite(3, 120)
	effect.SptSetAlphab(3, 2, 120)
	effect.SptSetUvSize(3, 0.0, 64.0, 32.0, 32.0, 120)
	if value == 0 then
		effect.SptSetColor(3, 96.0, 210.0, 250.0, 128.0, 120)
		effect.SetValue(1, 96.0)
		effect.SetValue(2, 210.0)
		effect.SetValue(3, 250.0)
	end
	if value == 1 then
		effect.SptSetColor(3, 225.0, 220.0, 0.0, 128.0, 120)
		effect.SetValue(1, 225.0)
		effect.SetValue(2, 220.0)
		effect.SetValue(3, 0.0)
	end
	effect.SptSetDrawFlag(3, 0, 120)
	effect.SptSetPutSize(3, 6.0, 6.0, 120)
	effect.SptSetPos(3, 0.0, 0.0, 0.0, 120)
	effect.SptInitSprite(123, 9)
	effect.SptSetAlphab(123, 2, 9)
	effect.SptSetUvSize(123, 64.0, 64.0, 64.0, 64.0, 9)
	if value == 0 then
		effect.SptSetColor(123, 96.0, 210.0, 250.0, 36.0, 9)
		effect.SetValue(4, 64.0)
		effect.SetValue(5, 148.0)
		effect.SetValue(6, 128.0)
	end
	if value == 1 then
		effect.SptSetColor(123, 225.0, 220.0, 0.0, 36.0, 9)
		effect.SetValue(4, 225.0)
		effect.SetValue(5, 220.0)
		effect.SetValue(6, 128.0)
	end
	effect.SptSetDrawFlag(123, 0, 9)
	effect.SptSetPutSize(123, 32.0, 32.0, 9)
	effect.SptSetPos(123, 0.0, 0.0, 0.0, 9)
	var1 = 0
	value = 0
	while value < 3 do
		value_2 = effect.GetRand(2.0) or value_2
		value_2 = vm.f32(value_2 + 11.0)
		var23 = vm.f32(vm.f32(2.0943952) * value)
		var19 = vm.f32(vm.sin(var23) * value_2)
		var20 = vm.f32(var6 + 6.0)
		var21 = vm.f32(vm.cos(var23) * value_2)
		effect.SptSetPos(value, var19, var20, var21)
		var8[value + 1] = vm.f32(120.0 * value)
		var11[value + 1] = value_2
		var14[value + 1] = 6.0
		value = value + 1
	end
	effect.SptSetVeloRotz(0, 0.1, 3)
	var24 = 0
	while var24 < 3 do
		var25[var24 + 1] = 0
		var28[var24 + 1] = 0
		var34[var24 + 1] = 1.5
		var24 = var24 + 1
	end
	var24 = 0
	while var1 < 60 do
		if var1 > var24 * 7 and var24 < 3 then
			effect.SptSetDrawFlag(var24, 1)
			do
				local out1, out2, out3 = effect.CopyVector(0.0, 0.0, 0.0)
				var5 = out1 or var5
				var6 = out2 or var6
				var7 = out3 or var7
			end
			var5 = effect.GetValueFloat(1) or var5
			var6 = effect.GetValueFloat(2) or var6
			var7 = effect.GetValueFloat(3) or var7
			effect.SptSetVeloCol(var24, 0.0, 0.0, 0.0, 15.0)
			var24 = var24 + 1
		end
		do
			local out1, out2, out3 = effect.ScnGetChrPos(target_id)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		value = 0
		while value < var24 do
			var8[value + 1] = vm.f32(var8[value + 1] + 11.0)
			var14[value + 1] = vm.f32(var14[value + 1] + 2.5)
			var38 = vm.f32(
				var5 + vm.f32(vm.sin(vm.f32(vm.f32(var8[value + 1] / 180.0) * vm.f32(3.1415927))) * var11[value + 1])
			)
			var39 = vm.f32(var6 + vm.f32(var14[value + 1] * var34[value + 1]))
			var40 = vm.f32(
				var7 + vm.f32(vm.cos(vm.f32(vm.f32(var8[value + 1] / 180.0) * vm.f32(3.1415927))) * var11[value + 1])
			)
			var34[value + 1] = vm.f32(var34[value + 1] - vm.f32(0.05))
			effect.SptSetPos(value, var38, var39, var40)
			if var1 > value * 7 + 8 then
				effect.SptSetVeloCol(value, 0.0, 0.0, 0.0, 0.0)
				effect.SptAddColor(value, 0.0, 0.0, 0.0, -7.0)
			end
			var37 = effect.SptGetDrawFlag(value) or var37
			if var37 == 1 then
				if var25[value + 1] < 40 then
					effect.SptSetDrawFlag(vm.i32(3 + value * 20 * 2 + var25[value + 1]), 1)
					value_3 = effect.GetRand(4.0) or value_3
					effect.GetRand(0.5)
					value_4 = effect.GetRand(360.0) or value_4
					value_3 = vm.f32(value_3 + 2.0)
					var41 = vm.f32(var38 + vm.f32(vm.sin(value_4) * value_3))
					var42 = var39
					var43 = vm.f32(var40 + vm.f32(vm.cos(value_4) * value_3))
					effect.SptSetPos(vm.i32(3 + value * 20 * 2 + var25[value + 1]), var41, var42, var43)
					value_3 = effect.GetRand(4.0) or value_3
					effect.GetRand(0.5)
					value_4 = effect.GetRand(360.0) or value_4
					value_3 = vm.f32(value_3 + 2.0)
					var41 = vm.f32(var38 + vm.f32(vm.sin(value_4) * value_3))
					var42 = var39
					var43 = vm.f32(var40 + vm.f32(vm.cos(value_4) * value_3))
					effect.SptSetPos(vm.i32(vm.i32(3 + value * 20 * 2 + var25[value + 1]) + 1), var41, var42, var43)
					var25[value + 1] = vm.i32(var25[value + 1] + 2)
				end
				var3 = 0
				while var3 < var25[value + 1] do
					var50 = vm.i32(3 + value * 20 * 2 + var3)
					do
						local out1, out2, out3 = effect.SptGetPos(var50)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					pos_y = vm.f32(pos_y + -1.0)
					effect.SptSetPos(var50, pos_x, pos_y, pos_z)
					effect.SptAddColor(var50, 0.0, 0.0, 0.0, -5.0)
					var3 = var3 + 1
				end
			end
			var37 = effect.SptGetDrawFlag(value) or var37
			var37 = 1
			if var37 ~= 0 then
				if var28[value + 1] < 3 then
					var51 = vm.i32(123 + value * 3 + var28[value + 1])
					effect.SptSetDrawFlag(var51, 1)
					effect.SptSetPos(var51, var38, var39, var40)
					var28[value + 1] = vm.i32(var28[value + 1] + 1)
				end
				var4 = 0
				while var4 < var28[value + 1] do
					var53 = vm.i32(123 + value * 3 + var4)
					var52 = vm.f32(5.0 * var4)
					var38 = vm.f32(
						var5
							+ vm.f32(
								vm.sin(vm.f32(vm.f32(vm.f32(var8[value + 1] - var52) / 180.0) * vm.f32(3.1415927)))
									* var11[value + 1]
							)
					)
					var39 = vm.f32(var6 + vm.f32(vm.f32(var14[value + 1] - var52) * var34[value + 1]))
					var40 = vm.f32(
						var7
							+ vm.f32(
								vm.cos(vm.f32(vm.f32(vm.f32(var8[value + 1] - var52) / 180.0) * vm.f32(3.1415927)))
									* var11[value + 1]
							)
					)
					effect.SptSetPos(var53, var38, var39, var40)
					if var1 > value * 7 + 12 then
						effect.SptSetVeloCol(var53, 0.0, 0.0, 0.0, 0.0)
						effect.SptAddColor(var53, 0.0, 0.0, 0.0, -2.0)
					end
					var4 = var4 + 1
				end
			end
			value = value + 1
		end
		vm.wait()
		var1 = var1 + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
