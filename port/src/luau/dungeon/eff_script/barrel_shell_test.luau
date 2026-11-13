--!strict
--- A test puff of smoke from a barrel shell.

local vm = require("@lib/vm")

--- Launches a smoke puff sprite from a random point around a position.
local function spawn_smoke_puff(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, heading_angle: f32, range: f32)
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	value_2 = effect.get_random_number(range) or value_2
	value_3 = effect.get_random_number(360.0) or value_3
	value_4 = effect.get_random_number(0.02) or value_4
	value_5 = effect.get_random_number(0.3) or value_5
	value = effect.get_random_number(0.3) or value
	value_4 = vm.f32(value_4 + vm.f32(0.01))
	value_5 = vm.f32(value_5 + vm.f32(0.3))
	value = vm.f32(value + vm.f32(0.8))
	value_3 = vm.f32(vm.f32(value_3 / 180.0) * vm.f32(3.1415927))
	puff_x = vm.f32(origin_x + vm.f32(vm.sin(value_3) * value_2))
	puff_y = origin_y
	puff_z = vm.f32(origin_z + vm.f32(vm.cos(value_3) * value_2))
	velocity_x = vm.f32(vm.f32(0.02) * vm.sin(heading_angle))
	velocity_z = vm.f32(vm.f32(0.02) * vm.cos(heading_angle))
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, puff_x, puff_y, puff_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, value_5, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 2.0)
	effect.set_sprite_angular_velocity(sprite_index, value_4)
	effect.set_sprite_scale(sprite_index, value, value, value)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Launches a single smoke sprite at the position and fades it out.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local color_w: f32 = 0
	local spawn_range: f32 = 0
	local heading_angle: f32 = 0
	local frame: s32 = 0
	local allocation_result: s32 = 0
	local value: f32 = 0
	effect.get_owner_character()
	allocation_result = effect.allocate_sprites_2(1) or allocation_result
	if allocation_result == 0 then
		return
	end
	effect.set_sprite_texture("effect00")
	effect.reset_sprites(0, 1)
	effect.set_sprite_blend_mode(0, 2, 1)
	effect.set_sprite_texture_rect(0, 0.1, 161.0, 95.0, 95.0, 1)
	effect.set_sprite_size(0, 24.0, 48.0, 1)
	effect.set_sprite_visible(0, 0, 1)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 1)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	spawn_range = 15.0
	heading_angle = 0.0
	frame = 0
	while frame < 1 do
		spawn_smoke_puff(frame, work_vect1_x, work_vect1_y, work_vect1_z, spawn_range, heading_angle)
		frame = frame + 1
	end
	while frame < 150 do
		for sprite_index = 0, 0 do
			do
				local _, _, _, out4 = effect.get_sprite_color(sprite_index)
				color_w = out4 or color_w
			end
			if color_w > 64.0 then
				effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 63.0)
				value = effect.get_random_number(0.6) or value
				value = vm.f32(value + vm.f32(0.4))
				effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, -value)
			end
		end
		vm.wait()
		frame = frame + 1
	end
	effect.set_sprite_visible(0, 0, 1)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
