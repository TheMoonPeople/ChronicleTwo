--!strict
--- A drifting pollen mote that sheds fading spore sprites.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded and has nothing to set up.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Initialisation program that the engine never runs for this effect.
function script.init() end

--- Moves a pollen mote in a wobbling path and leaves a trail of spore sprites that fade out.
function script.on_start()
	local spore_alphas: { f32 } = table.create(10, 0)
	local head_alpha: f32 = 0
	local is_active: { s32 } = table.create(10, 0)
	local frame: s32 = 0
	local value: f32 = 0
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local wobble_angle_x: f32 = 0
	local wobble_angle_z: f32 = 0
	local drift_x: f32 = 0
	local drift_y: f32 = 0
	local drift_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local value_2: f32 = 0
	frame = 0
	while frame < 10 do
		spore_alphas[frame + 1] = 0.0
		is_active[frame + 1] = 0
		frame = frame + 1
	end
	head_alpha = 128.0
	effect.allocate_sprites_1(11)
	effect.set_sprite_texture("b02maphousi01")
	value = effect.get_random_number(10.0) or value
	value = vm.f32(value + 25.0)
	effect.reset_sprites(0)
	effect.set_sprite_blend_mode(0, 2)
	effect.set_sprite_visible(0, 1)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	effect.set_sprite_position(0, work_vect1_x, work_vect1_y, work_vect1_z)
	effect.set_sprite_size(0, value, value)
	effect.set_sprite_texture_rect(0, 0.0, 64.0, 64.0, 64.0)
	value = vm.f32(value + 6.0)
	effect.reset_sprites(1, 10)
	effect.set_sprite_blend_mode(1, 2, 10)
	effect.set_sprite_visible(1, 1, 10)
	effect.set_sprite_position(1, 0.0, 0.0, 0.0, 10)
	effect.set_sprite_size(1, value, value, 10)
	effect.set_sprite_texture_rect(1, 0.0, 0.0, 64.0, 64.0, 10)
	effect.set_sprite_color(1, 128.0, 128.0, 128.0, 0.0, 10)
	wobble_angle_x = effect.get_random_number(360.0) or wobble_angle_x
	wobble_angle_z = effect.get_random_number(360.0) or wobble_angle_z
	wobble_angle_x = vm.f32(vm.f32(vm.f32(wobble_angle_x / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
	wobble_angle_z = vm.f32(vm.f32(vm.f32(wobble_angle_z / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
	frame = 0
	while true do
		wobble_angle_x = vm.f32(wobble_angle_x + vm.f32(0.04))
		wobble_angle_z = vm.f32(wobble_angle_z + vm.f32(0.04))
		wobble_angle_x = effect.wrap_angle(wobble_angle_x) or wobble_angle_x
		wobble_angle_z = effect.wrap_angle(wobble_angle_z) or wobble_angle_z
		drift_x = vm.f32(vm.sin(wobble_angle_x) * 1.5)
		drift_y = vm.f32(3.4)
		drift_z = vm.f32(vm.cos(wobble_angle_z) * 1.5)
		effect.offset_sprite_position(0, drift_x, drift_y, drift_z)
		if vm.imod(frame, 2) == 0 then
			for slot = 0, 9 do
				if is_active[slot + 1] == 0 then
					spore_alphas[slot + 1] = vm.f32(head_alpha - 20.0)
					is_active[slot + 1] = 1
					do
						local out1, out2, out3 = effect.get_sprite_position(0)
						pos_x = out1 or pos_x
						pos_y = out2 or pos_y
						pos_z = out3 or pos_z
					end
					effect.set_sprite_position(slot + 1, pos_x, pos_y, pos_z)
					effect.set_sprite_texture_rect(slot + 1, 0.0, 0.0, 64.0, 64.0)
					value_2 = effect.get_random_number(360.0) or value_2
					value_2 = vm.f32(vm.f32(vm.f32(wobble_angle_x / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
					effect.set_sprite_rotation(slot + 1, value_2)
					break
				end
			end
		end
		for spore_index = 0, 9 do
			if is_active[spore_index + 1] ~= 0 then
				spore_alphas[spore_index + 1] = vm.f32(spore_alphas[spore_index + 1] - 6.0)
				if spore_alphas[spore_index + 1] < 48.0 then
					effect.set_sprite_texture_rect(spore_index + 1, 64.0, 64.0, 64.0, 64.0)
				end
				if spore_alphas[spore_index + 1] <= 0.0 then
					effect.set_sprite_color(spore_index + 1, 128.0, 128.0, 128.0, 0.0)
					spore_alphas[spore_index + 1] = 0.0
					is_active[spore_index + 1] = 0
				end
				effect.set_sprite_color(spore_index + 1, 128.0, 128.0, 128.0, spore_alphas[spore_index + 1])
			end
		end
		if frame >= 90 then
			head_alpha = vm.f32(head_alpha - vm.f32(4.4))
			if head_alpha <= 0.0 then
				head_alpha = 0.0
			end
		end
		effect.set_sprite_color(0, 128.0, 128.0, 128.0, head_alpha)
		if frame >= 120 then
			break
		else
			frame = frame + 1
			vm.wait()
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Runs when the effect ends; the effect has nothing to clean up.
function script.on_finish() end

return script
