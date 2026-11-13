--!strict
--- Shows a glowing charge-up effect tinted by the spell colour while Monica charges a spell.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Builds the charge glow sprites and loops their pulse animation.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local pulse_scale: f32 = 0
	local frame: s32 = 0
	local pulse_index: s32 = 0
	local random_angle: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		color_red = out1 or color_red
		color_green = out2 or color_green
		color_blue = out3 or color_blue
	end
	effect.set_sprite_texture("effect01")
	effect.allocate_sprites_1(5)
	effect.reset_sprites(0, 5)
	effect.set_sprite_blend_mode(0, 2, 5)
	effect.set_sprite_visible(0, 1, 5)
	effect.set_sprite_size(0, 10.24, 8.32)
	effect.set_sprite_texture_rect(0, 64.0, 128.0, 64.0, 64.0)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0)
	effect.ease_sprite_color(0, color_red, color_green, color_blue, 128.0, 16.0)
	effect.set_sprite_scale(0, 0.0, 0.0)
	effect.ease_sprite_scale(0, 6.0, 6.0, 24.0)
	effect.set_sprite_size(1, 10.24, 8.32, 2)
	effect.set_sprite_texture_rect(1, 0.0, 192.0, 64.0, 64.0, 2)
	effect.set_sprite_color(1, color_red, color_green, color_blue, 0.0, 2)
	effect.set_sprite_angular_velocity(1, 0.1)
	effect.set_sprite_angular_velocity(2, -0.1)
	effect.ease_sprite_color(1, color_red, color_green, color_blue, 128.0, 16.0, 2)
	effect.set_sprite_scale(1, 0.0, 0.0, 2)
	effect.ease_sprite_scale(1, 1.0, 1.0, 24.0, 2)
	effect.set_sprite_size(3, 10.24, 8.32, 2)
	effect.set_sprite_texture_rect(3, 0.0, 128.0, 64.0, 64.0, 2)
	effect.set_sprite_color(3, color_red, color_green, color_blue, 128.0, 2)
	effect.set_sprite_scale(3, 0.0, 0.0, 2)
	pulse_scale = 0.0
	pulse_index = 0
	frame = 0
	while frame < 120 do
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			position_x = out1 or position_x
			position_y = out2 or position_y
			position_z = out3 or position_z
		end
		effect.set_sprite_position(1, position_x, position_y, position_z, 2)
		effect.set_sprite_position(3, position_x, position_y, position_z, 2)
		pulse_scale = vm.f32(pulse_scale + vm.f32(vm.f32(3.0 - pulse_scale) / 24.0))
		if vm.imod(frame, 2) == 0 then
			effect.set_sprite_position(0, position_x, position_y, position_z)
			effect.set_sprite_scale(3 + pulse_index, pulse_scale, pulse_scale)
			effect.ease_sprite_scale(3 + pulse_index, 0.2, 0.2, 4.0)
			random_angle = effect.get_random_number(6.2831855) or random_angle
			random_angle = vm.f32(random_angle - vm.f32(3.1415927))
			effect.set_sprite_rotation(3 + pulse_index, random_angle)
			pulse_index = pulse_index + 1
			if pulse_index >= 2 then
				pulse_index = 0
			end
		end
		frame = frame + 1
		if frame >= 100 then
			frame = 0
		end
		vm.wait()
	end
end

--- Flashes the charge sprites outward and fades them out.
function script.on_finish()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		color_red = out1 or color_red
		color_green = out2 or color_green
		color_blue = out3 or color_blue
	end
	effect.reset_sprites(0, 5)
	effect.set_sprite_blend_mode(0, 2, 5)
	effect.set_sprite_visible(1, 1, 2)
	effect.set_sprite_position(1, position_x, position_y, position_z, 2)
	effect.set_sprite_visible(0, 0)
	effect.set_sprite_visible(3, 0, 2)
	effect.set_sprite_size(1, 10.24, 8.32, 2)
	effect.set_sprite_color(1, color_red, color_green, color_blue, 128.0, 2)
	effect.set_sprite_scale(1, 0.0, 0.0, 2)
	effect.set_sprite_texture_rect(1, 128.0, 0.0, 128.0, 128.0)
	effect.ease_sprite_scale(1, 3.0, 3.0, 2.0)
	effect.ease_sprite_color(1, color_red, color_green, color_blue, 0.0, 3.0)
	vm.wait()
	effect.set_sprite_texture_rect(2, 0.0, 0.0, 128.0, 128.0)
	effect.ease_sprite_scale(2, 1.5, 1.5, 3.0)
	effect.ease_sprite_color(2, color_red, color_green, color_blue, 0.0, 4.0)
	frame = 0
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
end

return script
