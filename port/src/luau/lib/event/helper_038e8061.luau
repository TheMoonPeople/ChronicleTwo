--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local interpolate = require("@lib/event/interpolate")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_038e8061()
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	local rot_x: f32 = 0
	local rot_z: f32 = 0
	local var12: s32 = 0
	event.set_time_of_day(12.0)
	event.set_time_of_day_advancing(0)
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.set_character_motion(0, "立ち")
	event.load_character_motion_pack(5, "event/time_gate/red/c01b_warp.gltf", "info", 0)
	event.set_character_active(0)
	event.attach_object_handle_to_character(0, 0)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_position(0, 663.45, 0.0, 1290.77)
	event.set_object_sequence_rotation(0, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(0, "走り", 4)
	event.load_character(5, "chara/c02_base.gltf", "info", 9)
	event.set_character_active(9)
	event.attach_object_handle_to_character(1, 9)
	event.load_equipment_model(5, 1, 4, "info", 9)
	event.load_equipment_model(5, 1, 3, "info", 9)
	event.load_equipment_model(5, 1, 2, "info", 9, 13)
	event.set_character_active(13)
	event.attach_object_handle_to_character(5, 13)
	event.set_object_handle_visible(5, 1)
	event.reset_object_handle_dynamic_animation(1)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.set_object_sequence_position(1, 699.23, 0.0, 1268.37)
	event.set_object_sequence_rotation(1, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(1, "走り", 4)
	event.load_character(5, "event/e400/e438/e438_paw.gltf", "info", 14)
	event.set_character_active(14)
	event.attach_object_handle_to_character(6, 14)
	event.clear_object_sequence(6)
	event.set_object_sequence_object(6, 6)
	event.set_object_sequence_position(6, 699.23, 0.0, 1268.37)
	event.set_object_sequence_rotation(6, 0.0, 2.3561945, 0.0)
	event.set_object_sequence_motion(6, "走り", 4)
	event.attach_object_handle_to_map_part_2(2, "p01_battleship")
	event.get_object_handle_position(2)
	event.set_object_handle_position(2, -6000.0, 1600.0, -8000.0)
	event.set_object_handle_rotation(2, 0.0, 2.3561945, 0.0)
	event.set_camera_sequence_position(575.95, 61.55, 1603.27)
	event.set_camera_sequence_look_at(463.45, 40.0, 1490.77)
	event.move_camera_sequence(950.95, 61.55, 1228.27, 838.45, 40.0, 1115.77, 113)
	event.set_object_sequence_position(0, 463.45, 0.0, 1510.77)
	event.move_object_sequence(0, 1963.45, 0.0, 10.77002, 450)
	event.set_object_sequence_position(1, 483.45, 0.0, 1470.77)
	event.move_object_sequence(1, 1953.45, 0.0, 0.77001953, 450)
	event.set_object_sequence_position(6, 453.45, 0.0, 1500.77)
	event.move_object_sequence(6, 1923.45, 0.0, 30.77002, 450)
	var3 = vm.f32(-2786.55)
	var4 = vm.f32(-786.55005)
	var5 = vm.f32(-1259.23)
	var6 = vm.f32(-3259.23)
	var12 = 0
	while var12 < 450 do
		if var12 == 113 then
			event.move_camera_sequence(2075.95, 6.11, 103.27002, 1963.45, 50.0, -9.22998, 337)
		end
		pos_x_2 = interpolate(var3, var4, var12, 450)
		pos_z_2 = interpolate(var5, var6, var12, 450)
		if var12 < 225 then
			pos_y_2 = interpolate(1400.0, 1000.0, var12, 225)
		else
			pos_y_2 = interpolate(1000.0, 1400.0, var12 - 225, 225)
		end
		if var12 < 150 then
			rot_x = interpolate(-0.25, 0.25, var12, 150)
			rot_z = 0.0
		else
			rot_x = interpolate(0.25, -0.25, var12 - 150, 300)
			rot_z = 0.0
		end
		event.set_object_handle_position(2, pos_x_2, pos_y_2, pos_z_2)
		event.set_object_handle_rotation(2, rot_x, 2.3561945, rot_z)
		var12 = var12 + 1
		vm.wait(1)
	end
	wait_frames(150)
	event.delete_character_extension_packs(0)
	event.delete_character(9)
	event.delete_character(13)
	event.delete_character(14)
	event.finish_event()
end

return helper_038e8061
