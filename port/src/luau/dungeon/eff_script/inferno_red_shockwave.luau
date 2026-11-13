--!strict
--- Inferno's red shockwave that travels forward, damages on contact and fades out.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Moves the wave forward until it hits something and then fades it out.
function script.on_start()
	local wave_x: f32 = 0
	local wave_y: f32 = 0
	local wave_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local frame: s32 = 0
	local damage: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		wave_x = out1 or wave_x
		wave_y = out2 or wave_y
		wave_z = out3 or wave_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(wave_x, wave_y, wave_z)
	effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
	effect.set_effect_character_motion("ループ")
	do
		local out1, out2, out3 = effect.get_direction_vector(rotation_x, rotation_y, rotation_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(velocity_x, velocity_y, velocity_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 15.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.create_collision_primitive("インフェ攻撃")
	effect.set_collision_primitive_damage(damage)
	do
		local out1, out2, out3 = effect.copy_vector(wave_x, wave_y, wave_z)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	frame = 0
	while frame < 115 do
		vm.wait()
		do
			local out1, out2, out3 = effect.add_vectors(wave_x, wave_y, wave_z, velocity_x, velocity_y, velocity_z)
			wave_x = out1 or wave_x
			wave_y = out2 or wave_y
			wave_z = out3 or wave_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(wave_x, wave_y, wave_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(wave_x, wave_y, wave_z)
		effect.set_collision_primitive_shape(wave_x, wave_y, wave_z, 25.0)
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			break
		else
			do
				local _, _, _, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, wave_x, wave_y, wave_z)
				hit_count = out4 or hit_count
			end
			if hit_count >= 0 then
				break
			else
				do
					local out1, out2, out3 = effect.copy_vector(wave_x, wave_y, wave_z)
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				frame = frame + 1
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_character_visible(0, 1, -0.9)
	frame = 0
	while frame < 15 do
		do
			local out1, out2, out3 = effect.add_vectors(wave_x, wave_y, wave_z, velocity_x, velocity_y, velocity_z)
			wave_x = out1 or wave_x
			wave_y = out2 or wave_y
			wave_z = out3 or wave_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(wave_x, wave_y, wave_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(wave_x, wave_y, wave_z)
		do
			local out1, out2, out3 = effect.copy_vector(wave_x, wave_y, wave_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
