--!strict
--- Draws the glowing trail of a moon flower beam bullet following its animated bullet bone.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Leaves a fading sprite trail along the path of the bullet bone until the beam motion finishes, then lingers for 30 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local bullet_x: f32 = 0
	local bullet_y: f32 = 0
	local bullet_z: f32 = 0
	local previous_x: f32 = 0
	local previous_y: f32 = 0
	local previous_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local sprite_index: s32 = 0
	local trail_x: f32 = 0
	local trail_y: f32 = 0
	local trail_z: f32 = 0
	local motion_progress: f32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		work_vect1_x = out1 or work_vect1_x
		work_vect1_y = out2 or work_vect1_y
		work_vect1_z = out3 or work_vect1_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		work_vect2_x = out1 or work_vect2_x
		work_vect2_y = out2 or work_vect2_y
		work_vect2_z = out3 or work_vect2_z
	end
	effect.set_effect_character_position(work_vect1_x, work_vect1_y, work_vect1_z)
	effect.rotate_effect_character_toward(work_vect2_x, work_vect2_y, work_vect2_z)
	effect.set_effect_character_motion("弾道", -1, 6)
	effect.set_sprite_texture("e616_tama")
	effect.allocate_sprites_1(120)
	effect.reset_sprites(0, 120)
	effect.set_sprite_blend_mode(0, 2, 120)
	effect.set_sprite_visible(0, 1, 120)
	effect.set_sprite_size(0, 200.0, 200.0, 120)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 120)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 120)
	effect.set_effect_character_frame_visible("tama", 0, 1)
	vm.wait()
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("tama--ba")
		bullet_x = out1 or bullet_x
		bullet_y = out2 or bullet_y
		bullet_z = out3 or bullet_z
	end
	vm.wait()
	sprite_index = 0
	while true do
		do
			local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
			previous_x = out1 or previous_x
			previous_y = out2 or previous_y
			previous_z = out3 or previous_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_frame_position("tama--ba")
			bullet_x = out1 or bullet_x
			bullet_y = out2 or bullet_y
			bullet_z = out3 or bullet_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(bullet_x, bullet_y, bullet_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, previous_x, previous_y, previous_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 4)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(previous_x, previous_y, previous_z)
			trail_x = out1 or trail_x
			trail_y = out2 or trail_y
			trail_z = out3 or trail_z
		end
		for i = 0, 3 do
			effect.set_sprite_position(sprite_index, trail_x, trail_y, trail_z)
			effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 128.0)
			effect.set_sprite_scale(sprite_index, 1.0, 1.0)
			effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 10)
			effect.ease_sprite_scale(sprite_index, 0.1, 0.1, 10)
			do
				local out1, out2, out3 = effect.add_vectors(trail_x, trail_y, trail_z, step_x, step_y, step_z)
				trail_x = out1 or trail_x
				trail_y = out2 or trail_y
				trail_z = out3 or trail_z
			end
			sprite_index = vm.i32(sprite_index + 1)
		end
		if sprite_index >= 120 then
			sprite_index = 0
		end
		motion_progress = effect.get_effect_character_motion_progress() or motion_progress
		if motion_progress >= 1.0 then
			break
		else
			vm.wait()
		end
	end
	sprite_index = 0
	while sprite_index < 30 do
		sprite_index = sprite_index + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
