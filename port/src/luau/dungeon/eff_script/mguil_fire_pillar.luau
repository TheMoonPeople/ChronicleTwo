--!strict
--- The fire pillar that erupts where Mguil's fire attacks land.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Plays the fire pillar motion at the impact point with a damaging hitbox that is removed once it hits or the pillar fades.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local frame: s32 = 0
	local value: s32 = 0
	local hit_num: s32 = 0
	local has_hit: s32 = 0
	local value_2: s32 = 0
	local check_motion_end: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.get_second_work_vector()
	value = effect.get_script_value(0) or value
	value_2 = effect.get_script_value(1) or value_2
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(0.0, 0.0, 0.0)
	effect.set_effect_character_scale(3.0, 3.0, 3.0)
	effect.set_effect_character_motion("火柱", -1, 6)
	effect.create_collision_primitive("Ｍギル火柱１")
	effect.set_collision_primitive_damage(value)
	effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 25.0)
	effect.play_character_sound(value_2, 9)
	has_hit = 0
	frame = 0
	while frame < 25 do
		if frame >= 10 then
			if has_hit == 0 then
				hit_num = effect.get_collision_primitive_hit_count() or hit_num
				if hit_num > 0 then
					if has_hit == 0 then
						has_hit = 1
						effect.delete_collision_primitive(-1)
					end
				end
			end
		end
		if frame == 10 then
			effect.delete_collision_primitive(-1)
			effect.create_collision_primitive("攻撃弱")
			effect.set_collision_primitive_damage(value)
			effect.set_collision_primitive_shape(work_vect1_x, work_vect1_y, work_vect1_z, 30.0)
		end
		if frame == 20 then
			if has_hit == 0 then
				has_hit = 1
				effect.delete_collision_primitive(-1)
			end
		end
		frame = frame + 1
		vm.wait()
	end
	check_motion_end = 0
	while check_motion_end == 0 do
		vm.wait()
		check_motion_end = effect.is_effect_character_motion_finished() or check_motion_end
	end
	if has_hit == 0 then
		has_hit = 1
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
