--!strict
--- Flies a bullet with a sprite streak, stopping at walls or on a character hit.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Advances the bullet each frame, leaving a streak of sprites, and ends on a character hit, a wall or timeout, fading the streak out only after a wall hit.
function script.on_start()
	local bullet_x: f32 = 0
	local bullet_y: f32 = 0
	local bullet_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local normal_x: f32 = 0
	local normal_y: f32 = 0
	local normal_z: f32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local intensity: f32 = 0
	local has_hit_target: s32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	has_hit_target = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		bullet_x = out1 or bullet_x
		bullet_y = out2 or bullet_y
		bullet_z = out3 or bullet_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_sprite_texture("effect00")
	effect.allocate_sprites_1(16)
	effect.reset_sprites(0, 16)
	effect.set_sprite_blend_mode(0, 2, 16)
	effect.set_sprite_visible(0, 1, 16)
	effect.set_sprite_size(0, 1.0, 1.0, 16)
	effect.set_sprite_texture_rect(0, 32.0, 80.0, 16.0, 16.0, 16)
	frame = 0
	while frame < 60 do
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
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.get_intersection_point_14(4, previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
			hit_x = out1 or hit_x
			hit_y = out2 or hit_y
			hit_z = out3 or hit_z
			normal_x = out4 or normal_x
			normal_y = out5 or normal_y
			normal_z = out6 or normal_z
			hit_result = out7 or hit_result
		end
		if hit_result >= 0 then
			do
				local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
				bullet_x = out1 or bullet_x
				bullet_y = out2 or bullet_y
				bullet_z = out3 or bullet_z
			end
			effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 16)
			effect.spread_sprite_colors(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
			intensity = effect.get_vector_length(velocity_x, velocity_y, velocity_z) or intensity
			do
				local out1, out2, out3 = effect.copy_vector(normal_x, normal_y, normal_z)
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
				local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, intensity / 2.0)
				velocity_x = out1 or velocity_x
				velocity_y = out2 or velocity_y
				velocity_z = out3 or velocity_z
			end
			break
		else
			effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, trail_x, trail_y, trail_z, 0.0, 0.0, 0.0, 16)
			effect.spread_sprite_colors(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		end
		effect.set_collision_primitive_shape(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z, 1.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			has_hit_target = 1
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	if frame >= 60 or has_hit_target == 1 then
		return
	end
	intensity = 128.0
	vm.wait()
	frame = 0
	while frame < 6 do
		do
			local out1, out2, out3 = effect.add_vectors(bullet_x, bullet_y, bullet_z, velocity_x, velocity_y, velocity_z)
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
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
		effect.spread_sprite_colors(0, intensity, intensity, intensity, intensity, 0.0, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		intensity = vm.f32(intensity - vm.f32(21.333334))
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
