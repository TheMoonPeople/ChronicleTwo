--!strict
--- Fires a fox character's bullet in a straight line until it hits something.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Flies the bullet along the owner's facing, damaging whatever it touches, until it hits or travels 300 frames.
function script.on_start()
	local user_id: s32 = 0
	local damage: s32 = 0
	local bullet_x: f32 = 0
	local bullet_y: f32 = 0
	local bullet_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local frame: s32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local hit_result: s32 = 0
	damage = effect.get_script_value(0) or damage
	user_id = effect.get_owner_character() or user_id
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bullet_x = out1 or bullet_x
		bullet_y = out2 or bullet_y
		bullet_z = out3 or bullet_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_rotation_4(user_id)
		previous_x = out1 or previous_x
		previous_y = out2 or previous_y
		previous_z = out3 or previous_z
	end
	do
		local out1, out2, out3 = effect.get_direction_vector(previous_x, previous_y, previous_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 20.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_sprite_texture("effect00")
	effect.allocate_sprites_1(16)
	effect.reset_sprites(0, 16)
	effect.set_sprite_blend_mode(0, 2, 16)
	effect.set_sprite_visible(0, 1, 16)
	effect.set_sprite_size(0, 3.0, 3.0, 16)
	effect.set_sprite_texture_rect(0, 32.0, 80.0, 16.0, 16.0, 16)
	effect.create_collision_primitive("通常攻撃")
	effect.set_collision_primitive_damage(damage)
	effect.set_effect_first_work_vector(bullet_x, bullet_y, bullet_z)
	frame = 0
	while frame < 300 do
		do
			local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(bullet_x, bullet_y, bullet_z, velocity_x, velocity_y, velocity_z)
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(velocity_x, velocity_y, velocity_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(trail_x, trail_y, trail_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.set_collision_primitive_shape(bullet_x, bullet_y, bullet_z, 5.0)
		do
			local out1, out2, out3 = effect.copy_vector(-velocity_x, -velocity_y, -velocity_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(trail_x, trail_y, trail_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(trail_x, trail_y, trail_z, 0.5)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 16)
		effect.spread_sprite_colors(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			break
		else
			hit_result = effect.get_intersection_point_8(4, previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z) or hit_result
			if hit_result >= 0 then
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
