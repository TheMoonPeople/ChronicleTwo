--!strict
--- Flies a gun bullet with a sprite streak until it hits a wall or character, then fades the streak.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Advances the bullet each frame leaving a streak of sprites, stops on a wall or character hit or after 60 frames, and fades the streak after a wall hit.
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
	local wall_x: f32 = 0
	local wall_y: f32 = 0
	local wall_z: f32 = 0
	local wall_normal_x: f32 = 0
	local wall_normal_y: f32 = 0
	local wall_normal_z: f32 = 0
	local streak_x: f32 = 0
	local streak_y: f32 = 0
	local streak_z: f32 = 0
	local intensity: f32 = 0
	local hit_character: s32 = 0
	local frame: s32 = 0
	local hit_result: s32 = 0
	hit_character = 0
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
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(streak_x, streak_y, streak_z)
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(streak_x, streak_y, streak_z, 0.5)
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		do
			local out1, out2, out3, out4, out5, out6, out7 =
				effect.get_intersection_point_14(4, previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z)
			wall_x = out1 or wall_x
			wall_y = out2 or wall_y
			wall_z = out3 or wall_z
			wall_normal_x = out4 or wall_normal_x
			wall_normal_y = out5 or wall_normal_y
			wall_normal_z = out6 or wall_normal_z
			hit_result = out7 or hit_result
		end
		if hit_result >= 0 then
			do
				local out1, out2, out3 = effect.copy_vector(wall_x, wall_y, wall_z)
				bullet_x = out1 or bullet_x
				bullet_y = out2 or bullet_y
				bullet_z = out3 or bullet_z
			end
			effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, streak_x, streak_y, streak_z, 0.0, 0.0, 0.0, 16)
			effect.spread_sprite_colors(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
			intensity = effect.get_vector_length(velocity_x, velocity_y, velocity_z) or intensity
			do
				local out1, out2, out3 = effect.copy_vector(wall_normal_x, wall_normal_y, wall_normal_z)
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
			effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, streak_x, streak_y, streak_z, 0.0, 0.0, 0.0, 16)
			effect.spread_sprite_colors(0, 128.0, 128.0, 128.0, 128.0, 2.0, 2.0, 2.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		end
		effect.set_collision_primitive_shape(previous_x, previous_y, previous_z, bullet_x, bullet_y, bullet_z, 1.0)
		hit_result = effect.get_collision_primitive_hit_count() or hit_result
		if hit_result > 0 then
			hit_character = 1
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
	effect.delete_collision_primitive(-1)
	if frame >= 60 or hit_character == 1 then
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
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(streak_x, streak_y, streak_z)
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(streak_x, streak_y, streak_z, 0.5)
			streak_x = out1 or streak_x
			streak_y = out2 or streak_y
			streak_z = out3 or streak_z
		end
		effect.spread_sprite_positions(0, bullet_x, bullet_y, bullet_z, streak_x, streak_y, streak_z, 0.0, 0.0, 0.0, 16)
		effect.spread_sprite_colors(0, intensity, intensity, intensity, intensity, 0.0, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0, 0.0, 16)
		intensity = vm.f32(intensity - vm.f32(21.333334))
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
