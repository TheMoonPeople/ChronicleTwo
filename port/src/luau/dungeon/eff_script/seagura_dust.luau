--!strict
-- dungeon/eff_script/seagura_dust.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local value: f32 = 0
	local value_2: s32 = 0
	local hit_num: s32 = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local value_3: f32 = 0
	local value_4: s32 = 0
	hit_num = 0
	value_2 = 0
	value = 0.0
	value_2 = effect.GetValue(0) or value_2
	value = effect.GetValueFloat(1) or value
	effect.SptSetTexname("base_eff2")
	effect.SptAssignSprite_1(80)
	effect.SptInitSprite(0, 80)
	effect.SptSetAlphab(0, 1, 80)
	effect.SptSetDrawFlag(0, 1, 80)
	effect.SptSetPutSize(0, 10.24, 8.32, 80)
	effect.SptSetUvSize(0, 65.0, 1.0, 62.0, 62.0, 80)
	effect.SptSetColor(0, 128.0, 128.0, 128.0, 0.0, 80)
	effect.ColprimCreate("強線形敵")
	effect.ColprimSetDamage(value_2)
	var9 = 0
	var10 = 0
	while true do
		do
			local out1, out2, out3 = effect.GetWorkVect1()
			work_vect1_x = out1 or work_vect1_x
			work_vect1_y = out2 or work_vect1_y
			work_vect1_z = out3 or work_vect1_z
		end
		do
			local out1, out2, out3 = effect.GetWorkVect2()
			work_vect2_x = out1 or work_vect2_x
			work_vect2_y = out2 or work_vect2_y
			work_vect2_z = out3 or work_vect2_z
		end
		if vm.imod(var9, 4) == 0 then
			do
				local out1, out2, out3 = effect.CopyVector(work_vect2_x, work_vect2_y, work_vect2_z)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.SubVector(var14, var15, var16, work_vect1_x, work_vect1_y, work_vect1_z)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.DivVector(var14, var15, var16, 10)
				var14 = out1 or var14
				var15 = out2 or var15
				var16 = out3 or var16
			end
			do
				local out1, out2, out3 = effect.CopyVector(work_vect1_x, work_vect1_y, work_vect1_z)
				var11 = out1 or var11
				var12 = out2 or var12
				var13 = out3 or var13
			end
			for var17 = 0, 9 do
				effect.SptSetPos(var10, var11, var12, var13)
				effect.SptSetColor(var10, 128.0, 128.0, 128.0, 16.0)
				effect.SptSetVeloCol(var10, 0.0, 0.0, 0.0, 10.24)
				effect.SptSetAccCol(var10, 0.0, 0.0, 0.0, -0.8)
				effect.SptSetScale(var10, 10.0, 10.0)
				effect.SptScaleConv(var10, 40.0, 40.0, 30.0)
				value_3 = effect.GetRand(6.2831855) or value_3
				value_3 = vm.f32(value_3 - vm.f32(3.1415927))
				effect.SptSetRotz(var10, value_3)
				value_4 = effect.GetRandInt(100) or value_4
				if value_4 < 50 then
					value_3 = vm.f32(0.14)
				else
					value_3 = vm.f32(-0.14)
				end
				effect.SptSetVeloRotz(var10, value_3)
				effect.SptSetAccRotz(var10, -vm.f32(value_3 * vm.f32(0.02)))
				do
					local out1, out2, out3 = effect.AddVector(var11, var12, var13, var14, var15, var16)
					var11 = out1 or var11
					var12 = out2 or var12
					var13 = out3 or var13
				end
				var10 = vm.i32(var10 + 1)
			end
			if var10 >= 80 then
				var10 = 0
			end
		end
		if hit_num <= 0 then
			effect.ColprimSetCoord(
				work_vect1_x,
				work_vect1_y,
				work_vect1_z,
				work_vect2_x,
				work_vect2_y,
				work_vect2_z,
				value
			)
			hit_num = effect.ColprimGetHitcnt() or hit_num
			if hit_num > 0 then
				effect.ColprimDelete(-1)
			end
		end
		var9 = vm.i32(var9 + 1)
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local var0: s32 = 0
	effect.ColprimDelete(-1)
	var0 = 0
	while var0 < 30 do
		var0 = var0 + 1
		vm.wait()
	end
end

return script
