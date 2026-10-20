--!strict
-- dungeon/articles/eff01.assets/foot_hamon.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.GetWorkVect2()
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	effect.ChrSetPos(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.ChrSetScale(var3, var4, var5)
	var9 = effect.GetRand(6.2831855) or var9
	var9 = vm.f32(var9 - vm.f32(3.1415927))
	var9 = effect.AngleLimit(var9) or var9
	effect.ChrSetRot(0.0, var9, 0.0)
	do
		local out1, out2, out3 = effect.CopyVector(0.06, 0.06, 0.06)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	effect.ChrSetShow(1, 1, 0.04)
	var10 = 0
	while var10 < 55 do
		effect.ChrSetScale(var3, var4, var5)
		do
			local out1, out2, out3 = effect.AddVector(var3, var4, var5, var6, var7, var8)
			var3 = out1 or var3
			var4 = out2 or var4
			var5 = out3 or var5
		end
		do
			local out1, out2, out3 = effect.ScaleVector(var6, var7, var8, 0.96)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		if var10 == 30 then
			effect.ChrSetShow(0, 1, 0.04)
		end
		var10 = var10 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
