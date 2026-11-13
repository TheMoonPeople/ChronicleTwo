--!strict
--- Emits an ultrasonic wave in front of the caster that damages characters in a small area.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Plays the wave motion, enables a damage area ahead of the caster at frame 8 and releases it at frame 18.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local pitch: f32 = 0
	local yaw: f32 = 0
	local roll: f32 = 0
	local radius: f32 = 0
	local damage: s32 = 0
	local has_released_collision: s32 = 0
	radius = 0.0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		pitch = out1 or pitch
		yaw = out2 or yaw
		roll = out3 or roll
	end
	damage = effect.get_script_value(0) or damage
	radius = effect.get_script_value_float(1) or radius
	effect.set_effect_character_position(position_x, position_y, position_z)
	effect.rotate_effect_character_toward(pitch, yaw, roll)
	effect.set_effect_character_motion("発射")
	has_released_collision = 0
	for frame = 0, 29 do
		if frame == 8 then
			effect.create_collision_primitive("弱攻撃")
			effect.set_collision_primitive_damage(damage)
			position_x = vm.f32(position_x + vm.f32(vm.sin(yaw) * 75.0))
			position_z = vm.f32(position_z + vm.f32(vm.cos(yaw) * 75.0))
			effect.set_collision_primitive_shape(position_x, position_y, position_z, radius)
		end
		if frame == 18 then
			has_released_collision = 1
			effect.delete_collision_primitive(-1)
		end
		vm.wait()
	end
	if has_released_collision == 0 then
		effect.delete_collision_primitive(-1)
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
