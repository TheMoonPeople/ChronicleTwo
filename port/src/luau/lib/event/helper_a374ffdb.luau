--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_a374ffdb(se_id: s32)
	local projection: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local projection_2: f32 = 0
	event.set_camera_sequence_position(-120.59, 12.3, -121.56)
	event.set_camera_sequence_look_at(-121.3, 14.64, -178.67)
	event.get_event_projection(projection)
	event.set_event_projection(478.9)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(0, 0.0, 1.49, 0.0)
	event.set_character_active(1, 34)
	event.set_object_sequence_position(2, -92.88, -13.05, -212.34)
	event.set_object_sequence_rotation(2, 0.0, -1.44, 0.0)
	event.set_character_active(1, 35)
	event.set_object_sequence_position(3, -128.93, -12.49, -206.0)
	event.set_object_sequence_rotation(3, 0.0, 1.49, 0.0)
	event.set_object_handle_visible(11, 0)
	vm.wait(1)
	event.set_object_sequence_motion(2, "歩き", 4)
	event.rotate_object_sequence(2, 0.0, -2.88, 0.0, 15)
	event.delay_object_sequence_motion_track(2, 15)
	event.set_object_sequence_motion(2, "上見立ち", 0)
	event.play_sound_effect(se_id, 4)
	event.reset_object_sequence_motion(0)
	event.reset_object_sequence_motion(3)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.rotate_object_sequence(0, 0.0, -3.11, 0.0, 30)
	event.rotate_object_sequence(3, 0.0, -3.11, 0.0, 30)
	wait_frames(30)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 0)
	event.set_object_sequence_motion(3, "立ち（スティーブ）", 0)
	event.play_sound_effect(se_id, 5)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	wait_frames(50)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4, -1.0, 1)
	event.set_object_sequence_motion(3, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -125.29, -12.78, -310.13, 120)
	event.move_object_sequence(3, -125.29, -12.78, -310.13, 120)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(70)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	var5 = 1.0
	var2 = vm.f32(132.00003)
	var3 = 120.0
	var4 = vm.f32(vm.fdiv(var2, var3))
	while true do
		projection_2 = vm.f32(vm.f32(478.9) + vm.f32(var4 * var5))
		event.set_event_projection(projection_2)
		vm.wait(4)
		var5 = vm.f32(var5 + 1.0)
		if var5 > var3 then
			break
		end
	end
	event.set_event_projection(projection)
end

return helper_a374ffdb
