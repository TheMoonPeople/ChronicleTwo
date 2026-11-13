--!strict
--- Scatters eight glowing embers between two points that drift upward and fade.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Places eight ember sprites around the midpoint of the two work vectors and floats them upward for 20 frames.
function script.on_start()
	local origin_x: f32 = 0
	local origin_y: f32 = 0
	local origin_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local ember_x: f32 = 0
	local ember_y: f32 = 0
	local ember_z: f32 = 0
	local angle: f32 = 0
	local radius: f32 = 0
	local height_offset: f32 = 0
	local scale: f32 = 0
	local index: s32 = 0
	local has_sprites: s32 = 0
	has_sprites = effect.allocate_sprites_2(8) or has_sprites
	if has_sprites == 0 then
		return
	end
	effect.set_sprite_texture("hinoko")
	effect.reset_sprites(0, 8)
	effect.set_sprite_blend_mode(0, 2, 8)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 8)
	effect.set_sprite_size(0, 1.0, 1.0, 8)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 8)
	effect.set_sprite_visible(0, 1, 8)
	effect.set_sprite_position(0, 0.0, -10.0, 0.0, 8)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		origin_x = out1 or origin_x
		origin_y = out2 or origin_y
		origin_z = out3 or origin_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	index = 0
	while index < 8 do
		angle = 1.0
		radius = 1.0
		height_offset = 1.0
		angle = effect.get_random_number(360.0) or angle
		radius = effect.get_random_number(15.0) or radius
		height_offset = effect.get_random_number(8.0) or height_offset
		scale = effect.get_random_number(400.0) or scale
		effect.get_random_number(800.0)
		angle = vm.f32(vm.f32(angle / 180.0) * vm.f32(3.1415927))
		scale = vm.f32(scale / 100.0)
		scale = vm.f32(scale + 2.0)
		ember_x = vm.f32(vm.f32(vm.f32(origin_x + work_vect2_x) / 2.0) + vm.f32(vm.sin(angle) * radius))
		ember_y = vm.f32(vm.f32(vm.f32(vm.f32(origin_y + work_vect2_y) / 2.0) - height_offset) + 4.0)
		ember_z = vm.f32(vm.f32(vm.f32(origin_z + work_vect2_z) / 2.0) + vm.f32(vm.cos(angle) * radius))
		effect.set_sprite_scale(index, scale, scale)
		effect.set_sprite_position(index, ember_x, ember_y, ember_z)
		effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, -8.0)
		index = index + 1
	end
	index = 0
	while index < 20 do
		vm.wait()
		for ember_index = 0, 7 do
			do
				local out1, out2, out3 = effect.get_sprite_position(ember_index)
				origin_x = out1 or origin_x
				origin_y = out2 or origin_y
				origin_z = out3 or origin_z
			end
			origin_y = vm.f32(origin_y - vm.f32(-0.8))
			effect.set_sprite_position(ember_index, origin_x, origin_y, origin_z)
		end
		index = index + 1
	end
	effect.set_sprite_visible(0, 0, 8)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
