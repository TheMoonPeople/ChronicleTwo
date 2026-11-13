--!strict
--- Sparks and smoke that spew from the player's robot when it malfunctions.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Emits rising smoke sprites from near the robot in a repeating cycle.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value: f32 = 0
	local angle: f32 = 0
	local tick: s32 = 0
	local sprite_cursor: s32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	effect.set_effect_character_position(pos_x, pos_y, pos_z)
	effect.set_effect_character_motion("ループ", -1, 4)
	effect.set_sprite_texture("kosyou")
	effect.allocate_sprites_1(20)
	effect.reset_sprites(0, 20)
	effect.set_sprite_visible(0, 1, 20)
	effect.set_sprite_blend_mode(0, 1, 20)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 30.0, 30.0, 20)
	effect.set_sprite_size(0, 8.0, 8.0, 20)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 20)
	value = effect.get_random_number(4.0) or value
	value = vm.f32(value + 6.0)
	angle = effect.get_random_number(6.2831855) or angle
	angle = vm.f32(angle - vm.f32(3.1415927))
	angle = effect.wrap_angle(angle) or angle
	pos_x = vm.f32(vm.f32(vm.sin(angle) * value) + pos_x)
	pos_y = vm.f32(20.0 + pos_y)
	pos_z = vm.f32(vm.f32(vm.cos(angle) * value) + pos_z)
	tick = 0
	sprite_cursor = 0
	while true do
		if vm.imod(tick, 4) == 0 then
			effect.set_sprite_position(sprite_cursor, pos_x, pos_y, pos_z)
			effect.set_sprite_velocity(sprite_cursor, 0.0, 0.8, 0.0)
			value_2 = effect.get_random_number(0.01) or value_2
			value_2 = vm.f32(value_2 - vm.f32(0.005))
			value_3 = effect.get_random_number(0.01) or value_3
			value_3 = vm.f32(value_3 - vm.f32(0.005))
			effect.set_sprite_acceleration(sprite_cursor, value_2, -0.00615, value_3)
			effect.set_sprite_color(sprite_cursor, 128.0, 128.0, 128.0, 16.0)
			effect.set_sprite_color_velocity(sprite_cursor, 0.0, 0.0, 0.0, 8.0)
			effect.set_sprite_color_acceleration(sprite_cursor, 0.0, 0.0, 0.0, -0.2)
			effect.set_sprite_scale(sprite_cursor, 0.1, 0.1)
			effect.set_sprite_scale_velocity(sprite_cursor, 0.04, 0.04)
			effect.set_sprite_scale_acceleration(sprite_cursor, 0.0005, 0.0005)
			angle = effect.get_random_number(6.2831855) or angle
			angle = vm.f32(angle - vm.f32(3.1415927))
			angle = effect.wrap_angle(angle) or angle
			effect.set_sprite_rotation(sprite_cursor, angle)
			sprite_cursor = sprite_cursor + 1
			if sprite_cursor >= 20 then
				sprite_cursor = 0
			end
		end
		tick = tick + 1
		if tick >= 20 then
			tick = 0
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
