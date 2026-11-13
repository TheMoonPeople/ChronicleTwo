--!strict
--- Waits on and controls scene object sequences.

local vm = require("@lib/vm")

local object = {}

--- Attaches fourteen map part pieces to object handles and returns how many are visible.
function object.count_visible_map_parts()
	local visible_flags: { s32 } = table.create(14, 0)
	local visible_count: s32 = 0
	event.attach_object_handle_to_map_part_3(0, "p08_i01h07", "i01h07_13-m7")
	event.attach_object_handle_to_map_part_3(1, "p08_i01h07", "i01h07_13-m21")
	event.attach_object_handle_to_map_part_3(2, "p08_i01h07", "i01h07_13-m8")
	event.attach_object_handle_to_map_part_3(3, "p08_i01h07", "i01h07_13-m20")
	event.attach_object_handle_to_map_part_3(4, "p08_i01h07", "i01h07_13-m9")
	event.attach_object_handle_to_map_part_3(5, "p08_i01h07", "i01h07_13-m19")
	event.attach_object_handle_to_map_part_3(6, "p08_i01h07", "i01h07_13-m10")
	event.attach_object_handle_to_map_part_3(7, "p08_i01h07", "i01h07_13-m18")
	event.attach_object_handle_to_map_part_3(8, "p08_i01h07", "i01h07_13-m11")
	event.attach_object_handle_to_map_part_3(9, "p08_i01h07", "i01h07_13-m17")
	event.attach_object_handle_to_map_part_3(10, "p08_i01h07", "i01h07_13-m12")
	event.attach_object_handle_to_map_part_3(11, "p08_i01h07", "i01h07_13-m16")
	event.attach_object_handle_to_map_part_3(12, "p08_i01h07", "i01h07_13-m14")
	event.attach_object_handle_to_map_part_3(13, "p08_i01h07", "i01h07_13-m15")
	visible_flags[1] = event.is_object_handle_visible(0) or visible_flags[1]
	visible_flags[2] = event.is_object_handle_visible(1) or visible_flags[2]
	visible_flags[3] = event.is_object_handle_visible(2) or visible_flags[3]
	visible_flags[4] = event.is_object_handle_visible(3) or visible_flags[4]
	visible_flags[5] = event.is_object_handle_visible(4) or visible_flags[5]
	visible_flags[6] = event.is_object_handle_visible(5) or visible_flags[6]
	visible_flags[7] = event.is_object_handle_visible(6) or visible_flags[7]
	visible_flags[8] = event.is_object_handle_visible(7) or visible_flags[8]
	visible_flags[9] = event.is_object_handle_visible(8) or visible_flags[9]
	visible_flags[10] = event.is_object_handle_visible(9) or visible_flags[10]
	visible_flags[11] = event.is_object_handle_visible(10) or visible_flags[11]
	visible_flags[12] = event.is_object_handle_visible(11) or visible_flags[12]
	visible_flags[13] = event.is_object_handle_visible(12) or visible_flags[13]
	visible_flags[14] = event.is_object_handle_visible(13) or visible_flags[14]
	visible_count = 0
	for i = 0, 13 do
		if visible_flags[i + 1] ~= 0 then
			visible_count = vm.i32(visible_count + 1)
		end
	end
	return visible_count
end

--- Attaches object handle 0 to the map part of the triggered event and returns its position and facing angle.
function object.get_trigger_placement(x: f32, y: f32, z: f32, angle: f32)
	local map_part: s32 = 0
	map_part = event.get_triggered_event_data_2(9) or map_part
	event.attach_object_handle_to_map_part_2(0, map_part)
	do
		local out1, out2, out3 = event.get_object_handle_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	angle = vm.bits_float(event.get_triggered_event_data_2(11)) or angle
	return x, y, z, angle
end

--- Disables the rapis function point and hides the s1301_3-m0 map part.
function object.hide_rapis_point()
	event.set_function_point_enabled("", "rapis", 0)
	event.attach_object_handle_to_map_part_3(30, "p01_s1301-m-m", "s1301_3-m0")
	event.set_object_handle_visible(30, 0)
end

--- Hides and shows the parts of the train car map object to set its default look.
function object.reset_train_car_parts()
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_07-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_08-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_08-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_08-m2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m2")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m3")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m4")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m5")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_15-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_15-m1")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_06-m")
	event.set_object_handle_visible(0, 0)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_04-m")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_04-m1")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m3")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m4")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_05-m5")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_06-m1")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m6")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m7")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m8")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m9")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m10")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_14-m11")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_15-m2")
	event.set_object_handle_visible(0, 1)
	event.attach_object_handle_to_map_part_3(0, "p01_train01", "s3601_15-m3")
	event.set_object_handle_visible(0, 1)
end

--- Waits until an object sequence has run its commands.
function object.wait_until_done(sequence: s32)
	local running: s32 = 0
	while true do
		running = event.is_object_sequence_running(sequence) or running
		if running == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return object
