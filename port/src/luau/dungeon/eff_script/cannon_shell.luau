--!strict
--- Lobs a cannon shell along a gravity arc to its target and explodes on contact.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Flies the shell along a ballistic arc until it hits geometry or a character, then spawns a large explosion.
function script.on_start()
	local shell_x: f32 = 0
	local shell_y: f32 = 0
	local shell_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local damage: s32 = 0
	local blast_type: s32 = 0
	local gravity: f32 = 0
	local distance: f32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	local surface_x: f32 = 0
	local surface_y: f32 = 0
	local surface_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		shell_x = out1 or shell_x
		shell_y = out2 or shell_y
		shell_z = out3 or shell_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	damage = effect.get_script_value(0) or damage
	blast_type = effect.get_script_value(1) or blast_type
	effect.set_effect_character_scale(0.5, 0.5, 0.5)
	do
		local out1, out2, out3 = effect.copy_vector(work_vect2_x, work_vect2_y, work_vect2_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(velocity_x, velocity_y, velocity_z, shell_x, shell_y, shell_z)
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
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 30.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	distance = effect.get_distance_between(shell_x, shell_y, shell_z, work_vect2_x, work_vect2_y, work_vect2_z) or distance
	gravity = vm.f32(vm.f32(-1.1999999) + vm.f32(distance * vm.f32(0.0004)))
	distance = vm.f32(vm.f32(distance / 30.0) + 1.0)
	velocity_y = vm.f32(
		vm.fdiv(
			vm.f32(vm.f32(vm.f32(work_vect2_y - shell_y) * 2.0) - vm.f32(vm.f32(gravity * distance) * distance)),
			vm.f32(distance * 2.0)
		)
	)
	effect.create_collision_primitive("円形チェック用")
	frame = 0
	while frame < 120 do
		do
			local out1, out2, out3 = effect.copy_vector(shell_x, shell_y, shell_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(shell_x, shell_y, shell_z, velocity_x, velocity_y, velocity_z)
			shell_x = out1 or shell_x
			shell_y = out2 or shell_y
			shell_z = out3 or shell_z
		end
		velocity_y = vm.f32(velocity_y + gravity)
		do
			local out1, out2, out3, out4 = effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, shell_x, shell_y, shell_z)
			surface_x = out1 or surface_x
			surface_y = out2 or surface_y
			surface_z = out3 or surface_z
			hit_result = out4 or hit_result
		end
		if hit_result >= 0 then
			do
				local out1, out2, out3 = effect.copy_vector(surface_x, surface_y, surface_z)
				previous_x = out1 or previous_x
				previous_y = out2 or previous_y
				previous_z = out3 or previous_z
			end
			break
		else
			effect.set_collision_primitive_shape(shell_x, shell_y, shell_z, 4.0)
			hit_result = effect.get_collision_primitive_hit_count() or hit_result
			if hit_result > 0 then
				do
					local out1, out2, out3 = effect.get_collision_primitive_hit_position()
					previous_x = out1 or previous_x
					previous_y = out2 or previous_y
					previous_z = out3 or previous_z
				end
				break
			else
				effect.set_effect_character_position(shell_x, shell_y, shell_z)
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
	effect.create_effect_1("Ｍ爆発大")
	effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
	effect.set_effect_value(0, damage)
	effect.set_effect_value(1, blast_type)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
