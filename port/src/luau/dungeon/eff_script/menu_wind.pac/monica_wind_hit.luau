--!strict
--- Impact effect of Monica's wind magic that scatters rising wind sprites at the hit point.

local vm = require("@lib/vm")

local script = {}

--- Performs no setup for the wind hit effect.
function script.setup() end

--- Spawns rising wind sprites around the hit position.
function script.on_start()
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local size_boost: f32 = 0
	local sprite_allocation: s32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local frame_count: s32 = 0
	local texture_choice: s32 = 0
	local sprite_index: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	size_boost = effect.get_script_value_float(0) or size_boost
	sprite_allocation = effect.allocate_sprites_2(24) or sprite_allocation
	if sprite_allocation == 0 then
		return
	end
	effect.set_sprite_texture("c02wind")
	effect.reset_sprites(0, 24)
	effect.set_sprite_blend_mode(0, 2, 24)
	effect.set_sprite_visible(0, 1, 24)
	effect.set_sprite_size(0, 20.0, 20.0, 24)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 24)
	effect.set_sprite_scale(0, 1.0 + vm.f32(1.0 * size_boost), 1.0 + vm.f32(1.0 * size_boost), 24)
	sprite_index = 0
	frame_count = 0
	while frame_count < 20 do
		if vm.imod(frame_count, 1) == 0 then
			texture_choice = effect.get_random_number_int(100) or texture_choice
			if vm.imod(texture_choice, 2) == 0 then
				effect.set_sprite_texture_rect(sprite_index, 64.0, 0.0, 64.0, 64.0)
			else
				effect.set_sprite_texture_rect(sprite_index, 64.0, 64.0, 64.0, 64.0)
			end
			offset_x = effect.get_random_number(10.0 + vm.f32(10.0 * size_boost)) or offset_x
			offset_x = vm.f32(vm.f32(offset_x - vm.f32(vm.f32(10.0 + vm.f32(10.0 * size_boost)) / 2.0)) + hit_x)
			offset_y = effect.get_random_number(10.0 + vm.f32(10.0 * size_boost)) or offset_y
			offset_y = vm.f32(-offset_y + hit_y)
			offset_z = effect.get_random_number(10.0 + vm.f32(10.0 * size_boost)) or offset_z
			offset_z = vm.f32(vm.f32(offset_z - vm.f32(vm.f32(10.0 + vm.f32(10.0 * size_boost)) / 2.0)) + hit_z)
			effect.set_sprite_position(sprite_index, offset_x, offset_y, offset_z)
			effect.set_sprite_velocity(sprite_index, 0.0, 1.0 + vm.f32(1.0 * size_boost), 0.0)
			effect.set_sprite_acceleration(sprite_index, 0.0, vm.f32(0.1) + vm.f32(vm.f32(0.1) * size_boost), 0.0)
			effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, -20.0)
			effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 25.6)
			effect.set_sprite_color_acceleration(sprite_index, 0.0, 0.0, 0.0, -6.4)
			sprite_index = sprite_index + 1
			if sprite_index >= 24 then
				sprite_index = 0
			end
		end
		frame_count = frame_count + 1
		vm.wait()
	end
	frame_count = 0
	while frame_count < 10 do
		frame_count = frame_count + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
