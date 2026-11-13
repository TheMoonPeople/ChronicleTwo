--!strict
--- Smoke that Mguil exhales from three body points while it breathes fire.

local vm = require("@lib/vm")

--- Launches a large smoke puff sprite from a random point around a position.
local function spawn_large_smoke_puff(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, heading_angle: f32, range: f32)
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = effect.get_random_number(range) or value
	value_2 = effect.get_random_number(360.0) or value_2
	value_3 = effect.get_random_number(0.01) or value_3
	value_4 = effect.get_random_number(1.0) or value_4
	value_4 = vm.f32(value_4 + 1.0)
	value_2 = vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))
	puff_x = vm.f32(origin_x + vm.f32(vm.sin(value_2) * value))
	puff_y = origin_y
	puff_z = vm.f32(origin_z + vm.f32(vm.cos(value_2) * value))
	velocity_x = vm.f32(vm.f32(0.8) * vm.sin(heading_angle))
	velocity_y = value_4
	velocity_z = vm.f32(vm.f32(0.8) * vm.cos(heading_angle))
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, puff_x, puff_y, puff_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 0.2)
	effect.set_sprite_angular_velocity(sprite_index, value_3)
end

--- Launches a small smoke puff sprite from a random point around a position.
local function spawn_small_smoke_puff(sprite_index: s32, origin_x: f32, origin_y: f32, origin_z: f32, heading_angle: f32, range: f32)
	local puff_x: f32 = 0
	local puff_y: f32 = 0
	local puff_z: f32 = 0
	local velocity_x: f32 = 0
	local velocity_y: f32 = 0
	local velocity_z: f32 = 0
	local sin_heading: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	value = effect.get_random_number(range) or value
	value_2 = effect.get_random_number(360.0) or value_2
	value_3 = effect.get_random_number(0.01) or value_3
	value_4 = effect.get_random_number(1.0) or value_4
	value_4 = vm.f32(value_4 + 0.5)
	value_2 = vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927))
	sin_heading = vm.sin(heading_angle)
	puff_x = vm.f32(origin_x + vm.f32(vm.sin(value_2) * value))
	puff_y = origin_y
	puff_z = vm.f32(origin_z + vm.f32(vm.cos(value_2) * value))
	velocity_x = vm.f32(vm.f32(0.4) * sin_heading)
	velocity_y = value_4
	velocity_z = vm.f32(vm.f32(0.4) * sin_heading)
	effect.set_sprite_visible(sprite_index, 1)
	effect.set_sprite_position(sprite_index, puff_x, puff_y, puff_z)
	effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_velocity(sprite_index, velocity_x, velocity_y, velocity_z)
	effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, 0.1)
	effect.set_sprite_angular_velocity(sprite_index, value_3)
end

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Emits drifting smoke puffs from the owner's emitter frames and fades them out until the effect is stopped.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local color_w: f32 = 0
	local spawn_range: f32 = 0
	local heading_angle: f32 = 0
	local user_id: s32 = 0
	local large_cursor: s32 = 0
	local small_cursor: s32 = 0
	local allocation_result: s32 = 0
	local emit_count: s32 = 0
	local value: s32 = 0
	user_id = effect.get_owner_character() or user_id
	allocation_result = effect.allocate_sprites_2(540) or allocation_result
	if allocation_result == 0 then
		return
	end
	effect.set_sprite_texture("effect00")
	effect.reset_sprites(0, 450)
	effect.set_sprite_blend_mode(0, 2, 450)
	effect.set_sprite_texture_rect(0, 0.1, 161.0, 95.0, 95.0, 450)
	effect.set_sprite_size(0, 32.0, 32.0, 450)
	effect.set_sprite_visible(0, 0, 450)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 450)
	effect.reset_sprites(450, 90)
	effect.set_sprite_blend_mode(450, 2, 90)
	effect.set_sprite_texture_rect(450, 161.0, 161.0, 95.0, 95.0, 90)
	effect.set_sprite_size(450, 100.0, 100.0, 90)
	effect.set_sprite_visible(450, 0, 90)
	effect.set_sprite_position(450, 0.0, 0.0, 0.0, 90)
	emit_count = 0
	large_cursor = 0
	small_cursor = 450
	while true do
		for sprite_index = 0, 539 do
			do
				local _, _, _, out4 = effect.get_sprite_color(sprite_index)
				color_w = out4 or color_w
			end
			if sprite_index < 450 then
				if color_w > 24.0 then
					effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 48.0)
					effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, -0.3)
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(sprite_index, 0)
				end
			else
				if color_w > 24.0 then
					effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 32.0)
					effect.set_sprite_color_velocity(sprite_index, 0.0, 0.0, 0.0, -0.2)
				end
				if color_w <= 0.0 then
					effect.set_sprite_visible(sprite_index, 0)
				end
			end
		end
		value = effect.get_script_value(2) or value
		if value == 0 then
			for emitter_index = 0, 2 do
				if emitter_index == 0 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_03")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 200.0
					heading_angle = 0.0
				end
				if emitter_index == 1 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_01")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 100.0
					heading_angle = vm.f32(1.5707964)
				end
				if emitter_index == 2 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_02")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 100.0
					heading_angle = vm.f32(-1.5707964)
				end
				for burst_index = 0, 1 do
					spawn_large_smoke_puff(large_cursor, pos_x, pos_y, pos_z, spawn_range, heading_angle)
					if large_cursor < 450 then
						large_cursor = large_cursor + 1
					else
						large_cursor = 0
					end
				end
				if vm.imod(emit_count, 4) == 0 then
					spawn_small_smoke_puff(small_cursor, pos_x, pos_y, pos_z, spawn_range, heading_angle)
				end
				if vm.imod(emit_count, 4) == 0 then
					if small_cursor < 540 then
						small_cursor = small_cursor + 1
					else
						small_cursor = 450
						emit_count = 0
					end
				end
			end
		end
		emit_count = vm.i32(emit_count + 1)
		vm.wait()
	end
	effect.set_sprite_visible(0, 0, 540)
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
