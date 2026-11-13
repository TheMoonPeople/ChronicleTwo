--!strict
--- The healing effect that spins glowing orbs with sparkle trails around the healed character.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Spawns three orbiting orbs with sparkle and halo trails around the healed character and animates them upward.
function script.on_start()
	local target_id: s32 = 0
	local frame: s32 = 0
	local value: s32 = 0
	local sparkle_index: s32 = 0
	local halo_index: s32 = 0
	local center_x: f32 = 0
	local center_y: f32 = 0
	local center_z: f32 = 0
	local orbit_angles_degrees: { f32 } = table.create(3, 0)
	local orbit_radii: { f32 } = table.create(3, 0)
	local orbit_heights: { f32 } = table.create(5, 0)
	local initial_x: f32 = 0
	local initial_y: f32 = 0
	local initial_z: f32 = 0
	local value_2: f32 = 0
	local initial_angle: f32 = 0
	local active_count: s32 = 0
	local sparkle_counts: { s32 } = table.create(3, 0)
	local halo_counts: { s32 } = table.create(3, 0)
	local rise_speeds: { f32 } = table.create(3, 0)
	local is_visible: s32 = 0
	local orb_x: f32 = 0
	local orb_y: f32 = 0
	local orb_z: f32 = 0
	local sparkle_x: f32 = 0
	local sparkle_y: f32 = 0
	local sparkle_z: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local sparkle_sprite: s32 = 0
	local new_halo_sprite: s32 = 0
	local halo_angle_offset: f32 = 0
	local halo_sprite: s32 = 0
	target_id = effect.get_target_character() or target_id
	do
		local out1, out2, out3 = effect.get_scene_character_position(target_id)
		center_x = out1 or center_x
		center_y = out2 or center_y
		center_z = out3 or center_z
	end
	value = 0
	value = effect.get_script_value(0) or value
	effect.set_sprite_texture("n_heal")
	effect.allocate_sprites_1(132)
	effect.reset_sprites(0, 3)
	effect.set_sprite_blend_mode(0, 2, 3)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 3)
	if value == 0 then
		effect.set_sprite_color(0, 96.0, 210.0, 250.0, 0.0, 3)
	end
	if value == 1 then
		effect.set_sprite_color(0, 225.0, 220.0, 0.0, 0.0, 3)
	end
	effect.set_sprite_visible(0, 0, 3)
	effect.set_sprite_size(0, 20.0, 20.0, 3)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 3)
	effect.set_sprite_scale(0, 0.5, 0.46, 3)
	effect.reset_sprites(3, 120)
	effect.set_sprite_blend_mode(3, 2, 120)
	effect.set_sprite_texture_rect(3, 0.0, 64.0, 32.0, 32.0, 120)
	if value == 0 then
		effect.set_sprite_color(3, 96.0, 210.0, 250.0, 128.0, 120)
		effect.set_script_value(1, 96.0)
		effect.set_script_value(2, 210.0)
		effect.set_script_value(3, 250.0)
	end
	if value == 1 then
		effect.set_sprite_color(3, 225.0, 220.0, 0.0, 128.0, 120)
		effect.set_script_value(1, 225.0)
		effect.set_script_value(2, 220.0)
		effect.set_script_value(3, 0.0)
	end
	effect.set_sprite_visible(3, 0, 120)
	effect.set_sprite_size(3, 6.0, 6.0, 120)
	effect.set_sprite_position(3, 0.0, 0.0, 0.0, 120)
	effect.reset_sprites(123, 9)
	effect.set_sprite_blend_mode(123, 2, 9)
	effect.set_sprite_texture_rect(123, 64.0, 64.0, 64.0, 64.0, 9)
	if value == 0 then
		effect.set_sprite_color(123, 96.0, 210.0, 250.0, 36.0, 9)
		effect.set_script_value(4, 64.0)
		effect.set_script_value(5, 148.0)
		effect.set_script_value(6, 128.0)
	end
	if value == 1 then
		effect.set_sprite_color(123, 225.0, 220.0, 0.0, 36.0, 9)
		effect.set_script_value(4, 225.0)
		effect.set_script_value(5, 220.0)
		effect.set_script_value(6, 128.0)
	end
	effect.set_sprite_visible(123, 0, 9)
	effect.set_sprite_size(123, 32.0, 32.0, 9)
	effect.set_sprite_position(123, 0.0, 0.0, 0.0, 9)
	frame = 0
	value = 0
	while value < 3 do
		value_2 = effect.get_random_number(2.0) or value_2
		value_2 = vm.f32(value_2 + 11.0)
		initial_angle = vm.f32(vm.f32(2.0943952) * value)
		initial_x = vm.f32(vm.sin(initial_angle) * value_2)
		initial_y = vm.f32(center_y + 6.0)
		initial_z = vm.f32(vm.cos(initial_angle) * value_2)
		effect.set_sprite_position(value, initial_x, initial_y, initial_z)
		orbit_angles_degrees[value + 1] = vm.f32(120.0 * value)
		orbit_radii[value + 1] = value_2
		orbit_heights[value + 1] = 6.0
		value = value + 1
	end
	effect.set_sprite_angular_velocity(0, 0.1, 3)
	active_count = 0
	while active_count < 3 do
		sparkle_counts[active_count + 1] = 0
		halo_counts[active_count + 1] = 0
		rise_speeds[active_count + 1] = 1.5
		active_count = active_count + 1
	end
	active_count = 0
	while frame < 60 do
		if frame > active_count * 7 and active_count < 3 then
			effect.set_sprite_visible(active_count, 1)
			do
				local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 0.0)
				center_x = out1 or center_x
				center_y = out2 or center_y
				center_z = out3 or center_z
			end
			center_x = effect.get_script_value_float(1) or center_x
			center_y = effect.get_script_value_float(2) or center_y
			center_z = effect.get_script_value_float(3) or center_z
			effect.set_sprite_color_velocity(active_count, 0.0, 0.0, 0.0, 15.0)
			active_count = active_count + 1
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			center_x = out1 or center_x
			center_y = out2 or center_y
			center_z = out3 or center_z
		end
		value = 0
		while value < active_count do
			orbit_angles_degrees[value + 1] = vm.f32(orbit_angles_degrees[value + 1] + 11.0)
			orbit_heights[value + 1] = vm.f32(orbit_heights[value + 1] + 2.5)
			orb_x = vm.f32(
				center_x + vm.f32(vm.sin(vm.f32(vm.f32(orbit_angles_degrees[value + 1] / 180.0) * vm.f32(3.1415927))) * orbit_radii[value + 1])
			)
			orb_y = vm.f32(center_y + vm.f32(orbit_heights[value + 1] * rise_speeds[value + 1]))
			orb_z = vm.f32(
				center_z + vm.f32(vm.cos(vm.f32(vm.f32(orbit_angles_degrees[value + 1] / 180.0) * vm.f32(3.1415927))) * orbit_radii[value + 1])
			)
			rise_speeds[value + 1] = vm.f32(rise_speeds[value + 1] - vm.f32(0.05))
			effect.set_sprite_position(value, orb_x, orb_y, orb_z)
			if frame > value * 7 + 8 then
				effect.set_sprite_color_velocity(value, 0.0, 0.0, 0.0, 0.0)
				effect.offset_sprite_color(value, 0.0, 0.0, 0.0, -7.0)
			end
			is_visible = effect.is_sprite_visible(value) or is_visible
			if is_visible == 1 then
				if sparkle_counts[value + 1] < 40 then
					effect.set_sprite_visible(vm.i32(3 + value * 20 * 2 + sparkle_counts[value + 1]), 1)
					value_3 = effect.get_random_number(4.0) or value_3
					effect.get_random_number(0.5)
					value_4 = effect.get_random_number(360.0) or value_4
					value_3 = vm.f32(value_3 + 2.0)
					sparkle_x = vm.f32(orb_x + vm.f32(vm.sin(value_4) * value_3))
					sparkle_y = orb_y
					sparkle_z = vm.f32(orb_z + vm.f32(vm.cos(value_4) * value_3))
					effect.set_sprite_position(vm.i32(3 + value * 20 * 2 + sparkle_counts[value + 1]), sparkle_x, sparkle_y, sparkle_z)
					value_3 = effect.get_random_number(4.0) or value_3
					effect.get_random_number(0.5)
					value_4 = effect.get_random_number(360.0) or value_4
					value_3 = vm.f32(value_3 + 2.0)
					sparkle_x = vm.f32(orb_x + vm.f32(vm.sin(value_4) * value_3))
					sparkle_y = orb_y
					sparkle_z = vm.f32(orb_z + vm.f32(vm.cos(value_4) * value_3))
					effect.set_sprite_position(vm.i32(vm.i32(3 + value * 20 * 2 + sparkle_counts[value + 1]) + 1), sparkle_x, sparkle_y, sparkle_z)
					sparkle_counts[value + 1] = vm.i32(sparkle_counts[value + 1] + 2)
				end
				sparkle_index = 0
				while sparkle_index < sparkle_counts[value + 1] do
					sparkle_sprite = vm.i32(3 + value * 20 * 2 + sparkle_index)
					do
						local out1, out2, out3 = effect.get_sprite_position(sparkle_sprite)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					pos_y = vm.f32(pos_y + -1.0)
					effect.set_sprite_position(sparkle_sprite, pos_x, pos_y, pos_z)
					effect.offset_sprite_color(sparkle_sprite, 0.0, 0.0, 0.0, -5.0)
					sparkle_index = sparkle_index + 1
				end
			end
			is_visible = effect.is_sprite_visible(value) or is_visible
			is_visible = 1
			if is_visible ~= 0 then
				if halo_counts[value + 1] < 3 then
					new_halo_sprite = vm.i32(123 + value * 3 + halo_counts[value + 1])
					effect.set_sprite_visible(new_halo_sprite, 1)
					effect.set_sprite_position(new_halo_sprite, orb_x, orb_y, orb_z)
					halo_counts[value + 1] = vm.i32(halo_counts[value + 1] + 1)
				end
				halo_index = 0
				while halo_index < halo_counts[value + 1] do
					halo_sprite = vm.i32(123 + value * 3 + halo_index)
					halo_angle_offset = vm.f32(5.0 * halo_index)
					orb_x = vm.f32(
						center_x
							+ vm.f32(
								vm.sin(vm.f32(vm.f32(vm.f32(orbit_angles_degrees[value + 1] - halo_angle_offset) / 180.0) * vm.f32(3.1415927)))
									* orbit_radii[value + 1]
							)
					)
					orb_y = vm.f32(center_y + vm.f32(vm.f32(orbit_heights[value + 1] - halo_angle_offset) * rise_speeds[value + 1]))
					orb_z = vm.f32(
						center_z
							+ vm.f32(
								vm.cos(vm.f32(vm.f32(vm.f32(orbit_angles_degrees[value + 1] - halo_angle_offset) / 180.0) * vm.f32(3.1415927)))
									* orbit_radii[value + 1]
							)
					)
					effect.set_sprite_position(halo_sprite, orb_x, orb_y, orb_z)
					if frame > value * 7 + 12 then
						effect.set_sprite_color_velocity(halo_sprite, 0.0, 0.0, 0.0, 0.0)
						effect.offset_sprite_color(halo_sprite, 0.0, 0.0, 0.0, -2.0)
					end
					halo_index = halo_index + 1
				end
			end
			value = value + 1
		end
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
