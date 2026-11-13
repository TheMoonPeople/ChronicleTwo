--!strict
--- Molten drops that fall from Mguil's body and bounce on the ground.

local vm = require("@lib/vm")
local particles = require("@lib/effect/particles")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Drips bouncing sprite drops from the owner's emitter frames until told to stop.
function script.on_start()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_y_2: f32 = 0
	local color_w: f32 = 0
	local spawn_range: f32 = 0
	local allocation_result: s32 = 0
	local user_id: s32 = 0
	local sprite_cursor: s32 = 0
	local value: s32 = 0
	local state_flag: s32 = 0
	local value_2: s32 = 0
	allocation_result = effect.allocate_sprites_2(210) or allocation_result
	if allocation_result == 0 then
		return
	end
	effect.set_sprite_texture("hinoko")
	effect.reset_sprites(0, 210)
	effect.set_sprite_blend_mode(0, 2, 210)
	effect.set_sprite_texture_rect(0, 64.0, 0.0, 64.0, 64.0, 210)
	effect.set_sprite_size(0, 1.0, 1.0, 210)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 210)
	effect.set_sprite_visible(0, 1, 210)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 210)
	effect.set_sprite_acceleration(0, 0.0, -0.3, 0.0, 210)
	user_id = effect.get_owner_character() or user_id
	sprite_cursor = 0
	while true do
		for sprite_index = 0, 209 do
			do
				local _, _, _, out4 = effect.get_sprite_color(sprite_index)
				color_w = out4 or color_w
			end
			if color_w <= 0.0 then
				effect.set_sprite_visible(sprite_index, 0)
			end
			state_flag = effect.is_sprite_visible(sprite_index) or state_flag
			if state_flag ~= 0 then
				do
					local _, out2, _ = effect.get_sprite_position(sprite_index)
					pos_y_2 = out2 or pos_y_2
				end
				if pos_y_2 < 2.0 then
					state_flag = effect.get_script_value(1) or state_flag
					if state_flag == 0 then
						pos_y_2 = vm.f32(pos_y_2 * vm.f32(-0.8))
						effect.set_sprite_velocity(sprite_index, 0.0, pos_y_2, 0.0)
						effect.set_sprite_acceleration(sprite_index, 0.0, -0.3, 0.0)
					end
				end
			end
		end
		value = effect.get_script_value(2) or value
		if value ~= 1 then
			for burst_index = 0, 3 do
				value_2 = effect.get_random_number_int(100) or value_2
				if value_2 < 33 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_03")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 20.0
				end
				if value_2 < 66 and value_2 >= 33 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_01")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 5.0
				end
				if value_2 < 100 and value_2 > 66 then
					do
						local out1, out2, out3 = effect.get_scene_character_frame_position(user_id, "eff0_02")
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					spawn_range = 5.0
				end
				particles.spawn_spark(sprite_cursor, spawn_range, pos_x, pos_y, pos_z)
				sprite_cursor = sprite_cursor + 1
				if sprite_cursor >= 210 then
					sprite_cursor = 0
				end
			end
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
