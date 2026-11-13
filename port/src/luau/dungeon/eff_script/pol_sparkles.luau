--!strict
--- Twinkling sparkles scattered at random inside a box around the owner.

local vm = require("@lib/vm")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Spawns drifting twinkling sparkles around the owner each frame.
function script.on_start()
	local owner_id: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local box_size_x: f32 = 0
	local box_size_y: f32 = 0
	local box_size_z: f32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local frame: s32 = 0
	local sprite_index: s32 = 0
	local texture_cell: s32 = 0
	local sprite_scale: f32 = 0
	local scale_holds_bits = true
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		box_size_x = out1 or box_size_x
		box_size_y = out2 or box_size_y
		box_size_z = out3 or box_size_z
	end
	owner_id = effect.get_owner_character() or owner_id
	effect.set_sprite_texture("plucas_kirakira")
	effect.allocate_sprites_1(60)
	effect.reset_sprites(0, 60)
	effect.set_sprite_blend_mode(0, 2, 60)
	effect.set_sprite_visible(0, 1, 60)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 60)
	effect.set_sprite_size(0, 8.0, 8.0, 60)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 60)
	sprite_index = 0
	frame = 0
	while frame < 90 do
		do
			local out1, out2, out3 = effect.get_scene_character_position(owner_id)
			owner_x = out1 or owner_x
			owner_y = out2 or owner_y
			owner_z = out3 or owner_z
		end
		owner_y = vm.f32(owner_y + 25.0)
		if vm.imod(frame, 1) == 0 then
			for i = 0, 3 do
				texture_cell = effect.get_random_number_int(4) or texture_cell
				effect.set_sprite_texture_rect(
					sprite_index,
					vm.i32(vm.imod(texture_cell, 2) * 32),
					vm.i32(vm.idiv(texture_cell, 2) * 32),
					32.0,
					32.0
				)
				sprite_x = effect.get_random_number(box_size_x) or sprite_x
				sprite_x = vm.f32(vm.f32(sprite_x - vm.f32(box_size_x / 2.0)) + owner_x)
				sprite_y = effect.get_random_number(box_size_y) or sprite_y
				sprite_y = vm.f32(vm.f32(sprite_y - vm.f32(box_size_y / 2.0)) + owner_y)
				sprite_z = effect.get_random_number(box_size_z) or sprite_z
				sprite_z = vm.f32(vm.f32(sprite_z - vm.f32(box_size_z / 2.0)) + owner_z)
				effect.set_sprite_position(sprite_index, sprite_x, sprite_y, sprite_z)
				sprite_scale = (if scale_holds_bits then vm.float_bits(effect.get_random_number(1.0)) else effect.get_random_number(1.0)) or sprite_scale
				sprite_scale = vm.f32(sprite_scale - 0.5)
				scale_holds_bits = false
				effect.set_sprite_scale(sprite_index, sprite_scale, sprite_scale)
				effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
				effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 32)
				effect.set_sprite_color_acceleration(sprite_index, 0.0, 0.0, 0.0, -4)
				effect.set_sprite_blinking(sprite_index, 0.0, 0.0, 0.0, 64.0, 0.3926991)
				sprite_y = effect.get_random_number(-0.3) or sprite_y
				sprite_y = vm.f32(sprite_y - vm.f32(0.3))
				effect.set_sprite_velocity(sprite_index, 0.0, sprite_y, 0.0)
				sprite_z = effect.get_random_number(6.2831855) or sprite_z
				sprite_z = vm.f32(sprite_z - vm.f32(3.1415927))
				sprite_z = effect.wrap_angle(sprite_z) or sprite_z
				effect.set_sprite_rotation(sprite_index, sprite_z)
				if texture_cell ~= 3 then
					sprite_z = effect.get_random_number(0.4) or sprite_z
					sprite_z = vm.f32(sprite_z - vm.f32(0.2))
					effect.set_sprite_angular_velocity(sprite_index, sprite_z)
				end
				sprite_index = sprite_index + 1
				if sprite_index >= 60 then
					sprite_index = 0
				end
			end
		end
		frame = frame + 1
		vm.wait()
	end
	frame = 0
	while frame < 30 do
		frame = frame + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
