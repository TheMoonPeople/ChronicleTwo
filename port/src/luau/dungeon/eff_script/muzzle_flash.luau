--!strict
--- Flashes a gun muzzle with a default or custom colour.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Flashes a bright sprite and a colour glow for five frames in the default or script-given colour.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local flash_scale: f32 = 0
	local color_r: f32 = 0
	local color_g: f32 = 0
	local color_b: f32 = 0
	local color_a: f32 = 0
	local variant: s32 = 0
	local glow_alpha_step: f32 = 0
	local frame: s32 = 0
	local custom_glow_alpha_step: f32 = 0
	local custom_frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_texture("effect00")
	effect.allocate_sprites_1(2)
	variant = 0
	do
		local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 0.0)
		color_r = out1 or color_r
		color_g = out2 or color_g
		color_b = out3 or color_b
	end
	color_a = 0.0
	variant = effect.get_script_value(0) or variant
	color_r = effect.get_script_value_float(1) or color_r
	color_g = effect.get_script_value_float(2) or color_g
	color_b = effect.get_script_value_float(3) or color_b
	color_a = effect.get_script_value_float(4) or color_a
	if variant == 0 then
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(0, 28.0, 28.0)
		effect.set_sprite_texture_rect(0, 193.0, 1.0, 62.0, 62.0)
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, 255.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -51.0)
		flash_scale = 0.5
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 1)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 64.0, 64.0)
		effect.set_sprite_texture_rect(1, 65.0, 65.0, 62.0, 62.0)
		effect.set_sprite_color(1, 128.0, 108.0, 40.0, 72.0)
		glow_alpha_step = 24.0
		frame = 0
		while frame < 5 do
			effect.set_sprite_scale(0, flash_scale, flash_scale)
			flash_scale = vm.f32(flash_scale + vm.f32(0.1))
			if frame == 2 then
				effect.offset_sprite_color(1, 128.0, 108.0, 40.0, glow_alpha_step)
			else
				glow_alpha_step = 56.0
				effect.offset_sprite_color(1, 128.0, 108.0, 40.0, -glow_alpha_step)
			end
			frame = frame + 1
			vm.wait()
		end
	end
	if variant == 1 then
		flash_scale = 0.5
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 1)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 64.0, 64.0)
		effect.set_sprite_texture_rect(1, 65.0, 65.0, 62.0, 62.0)
		effect.set_sprite_color(1, color_r, color_g, color_b, color_a)
		custom_glow_alpha_step = 24.0
		custom_frame = 0
		while custom_frame < 5 do
			if custom_frame == 2 then
				effect.offset_sprite_color(1, color_r, color_g, color_b, custom_glow_alpha_step)
			else
				custom_glow_alpha_step = 56.0
				effect.offset_sprite_color(1, color_r, color_g, color_b, -custom_glow_alpha_step)
			end
			custom_frame = custom_frame + 1
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
