--!strict
--- Himarra's spinning attack model that follows its owner and damages in front of it.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Follows the owner, applies the damage sphere partway through the spin, then fades out.
function script.on_start()
	local owner_id: s32 = 0
	local damage: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local owner_rotation_x: f32 = 0
	local owner_rotation_y: f32 = 0
	local owner_rotation_z: f32 = 0
	local frame: s32 = 0
	local strike_x: f32 = 0
	local strike_y: f32 = 0
	local strike_z: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	owner_id = effect.get_owner_character() or owner_id
	print("user id=", owner_id, "------------\n")
	do
		local out1, out2, out3 = effect.get_scene_character_position(owner_id)
		owner_x = out1 or owner_x
		owner_y = out2 or owner_y
		owner_z = out3 or owner_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(owner_id)
		owner_rotation_x = out1 or owner_rotation_x
		owner_rotation_y = out2 or owner_rotation_y
		owner_rotation_z = out3 or owner_rotation_z
	end
	damage = 0
	damage = effect.get_script_value(0) or damage
	effect.set_effect_character_position(owner_x, owner_y, owner_z)
	effect.rotate_effect_character_toward(owner_rotation_x, owner_rotation_y, owner_rotation_z)
	effect.set_effect_character_visible(1, 1, 0.04)
	effect.set_effect_character_motion("ループ", -1, 4)
	frame = 0
	strike_x = vm.f32(vm.f32(vm.sin(owner_rotation_y) * 30.0) + owner_x)
	strike_y = vm.f32(26.0 + owner_y)
	strike_z = vm.f32(vm.f32(vm.cos(owner_rotation_y) * 30.0) + owner_z)
	do
		local out1, out2, out3 = effect.copy_vector(strike_x, strike_y, strike_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.subtract_vectors(direction_x, direction_y, direction_z, owner_x, owner_y, owner_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	do
		local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	while frame < 20 do
		if frame == 9 then
			if damage ~= 0 then
				effect.create_collision_primitive("吹っ飛び攻撃")
				effect.set_collision_primitive_damage(damage)
			end
			if damage ~= 0 then
				effect.set_collision_primitive_shape(strike_x, strike_y, strike_z, 15.0)
			end
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		effect.set_effect_character_position(owner_x, owner_y, owner_z)
		frame = frame + 1
		vm.wait()
	end
	if damage ~= 0 then
		effect.delete_collision_primitive(-1)
	end
	effect.set_effect_character_visible(0, 1, 0.04)
	frame = 0
	while frame < 25 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		effect.set_effect_character_position(owner_x, owner_y, owner_z)
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
