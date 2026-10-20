--!strict
-- dungeon/eff_script/beam.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	effect.SptSetTexname("nana_rinpun")
	effect.SptAssignSprite_1(600)
	effect.SptInitSprite(0, 600)
	effect.SptSetAlphab(0, 2, 600)
	effect.SptSetDrawFlag(0, 1, 600)
	effect.SptSetPos(0, 0.0, -1000.0, 0.0, 600)
	effect.SptSetPutSize(0, 4.0, 4.0, 600)
	effect.SptSetUvSize(0, 129.0, 1.0, 126.0, 126.0, 600)
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
		do
			local out1, out2, out3 = effect.CopyVector(work_vect2_x, work_vect2_y, work_vect2_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.SubVector(var6, var7, var8, work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.DivVector(var6, var7, var8, 600.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.SptVanSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z, var6, var7, var8, 0.0, 0.0, 0.0, 600)
		vm.wait()
	end
end

--- Ends an effect.
function script.on_finish()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	var9 = 128.0
	var10 = 128.0
	var11 = 128.0
	var12 = 128.0
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
		do
			local out1, out2, out3 = effect.CopyVector(work_vect2_x, work_vect2_y, work_vect2_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.SubVector(var6, var7, var8, work_vect1_x, work_vect1_y, work_vect1_z)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		do
			local out1, out2, out3 = effect.DivVector(var6, var7, var8, 600.0)
			var6 = out1 or var6
			var7 = out2 or var7
			var8 = out3 or var8
		end
		effect.SptVanSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z, var6, var7, var8, 0.0, 0.0, 0.0, 600)
		effect.SptSetColor(0, var9, var10, var11, var12, 600)
		var12 = vm.f32(var12 - 4.0)
		if var12 <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

return script
