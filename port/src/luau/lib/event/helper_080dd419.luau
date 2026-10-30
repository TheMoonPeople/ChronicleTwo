--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_479dc9e9 = require("@lib/event/helper_479dc9e9")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_080dd419()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local var9: f32 = 0
	local var10: s32 = 0
	local var11: s32 = 0
	event.reset_action_character_motion(0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.start_background_file_loads_2("event/e700/e728/rasen_iwa.gltf", "snd2/sp/sp_049.sound.json")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_object_handle_rotation(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	var9 = event.get_direction_angle(var0, var1, var2, pos_x, pos_y, pos_z) or var9
	var9 = vm.f32(var9 - vm.f32(3.1415927))
	var9 = event.wrap_angle(var9) or var9
	var10 = 0
	while var10 < 20 do
		event.swing_camera_control_to_angle(var9)
		event.move_camera_control_with_pad(0)
		event.step_camera_control()
		var10 = var10 + 1
		vm.wait(1)
	end
	helper_479dc9e9()
	var11 = event.load_sound_effect_file_3(8, "snd2/sp/sp_049.sound.json") or var11
	event.load_character(5, "event/e700/e728/rasen_iwa.gltf", "info", 8)
	event.set_character_active(1, 8)
	event.set_character_position(8, pos_x, pos_y + 20.0, pos_z)
	event.set_character_rotation(8, rot_x, rot_y, rot_z)
	event.set_character_motion(8, "岩消える", 6, 0.6)
	event.play_sound_effect(var11, 0)
	event.move_object_sequence_eased(0, pos_x, pos_y - 260.0, pos_z, 60, 1, 1.0)
	event.reset_follow_camera(0)
	wait_objects(0)
	wait_frames(30)
	event.delete_character(8)
	event.finish_event()
end

return helper_080dd419
