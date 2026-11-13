--!strict
--- Monica's ice magic impact that spawns a frost model and a cluster of expanding frost puffs at the hit point.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Spawns a frost model that rises toward the hit point along with drifting frost puffs, then fades them out.
function script.on_start()
	local model_x: f32 = 0
	local model_y: f32 = 0
	local model_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local power: f32 = 0
	local model_yaw: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local frame: s32 = 0
	local puff_angle: f32 = 0
	local puff_radius: f32 = 0
	local puff_height: f32 = 0
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		hit_x = out1 or hit_x
		hit_y = out2 or hit_y
		hit_z = out3 or hit_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
		model_x = out1 or model_x
		model_y = out2 or model_y
		model_z = out3 or model_z
	end
	hit_y = vm.f32(hit_y + 2.0)
	model_y = vm.f32(model_y - 30.0)
	power = effect.get_script_value_float(0) or power
	model_yaw = effect.get_random_number(6.2831855) or model_yaw
	model_yaw = vm.f32(model_yaw - vm.f32(3.1415927))
	effect.rotate_effect_character_toward(0.0, model_yaw, 0.0)
	effect.set_effect_character_scale(4.0 + vm.f32(4.0 * power), 4.0 + vm.f32(4.0 * power), 4.0 + vm.f32(4.0 * power))
	effect.set_effect_character_visible(1, 1, 0.0625)
	effect.allocate_sprites_1(10)
	effect.set_sprite_texture("c02cold")
	effect.reset_sprites(0, 10)
	effect.set_sprite_visible(0, 1, 10)
	effect.set_sprite_blend_mode(0, 2, 10)
	effect.set_sprite_size(0, 6.0, 6.0, 10)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 10)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 10)
	if power < 1.0 then
		effect.play_battle_sound(71, model_x, model_y, model_z)
	else
		effect.play_battle_sound(77, model_x, model_y, model_z)
	end
	frame = 0
	while frame < 10 do
		do
			local out1, out2, out3 = effect.copy_vector(hit_x, hit_y, hit_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, model_x, model_y, model_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 2.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(model_x, model_y, model_z, step_x, step_y, step_z)
			model_x = out1 or model_x
			model_y = out2 or model_y
			model_z = out3 or model_z
		end
		effect.set_effect_character_position(model_x, model_y, model_z)
		puff_angle = effect.get_random_number(6.2831855) or puff_angle
		puff_angle = vm.f32(puff_angle - vm.f32(3.1415927))
		puff_radius = effect.get_random_number(2.0) or puff_radius
		puff_radius = vm.f32(puff_radius + vm.f32(6.0 + vm.f32(6.0 * power)))
		puff_height = effect.get_random_number(10.0 + vm.f32(10.0 * power)) or puff_height
		puff_height = vm.f32(puff_height - vm.f32(vm.f32(10.0 + vm.f32(10.0 * power)) / 2.0))
		puff_x = vm.f32(vm.f32(vm.sin(puff_angle) * puff_radius) + model_x)
		puff_y = vm.f32(puff_height + model_y)
		puff_z = vm.f32(vm.f32(vm.cos(puff_angle) * puff_radius) + model_z)
		effect.set_sprite_position(frame, puff_x, puff_y, puff_z)
		effect.set_sprite_color(frame, 128.0, 128.0, 128.0, 92.0)
		effect.ease_sprite_color(frame, 128.0, 128.0, 128.0, 0.0, 8.0)
		effect.set_sprite_scale(frame, 2.0 + vm.f32(2.0 * power), 2.0 + vm.f32(2.0 * power))
		effect.ease_sprite_scale(frame, 4.0 + vm.f32(4.0 * power), 4.0 + vm.f32(4.0 * power), 6.0)
		puff_angle = effect.get_random_number(6.2831855) or puff_angle
		puff_angle = vm.f32(puff_angle - vm.f32(3.1415927))
		effect.set_sprite_rotation(frame, puff_angle)
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
