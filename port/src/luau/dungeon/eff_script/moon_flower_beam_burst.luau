--!strict
--- Draws the bursting sparkle trails of the moon flower beam along eight animated grid bones.

local vm = require("@lib/vm")

local script = {}

--- Performs no load-time setup; the effect needs none.
function script.setup() end

--- Traces each of the eight grid bones with fading sprites every frame until the burst motion finishes, then lingers for 30 frames.
function script.on_start()
	local work_vect1_x: f32 = 0
	local work_vect1_y: f32 = 0
	local work_vect1_z: f32 = 0
	local work_vect2_x: f32 = 0
	local work_vect2_y: f32 = 0
	local work_vect2_z: f32 = 0
	local grid1_prev_x: f32 = 0
	local grid1_prev_y: f32 = 0
	local grid1_prev_z: f32 = 0
	local grid1_1_prev_x: f32 = 0
	local grid1_1_prev_y: f32 = 0
	local grid1_1_prev_z: f32 = 0
	local grid1_2_prev_x: f32 = 0
	local grid1_2_prev_y: f32 = 0
	local grid1_2_prev_z: f32 = 0
	local grid1_3_prev_x: f32 = 0
	local grid1_3_prev_y: f32 = 0
	local grid1_3_prev_z: f32 = 0
	local grid1_4_prev_x: f32 = 0
	local grid1_4_prev_y: f32 = 0
	local grid1_4_prev_z: f32 = 0
	local grid1_6_prev_x: f32 = 0
	local grid1_6_prev_y: f32 = 0
	local grid1_6_prev_z: f32 = 0
	local grid1_6_1_prev_x: f32 = 0
	local grid1_6_1_prev_y: f32 = 0
	local grid1_6_1_prev_z: f32 = 0
	local grid1_6_2_prev_x: f32 = 0
	local grid1_6_2_prev_y: f32 = 0
	local grid1_6_2_prev_z: f32 = 0
	local sprite_index: s32 = 0
	local current_x: f32 = 0
	local current_y: f32 = 0
	local current_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
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
	effect.set_effect_character_motion("月花ビームはじけ", -1, 6)
	effect.set_sprite_texture("e640_beamhajike")
	effect.allocate_sprites_1(1920)
	effect.reset_sprites(0, 1920)
	effect.set_sprite_blend_mode(0, 2, 1920)
	effect.set_sprite_visible(0, 1, 1920)
	effect.set_sprite_size(0, 50.0, 50.0, 1920)
	effect.set_sprite_texture_rect(0, 1.0, 1.0, 62.0, 62.0, 1920)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 1920)
	vm.wait()
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1--ba")
		grid1_prev_x = out1 or grid1_prev_x
		grid1_prev_y = out2 or grid1_prev_y
		grid1_prev_z = out3 or grid1_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_1--ba")
		grid1_1_prev_x = out1 or grid1_1_prev_x
		grid1_1_prev_y = out2 or grid1_1_prev_y
		grid1_1_prev_z = out3 or grid1_1_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_2--ba")
		grid1_2_prev_x = out1 or grid1_2_prev_x
		grid1_2_prev_y = out2 or grid1_2_prev_y
		grid1_2_prev_z = out3 or grid1_2_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_3--ba")
		grid1_3_prev_x = out1 or grid1_3_prev_x
		grid1_3_prev_y = out2 or grid1_3_prev_y
		grid1_3_prev_z = out3 or grid1_3_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_4--ba")
		grid1_4_prev_x = out1 or grid1_4_prev_x
		grid1_4_prev_y = out2 or grid1_4_prev_y
		grid1_4_prev_z = out3 or grid1_4_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6--ba")
		grid1_6_prev_x = out1 or grid1_6_prev_x
		grid1_6_prev_y = out2 or grid1_6_prev_y
		grid1_6_prev_z = out3 or grid1_6_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_1--ba")
		grid1_6_1_prev_x = out1 or grid1_6_1_prev_x
		grid1_6_1_prev_y = out2 or grid1_6_1_prev_y
		grid1_6_1_prev_z = out3 or grid1_6_1_prev_z
	end
	do
		local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_2--ba")
		grid1_6_2_prev_x = out1 or grid1_6_2_prev_x
		grid1_6_2_prev_y = out2 or grid1_6_2_prev_y
		grid1_6_2_prev_z = out3 or grid1_6_2_prev_z
	end
	effect.set_effect_character_frame_visible("grid1--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_1--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_2--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_3--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_4--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_6--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_6_1--ba", 0, 0)
	effect.set_effect_character_frame_visible("grid1_6_2--ba", 0, 0)
	sprite_index = 0
	while true do
		for bone_index = 0, 7 do
			if bone_index == 0 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_prev_x, grid1_prev_y, grid1_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 1 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_1--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_1_prev_x, grid1_1_prev_y, grid1_1_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 2 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_2--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_2_prev_x, grid1_2_prev_y, grid1_2_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 3 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_3--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_3_prev_x, grid1_3_prev_y, grid1_3_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 4 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_4--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_4_prev_x, grid1_4_prev_y, grid1_4_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 5 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_6_prev_x, grid1_6_prev_y, grid1_6_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 6 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_1--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_6_1_prev_x, grid1_6_1_prev_y, grid1_6_1_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			if bone_index == 7 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_2--ba")
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
				do
					local out1, out2, out3 = effect.copy_vector(grid1_6_2_prev_x, grid1_6_2_prev_y, grid1_6_2_prev_z)
					step_x = out1 or step_x
					step_y = out2 or step_y
					step_z = out3 or step_z
				end
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, current_x, current_y, current_z)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			do
				local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 8)
				step_x = out1 or step_x
				step_y = out2 or step_y
				step_z = out3 or step_z
			end
			for step_index = 0, 7 do
				effect.set_sprite_position(sprite_index, current_x, current_y, current_z)
				effect.set_sprite_color(sprite_index, 128.0, 128.0, 128.0, 128.0)
				effect.ease_sprite_color(sprite_index, 128.0, 128.0, 128.0, 0.0, 10)
				effect.set_sprite_scale(sprite_index, 1.0, 1.0)
				effect.ease_sprite_scale(sprite_index, 0.2, 0.2, 20)
				sprite_index = vm.i32(sprite_index + 1)
				do
					local out1, out2, out3 = effect.add_vectors(current_x, current_y, current_z, step_x, step_y, step_z)
					current_x = out1 or current_x
					current_y = out2 or current_y
					current_z = out3 or current_z
				end
			end
			if bone_index == 0 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1--ba")
					grid1_prev_x = out1 or grid1_prev_x
					grid1_prev_y = out2 or grid1_prev_y
					grid1_prev_z = out3 or grid1_prev_z
				end
			end
			if bone_index == 1 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_1--ba")
					grid1_1_prev_x = out1 or grid1_1_prev_x
					grid1_1_prev_y = out2 or grid1_1_prev_y
					grid1_1_prev_z = out3 or grid1_1_prev_z
				end
			end
			if bone_index == 2 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_2--ba")
					grid1_2_prev_x = out1 or grid1_2_prev_x
					grid1_2_prev_y = out2 or grid1_2_prev_y
					grid1_2_prev_z = out3 or grid1_2_prev_z
				end
			end
			if bone_index == 3 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_3--ba")
					grid1_3_prev_x = out1 or grid1_3_prev_x
					grid1_3_prev_y = out2 or grid1_3_prev_y
					grid1_3_prev_z = out3 or grid1_3_prev_z
				end
			end
			if bone_index == 4 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_4--ba")
					grid1_4_prev_x = out1 or grid1_4_prev_x
					grid1_4_prev_y = out2 or grid1_4_prev_y
					grid1_4_prev_z = out3 or grid1_4_prev_z
				end
			end
			if bone_index == 5 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6--ba")
					grid1_6_prev_x = out1 or grid1_6_prev_x
					grid1_6_prev_y = out2 or grid1_6_prev_y
					grid1_6_prev_z = out3 or grid1_6_prev_z
				end
			end
			if bone_index == 6 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_1--ba")
					grid1_6_1_prev_x = out1 or grid1_6_1_prev_x
					grid1_6_1_prev_y = out2 or grid1_6_1_prev_y
					grid1_6_1_prev_z = out3 or grid1_6_1_prev_z
				end
			end
			if bone_index == 7 then
				do
					local out1, out2, out3 = effect.get_effect_character_frame_position("grid1_6_2--ba")
					grid1_6_2_prev_x = out1 or grid1_6_2_prev_x
					grid1_6_2_prev_y = out2 or grid1_6_2_prev_y
					grid1_6_2_prev_z = out3 or grid1_6_2_prev_z
				end
			end
		end
		if sprite_index >= 1920 then
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
