--!strict
--- Raises a monster thunder pillar that knocks back characters standing at its position.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script loads; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the thunder pillar animation with a knockback collision that ends on the first hit or near the end of the animation.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local motion_progress: f32 = 0
	local damage: s32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_effect_character_position(position_x, position_y, position_z)
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_motion("雷柱", -1, 6)
	frame = 0
	effect.create_collision_primitive("吹っ飛び攻撃")
	effect.set_collision_primitive_damage(damage)
	effect.set_collision_primitive_shape(position_x, position_y, position_z, 25.0)
	while frame < 56 do
		motion_progress = effect.get_effect_character_motion_progress() or motion_progress
		if motion_progress > vm.f32(0.966) then
			effect.delete_collision_primitive(-1)
			return
		end
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			effect.delete_collision_primitive(-1)
			break
		else
			if frame == 48 then
				effect.delete_collision_primitive(-1)
			end
			vm.wait()
			frame = frame + 1
		end
	end
	effect.delete_collision_primitive(-1)
	while frame < 56 do
		motion_progress = effect.get_effect_character_motion_progress() or motion_progress
		if motion_progress > vm.f32(0.966) then
			effect.delete_collision_primitive(-1)
			return
		end
		if frame == 48 then
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
		frame = frame + 1
	end
	effect.delete_collision_primitive(-1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Empty finish handler; the effect needs no cleanup.
function script.on_finish() end

return script
