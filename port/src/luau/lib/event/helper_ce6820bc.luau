--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_ce6820bc(se_id: s32)
	local projection: f32 = 0
	local var2: f32 = 0
	local projection_2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	event.set_camera_sequence_position(-118.58, 15.3, -131.62)
	event.set_camera_sequence_look_at(-119.04, 14.32, -218.31)
	projection = event.get_event_projection() or projection
	event.set_event_projection(417.9)
	event.set_object_sequence_position(0, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(0, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_position(1, -119.53, -12.53, -229.18)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(0, "歩き（スティーブ）")
	event.set_object_sequence_motion(1, "歩き（スティーブ）")
	event.rotate_object_sequence(0, 0.0, 3.14, 0.0, 50)
	event.rotate_object_sequence(1, 0.0, 3.14, 0.0, 50)
	wait_objects(0)
	wait_objects(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	wait_objects(0)
	wait_objects(1)
	event.play_sound_effect(se_id, 0)
	event.rotate_object_sequence(12, 0.0, -1.57, 0.0, 50)
	event.rotate_object_sequence(13, 0.0, 1.57, 0.0, 50)
	wait_objects(12)
	wait_objects(13)
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(100)
	event.fade_out_camera_sequence(50, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 0)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 0)
	event.move_object_sequence(0, -119.23, -12.53, -333.8, 150)
	event.move_object_sequence(1, -119.23, -12.53, -333.8, 150)
	event.move_camera_sequence(-118.7, 15.3, -153.91, -119.04, 14.32, -218.31, 150)
	var4 = 150.0
	var5 = 1.0
	var2 = vm.f32(vm.fdiv(vm.f32(107.00003), var4))
	while true do
		projection_2 = vm.f32(var2 * var5)
		projection_2 = vm.f32(vm.f32(417.9) + projection_2)
		event.set_event_projection(projection_2)
		vm.wait(7)
		var5 = vm.f32(var5 + 1.0)
		if var5 > var4 then
			break
		end
	end
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	event.set_event_projection(projection)
end

return helper_ce6820bc
