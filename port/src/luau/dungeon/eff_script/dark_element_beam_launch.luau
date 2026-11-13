--!strict
--- Aims the beam at the player from the owner and drives the beam body through its stages.

local vm = require("@lib/vm")
local motion = require("@lib/effect/motion")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Tracks the owner's orb joint and the target position, creates the beam effect and feeds it its target until the owner ends each stage.
function script.on_start()
	local orb_x: f32 = 0
	local orb_y: f32 = 0
	local orb_z: f32 = 0
	local rotation_x: f32 = 0
	local rotation_y: f32 = 0
	local rotation_z: f32 = 0
	local target_x: f32 = 0
	local target_y: f32 = 0
	local target_z: f32 = 0
	local current_rotation_x: f32 = 0
	local current_rotation_y: f32 = 0
	local current_rotation_z: f32 = 0
	local scale: f32 = 0
	local direction_x: f32 = 0
	local direction_y: f32 = 0
	local direction_z: f32 = 0
	local current_y: f32 = 0
	local owner_id: s32 = 0
	local frame: s32 = 0
	local stage: s32 = 0
	local beam_handle: s32 = 0
	local damage: s32 = 0
	local vector_scale: f32 = 0
	local beam_vector_x: f32 = 0
	local beam_vector_y: f32 = 0
	local beam_vector_z: f32 = 0
	local pitch_offset: f32 = 0
	damage = 0
	scale = 0.0
	owner_id = effect.get_owner_character() or owner_id
	damage = effect.get_script_value(0) or damage
	scale = effect.get_script_value_float(2) or scale
	effect.set_effect_character_scale(scale, scale, scale * 2.0)
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		target_x = out1 or target_x
		target_y = out2 or target_y
		target_z = out3 or target_z
	end
	effect.set_effect_character_motion("攻撃２入り", 6)
	while frame < 13 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
			orb_x = out1 or orb_x
			orb_y = out2 or orb_y
			orb_z = out3 or orb_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "tama")
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(target_x, target_y, target_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_character_position(orb_x, orb_y, orb_z)
		effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
		vm.wait()
		frame = frame + 1
		stage = effect.get_script_value(1) or stage
		if stage == 1 then
			break
		end
	end
	beam_handle = effect.create_effect_2("ＤＥビームＨ") or beam_handle
	effect.set_effect_value(beam_handle, 0, damage)
	effect.set_effect_value(beam_handle, 2, 0)
	effect.create_collision_primitive("通常攻撃")
	do
		local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
		orb_x = out1 or orb_x
		orb_y = out2 or orb_y
		orb_z = out3 or orb_z
	end
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "tama")
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	effect.set_effect_character_position(orb_x, orb_y, orb_z)
	effect.set_effect_character_motion("攻撃２ループ", 0)
	while true do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
			orb_x = out1 or orb_x
			orb_y = out2 or orb_y
			orb_z = out3 or orb_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "tama")
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			target_x = out1 or target_x
			target_y = out2 or target_y
			target_z = out3 or target_z
		end
		rotation_y = motion.get_angle_to_target(target_x, target_y, target_z, rotation_y)
		effect.get_distance_between(target_x, target_y, target_z, orb_x, orb_y, orb_z)
		do
			local _, out2, _ = effect.get_effect_character_position()
			current_y = out2 or current_y
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation()
			current_rotation_x = out1 or current_rotation_x
			current_rotation_y = out2 or current_rotation_y
			current_rotation_z = out3 or current_rotation_z
		end
		do
			local out1, out2, out3 = effect.get_direction_vector(current_rotation_x, current_rotation_y, current_rotation_z)
			direction_x = out1 or direction_x
			direction_y = out2 or direction_y
			direction_z = out3 or direction_z
		end
		vector_scale = current_y
		do
			local out1, out2, out3 = effect.copy_vector(direction_x, direction_y, direction_z)
			beam_vector_x = out1 or beam_vector_x
			beam_vector_y = out2 or beam_vector_y
			beam_vector_z = out3 or beam_vector_z
		end
		do
			local out1, out2, out3 = effect.scale_vector(beam_vector_x, beam_vector_y, beam_vector_z, vector_scale)
			beam_vector_x = out1 or beam_vector_x
			beam_vector_y = out2 or beam_vector_y
			beam_vector_z = out3 or beam_vector_z
		end
		do
			local out1, out2, out3 = effect.get_effect_character_rotation_toward(target_x, target_y, target_z)
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_first_work_vector(beam_handle, target_x, target_y, target_z)
		effect.set_effect_value_float(beam_handle, 1, scale)
		effect.set_effect_character_position(orb_x, orb_y, orb_z)
		effect.rotate_effect_character_toward(rotation_x, rotation_y, rotation_z)
		vm.wait()
		stage = effect.get_script_value(1) or stage
		if stage == 2 then
			break
		end
	end
	effect.delete_collision_primitive(-1)
	effect.set_effect_value(beam_handle, 2, 1)
	do
		local out1, out2, out3 = effect.get_effect_character_rotation()
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	pitch_offset = rotation_x
	do
		local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "tama")
		rotation_x = out1 or rotation_x
		rotation_y = out2 or rotation_y
		rotation_z = out3 or rotation_z
	end
	pitch_offset = vm.f32(pitch_offset - rotation_x)
	effect.set_effect_character_motion("攻撃２戻り", 6)
	while frame < 40 do
		do
			local out1, out2, out3 = effect.get_scene_character_frame_position(owner_id, "tama")
			orb_x = out1 or orb_x
			orb_y = out2 or orb_y
			orb_z = out3 or orb_z
		end
		do
			local out1, out2, out3 = effect.get_scene_character_frame_rotation(owner_id, "tama")
			rotation_x = out1 or rotation_x
			rotation_y = out2 or rotation_y
			rotation_z = out3 or rotation_z
		end
		effect.set_effect_first_work_vector(beam_handle, target_x, target_y, target_z)
		effect.set_effect_character_position(orb_x, orb_y, orb_z)
		effect.rotate_effect_character_toward(rotation_x + pitch_offset, rotation_y, rotation_z)
		vm.wait()
		frame = frame + 1
		stage = effect.get_script_value(1) or stage
		if stage == 3 then
			break
		end
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the effect has no finish handling.
function script.on_finish() end

return script
