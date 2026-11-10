--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local wait_frames = require("@lib/event/wait_frames")
local wait_objects = require("@lib/event/wait_objects")

--- Helper function.
local function helper_c14c6c96(arg0: s32, arg1: s32)
	local var2: any = 0
	local var3: s32 = 0
	local var7: s32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local pos_x_2: f32 = 0
	local pos_y_2: f32 = 0
	local pos_z_2: f32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	while true do
		event.open_message_window_2(0, "A long time ago I gave her a brooch\nwith her star sign on it.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Holly sorted it out for me so I don't\nreally remember,\nbut I'm sure it was a 4-legged animal..."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"What kind of birthday\npresents have I given her?<page>Hmm...lots of coats\nand scarves I suppose.<page>I never know what to get her.\nIt's a real struggle every year."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Oh yes! Claire's birthday is always a right pain!\nIt's on a day when both burnable and non-burnable\ngarbage get collected.<page>It's my job to put the\ngarbage out in our house."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Non-burnable garbage gets collected\non days divisible by 7,<page>and burnable garbage gets collected\non days divisible by 3."
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "You wouldn't forget that though,\nwould you?")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.open_message_window_2(
			0,
			"I get it! Mystery solved!\nThe combination is...<page>I don't know...Let's listen some more."
		)
		var2 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
		if var2 == 0 then
			break
		else
			if var2 == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(arg0, "会話")
		end
	end
	event.set_menu_value(0, "Enter the secret code number.", "1221", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		var3 = out1 or var3
	end
	if var3 == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait_frames(15)
	var7 = event.get_sound_id(2) or var7
	do
		local out1, out2, out3 = event.get_character_position(arg0)
		var8 = out1 or var8
		var9 = out2 or var9
		var10 = out3 or var10
	end
	do
		local out1, out2, out3 = event.get_character_rotation(arg0)
		var11 = out1 or var11
		var12 = out2 or var12
		var13 = out3 or var13
	end
	event.set_character_position(arg0, -100.0, 0.0, -110.0)
	event.set_character_rotation(arg0, 0.0, 3.1415927, 0.0)
	event.set_character_motion(arg0, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		var14 = out1 or var14
		var15 = out2 or var15
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		var17 = out1 or var17
		var18 = out2 or var18
		var19 = out3 or var19
	end
	var20 = event.get_arc_tangent(-100.0 - var14, -110.0 - var16) or var20
	event.set_character_rotation(0, 0.0, var20, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		pos_x_2 = out1 or pos_x_2
		pos_y_2 = out2 or pos_y_2
		pos_z_2 = out3 or pos_z_2
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait_frames(30)
	if var3 == 0 then
		event.set_character_motion(arg0, "会話")
		event.open_message_window_2(0, "Hmm, it won't open. Oh dear...<page>There are some really important\ndocuments in there...")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.fade_out_screen(15)
		wait_frames(15)
		event.set_character_rotation(0, var17, var18, var19)
		event.set_character_position(arg0, var8, var9, var10)
		event.set_character_rotation(arg0, var11, var12, var13)
		event.set_camera_position(pos_x, pos_y, pos_z)
		event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(0, "Er...Hmm...\n1,<page>2,<page>2,<page>1...")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.play_sound_effect(var7, 66)
	event.open_message_window_2(0, "Wa-hoo!<page>Great,\nit worked!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.attach_object_handle_to_character(0, arg0)
	event.clear_object_sequence(0, arg0)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, var14, var15, var16, 30)
	wait_objects(0)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(0, "Great! Now I can get my\nimportant documents out!<page>Oh, thank you!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	event.fade_out_screen(15)
	wait_frames(15)
	event.set_character_rotation(0, var17, var18, var19)
	event.set_character_position(arg0, var8, var9, var10)
	event.set_character_rotation(arg0, var11, var12, var13)
	event.set_camera_position(pos_x, pos_y, pos_z)
	event.set_camera_look_at(pos_x_2, pos_y_2, pos_z_2)
	event.fade_in_screen(15)
	wait_frames(15)
	event.set_character_motion(arg0, "会話")
	event.open_message_window_2(
		0,
		"What important documents?<page>Documents that will help Vice Mayor Morton\ndo my job while I'm away.<page>It's a bit of a worry,\nbut I'm sure it'll be okay."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Right, now I'm all set to leave town too.<page>Cedric told me everything.<page>Come on, let's go."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

return helper_c14c6c96
