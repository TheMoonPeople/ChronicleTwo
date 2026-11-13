--!strict
--- The stream of droplets that Shigu spits from its mouth.

local vm = require("@lib/vm")

--- Launches one spit sprite from a random point around the mouth along a direction.
local function spawn_spit_sprite(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, direction_x: f32, direction_y: f32, direction_z: f32)
	local spawn_x: f32 = 0
	local spawn_y: f32 = 0
	local spawn_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	value = 0.0
	value_2 = 0.0
	value_3 = 0.0
	do
		local out1, out2, out3 = effect.normalize_vector(direction_x, direction_y, direction_z)
		direction_x = out1 or direction_x
		direction_y = out2 or direction_y
		direction_z = out3 or direction_z
	end
	value = effect.get_random_number(0.02) or value
	value = vm.f32(value + vm.f32(0.01))
	value_2 = effect.get_random_number(6.2831855) or value_2
	value_3 = effect.get_random_number(5.0) or value_3
	value_3 = vm.f32(value_3 + 5.0)
	spawn_x = vm.f32(origin_x + vm.f32(vm.sin(value_2) * value_3))
	spawn_y = origin_y
	spawn_z = vm.f32(origin_z + vm.f32(vm.cos(value_2) * value_3))
	do
		local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	do
		local out1, out2, out3 = effect.scale_vector(velocity_x, velocity_y, velocity_z, 5.0)
		velocity_x = out1 or velocity_x
		velocity_y = out2 or velocity_y
		velocity_z = out3 or velocity_z
	end
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, spawn_x, spawn_y, spawn_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 8.0)
	effect.set_sprite_scale(sprite_index, 1.0, 1.0, 1.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 3.0)
	effect.set_sprite_acceleration(sprite_index, 0.0, -0.05, 0.0)
	effect.set_sprite_angular_velocity(sprite_index, value)
	effect.set_sprite_scale_velocity(sprite_index, 0.04, 0.04)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Streams spit sprites from the owner's mouth that fall, bounce on the ground and fade until the effect is stopped.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local mouth_direction_x: f32 = 0
	local mouth_direction_y: f32 = 0
	local mouth_direction_z: f32 = 0
	local color_w: f32 = 0
	local value: f32 = 0
	local index: s32 = 0
	local user_id: s32 = 0
	local sprite_cursor: s32 = 0
	local state_flag: s32 = 0
	local pos_y_3: f32 = 0
	local pos_y_4: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = 0.0
	state_flag = effect.allocate_sprites_2(600) or state_flag
	if state_flag == 0 then
		return
	end
	effect.set_sprite_texture("Shigu_breath")
	effect.reset_sprites(0, 600)
	effect.set_sprite_blend_mode(0, 2, 600)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 128.0, 128.0, 600)
	effect.set_sprite_size(0, 32.0, 32.0, 600)
	effect.set_sprite_visible(0, 0, 600)
	effect.set_sprite_position(0, 0.0, -50.0, 0.0, 600)
	effect.set_sprite_acceleration(0, 0.0, -0.005, 0.0, 600)
	user_id = effect.get_owner_character() or user_id
	effect.get_script_value(0)
	value = effect.get_script_value_float(1) or value
	sprite_cursor = 0
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "sakana")
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "ef_null")
			mouth_direction_x = out1 or mouth_direction_x
			mouth_direction_y = out2 or mouth_direction_y
			mouth_direction_z = out3 or mouth_direction_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(mouth_direction_x, mouth_direction_y, mouth_direction_z, pos_x, pos_y, pos_z)
			mouth_direction_x = out1 or mouth_direction_x
			mouth_direction_y = out2 or mouth_direction_y
			mouth_direction_z = out3 or mouth_direction_z
		end
		index = 0
		while index < 600 do
			state_flag = effect.is_sprite_visible(index) or state_flag
			if state_flag ~= 0 then
				do
					local _, out2, _ = effect.get_sprite_position(index)
					pos_y_3 = out2 or pos_y_3
				end
				do
					local _, out2, _ = effect.get_scene_character_position(user_id)
					pos_y_4 = out2 or pos_y_4
				end
				pos_y_4 = vm.f32(pos_y_4 - value)
				if pos_y_3 < vm.f32(pos_y_4 + 2.0) then
					pos_y_3 = vm.f32(pos_y_3 * vm.f32(-0.7))
					pos_y_3 = vm.f32(0.7)
					effect.set_sprite_velocity(index, 0.0, pos_y_3, 0.0)
				end
				do
					local _, _, _, out4 = effect.get_sprite_color(index)
					color_w = out4 or color_w
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(index, 0)
				end
				if color_w >= 96.0 then
					effect.set_sprite_color(index, 128.0, 128.0, 128.0, 31.0)
					effect.set_sprite_color_velocity(index, 0.0, 0.0, 0.0, -1.2)
				end
			end
			index = index + 1
		end
		index = 0
		while index < 2 do
			value_4 = 0.0
			value_3 = 0.0
			value_4 = effect.get_random_number(5.0) or value_4
			value_3 = effect.get_random_number(6.2831855) or value_3
			value_4 = vm.f32(value_4 + 12.0)
			spawn_spit_sprite(
				sprite_cursor,
				pos_x,
				pos_y,
				pos_z,
				vm.f32(mouth_direction_x + vm.f32(vm.sin(value_3) * value_4)),
				mouth_direction_y,
				vm.f32(mouth_direction_z + vm.f32(vm.cos(value_3) * value_4))
			)
			sprite_cursor = sprite_cursor + 1
			if sprite_cursor >= 600 then
				sprite_cursor = 0
			end
			index = index + 1
		end
		state_flag = effect.get_script_value(3) or state_flag
		if state_flag == 1 then
			break
		else
			effect.get_scene_character_frame_position(user_id, "ef_null")
			vm.wait()
		end
	end
	effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -1.4, 600)
	effect.set_sprite_velocity(0, 0.0, -0.5, 0.0, 600)
	effect.set_sprite_scale_velocity(0, -0.01, -0.01, -0.01, 600)
	index = 0
	while index < 90 do
		vm.wait()
		index = index + 1
	end
end

--- Slows down the remaining sprites and waits for them to fade out.
function script.on_finish()
	effect.set_sprite_color_velocity(0, 0.0, 0.0, 0.0, -0.2, 600)
	effect.set_sprite_velocity(0, 0.0, 0.0, 0.0, 600)
	effect.set_sprite_scale_velocity(0, 0.0, 0.0, 0.0, 600)
	for frame = 0, 89 do
		vm.wait()
	end
end

return script
