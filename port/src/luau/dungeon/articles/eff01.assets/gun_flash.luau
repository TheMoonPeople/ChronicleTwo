--!strict
-- dungeon/articles/eff01.assets/gun_flash.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local value: f32 = 0
	local value_2: s32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: f32 = 0
	local var12: s32 = 0
	do
		local out1, out2, out3 = effect.GetWorkVect1()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.SptSetTexname("effect00")
	effect.SptAssignSprite_1(2)
	value_2 = 0
	do
		local out1, out2, out3 = effect.CopyVector(0.0, 0.0, 0.0)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	value = 0.0
	value_2 = effect.GetValue(0) or value_2
	var4 = effect.GetValueFloat(1) or var4
	var5 = effect.GetValueFloat(2) or var5
	var6 = effect.GetValueFloat(3) or var6
	value = effect.GetValueFloat(4) or value
	if value_2 == 0 then
		effect.SptInitSprite(0)
		effect.SptSetAlphab(0, 2)
		effect.SptSetDrawFlag(0, 1)
		effect.SptSetPos(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(0, 28.0, 28.0)
		effect.SptSetUvSize(0, 193.0, 1.0, 62.0, 62.0)
		effect.SptSetColor(0, 128.0, 128.0, 128.0, 255.0)
		effect.SptSetVeloCol(0, 0.0, 0.0, 0.0, -51.0)
		var3 = 0.5
		effect.SptInitSprite(1)
		effect.SptSetAlphab(1, 2)
		effect.SptSetDrawFlag(1, 1)
		effect.SptSetPos(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(1, 64.0, 64.0)
		effect.SptSetUvSize(1, 65.0, 65.0, 62.0, 62.0)
		effect.SptSetColor(1, 128.0, 108.0, 40.0, 72.0)
		var9 = 24.0
		var10 = 0
		while var10 < 5 do
			effect.SptSetScale(0, var3, var3)
			var3 = vm.f32(var3 + vm.f32(0.1))
			if var10 == 2 then
				effect.SptAddColor(1, 128.0, 108.0, 40.0, var9)
			else
				var9 = 56.0
				effect.SptAddColor(1, 128.0, 108.0, 40.0, -var9)
			end
			var10 = var10 + 1
			vm.wait()
		end
	end
	if value_2 == 1 then
		var3 = 0.5
		effect.SptInitSprite(1)
		effect.SptSetAlphab(1, 2)
		effect.SptSetDrawFlag(1, 1)
		effect.SptSetPos(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.SptSetPutSize(1, 64.0, 64.0)
		effect.SptSetUvSize(1, 65.0, 65.0, 62.0, 62.0)
		effect.SptSetColor(1, var4, var5, var6, value)
		var11 = 24.0
		var12 = 0
		while var12 < 5 do
			if var12 == 2 then
				effect.SptAddColor(1, var4, var5, var6, var11)
			else
				var11 = 56.0
				effect.SptAddColor(1, var4, var5, var6, -var11)
			end
			var12 = var12 + 1
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
