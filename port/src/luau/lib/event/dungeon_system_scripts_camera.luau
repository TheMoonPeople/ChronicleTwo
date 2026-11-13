--!strict
--- Camera helpers for the dungeon system scripts: talk camera and the player camera behind the character.

local vm = require("@lib/vm")

local dungeon_system_scripts_camera = {}

--- Places the player camera behind the character for the given facing angle and enables camera control with a limited range.
function dungeon_system_scripts_camera.place_camera_behind_character(facing_angle: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	event.set_camera_control_enabled(0)
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	y = vm.f32(y + 25.0)
	event.set_camera_look_at(x, y, z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	x = vm.f32(vm.f32(vm.sin(facing_angle) * 100.0) + x)
	y = vm.f32(y + 5.0)
	z = vm.f32(vm.f32(vm.cos(facing_angle) * 100.0) + z)
	event.set_camera_position(x, y, z)
	event.set_camera_control_enabled(1)
	event.set_camera_control_range(10.0, 40.0, 60.0, 160.0)
end

--- Moves the player in front of a character and frames both with the talk camera.
function dungeon_system_scripts_camera.set_up_talk_camera(player_slot: s32, npc_character: s32, unused_value: any)
	local look_angle: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_y: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local front_x: f32 = 0
	local front_z: f32 = 0
	local delta_x: f32 = 0
	local delta_z: f32 = 0
	event.initialize_event()
	event.attach_object_handle_to_character(0, npc_character)
	do
		local out1, out2, out3 = event.get_character_position(player_slot)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	event.get_character_rotation(player_slot)
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
	front_x = vm.f32(vm.sin(npc_rotation_y) * 30.0)
	front_z = vm.f32(vm.cos(npc_rotation_y) * 30.0)
	front_x = vm.f32(front_x + npc_x)
	front_z = vm.f32(front_z + npc_z)
	player_x = front_x
	player_z = front_z
	event.set_character_position(player_slot, player_x, player_y, player_z)
	delta_x = vm.f32(npc_x - player_x)
	delta_z = vm.f32(npc_z - player_z)
	look_angle = event.get_look_angle(delta_x, delta_z) or look_angle
	event.set_character_rotation(player_slot, 0.0, look_angle, 0.0)
	do
		local out1, out2, out3, out4, out5, out6 = event.get_talk_camera_points(player_x, player_y, player_z, npc_x, npc_y, npc_z, look_angle)
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
		look_at_x = out4 or look_at_x
		look_at_y = out5 or look_at_y
		look_at_z = out6 or look_at_z
	end
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
end

return dungeon_system_scripts_camera
