--!strict
--- Emits puffs of dust from alternating sides of the buggy.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Every other frame, spawns a batch of dust sprites beside the owner, alternating left and right.
function script.on_start()
	local owner_id: s32 = 0
	local owner_x: f32 = 0
	local owner_y: f32 = 0
	local owner_z: f32 = 0
	local owner_yaw: f32 = 0
	local frame: s32 = 0
	local next_sprite_index: s32 = 0
	local side_toggle: s32 = 0
	local spawn_index: s32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local spin: f32 = 0
	local spin_roll: s32 = 0
	owner_id = effect.get_owner_character() or owner_id
	effect.set_sprite_texture("base_eff2")
	effect.allocate_sprites_1(64)
	effect.reset_sprites(0, 64)
	effect.set_sprite_blend_mode(0, 1, 64)
	effect.set_sprite_visible(0, 1, 64)
	effect.set_sprite_size(0, 10.24, 8.32, 64)
	effect.set_sprite_texture_rect(0, 65.0, 1.0, 62.0, 62.0, 64)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 64)
	frame = 0
	next_sprite_index = 0
	side_toggle = 0
	while true do
		if vm.imod(frame, 2) == 0 then
			spawn_index = 0
			do
				local out1, out2, out3 = effect.get_scene_character_position(owner_id)
				owner_x = out1 or owner_x
				owner_y = out2 or owner_y
				owner_z = out3 or owner_z
			end
			owner_yaw = effect.get_scene_character_rotation_2(owner_id) or owner_yaw
			owner_yaw = effect.wrap_angle(owner_yaw) or owner_yaw
			if side_toggle == 1 then
				owner_x = vm.f32(vm.f32(vm.sin(vm.f32(owner_yaw + vm.f32(1.57))) * 35.0) + owner_x)
				owner_z = vm.f32(vm.f32(vm.cos(vm.f32(owner_yaw + vm.f32(1.57))) * 35.0) + owner_z)
				side_toggle = 0
			else
				owner_x = vm.f32(vm.f32(vm.sin(vm.f32(owner_yaw - vm.f32(1.57))) * 35.0) + owner_x)
				owner_z = vm.f32(vm.f32(vm.cos(vm.f32(owner_yaw - vm.f32(1.57))) * 35.0) + owner_z)
				side_toggle = 1
			end
			while spawn_index < 4 do
				sprite_x = effect.get_random_number(10.0) or sprite_x
				sprite_x = vm.f32(vm.f32(sprite_x - 5.0) + owner_x)
				sprite_y = effect.get_random_number(5.0) or sprite_y
				sprite_y = vm.f32(vm.f32(sprite_y + owner_y) + 14.0)
				sprite_z = effect.get_random_number(10.0) or sprite_z
				sprite_z = vm.f32(vm.f32(sprite_z - 5.0) + owner_z)
				effect.set_sprite_position(next_sprite_index, sprite_x, sprite_y, sprite_z)
				sprite_x = effect.get_random_number(0.6) or sprite_x
				sprite_x = vm.f32(sprite_x - vm.f32(0.3))
				sprite_y = effect.get_random_number(0.6) or sprite_y
				sprite_y = vm.f32(sprite_y - vm.f32(0.3))
				effect.set_sprite_velocity(next_sprite_index, 0.0, 0.0, -20.0)
				effect.set_sprite_acceleration(next_sprite_index, sprite_x, sprite_y, 0.0)
				spin = effect.get_random_number(6.2831855) or spin
				spin = vm.f32(spin - vm.f32(3.1415927))
				effect.set_sprite_rotation(next_sprite_index, spin)
				spin_roll = effect.get_random_number_int(100) or spin_roll
				if spin_roll < 50 then
					spin = vm.f32(0.2)
				else
					spin = vm.f32(-0.2)
				end
				effect.set_sprite_angular_velocity(next_sprite_index, spin)
				effect.set_sprite_angular_acceleration(next_sprite_index, -vm.f32(spin * vm.f32(0.02)))
				effect.set_sprite_color(next_sprite_index, 128.0, 128.0, 128.0, 16.0)
				effect.set_sprite_color_velocity(next_sprite_index, 0.0, 0.0, 0.0, 10.24)
				effect.set_sprite_color_acceleration(next_sprite_index, 0.0, 0.0, 0.0, -0.8)
				effect.set_sprite_scale(next_sprite_index, 10.0, 10.0)
				effect.ease_sprite_scale(next_sprite_index, 40.0, 40.0, 20.0)
				spawn_index = spawn_index + 1
				next_sprite_index = next_sprite_index + 1
				if next_sprite_index >= 64 then
					next_sprite_index = 0
				end
			end
		end
		frame = vm.i32(frame + 1)
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
