--!strict
--- Shoots a Memo Eater bullet in a straight line that damages what it hits.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Moves the bullet forward each frame until it hits a character or the map, then spawns a hit effect.
function script.on_start()
	local damage: s32 = 0
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local frame: s32 = 0
	local backward_x: f32 = 0
	local backward_y: f32 = 0
	local backward_z: f32 = 0
	local hit_count: s32 = 0
	local impact_x: f32 = 0
	local impact_y: f32 = 0
	local impact_z: f32 = 0
	effect.get_owner_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	damage = effect.get_script_value(0) or damage
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 5.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.create_collision_primitive("鼻マシンガン")
	effect.set_collision_primitive_damage(damage)
	effect.set_effect_first_work_vector(position_x, position_y, position_z)
	frame = 0
	while frame < 150 do
		do
			local out1, out2, out3 = effect.copy_vector(position_x, position_y, position_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(position_x, position_y, position_z, velocity_x, velocity_y, velocity_z)
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(velocity_x, velocity_y, velocity_z)
			backward_x = out1 or backward_x
			backward_y = out2 or backward_y
			backward_z = out3 or backward_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(backward_x, backward_y, backward_z)
			backward_x = out1 or backward_x
			backward_y = out2 or backward_y
			backward_z = out3 or backward_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(-velocity_x, -velocity_y, -velocity_z)
			backward_x = out1 or backward_x
			backward_y = out2 or backward_y
			backward_z = out3 or backward_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(backward_x, backward_y, backward_z)
			backward_x = out1 or backward_x
			backward_y = out2 or backward_y
			backward_z = out3 or backward_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(backward_x, backward_y, backward_z, 0.5)
			backward_x = out1 or backward_x
			backward_y = out2 or backward_y
			backward_z = out3 or backward_z
		end
		effect.set_collision_primitive_shape(position_x, position_y, position_z, 4.0)
		effect.set_effect_character_position(position_x, position_y, position_z)
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			effect.create_effect_1("メムイータ－弾Ｈ")
			effect.set_effect_first_work_vector(previous_x, previous_y, previous_z)
			break
		else
			do
				local out1, out2, out3, out4 =
					effect.get_intersection_point_11(4, previous_x, previous_y, previous_z, position_x, position_y, position_z)
				impact_x = out1 or impact_x
				impact_y = out2 or impact_y
				impact_z = out3 or impact_z
				hit_count = out4 or hit_count
			end
			if hit_count >= 0 then
				effect.create_effect_1("メムイータ－弾Ｈ")
				effect.set_effect_first_work_vector(impact_x, impact_y, impact_z)
				break
			else
				frame = frame + 1
				vm.wait()
			end
		end
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
