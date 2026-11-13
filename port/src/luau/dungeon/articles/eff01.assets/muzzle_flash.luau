--!strict
--- Shows a flash of light at a gun muzzle, in the default yellow or a supplied colour.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Flashes the muzzle sprites for five frames, using the default or the supplied colour.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local flash_scale: f32 = 0
	local red: f32 = 0
	local green: f32 = 0
	local blue: f32 = 0
	local alpha: f32 = 0
	local colour_mode: s32 = 0
	local alpha_step: f32 = 0
	local frame: s32 = 0
	local custom_alpha_step: f32 = 0
	local custom_frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	effect.set_sprite_texture("effect00")
	effect.allocate_sprites_1(2)
	colour_mode = 0
	do
		local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 0.0)
		red = out1 or red
		green = out2 or green
		blue = out3 or blue
	end
	alpha = 0.0
	colour_mode = effect.get_script_value(0) or colour_mode
	red = effect.get_script_value_float(1) or red
	green = effect.get_script_value_float(2) or green
	blue = effect.get_script_value_float(3) or blue
	alpha = effect.get_script_value_float(4) or alpha
	if colour_mode == 0 then
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, position_x, position_y, position_z)
		effect.set_sprite_size(0, 28.0, 28.0)
		effect.set_sprite_texture_rect(0, 193.0, 1.0, 62.0, 62.0)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 255.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -51.0)
		flash_scale = 0.5
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 1)
		effect.set_sprite_position(1, position_x, position_y, position_z)
		effect.set_sprite_size(1, 64.0, 64.0)
		effect.set_sprite_texture_rect(1, 65.0, 65.0, 62.0, 62.0)
		effect.set_sprite_color(1, 128.0, 108.0, 40.0, 72.0)
		alpha_step = 24.0
		frame = 0
		while frame < 5 do
			effect.set_sprite_scale(0, flash_scale, flash_scale)
			flash_scale = vm.f32(flash_scale + vm.f32(0.1))
			if frame == 2 then
				effect.offset_sprite_color(1, 128.0, 108.0, 40.0, alpha_step)
			else
				alpha_step = 56.0
				effect.offset_sprite_color(1, 128.0, 108.0, 40.0, -alpha_step)
			end
			frame = frame + 1
			vm.wait()
		end
	end
	if colour_mode == 1 then
		flash_scale = 0.5
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 1)
		effect.set_sprite_position(1, position_x, position_y, position_z)
		effect.set_sprite_size(1, 64.0, 64.0)
		effect.set_sprite_texture_rect(1, 65.0, 65.0, 62.0, 62.0)
		effect.set_sprite_color(1, red, green, blue, alpha)
		custom_alpha_step = 24.0
		custom_frame = 0
		while custom_frame < 5 do
			if custom_frame == 2 then
				effect.offset_sprite_color(1, red, green, blue, custom_alpha_step)
			else
				custom_alpha_step = 56.0
				effect.offset_sprite_color(1, red, green, blue, -custom_alpha_step)
			end
			custom_frame = custom_frame + 1
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
