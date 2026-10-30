--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0daab607 = require("@lib/event/helper_0daab607")
local helper_90f36555 = require("@lib/event/helper_90f36555")
local interpolate = require("@lib/event/interpolate")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_455f6141()
	local var0: s32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_z: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local pos_y: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	event.initialize_event()
	event.set_character_motion(0, "立ち")
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, -15.0, 0.0, -25.0)
	event.set_object_sequence_rotation(0, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(0, "歩き", 4)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 15.0, 0.0, -25.0)
	event.set_object_sequence_rotation(1, 0.0, 3.14, 0.0)
	event.set_object_sequence_motion(1, "歩き", 4)
	event.reset_object_handle_dynamic_animation(1)
	event.set_time_of_day(18.0)
	event.set_time_of_day_advancing(0)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-1989.26, 42.52, 580.43)
	event.set_camera_sequence_look_at(-1909.39, 98.92, 395.66)
	wait_frames(60)
	var1 = event.get_arc_tangent(79.869995, -184.76999) or var1
	var2 = event.get_arc_tangent(379.87, -334.77) or var2
	var3 = event.get_distance_between(-1909.39, 0.0, 395.66, -1989.26, 0.0, 580.43) or var3
	var0 = 0
	while var0 < 180 do
		var4 = interpolate(var1, var2, var0, 180)
		var5 = vm.f32(vm.sin(var4) * var3)
		var6 = vm.f32(vm.cos(var4) * var3)
		event.set_camera_sequence_look_at(var5 - vm.f32(1989.26), 98.92, var6 + vm.f32(580.43))
		var0 = var0 + 1
		vm.wait(2)
	end
	event.set_time_of_day(0.0)
	event.set_time_of_day_advancing(0)
	event.set_object_sequence_position(0, -15.0, 0.0, -25.0)
	event.set_object_sequence_position(1, 15.0, 0.0, -25.0)
	event.move_object_sequence(1, 15.0, 0.0, -225.0, 360)
	event.move_object_sequence(0, -15.0, 0.0, -225.0, 360)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 18.37, 42.25)
	event.set_camera_sequence_look_at(0.0, 213.16, -316.49)
	pos_z = 42.25
	var8 = 0.0
	var9 = helper_90f36555(vm.f32(1164.86), 0.0, 360)
	pos_y = vm.f32(213.16)
	var12, var11 = helper_0daab607(vm.f32(vm.f32(330.93) - pos_y), 1.8359375, 360, var12, var11)
	var0 = 0
	while var0 < 360 do
		pos_z = vm.f32(pos_z + var8)
		var8 = vm.f32(var8 + var9)
		event.set_camera_sequence_position(0.0, 18.37, pos_z)
		pos_y = vm.f32(pos_y + var11)
		var11 = vm.f32(var11 + var12)
		event.set_camera_sequence_look_at(0.0, pos_y, -316.49)
		var0 = var0 + 1
		vm.wait(3)
	end
	wait_frames(300)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.finish_event()
end

return helper_455f6141
