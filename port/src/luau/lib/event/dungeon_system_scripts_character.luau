--!strict
--- Character helpers for the dungeon system scripts: turning characters toward a rotation or each other.

local vm = require("@lib/vm")
local calc = vm.module("@lib/event/calc")

local dungeon_system_scripts_character = {}

--- Turns the player and another character to face each other, optionally with the talk camera.
function dungeon_system_scripts_character.face_each_other(player_slot: s32, npc_character: s32, unused_value: any, use_talk_camera: s32)
	local player_goal_angle: f32 = 0
	local npc_goal_angle: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local player_rotation_y: f32 = 0
	local npc_rotation_y: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local delta_x: f32 = 0
	local delta_z: f32 = 0
	local player_start_rotation: f32 = 0
	local player_goal_rotation: f32 = 0
	local player_rotation_delta: f32 = 0
	local player_step_rotation: f32 = 0
	local npc_start_rotation: f32 = 0
	local npc_goal_rotation: f32 = 0
	local npc_rotation_delta: f32 = 0
	local npc_step_rotation: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, npc_character)
	do
		local out1, out2, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local _, out2, _ = event.get_character_rotation(player_slot)
		player_rotation_y = out2 or player_rotation_y
	end
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		npc_rotation_y = out2 or npc_rotation_y
	end
	delta_x = vm.f32(npc_x - player_x)
	delta_z = vm.f32(npc_z - player_z)
	player_goal_angle = event.get_look_angle(delta_x, delta_z) or player_goal_angle
	npc_goal_angle = event.get_look_angle(-delta_x, -delta_z) or npc_goal_angle
	if use_talk_camera ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(player_x, player_y, player_z, npc_x, npc_y, npc_z, player_goal_angle)
			camera_x = out1 or camera_x
			camera_y = out2 or camera_y
			camera_z = out3 or camera_z
			look_at_x = out4 or look_at_x
			look_at_y = out5 or look_at_y
			look_at_z = out6 or look_at_z
		end
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.start_crossfade(10)
	end
	player_start_rotation = player_rotation_y
	player_goal_rotation = player_goal_angle
	player_rotation_delta = vm.f32(player_goal_rotation - player_start_rotation)
	if player_rotation_delta < vm.f32(-3.1415927) then
		player_rotation_delta = vm.f32(player_rotation_delta + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < player_rotation_delta then
		player_rotation_delta = vm.f32(player_rotation_delta - vm.f32(6.2831855))
	end
	npc_start_rotation = npc_rotation_y
	npc_goal_rotation = npc_goal_angle
	npc_rotation_delta = vm.f32(npc_goal_rotation - npc_start_rotation)
	if npc_rotation_delta < vm.f32(-3.1415927) then
		npc_rotation_delta = vm.f32(npc_rotation_delta + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < npc_rotation_delta then
		npc_rotation_delta = vm.f32(npc_rotation_delta - vm.f32(6.2831855))
	end
	if -0.5 < player_rotation_delta and player_rotation_delta < 0.5 then
		event.set_character_motion(player_slot, "立ち")
	else
		event.set_character_motion(player_slot, "歩き")
	end
	if -0.5 < npc_rotation_delta and npc_rotation_delta < 0.5 then
	else
		event.set_character_motion(npc_character, "歩き")
	end
	frame = 0.0
	frame_count = vm.f32(calc.max(calc.absolute(player_rotation_delta), calc.absolute(npc_rotation_delta)) * 8.0)
	while frame < frame_count do
		player_step_rotation = calc.interpolate(0.0, player_rotation_delta, frame, frame_count)
		player_step_rotation = vm.f32(player_step_rotation + player_start_rotation)
		event.set_character_rotation(player_slot, 0.0, player_step_rotation, 0.0)
		npc_step_rotation = calc.interpolate(0.0, npc_rotation_delta, frame, frame_count)
		npc_step_rotation = vm.f32(npc_step_rotation + npc_start_rotation)
		event.set_object_handle_rotation(0, 0.0, npc_step_rotation, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.set_character_motion(player_slot, "立ち")
	event.set_character_motion(npc_character, "会話")
	event.set_character_rotation(player_slot, 0.0, player_goal_angle, 0.0)
	event.set_object_handle_rotation(0, 0.0, npc_goal_angle, 0.0)
end

--- Smoothly turns a character over ten frames until it faces the target rotation, walking if the turn is large.
function dungeon_system_scripts_character.turn_character_to_rotation(character: s32, target_rotation: f32)
	local current_rotation: f32 = 0
	local start_rotation: f32 = 0
	local goal_rotation: f32 = 0
	local rotation_delta: f32 = 0
	local step_rotation: f32 = 0
	local frame: f32 = 0
	local frame_count: f32 = 0
	event.attach_object_handle_to_character(0, character)
	event.get_object_handle_position(0)
	do
		local _, out2, _ = event.get_object_handle_rotation(0)
		current_rotation = out2 or current_rotation
	end
	start_rotation = current_rotation
	goal_rotation = target_rotation
	rotation_delta = vm.f32(goal_rotation - start_rotation)
	if rotation_delta < vm.f32(-3.1415927) then
		rotation_delta = vm.f32(rotation_delta + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < rotation_delta then
		rotation_delta = vm.f32(rotation_delta - vm.f32(6.2831855))
	end
	if -0.5 < rotation_delta and rotation_delta < 0.5 then
		event.set_character_motion(character, "立ち")
	else
		event.set_character_motion(character, "歩き")
	end
	frame = 0.0
	frame_count = 10.0
	while frame <= frame_count do
		step_rotation = calc.interpolate(0.0, rotation_delta, frame, frame_count)
		step_rotation = vm.f32(step_rotation + start_rotation)
		event.set_object_handle_rotation(0, 0.0, step_rotation, 0.0)
		frame = vm.f32(frame + 1.0)
		vm.wait(1)
	end
	event.set_object_handle_rotation(0, 0.0, target_rotation, 0.0)
end

return dungeon_system_scripts_character
