--!strict
-- dungeon/eff_script/g_magic_sub2.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	local var7: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	var3 = vm.f32(0.4)
	var4 = effect.get_random_number(6.2831855) or var4
	var4 = vm.f32(var4 - vm.f32(3.1415927))
	effect.set_effect_character_visible(1, 1, 0.1)
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	var5 = vm.f32(0.3)
	var6 = vm.f32(0.025)
	var7 = 0
	while var7 < 35 do
		var4 = effect.wrap_angle(var4) or var4
		effect.rotate_effect_character_toward(0.0, var4, 0.0)
		var4 = vm.f32(var4 + vm.f32(0.06))
		if var7 == 9 then
			effect.set_effect_character_visible(0, 1, 0.06)
		end
		effect.set_effect_character_scale(var3, var3, var3)
		if var7 < 3 then
			var3 = vm.f32(var3 + vm.f32(0.6))
		else
			var5 = vm.f32(var5 - var6)
			var3 = vm.f32(var3 - var5)
			if var3 < 0.0 then
				var3 = 0.0
			end
		end
		var7 = var7 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
