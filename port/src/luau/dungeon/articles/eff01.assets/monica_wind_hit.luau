--!strict
--- Shows the impact of Monica's wind magic as rising wind sprites scattered around the hit position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Spawns rising wind sprites around the hit position over twenty frames.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local charge_ratio: f32 = 0
	local sprites_allocated: s32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local frame: s32 = 0
	local random_roll: s32 = 0
	local sprite_index: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	sprites_allocated = effect.allocate_sprites_2(24) or sprites_allocated
	if sprites_allocated == 0 then
		return
	end
	effect.set_sprite_texture("c02wind")
	effect.reset_sprites(0, 24)
	effect.set_sprite_blend_mode(0, 2, 24)
	effect.set_sprite_visible(0, 1, 24)
	effect.set_sprite_size(0, 20.0, 20.0, 24)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 24)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * charge_ratio), 1.0 + vm.f32(1.0 * charge_ratio), 24)
	if charge_ratio < 1.0 then
		effect.play_battle_sound(73, hit_x, hit_y, hit_z)
	else
		effect.play_battle_sound(79, hit_x, hit_y, hit_z)
	end
	sprite_index = 0
	frame = 0
	while frame < 20 do
		if vm.imod(frame, 1) == 0 then
			random_roll = effect.get_random_number_int(100) or random_roll
			if vm.imod(random_roll, 2) == 0 then
				effect.set_sprite_texture_rect(sprite_index, 64.0, 0.0, 64.0, 64.0)
			else
				effect.set_sprite_texture_rect(sprite_index, 64.0, 64.0, 64.0, 64.0)
			end
			sprite_x = effect.get_random_number(10.0 + vm.f32(10.0 * charge_ratio)) or sprite_x
			sprite_x = vm.f32(vm.f32(sprite_x - vm.f32(vm.f32(10.0 + vm.f32(10.0 * charge_ratio)) / 2.0)) + hit_x)
			sprite_y = effect.get_random_number(10.0 + vm.f32(10.0 * charge_ratio)) or sprite_y
			sprite_y = vm.f32(-sprite_y + hit_y)
			sprite_z = effect.get_random_number(10.0 + vm.f32(10.0 * charge_ratio)) or sprite_z
			sprite_z = vm.f32(vm.f32(sprite_z - vm.f32(vm.f32(10.0 + vm.f32(10.0 * charge_ratio)) / 2.0)) + hit_z)
			effect.set_sprite_position(sprite_index, sprite_x, sprite_y, sprite_z)
			effect.set_sprite_velocity(sprite_index, 0.0, 1.0 + vm.f32(1.0 * charge_ratio), 0.0)
			effect.set_sprite_acceleration(sprite_index, 0.0, vm.f32(0.1) + vm.f32(vm.f32(0.1) * charge_ratio), 0.0)
			effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, -20.0)
			effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 25.6)
			effect.set_sprite_color_acceleration(sprite_index, 0.0, 0.0, 0.0, -6.4)
			sprite_index = sprite_index + 1
			if sprite_index >= 24 then
				sprite_index = 0
			end
		end
		frame = frame + 1
		vm.wait()
	end
	frame = 0
	while frame < 10 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
