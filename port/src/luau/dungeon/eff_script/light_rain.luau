--!strict
--- Rains small drifting light flakes over an area given by the second work vector.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Leaves the default initialisation program empty so nothing runs before the effect starts.
function script.init() end

--- Spawns recycled flake sprites at random positions inside the area every other frame and never finishes on its own.
function script.on_start()
	local sprite_count: s32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_z: f32 = 0
	local flake_x: f32 = 0
	local flake_y: f32 = 0
	local random_value: f32 = 0
	local frame_counter: s32 = 0
	local sprite_index: s32 = 0
	local texture_cell: s32 = 0
	local flake_scale: f32 = 0
	local is_flake_scale_int = true
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, _, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_z = out3 or work_vect2_z
	end
	sprite_count = effect.get_script_value(0) or sprite_count
	effect.set_sprite_texture("e732_snow")
	effect.allocate_sprites_1(sprite_count)
	effect.reset_sprites(0, sprite_count)
	effect.set_sprite_blend_mode(0, 2, sprite_count)
	effect.set_sprite_visible(0, 1, sprite_count)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, sprite_count)
	effect.set_sprite_size(0, 8.0, 8.0, sprite_count)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, sprite_count)
	sprite_index = 0
	frame_counter = 0
	while true do
		if vm.imod(frame_counter, 2) == 0 then
			for i = 0, 3 do
				texture_cell = effect.get_random_number_int(4) or texture_cell
				effect.set_sprite_texture_rect(
					sprite_index,
					vm.i32(vm.imod(texture_cell, 2) * 32),
					vm.i32(vm.idiv(texture_cell, 2) * 32),
					32.0,
					32.0
				)
				flake_x = effect.get_random_number(work_vect2_x) or flake_x
				flake_x = vm.f32(vm.f32(flake_x - vm.f32(work_vect2_x / 2.0)) + work_vect1_x)
				flake_y = work_vect1_y
				random_value = effect.get_random_number(work_vect2_z) or random_value
				random_value = vm.f32(vm.f32(random_value - vm.f32(work_vect2_z / 2.0)) + work_vect1_z)
				effect.set_sprite_position(sprite_index, flake_x, flake_y, random_value)
				flake_scale = (if is_flake_scale_int then vm.float_bits(effect.get_random_number(1.0)) else effect.get_random_number(1.0)) or flake_scale
				flake_scale = vm.f32(flake_scale - 0.5)
				is_flake_scale_int = false
				effect.set_sprite_scale(sprite_index, flake_scale, flake_scale)
				effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 64.0)
				effect.set_sprite_blinking(sprite_index, 0.0, 0.0, 0.0, 64.0, 0.3926991)
				flake_y = effect.get_random_number(-0.3) or flake_y
				flake_y = vm.f32(flake_y - vm.f32(0.3))
				effect.set_sprite_velocity(sprite_index, 0.0, flake_y, 0.0)
				random_value = effect.get_random_number(6.2831855) or random_value
				random_value = vm.f32(random_value - vm.f32(3.1415927))
				random_value = effect.wrap_angle(random_value) or random_value
				effect.set_sprite_rotation(sprite_index, random_value)
				if texture_cell ~= 3 then
					random_value = effect.get_random_number(0.4) or random_value
					random_value = vm.f32(random_value - vm.f32(0.2))
					effect.set_sprite_angular_velocity(sprite_index, random_value)
				end
				sprite_index = vm.i32(sprite_index + 1)
				if sprite_index >= sprite_count then
					sprite_index = 0
				end
			end
		end
		frame_counter = vm.i32(frame_counter + 1)
		vm.wait()
	end
	frame_counter = 0
	while frame_counter < 30 do
		frame_counter = frame_counter + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
