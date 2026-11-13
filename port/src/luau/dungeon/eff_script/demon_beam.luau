--!strict
--- Fires a sprite beam from the owner's body toward the player that damages whatever it touches and fades out afterwards.

local vm = require("@lib/vm")

local script = {}

--- Runs once when the script is loaded and has nothing to prepare.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Empty initialisation program that the engine never runs.
function script.init() end

--- Extends the beam tip toward the player each frame, spawning hit effects along the way, then shrinks and fades the beam.
function script.on_start()
	local emitter_x: f32 = 0
	local emitter_y: f32 = 0
	local emitter_z: f32 = 0
	local tip_x: f32 = 0
	local tip_y: f32 = 0
	local tip_z: f32 = 0
	local sprite_spacing_x: f32 = 0
	local sprite_spacing_y: f32 = 0
	local sprite_spacing_z: f32 = 0
	local tip_step_x: f32 = 0
	local tip_step_y: f32 = 0
	local tip_step_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local scratch_x: f32 = 0
	local scratch_y: f32 = 0
	local scratch_z: f32 = 0
	local frame: s32 = 0
	local hit_count: s32 = 0
	local damage: s32 = 0
	local owner_id: s32 = 0
	local phase_command: s32 = 0
	hit_count = 0
	owner_id = 0
	effect.set_sprite_texture("nana_rinpun")
	effect.allocate_sprites_1(400)
	effect.reset_sprites(0, 400)
	effect.set_sprite_blend_mode(0, 2, 400)
	effect.set_sprite_visible(0, 1, 400)
	effect.set_sprite_position(0, 0.0, -1000.0, 0.0, 400)
	effect.set_sprite_size(0, 4.5, 4.5, 400)
	effect.set_sprite_texture_rect(0, 129.0, 1.0, 126.0, 126.0, 400)
	owner_id = effect.get_owner_character() or owner_id
	effect.get_target_character()
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		emitter_x = out1 or emitter_x
		emitter_y = out2 or emitter_y
		emitter_z = out3 or emitter_z
	end
	do
		local out1, out2, out3 = effect.get_second_work_vector()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	damage = effect.get_script_value(1) or damage
	do
		local out1, out2, out3 = effect.get_scene_character_position(0)
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol2")
		emitter_x = out1 or emitter_x
		emitter_y = out2 or emitter_y
		emitter_z = out3 or emitter_z
	end
	do
		local out1, out2, out3 = effect.copy_vector(emitter_x, -20.0, emitter_z)
		tip_x = out1 or tip_x
		tip_y = out2 or tip_y
		tip_z = out3 or tip_z
	end
	effect.create_collision_primitive("中ＢＧＣ")
	effect.set_collision_primitive_damage(damage)
	frame = 0
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol2")
			emitter_x = out1 or emitter_x
			emitter_y = out2 or emitter_y
			emitter_z = out3 or emitter_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(target_x, -20.0, target_z)
			tip_step_x = out1 or tip_step_x
			tip_step_y = out2 or tip_step_y
			tip_step_z = out3 or tip_step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(tip_step_x, tip_step_y, tip_step_z, emitter_x, 0.0, emitter_z)
			tip_step_x = out1 or tip_step_x
			tip_step_y = out2 or tip_step_y
			tip_step_z = out3 or tip_step_z
		end
		do
			local out1, out2, out3 = effect.normalize_vector(tip_step_x, tip_step_y, tip_step_z)
			tip_step_x = out1 or tip_step_x
			tip_step_y = out2 or tip_step_y
			tip_step_z = out3 or tip_step_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(tip_step_x, tip_step_y, tip_step_z, 4.5)
			tip_step_x = out1 or tip_step_x
			tip_step_y = out2 or tip_step_y
			tip_step_z = out3 or tip_step_z
		end
		do
			local out1, out2, out3 = effect.add_vectors(tip_x, tip_y, tip_z, tip_step_x, 0.0, tip_step_z)
			tip_x = out1 or tip_x
			tip_y = out2 or tip_y
			tip_z = out3 or tip_z
		end
		tip_y = -20.0
		do
			local out1, out2, out3 = effect.copy_vector(tip_x, tip_y, tip_z)
			sprite_spacing_x = out1 or sprite_spacing_x
			sprite_spacing_y = out2 or sprite_spacing_y
			sprite_spacing_z = out3 or sprite_spacing_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, emitter_x, emitter_y, emitter_z)
			sprite_spacing_x = out1 or sprite_spacing_x
			sprite_spacing_y = out2 or sprite_spacing_y
			sprite_spacing_z = out3 or sprite_spacing_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 400.0)
			sprite_spacing_x = out1 or sprite_spacing_x
			sprite_spacing_y = out2 or sprite_spacing_y
			sprite_spacing_z = out3 or sprite_spacing_z
		end
		effect.spread_sprite_positions(0, emitter_x, emitter_y, emitter_z, sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 0.0, 0.0, 0.0, 400)
		effect.set_collision_primitive_shape(tip_x, tip_y, tip_z, 20.0)
		hit_count = effect.get_collision_primitive_hit_count() or hit_count
		if hit_count > 0 then
			break
		else
			if vm.imod(frame, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(tip_x, tip_y, tip_z)
				effect.set_effect_value(0, damage)
			end
			phase_command = effect.get_script_value(0) or phase_command
			if phase_command == 2 then
				break
			else
				vm.wait()
				frame = vm.i32(frame + 1)
			end
		end
	end
	if hit_count <= 0 then
		do
			local out1, out2, out3 = effect.get_scene_character_position(0)
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		effect.copy_vector(scratch_x, scratch_y, scratch_z)
		do
			local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
			scratch_x = out1 or scratch_x
			scratch_y = out2 or scratch_y
			scratch_z = out3 or scratch_z
		end
		frame = 0
		while true do
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol2")
				emitter_x = out1 or emitter_x
				emitter_y = out2 or emitter_y
				emitter_z = out3 or emitter_z
			end
			do
				local out1, out2, out3 = effect.get_scene_character_position(0)
				target_x = out1 or target_x
				target_y = out2 or target_y
				target_z = out3 or target_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
				tip_step_x = out1 or tip_step_x
				tip_step_y = out2 or tip_step_y
				tip_step_z = out3 or tip_step_z
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(tip_step_x, tip_step_y, tip_step_z, tip_x, tip_y, tip_z)
				tip_step_x = out1 or tip_step_x
				tip_step_y = out2 or tip_step_y
				tip_step_z = out3 or tip_step_z
			end
			do
				local out1, out2, out3 = effect.normalize_vector(tip_step_x, tip_step_y, tip_step_z)
				tip_step_x = out1 or tip_step_x
				tip_step_y = out2 or tip_step_y
				tip_step_z = out3 or tip_step_z
			end
			do
				local out1, out2, out3 = effect.scale_vector(tip_step_x, tip_step_y, tip_step_z, 4.5)
				tip_step_x = out1 or tip_step_x
				tip_step_y = out2 or tip_step_y
				tip_step_z = out3 or tip_step_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(tip_x, tip_y, tip_z, tip_step_x, tip_step_y, tip_step_z)
				tip_x = out1 or tip_x
				tip_y = out2 or tip_y
				tip_z = out3 or tip_z
			end
			tip_y = vm.f32(target_y - 10.0)
			do
				local out1, out2, out3 = effect.copy_vector(tip_x, tip_y, tip_z)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, emitter_x, emitter_y, emitter_z)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			do
				local out1, out2, out3 = effect.divide_vector(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 400.0)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			effect.spread_sprite_positions(0, emitter_x, emitter_y, emitter_z, sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 0.0, 0.0, 0.0, 400)
			effect.set_collision_primitive_shape(tip_x, tip_y, tip_z, 20.0)
			if vm.imod(frame, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(tip_x, tip_y, tip_z)
				effect.set_effect_value(0, damage)
			end
			hit_count = effect.get_collision_primitive_hit_count() or hit_count
			if hit_count > 0 then
				break
			end
			phase_command = effect.get_script_value(0) or phase_command
			if phase_command == 3 then
				break
			end
			effect.copy_vector(scratch_x, scratch_y, scratch_z)
			do
				local out1, out2, out3 = effect.copy_vector(target_x, target_y, target_z)
				scratch_x = out1 or scratch_x
				scratch_y = out2 or scratch_y
				scratch_z = out3 or scratch_z
			end
			vm.wait()
			frame = vm.i32(frame + 1)
		end
	end
	frame = 0
	effect.set_sprite_color_velocity(0, 128.0, 128.0, 128.0, vm.fdiv(128.0, 60), 400)
	effect.set_sprite_scale_velocity(0, -0.1, 0.0, 400)
	while frame < 60 do
		do
			local out1, out2 = effect.get_sprite_scale(0)
			scratch_x = out1 or scratch_x
			scratch_y = out2 or scratch_y
		end
		if scratch_x <= 0.0 then
			break
		else
			do
				local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "dcol2")
				emitter_x = out1 or emitter_x
				emitter_y = out2 or emitter_y
				emitter_z = out3 or emitter_z
			end
			do
				local out1, out2, out3 = effect.add_vectors(tip_x, tip_y, tip_z, tip_step_x, tip_step_y, tip_step_z)
				tip_x = out1 or tip_x
				tip_y = out2 or tip_y
				tip_z = out3 or tip_z
			end
			do
				local out1, out2, out3 = effect.copy_vector(tip_x, tip_y, tip_z)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			do
				local out1, out2, out3 = effect.subtract_vectors(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, emitter_x, emitter_y, emitter_z)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			do
				local out1, out2, out3 = effect.divide_vector(sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 400.0)
				sprite_spacing_x = out1 or sprite_spacing_x
				sprite_spacing_y = out2 or sprite_spacing_y
				sprite_spacing_z = out3 or sprite_spacing_z
			end
			effect.spread_sprite_positions(0, emitter_x, emitter_y, emitter_z, sprite_spacing_x, sprite_spacing_y, sprite_spacing_z, 0.0, 0.0, 0.0, 400)
			if vm.imod(frame, 6) == 0 then
				effect.create_effect_1("魔人ビームＨ")
				effect.set_effect_first_work_vector(tip_x, 0.0, tip_z)
			end
			vm.wait()
			frame = frame + 1
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
