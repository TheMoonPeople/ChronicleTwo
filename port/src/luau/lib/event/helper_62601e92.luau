--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_62601e92(se_id: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
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
	event.play_sound_effect(se_id, 1)
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
		vm.wait(2)
		var4 = var4 + 1
	end
	helper_888ab2a3(2)
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
	helper_888ab2a3(20)
	event.play_sound_effect(se_id, 2)
	event.play_sound_effect(se_id, 0)
	event.set_camera_sequence_position(-290.45, 68.57, 35.18)
	event.set_camera_sequence_look_at(-328.09, 70.17, 34.47)
	event.reset_object_sequence_dynamic_animation(0)
	wait_objects(0)
	wait_objects(1)
	event.set_object_sequence_motion(0, "立ち（スティーブ）", 4, -1.0)
	event.set_object_sequence_motion(1, "立ち（スティーブ）", 4, -1.0)
	helper_888ab2a3(30)
end

return helper_62601e92
