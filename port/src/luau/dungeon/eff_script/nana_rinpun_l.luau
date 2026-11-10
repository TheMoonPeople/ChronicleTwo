--!strict
-- dungeon/eff_script/nana_rinpun_l.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local scale: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local work_vect2_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: s32 = 0
	local target_id: s32 = 0
	local var17: s32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local var28: f32 = 0
	local var29: f32 = 0
	local reversed: s32 = 0
	local hit_num: s32 = 0
	scale = 12.5
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		var1 = out1 or var1
		var2 = out2 or var2
		var3 = out3 or var3
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		var4 = out1 or var4
		var5 = out2 or var5
		work_vect2_z = out3 or work_vect2_z
	end
	value = effect.get_script_value(0) or value
	target_id = effect.get_target_character() or target_id
	effect.set_effect_character_position(var1, var2, var3)
	effect.rotate_effect_character_toward(var4, var5, work_vect2_z)
	effect.set_effect_character_motion("ループ", -1.0, 4)
	var17 = 0
	while var17 < 300 do
		if var17 <= 6 then
			do
				local out1, out2, out3 = effect.get_direction_vector(var4, var5, work_vect2_z)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
		elseif var17 <= 30 then
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				pos_x = out1 or pos_x
				pos_y = out2 or pos_y
				pos_z = out3 or pos_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(pos_x, pos_y, pos_z)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(var19, var20, var21, var1, var2, var3)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
			do
				local out1, out2, out3 = effect.normalize_vector(var19, var20, var21)
				var19 = out1 or var19
				var20 = out2 or var20
				var21 = out3 or var21
			end
		end
		do
			local out1, out2, out3 = effect.copy_vector(var19, var20, var21)
			var22 = out1 or var22
			var23 = out2 or var23
			var24 = out3 or var24
		end
		do
			local out1, out2, out3 = effect.scale_vector(var22, var23, var24, scale)
			var22 = out1 or var22
			var23 = out2 or var23
			var24 = out3 or var24
		end
		do
			local out1, out2, out3 = effect.add_vectors(var1, var2, var3, var22, var23, var24)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			pos_x_2 = out1 or pos_x_2
			pos_y_2 = out2 or pos_y_2
			pos_z_2 = out3 or pos_z_2
		end
		pos_y_2 = vm.f32(pos_y_2 + 30.0)
		do
			local out1, out2, _ = effect.get_rotation_toward_9(var1, var2, var3, pos_x_2, pos_y_2, pos_z_2)
			var28 = out1 or var28
			var29 = out2 or var29
		end
		var28 = vm.f32(var28 - var4)
		var29 = vm.f32(var29 - var5)
		var28 = effect.wrap_angle(var28) or var28
		var29 = effect.wrap_angle(var29) or var29
		var28 = vm.f32(var28 / 30.0)
		var29 = vm.f32(var29 / 60.0)
		var4 = vm.f32(var4 + var28)
		var5 = vm.f32(var5 + var29)
		var4 = effect.wrap_angle(var4) or var4
		var5 = effect.wrap_angle(var5) or var5
		do
			local out1, _, _, _ = effect.get_collision_primitive_knockback()
			reversed = out1 or reversed
		end
		if reversed > 0 then
			effect.create_effect_1("ガードエフェクトＡ")
			effect.set_effect_first_work_vector(var1, var2, var3)
			effect.create_effect_1("蝶りんぷんＨ")
			effect.set_effect_first_work_vector(var1, var2, var3)
			break
		else
			effect.set_effect_character_position(var1, var2, var3)
			effect.rotate_effect_character_toward(var4, var5, work_vect2_z)
			hit_num = effect.get_collision_primitive_hit_count() or hit_num
			if hit_num >= 1 then
				effect.create_effect_1("蝶りんぷんＨ")
				effect.set_effect_first_work_vector(var1, var2, var3)
				break
			else
				if vm.imod(var17, 6) == 0 then
					effect.delete_collision_primitive(-1)
					effect.get_owner_character()
					effect.create_collision_primitive("りんぷん")
					effect.set_collision_primitive_damage(value)
					effect.set_collision_primitive_shape(var1, var2, var3, 20.0)
				end
				var17 = var17 + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	var17 = 0
	effect.set_effect_character_visible(0, 1, -3.0)
	while var17 < 30 do
		var17 = var17 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
