--!strict
--- Impact effect of Monica's ice magic that scatters frost sprites around the hit position.

local vm = require("@lib/vm")

local script = {}

--- Performs no setup for the ice hit.
function script.setup() end

--- Scatters frost sprites around the hit point while a spinning ice shard fades out.
function script.on_start()
	local shard_x: f32 = 0
	local shard_y: f32 = 0
	local shard_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local charge_level: f32 = 0
	local shard_yaw: f32 = 0
	local delta_x: f32 = 0
	local delta_y: f32 = 0
	local delta_z: f32 = 0
	local frame: s32 = 0
	local sprite_angle: f32 = 0
	local sprite_radius: f32 = 0
	local sprite_height_offset: f32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
		shard_x = out1 or shard_x
		shard_y = out2 or shard_y
		shard_z = out3 or shard_z
	end
	hit_y = vm.f32(hit_y + 2.0)
	shard_y = vm.f32(shard_y - 30.0)
	charge_level = effect.get_script_value_float(0) or charge_level
	shard_yaw = effect.get_random_number(6.2831855) or shard_yaw
	shard_yaw = vm.f32(shard_yaw - vm.f32(3.1415927))
	effect.rotate_effect_character_toward(0.0, shard_yaw, 0.0)
	effect.set_effect_character_scale(4.0 + vm.f32(4.0 * charge_level), 4.0 + vm.f32(4.0 * charge_level), 4.0 + vm.f32(4.0 * charge_level))
	effect.set_effect_character_visible(1, 1, 0.0625)
	effect.allocate_sprites_1(10)
	effect.set_sprite_texture("c02cold")
	effect.reset_sprites(0, 10)
	effect.set_sprite_visible(0, 1, 10)
	effect.set_sprite_blend_mode(0, 2, 10)
	effect.set_sprite_size(0, 6.0, 6.0, 10)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 10)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 10)
	frame = 0
	while frame < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
			delta_x = out1 or delta_x
			delta_y = out2 or delta_y
			delta_z = out3 or delta_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(delta_x, delta_y, delta_z, shard_x, shard_y, shard_z)
			delta_x = out1 or delta_x
			delta_y = out2 or delta_y
			delta_z = out3 or delta_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(delta_x, delta_y, delta_z, 2.0)
			delta_x = out1 or delta_x
			delta_y = out2 or delta_y
			delta_z = out3 or delta_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(shard_x, shard_y, shard_z, delta_x, delta_y, delta_z)
			shard_x = out1 or shard_x
			shard_y = out2 or shard_y
			shard_z = out3 or shard_z
		end
		effect.set_effect_character_position(shard_x, shard_y, shard_z)
		sprite_angle = effect.get_random_number(6.2831855) or sprite_angle
		sprite_angle = vm.f32(sprite_angle - vm.f32(3.1415927))
		sprite_radius = effect.get_random_number(2.0) or sprite_radius
		sprite_radius = vm.f32(sprite_radius + vm.f32(6.0 + vm.f32(6.0 * charge_level)))
		sprite_height_offset = effect.get_random_number(10.0 + vm.f32(10.0 * charge_level)) or sprite_height_offset
		sprite_height_offset = vm.f32(sprite_height_offset - vm.f32(vm.f32(10.0 + vm.f32(10.0 * charge_level)) / 2.0))
		sprite_x = vm.f32(vm.f32(vm.sin(sprite_angle) * sprite_radius) + shard_x)
		sprite_y = vm.f32(sprite_height_offset + shard_y)
		sprite_z = vm.f32(vm.f32(vm.cos(sprite_angle) * sprite_radius) + shard_z)
		effect.set_sprite_position(frame, sprite_x, sprite_y, sprite_z)
		effect.set_sprite_color(frame, 128.0, 128.0, 128.0, 92.0)
		effect.ease_sprite_color(frame, 128.0, 128.0, 128.0, 0.0, 8.0)
		effect.set_sprite_scale(frame, 2.0 + vm.f32(2.0 * charge_level), 2.0 + vm.f32(2.0 * charge_level))
		effect.ease_sprite_scale(frame, 4.0 + vm.f32(4.0 * charge_level), 4.0 + vm.f32(4.0 * charge_level), 6.0)
		sprite_angle = effect.get_random_number(6.2831855) or sprite_angle
		sprite_angle = vm.f32(sprite_angle - vm.f32(3.1415927))
		effect.set_sprite_rotation(frame, sprite_angle)
		frame = frame + 1
		vm.wait()
	end
	frame = 0
	while frame < 10 do
		frame = frame + 1
		vm.wait()
	end
	effect.set_effect_character_visible(0, 1, 0.2)
	frame = 0
	while frame < 5 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
