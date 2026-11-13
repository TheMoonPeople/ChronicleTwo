--!strict
--- Shows the impact of Monica's ice magic as frost sprites scattered around the hit position.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Moves an ice effect character up to the hit position while scattering fading frost sprites around it.
function script.on_start()
	local effect_x: f32 = 0
	local effect_y: f32 = 0
	local effect_z: f32 = 0
	local hit_x: f32 = 0
	local hit_y: f32 = 0
	local hit_z: f32 = 0
	local charge_ratio: f32 = 0
	local random_yaw: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local frame: s32 = 0
	local random_angle: f32 = 0
	local radius: f32 = 0
	local height_offset: f32 = 0
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
		effect_x = out1 or effect_x
		effect_y = out2 or effect_y
		effect_z = out3 or effect_z
	end
	hit_y = vm.f32(hit_y + 2.0)
	effect_y = vm.f32(effect_y - 30.0)
	charge_ratio = effect.get_script_value_float(0) or charge_ratio
	random_yaw = effect.get_random_number(6.2831855) or random_yaw
	random_yaw = vm.f32(random_yaw - vm.f32(3.1415927))
	effect.rotate_effect_character_toward(0.0, random_yaw, 0.0)
	effect.set_effect_character_scale(4.0 + vm.f32(4.0 * charge_ratio), 4.0 + vm.f32(4.0 * charge_ratio), 4.0 + vm.f32(4.0 * charge_ratio))
	effect.set_effect_character_visible(1, 1, 0.0625)
	effect.allocate_sprites_1(10)
	effect.set_sprite_texture("c02cold")
	effect.reset_sprites(0, 10)
	effect.set_sprite_visible(0, 1, 10)
	effect.set_sprite_blend_mode(0, 2, 10)
	effect.set_sprite_size(0, 6.0, 6.0, 10)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0, 10)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 10)
	if charge_ratio < 1.0 then
		effect.play_battle_sound(71, effect_x, effect_y, effect_z)
	else
		effect.play_battle_sound(77, effect_x, effect_y, effect_z)
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
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, effect_x, effect_y, effect_z)
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
			local out1, out2, out3 = effect.add_vectors(effect_x, effect_y, effect_z, step_x, step_y, step_z)
			effect_x = out1 or effect_x
			effect_y = out2 or effect_y
			effect_z = out3 or effect_z
		end
		effect.set_effect_character_position(effect_x, effect_y, effect_z)
		random_angle = effect.get_random_number(6.2831855) or random_angle
		random_angle = vm.f32(random_angle - vm.f32(3.1415927))
		radius = effect.get_random_number(2.0) or radius
		radius = vm.f32(radius + vm.f32(6.0 + vm.f32(6.0 * charge_ratio)))
		height_offset = effect.get_random_number(10.0 + vm.f32(10.0 * charge_ratio)) or height_offset
		height_offset = vm.f32(height_offset - vm.f32(vm.f32(10.0 + vm.f32(10.0 * charge_ratio)) / 2.0))
		sprite_x = vm.f32(vm.f32(vm.sin(random_angle) * radius) + effect_x)
		sprite_y = vm.f32(height_offset + effect_y)
		sprite_z = vm.f32(vm.f32(vm.cos(random_angle) * radius) + effect_z)
		effect.set_sprite_position(frame, sprite_x, sprite_y, sprite_z)
		effect.set_sprite_color(frame, 128.0, 128.0, 128.0, 92.0)
		effect.ease_sprite_color(frame, 128.0, 128.0, 128.0, 0.0, 8.0)
		effect.set_sprite_scale(frame, 2.0 + vm.f32(2.0 * charge_ratio), 2.0 + vm.f32(2.0 * charge_ratio))
		effect.ease_sprite_scale(frame, 4.0 + vm.f32(4.0 * charge_ratio), 4.0 + vm.f32(4.0 * charge_ratio), 6.0)
		random_angle = effect.get_random_number(6.2831855) or random_angle
		random_angle = vm.f32(random_angle - vm.f32(3.1415927))
		effect.set_sprite_rotation(frame, random_angle)
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
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
