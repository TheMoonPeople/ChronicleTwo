--!strict
--- Helpers for field town f01: resident visibility, character turning and a walking-away cutscene.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")
local character = vm.module("@lib/event/character")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local field_town_f01 = {}

--- Turns a character smoothly to a target angle, switching to the walking motion when the turn exceeds about half a radian.
function field_town_f01.turn_to_angle(character: s32, target_angle: f32)
	local start_angle: f32 = 0
	local angle_delta: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	local rotation_y: f32 = 0
	do
		local _, out2, _ = event.get_character_rotation(character)
		start_angle = out2 or start_angle
	end
	angle_delta = vm.f32(target_angle - start_angle)
	if angle_delta < vm.f32(-3.1415927) then
		angle_delta = vm.f32(angle_delta + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < angle_delta then
		angle_delta = vm.f32(angle_delta - vm.f32(6.2831855))
	end
	if -0.5 < angle_delta and angle_delta < 0.5 then
	else
		event.set_character_motion(character, "歩き")
	end
	frame = 0.0
	frame_count = vm.f32(calc.absolute(angle_delta) * 8.0)
	while frame < frame_count do
		rotation_y = calc.interpolate(0.0, angle_delta, frame, frame_count)
		rotation_y = vm.f32(rotation_y + start_angle)
		event.set_character_rotation(character, 0.0, rotation_y, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.get_character_rotation(character, 0.0, target_angle, 0.0)
	event.set_character_motion(character, "立ち")
end

--- Turns a character to face a point on the ground plane.
function field_town_f01.turn_toward_point(character: s32, target_x: f32, target_z: f32)
	local current_x: f32 = 0
	local current_z: f32 = 0
	local target_angle: f32 = 0
	do
		local out1, _, out3 = event.get_character_position(character)
		current_x = out1 or current_x
		current_z = out3 or current_z
	end
	target_angle = event.get_look_angle(target_x - current_x, target_z - current_z) or target_angle
	field_town_f01.turn_to_angle(character, target_angle)
end

--- Shows or hides the town's resident characters according to georama analysis flags and save flag 275.
function field_town_f01.update_resident_visibility()
	local character_slot: s32 = 0
	local analysis_flag: s32 = 0
	local save_flag: s32 = 0
	save_flag = event.get_save_flag(275) or save_flag
	analysis_flag = event.get_georama_analysis_flag(104) or analysis_flag
	if analysis_flag == 0 or save_flag == 0 then
		character_slot = event.get_character_slot_by_number(102) or character_slot
		event.set_character_active(0, character_slot)
	else
		character_slot = event.get_character_slot_by_number(102) or character_slot
		event.set_character_active(1, character_slot)
	end
	analysis_flag = event.get_georama_analysis_flag(105) or analysis_flag
	if analysis_flag == 0 or save_flag == 0 then
		character_slot = event.get_character_slot_by_number(103) or character_slot
		event.set_character_active(0, character_slot)
	else
		character_slot = event.get_character_slot_by_number(103) or character_slot
		event.set_character_active(1, character_slot)
	end
	analysis_flag = event.get_georama_analysis_flag(106) or analysis_flag
	if analysis_flag == 0 or save_flag == 0 then
		character_slot = event.get_character_slot_by_number(101) or character_slot
		event.set_character_active(0, character_slot)
	else
		character_slot = event.get_character_slot_by_number(101) or character_slot
		event.set_character_active(1, character_slot)
	end
	analysis_flag = event.get_georama_analysis_flag(107) or analysis_flag
	character.set_active_by_number(104, analysis_flag)
	analysis_flag = event.get_georama_analysis_flag(103) or analysis_flag
	character.set_active_by_number(105, analysis_flag)
end

--- Makes two sequenced characters walk away along paths after a line of dialogue while the camera fades out.
function field_town_f01.walk_away_along_paths()
	event.set_object_sequence_motion(0, "上向く会話", 2)
	event.queue_object_sequence_next_motion(0, "上向くL", 4)
	message.show_voiced(2850030)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.rotate_object_sequence(0, 0.0, 0.2, 0.0, 15)
	event.rotate_object_sequence(1, 0.0, 0.0, 0.0, 15)
	wait.frames(15)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(30)
	event.fade_out_camera_sequence(30, 0.0, 0.0, 0.0)
	event.clear_object_sequence_path(0)
	event.set_object_sequence_path_frames(0, 120)
	event.add_object_sequence_path_point(0, 13.4, 6.52, 613.7)
	event.add_object_sequence_path_point(0, 16.54, 2.3, 632.93)
	event.add_object_sequence_path_point(0, 19.85, -3.85, 662.84)
	event.add_object_sequence_path_point(0, 22.02, -8.04, 684.68)
	event.add_object_sequence_path_point(0, 24.22, -12.54, 709.74)
	event.add_object_sequence_path_point(0, 26.96, -12.32, 737.33)
	event.start_object_sequence_path(0)
	event.clear_object_sequence_path(1)
	event.set_object_sequence_path_frames(1, 120)
	event.add_object_sequence_path_point(1, 47.24, 7.54, 600.38)
	event.add_object_sequence_path_point(1, 49.86, 2.84, 624.2)
	event.add_object_sequence_path_point(1, 51.55, -2.15, 651.95)
	event.add_object_sequence_path_point(1, 52.91, -6.17, 674.31)
	event.add_object_sequence_path_point(1, 55.85, -12.79, 722.8)
	event.start_object_sequence_path(1)
	wait.frames(60)
end

return field_town_f01
