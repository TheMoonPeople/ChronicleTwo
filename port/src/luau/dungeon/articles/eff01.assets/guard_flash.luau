--!strict
--- Shows glow sprites at the point where a guard blocks an attack.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Animates expanding guard glow sprites at the work position.
function script.on_start()
	local position_x: f32 = 0
	local position_y: f32 = 0
	local position_z: f32 = 0
	local style: s32 = 0
	local flash_scale: f32 = 0
	local glow_scale: f32 = 0
	local frame: s32 = 0
	local large_flash_scale: f32 = 0
	local ring_scale: f32 = 0
	local halo_scale: f32 = 0
	local shrink_frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		position_x = out1 or position_x
		position_y = out2 or position_y
		position_z = out3 or position_z
	end
	style = 0
	effect.copy_vector(0.0, 0.0, 0.0)
	style = effect.get_script_value(0) or style
	effect.get_second_work_vector()
	effect.copy_vector(96.0, 128.0, 96.0)
	style = 0
	if style == 0 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(2)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, position_x, position_y, position_z)
		effect.set_sprite_size(0, 30.0, 30.0)
		effect.set_sprite_texture_rect(0, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, position_x, position_y, position_z)
		effect.set_sprite_size(1, 25.0, 25.0)
		effect.set_sprite_texture_rect(1, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 64.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -2.0)
		flash_scale = 1.0
		glow_scale = 1.0
		frame = 0
		while frame <= 36 do
			effect.set_sprite_scale(0, flash_scale, flash_scale)
			effect.set_sprite_scale(1, glow_scale, glow_scale)
			flash_scale = vm.f32(flash_scale + vm.f32(0.03))
			if frame == 4 then
				effect.set_sprite_visible(1, 1)
			end
			if frame > 4 then
				glow_scale = vm.f32(glow_scale + vm.f32(0.02))
			end
			frame = frame + 1
			vm.wait()
		end
	end
	if style == 1 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(3)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, position_x, position_y, position_z)
		effect.set_sprite_size(0, 60.0, 60.0)
		effect.set_sprite_texture_rect(0, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, position_x, position_y, position_z)
		effect.set_sprite_size(1, 42.0, 42.0)
		effect.set_sprite_texture_rect(1, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(2)
		effect.set_sprite_blend_mode(2, 2)
		effect.set_sprite_visible(2, 0)
		effect.set_sprite_position(2, position_x, position_y, position_z)
		effect.set_sprite_size(2, 32.0, 32.0)
		effect.set_sprite_texture_rect(2, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(2, 96.0, 128.0, 96.0, 32.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(2, 0.0, 0.0, 0.0, -2.0)
		large_flash_scale = 1.0
		ring_scale = 1.0
		halo_scale = 1.0
		shrink_frame = 0
		effect.set_sprite_visible(0, 0)
		effect.set_sprite_angular_velocity(1, 0.03)
		effect.set_sprite_angular_acceleration(1, 0.015, 0.015, 0.015)
		while shrink_frame <= 36 do
			effect.set_sprite_scale(0, large_flash_scale, large_flash_scale)
			effect.set_sprite_scale(1, ring_scale, ring_scale)
			effect.set_sprite_scale(2, halo_scale, halo_scale)
			large_flash_scale = vm.f32(large_flash_scale - vm.f32(0.02))
			if shrink_frame == 0 then
				effect.set_sprite_visible(1, 1)
			end
			if shrink_frame > 0 then
				ring_scale = vm.f32(ring_scale - vm.f32(0.04))
			end
			if ring_scale <= vm.f32(0.6) then
				break
			end
			shrink_frame = vm.i32(shrink_frame + 1)
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
