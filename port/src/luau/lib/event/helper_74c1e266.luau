--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_camera = require("@lib/event/wait_camera")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_74c1e266(se_id: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	event.mark_camera_sequence_fade_track()
	event.fade_in_camera_sequence(200, 0.0, 0.0, 0.0)
	event.set_camera_sequence_position(1010.98, 218.14, -55.12)
	event.set_camera_sequence_look_at(-755.14, 237.29, -2.56)
	event.set_object_sequence_position(0, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -943.03, 134.76, 0.63)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.move_camera_sequence(64.12, 205.59, -18.9, -755.14, 157.59, -2.56, 120)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 120)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 120)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.set_camera_sequence_position(-667.47, 186.39, -3.73)
	event.set_camera_sequence_look_at(-755.14, 160.61, -2.56)
	event.set_object_sequence_position(0, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -768.25, 133.66, -2.78)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "歩き（スティーブ）", 4)
	event.set_object_sequence_motion(1, "歩き（スティーブ）", 4)
	event.move_object_sequence(0, -739.93, 134.76, -3.16, 20)
	event.move_object_sequence(1, -739.93, 134.76, -3.16, 20)
	wait_objects(0)
	wait_objects(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "立ち（スティーブ）")
	wait_objects(0)
	wait_objects(1)
	wait_camera()
	helper_888ab2a3(30)
	event.set_camera_sequence_position(-302.7, 76.94, -10.38)
	event.set_camera_sequence_look_at(-787.0, 134.76, 18.98)
	event.set_character_active(1, 0)
	event.set_object_sequence_position(0, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4)
	event.set_character_active(1, 9)
	event.set_object_sequence_position(1, -802.5, 134.76, -2.32)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4)
	event.play_sound_effect(se_id, 2)
	event.set_object_sequence_motion(0, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(0, "立ち（スティーブ）")
	event.set_object_sequence_motion(1, "ジャンプ", 2, 0.4)
	event.queue_object_sequence_next_motion(1, "立ち（スティーブ）")
	event.delay_object_sequence_position_track(0, 3)
	event.delay_object_sequence_position_track(1, 3)
	event.jump_object_sequence(0, -378.73, 50.06, 32.39, -0.35, 31)
	event.jump_object_sequence(1, -378.73, 50.06, 32.39, -0.35, 31)
	var4 = 0
	helper_888ab2a3(2)
	while var4 < 31 do
		do
			local out1, out2, out3 = event.get_character_position(9)
			var1 = out1 or var1
			var2 = out2 or var2
			var3 = out3 or var3
		end
		event.set_camera_sequence_look_at(var1 - 14.5, var2 + 17.0, var3 + vm.f32(21.3))
		vm.wait(11)
		var4 = var4 + 1
	end
	do
		local out1, out2, out3 = event.get_character_position(9)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(var5, var6 + 5.0, var7)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-378.99, 55.0, 20.63)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	event.create_effect("砂煙e107")
	event.set_effect_first_vector(-379.65, 55.0, 46.12)
	event.set_effect_second_vector(1.2, 1.2, 1.2)
	helper_888ab2a3(22)
	event.play_sound_effect(se_id, 3)
	event.play_sound_effect(se_id, 1)
	event.set_camera_sequence_position(-261.64, 62.84, 2.96)
	event.set_camera_sequence_look_at(-368.77, 78.25, 5.08)
	event.set_object_sequence_position(0, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(0, 0.0, 1.6, 0.0)
	event.set_object_sequence_position(1, -377.87, 50.06, 4.42)
	event.set_object_sequence_rotation(1, 0.0, 1.6, 0.0)
	wait_objects(0)
	wait_objects(1)
	helper_888ab2a3(30)
end

return helper_74c1e266
