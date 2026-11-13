--!strict
--- Shows a healing effect in which three glowing orbs spiral around the target character leaving sparkles and afterimages, tinted blue or yellow by the heal variant.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no initialisation.
function script.init() end

--- Spirals three orbs around the target character with sparkle and afterimage trails for sixty frames.
function script.on_start()
	local target_id: s32 = 0
	local frame: s32 = 0
	local orb_index: s32 = 0
	local sparkle_index: s32 = 0
	local afterimage_index: s32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local orb_angles_degrees: { f32 } = table.create(3, 0)
	local orb_radii: { f32 } = table.create(3, 0)
	local orb_heights: { f32 } = table.create(5, 0)
	local orb_start_x: f32 = 0
	local orb_start_y: f32 = 0
	local orb_start_z: f32 = 0
	local orb_radius: f32 = 0
	local orb_start_angle: f32 = 0
	local active_orb_count: s32 = 0
	local sparkle_counts: { s32 } = table.create(3, 0)
	local afterimage_counts: { s32 } = table.create(3, 0)
	local orb_rise_scales: { f32 } = table.create(3, 0)
	local is_orb_visible: s32 = 0
	local orb_x: f32 = 0
	local orb_y: f32 = 0
	local orb_z: f32 = 0
	local sparkle_x: f32 = 0
	local sparkle_y: f32 = 0
	local sparkle_z: f32 = 0
	local sparkle_radius: f32 = 0
	local sparkle_angle: f32 = 0
	local sprite_x: f32 = 0
	local sprite_y: f32 = 0
	local sprite_z: f32 = 0
	local sparkle_sprite_index: s32 = 0
	local afterimage_sprite_index: s32 = 0
	local afterimage_lag: f32 = 0
	local trail_sprite_index: s32 = 0
	target_id = effect.get_target_character() or target_id
	do
		local out1, out2, out3 = effect.get_scene_character_position(target_id)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	orb_index = 0
	orb_index = effect.get_script_value(0) or orb_index
	effect.set_sprite_texture("n_heal")
	effect.allocate_sprites_1(132)
	effect.reset_sprites(0, 3)
	effect.set_sprite_blend_mode(0, 2, 3)
	effect.set_sprite_texture_rect(0, 0.0, 0.0, 64.0, 64.0, 3)
	if orb_index == 0 then
		effect.set_sprite_color(0, 96.0, 210.0, 250.0, 0.0, 3)
	end
	if orb_index == 1 then
		effect.set_sprite_color(0, 225.0, 220.0, 0.0, 0.0, 3)
	end
	effect.set_sprite_visible(0, 0, 3)
	effect.set_sprite_size(0, 20.0, 20.0, 3)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 3)
	effect.set_sprite_scale(0, 0.5, 0.46, 3)
	effect.reset_sprites(3, 120)
	effect.set_sprite_blend_mode(3, 2, 120)
	effect.set_sprite_texture_rect(3, 0.0, 64.0, 32.0, 32.0, 120)
	if orb_index == 0 then
		effect.set_sprite_color(3, 96.0, 210.0, 250.0, 128.0, 120)
		effect.set_script_value(1, 96.0)
		effect.set_script_value(2, 210.0)
		effect.set_script_value(3, 250.0)
	end
	if orb_index == 1 then
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
	if orb_index == 0 then
		effect.set_sprite_color(123, 96.0, 210.0, 250.0, 36.0, 9)
		effect.set_script_value(4, 64.0)
		effect.set_script_value(5, 148.0)
		effect.set_script_value(6, 128.0)
	end
	if orb_index == 1 then
		effect.set_sprite_color(123, 225.0, 220.0, 0.0, 36.0, 9)
		effect.set_script_value(4, 225.0)
		effect.set_script_value(5, 220.0)
		effect.set_script_value(6, 128.0)
	end
	effect.set_sprite_visible(123, 0, 9)
	effect.set_sprite_size(123, 32.0, 32.0, 9)
	effect.set_sprite_position(123, 0.0, 0.0, 0.0, 9)
	frame = 0
	orb_index = 0
	while orb_index < 3 do
		orb_radius = effect.get_random_number(2.0) or orb_radius
		orb_radius = vm.f32(orb_radius + 11.0)
		orb_start_angle = vm.f32(vm.f32(2.0943952) * orb_index)
		orb_start_x = vm.f32(vm.sin(orb_start_angle) * orb_radius)
		orb_start_y = vm.f32(target_y + 6.0)
		orb_start_z = vm.f32(vm.cos(orb_start_angle) * orb_radius)
		effect.set_sprite_position(orb_index, orb_start_x, orb_start_y, orb_start_z)
		orb_angles_degrees[orb_index + 1] = vm.f32(120.0 * orb_index)
		orb_radii[orb_index + 1] = orb_radius
		orb_heights[orb_index + 1] = 6.0
		orb_index = orb_index + 1
	end
	effect.set_sprite_angular_velocity(0, 0.1, 3)
	active_orb_count = 0
	while active_orb_count < 3 do
		sparkle_counts[active_orb_count + 1] = 0
		afterimage_counts[active_orb_count + 1] = 0
		orb_rise_scales[active_orb_count + 1] = 1.5
		active_orb_count = active_orb_count + 1
	end
	active_orb_count = 0
	while frame < 60 do
		if frame > active_orb_count * 7 and active_orb_count < 3 then
			effect.set_sprite_visible(active_orb_count, 1)
			do
				local out1, out2, out3 = effect.copy_vector(0.0, 0.0, 0.0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			target_x = effect.get_script_value_float(1) or target_x
			target_y = effect.get_script_value_float(2) or target_y
			target_z = effect.get_script_value_float(3) or target_z
			effect.set_sprite_color_velocity(active_orb_count, 0.0, 0.0, 0.0, 15.0)
			active_orb_count = active_orb_count + 1
		end
		do
			local out1, out2, out3 = effect.get_scene_character_position(target_id)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		orb_index = 0
		while orb_index < active_orb_count do
			orb_angles_degrees[orb_index + 1] = vm.f32(orb_angles_degrees[orb_index + 1] + 11.0)
			orb_heights[orb_index + 1] = vm.f32(orb_heights[orb_index + 1] + 2.5)
			orb_x = vm.f32(
				target_x + vm.f32(vm.sin(vm.f32(vm.f32(orb_angles_degrees[orb_index + 1] / 180.0) * vm.f32(3.1415927))) * orb_radii[orb_index + 1])
			)
			orb_y = vm.f32(target_y + vm.f32(orb_heights[orb_index + 1] * orb_rise_scales[orb_index + 1]))
			orb_z = vm.f32(
				target_z + vm.f32(vm.cos(vm.f32(vm.f32(orb_angles_degrees[orb_index + 1] / 180.0) * vm.f32(3.1415927))) * orb_radii[orb_index + 1])
			)
			orb_rise_scales[orb_index + 1] = vm.f32(orb_rise_scales[orb_index + 1] - vm.f32(0.05))
			effect.set_sprite_position(orb_index, orb_x, orb_y, orb_z)
			if frame > orb_index * 7 + 8 then
				effect.set_sprite_color_velocity(orb_index, 0.0, 0.0, 0.0, 0.0)
				effect.offset_sprite_color(orb_index, 0.0, 0.0, 0.0, -7.0)
			end
			is_orb_visible = effect.is_sprite_visible(orb_index) or is_orb_visible
			if is_orb_visible == 1 then
				if sparkle_counts[orb_index + 1] < 40 then
					effect.set_sprite_visible(vm.i32(3 + orb_index * 20 * 2 + sparkle_counts[orb_index + 1]), 1)
					sparkle_radius = effect.get_random_number(4.0) or sparkle_radius
					effect.get_random_number(0.5)
					sparkle_angle = effect.get_random_number(360.0) or sparkle_angle
					sparkle_radius = vm.f32(sparkle_radius + 2.0)
					sparkle_x = vm.f32(orb_x + vm.f32(vm.sin(sparkle_angle) * sparkle_radius))
					sparkle_y = orb_y
					sparkle_z = vm.f32(orb_z + vm.f32(vm.cos(sparkle_angle) * sparkle_radius))
					effect.set_sprite_position(vm.i32(3 + orb_index * 20 * 2 + sparkle_counts[orb_index + 1]), sparkle_x, sparkle_y, sparkle_z)
					sparkle_radius = effect.get_random_number(4.0) or sparkle_radius
					effect.get_random_number(0.5)
					sparkle_angle = effect.get_random_number(360.0) or sparkle_angle
					sparkle_radius = vm.f32(sparkle_radius + 2.0)
					sparkle_x = vm.f32(orb_x + vm.f32(vm.sin(sparkle_angle) * sparkle_radius))
					sparkle_y = orb_y
					sparkle_z = vm.f32(orb_z + vm.f32(vm.cos(sparkle_angle) * sparkle_radius))
					effect.set_sprite_position(vm.i32(vm.i32(3 + orb_index * 20 * 2 + sparkle_counts[orb_index + 1]) + 1), sparkle_x, sparkle_y, sparkle_z)
					sparkle_counts[orb_index + 1] = vm.i32(sparkle_counts[orb_index + 1] + 2)
				end
				sparkle_index = 0
				while sparkle_index < sparkle_counts[orb_index + 1] do
					sparkle_sprite_index = vm.i32(3 + orb_index * 20 * 2 + sparkle_index)
					do
						local out1, out2, out3 = effect.get_sprite_position(sparkle_sprite_index)
						sprite_x = out1 or sprite_x
						sprite_y = out2 or sprite_y
						sprite_z = out3 or sprite_z
					end
					sprite_y = vm.f32(sprite_y + -1.0)
					effect.set_sprite_position(sparkle_sprite_index, sprite_x, sprite_y, sprite_z)
					effect.offset_sprite_color(sparkle_sprite_index, 0.0, 0.0, 0.0, -5.0)
					sparkle_index = sparkle_index + 1
				end
			end
			is_orb_visible = effect.is_sprite_visible(orb_index) or is_orb_visible
			is_orb_visible = 1
			if is_orb_visible ~= 0 then
				if afterimage_counts[orb_index + 1] < 3 then
					afterimage_sprite_index = vm.i32(123 + orb_index * 3 + afterimage_counts[orb_index + 1])
					effect.set_sprite_visible(afterimage_sprite_index, 1)
					effect.set_sprite_position(afterimage_sprite_index, orb_x, orb_y, orb_z)
					afterimage_counts[orb_index + 1] = vm.i32(afterimage_counts[orb_index + 1] + 1)
				end
				afterimage_index = 0
				while afterimage_index < afterimage_counts[orb_index + 1] do
					trail_sprite_index = vm.i32(123 + orb_index * 3 + afterimage_index)
					afterimage_lag = vm.f32(5.0 * afterimage_index)
					orb_x = vm.f32(
						target_x
							+ vm.f32(
								vm.sin(vm.f32(vm.f32(vm.f32(orb_angles_degrees[orb_index + 1] - afterimage_lag) / 180.0) * vm.f32(3.1415927)))
									* orb_radii[orb_index + 1]
							)
					)
					orb_y = vm.f32(target_y + vm.f32(vm.f32(orb_heights[orb_index + 1] - afterimage_lag) * orb_rise_scales[orb_index + 1]))
					orb_z = vm.f32(
						target_z
							+ vm.f32(
								vm.cos(vm.f32(vm.f32(vm.f32(orb_angles_degrees[orb_index + 1] - afterimage_lag) / 180.0) * vm.f32(3.1415927)))
									* orb_radii[orb_index + 1]
							)
					)
					effect.set_sprite_position(trail_sprite_index, orb_x, orb_y, orb_z)
					if frame > orb_index * 7 + 12 then
						effect.set_sprite_color_velocity(trail_sprite_index, 0.0, 0.0, 0.0, 0.0)
						effect.offset_sprite_color(trail_sprite_index, 0.0, 0.0, 0.0, -2.0)
					end
					afterimage_index = afterimage_index + 1
				end
			end
			orb_index = orb_index + 1
		end
		vm.wait()
		frame = frame + 1
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect needs no finish handling.
function script.on_finish() end

return script
