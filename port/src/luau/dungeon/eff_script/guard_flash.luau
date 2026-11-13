--!strict
--- Flashes a guard ring at the first work vector, with a variant selected by a script value.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Expands and fades a glowing ring for the first variant, or shrinks a spinning ring for the second variant.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local variant: s32 = 0
	local core_scale: f32 = 0
	local halo_scale: f32 = 0
	local frame: s32 = 0
	local outer_scale: f32 = 0
	local middle_scale: f32 = 0
	local inner_scale: f32 = 0
	local shrink_frame: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	variant = 0
	effect.copy_vector(0.0, 0.0, 0.0)
	variant = effect.get_script_value(0) or variant
	effect.get_second_work_vector()
	effect.copy_vector(96.0, 128.0, 96.0)
	variant = 0
	if variant == 0 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(2)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(0, 30.0, 30.0)
		effect.set_sprite_texture_rect(0, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 25.0, 25.0)
		effect.set_sprite_texture_rect(1, 0, 0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 64.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -2.0)
		core_scale = 1.0
		halo_scale = 1.0
		frame = 0
		while frame <= 36 do
			effect.set_sprite_scale(0, core_scale, core_scale)
			effect.set_sprite_scale(1, halo_scale, halo_scale)
			core_scale = vm.f32(core_scale + vm.f32(0.03))
			if frame == 4 then
				effect.set_sprite_visible(1, 1)
			end
			if frame > 4 then
				halo_scale = vm.f32(halo_scale + vm.f32(0.02))
			end
			frame = frame + 1
			vm.wait()
		end
	end
	if variant == 1 then
		effect.set_sprite_texture("effect01")
		effect.allocate_sprites_1(3)
		effect.reset_sprites(0)
		effect.set_sprite_blend_mode(0, 2)
		effect.set_sprite_visible(0, 1)
		effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(0, 60.0, 60.0)
		effect.set_sprite_texture_rect(0, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(0, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(1)
		effect.set_sprite_blend_mode(1, 2)
		effect.set_sprite_visible(1, 0)
		effect.set_sprite_position(1, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(1, 42.0, 42.0)
		effect.set_sprite_texture_rect(1, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(1, 96.0, 128.0, 96.0, 128.0)
		effect.reset_sprites(2)
		effect.set_sprite_blend_mode(2, 2)
		effect.set_sprite_visible(2, 0)
		effect.set_sprite_position(2, work_vect1_x, work_vect1_y, work_vect1_z)
		effect.set_sprite_size(2, 32.0, 32.0)
		effect.set_sprite_texture_rect(2, 128.0, 0.0, 128.0, 128.0)
		effect.set_sprite_color(2, 96.0, 128.0, 96.0, 32.0)
		effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(1, 0.0, 0.0, 0.0, -8.0)
		effect.set_sprite_color_velocity(2, 0.0, 0.0, 0.0, -2.0)
		outer_scale = 1.0
		middle_scale = 1.0
		inner_scale = 1.0
		shrink_frame = 0
		effect.set_sprite_visible(0, 0)
		effect.set_sprite_angular_velocity(1, 0.03)
		effect.set_sprite_angular_acceleration(1, 0.015, 0.015, 0.015)
		while shrink_frame <= 36 do
			effect.set_sprite_scale(0, outer_scale, outer_scale)
			effect.set_sprite_scale(1, middle_scale, middle_scale)
			effect.set_sprite_scale(2, inner_scale, inner_scale)
			outer_scale = vm.f32(outer_scale - vm.f32(0.02))
			if shrink_frame == 0 then
				effect.set_sprite_visible(1, 1)
			end
			if shrink_frame > 0 then
				middle_scale = vm.f32(middle_scale - vm.f32(0.04))
			end
			if middle_scale <= vm.f32(0.6) then
				break
			end
			shrink_frame = vm.i32(shrink_frame + 1)
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
