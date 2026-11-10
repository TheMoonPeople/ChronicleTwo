--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03be2878 = require("@lib/event/helper_03be2878")
local helper_1575b2d1 = require("@lib/event/helper_1575b2d1")
local helper_17b4bfd0 = require("@lib/event/helper_17b4bfd0")
local helper_3cd4938c = require("@lib/event/helper_3cd4938c")
local helper_40ec7a31 = require("@lib/event/helper_40ec7a31")
local helper_46310e80 = require("@lib/event/helper_46310e80")
local helper_5404e510 = require("@lib/event/helper_5404e510")
local helper_58844b1e = require("@lib/event/helper_58844b1e")
local helper_60734d93 = require("@lib/event/helper_60734d93")
local helper_6ae6eb2a = require("@lib/event/helper_6ae6eb2a")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_7bd8f811 = require("@lib/event/helper_7bd8f811")
local helper_8940e3ff = require("@lib/event/helper_8940e3ff")
local helper_8a34efb6 = require("@lib/event/helper_8a34efb6")
local helper_8cecd5b9 = require("@lib/event/helper_8cecd5b9")
local helper_9d930a76 = require("@lib/event/helper_9d930a76")
local helper_9f93c6f6 = require("@lib/event/helper_9f93c6f6")
local helper_a207c365 = require("@lib/event/helper_a207c365")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_ae2d88fa = require("@lib/event/helper_ae2d88fa")
local helper_db6ea4f8 = require("@lib/event/helper_db6ea4f8")
local helper_e683e02c = require("@lib/event/helper_e683e02c")
local helper_e929b0be = require("@lib/event/helper_e929b0be")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f5c274e4 = require("@lib/event/helper_f5c274e4")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_655d8f32(chara_no: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local now_sub_map_no: s32 = 0
	local flag: s32 = 0
	local var7: any = 0
	local var8: any = 0
	local var9: s32 = 0
	local var10: s32 = 0
	local var11: any = 0
	local var12: s32 = 0
	local var13: s32 = 0
	local var14: any = 0
	local var15: s32 = 0
	local var16: s32 = 0
	local var17: any = 0
	local var18: s32 = 0
	local active_chr_no: s32 = 0
	local var20: any = 0
	event.apply_message_window_preset(0, 0)
	event.set_message_bubble_tail(0, 1)
	var2 = event.get_chapter() or var2
	var3 = event.get_triggered_event_data_2(14) or var3
	event.get_current_map()
	now_sub_map_no = event.get_current_submap() or now_sub_map_no
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, chara_no)
	if var3 == 3 then
		helper_f5c274e4(chara_no, arg1)
	end
	if var3 == 5 then
		helper_e683e02c(chara_no, arg1)
	end
	if var3 == 4 then
		flag = event.get_save_flag(104) or flag
		if flag == 0 then
			event.open_message_window_2(0, "Let me shop\nDig for a scoop")
			var7 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var7 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var7 == 1 then
				if helper_ae2d88fa(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(6)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_9d930a76()
			end
		else
			event.open_message_window_2(0, "Be my friend!\nDig for a scoop")
			var8 = helper_f0757175(chara_no, -1, 2, 0, 0, 0)
			if var8 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var8 == 1 then
				if helper_ae2d88fa(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_1575b2d1(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_9f93c6f6(chara_no, arg1)
	end
	if var3 == 8 then
		helper_6ae6eb2a(chara_no, arg1)
	end
	if var3 == 10 then
		helper_e929b0be(chara_no, arg1)
	end
	if var3 == 11 then
		helper_3cd4938c(chara_no, arg1)
	end
	if var3 == 12 then
		var9 = event.get_quest_request_status(0, 0) or var9
		var10 = event.get_quest_request_status(0, 8) or var10
		if var9 == 2 and var10 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			var11 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var11 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var11 == 1 then
				helper_46310e80(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_9d930a76()
		else
			helper_46310e80(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_40ec7a31(chara_no, arg1)
	end
	if var3 == 15 then
		var12 = event.get_quest_request_status(0, 0) or var12
		var13 = event.get_quest_request_status(0, 10) or var13
		if var12 == 2 and var13 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			var14 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var14 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var14 == 1 then
				helper_60734d93(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_9d930a76()
		else
			helper_60734d93(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_8a34efb6(chara_no, arg1)
	end
	if var3 == 17 then
		helper_58844b1e(chara_no, arg1)
	end
	if var3 == 18 then
		var15 = event.get_quest_request_status(0, 0) or var15
		var16 = event.get_quest_request_status(0, 13) or var16
		if var15 == 2 and var16 ~= 2 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Hello\nBe my friend!")
			var17 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var17 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var17 == 1 then
				helper_db6ea4f8(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_9d930a76()
		else
			helper_db6ea4f8(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_03be2878(chara_no, arg1)
	end
	if var3 == 20 then
		helper_a207c365(chara_no, arg1)
	end
	if var3 == 21 then
		helper_8940e3ff(chara_no, arg1)
	end
	if var3 == 23 then
		helper_8cecd5b9(chara_no, arg1)
	end
	if var3 == 24 then
		helper_7bd8f811(chara_no, arg1)
	end
	if var3 == 25 then
		helper_5404e510(chara_no, arg1)
	end
	if var3 == 33 then
		var18 = event.get_quest_request_status(0, 8) or var18
		active_chr_no = event.get_playable_character() or active_chr_no
		if var18 == 1 and active_chr_no == 0 then
			event.set_character_motion(arg1, "立ち")
			event.open_message_window_2(0, "Let me shop\nHello")
			var20 = helper_ac02d4a5(0, -1, 5, 256, 208, 2, 1)
			if var20 < 0 then
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
			if var20 == 1 then
				helper_17b4bfd0(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		helper_9d930a76()
	end
	if var3 == 1 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Lately I've been having a hard time\nseeing all the tiny little parts.<page>Guess I'm gettin' a bit\nlong in the tooth..."
			)
		else
			event.open_message_window_2(
				0,
				"Seeing the Blackstone Railroad\noperate all over the continent is a\ndream both Need and I share.<page>We can count on you to help, right?"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 2 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(0, "If I don't have my hands in\nsomething at all times,\nI get real cranky.")
		else
			event.open_message_window_2(
				0,
				"If they discover Zelmite I'll\nbe real busy too. That's right.\nI'd dig, dig and dig some more!!"
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 6 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"You know, I have a lot of bugs\nin my feathers these days,\nand they make me itch terribly."
			)
		else
			event.open_message_window_2(
				0,
				"It's fine if you spend your time\nhunting for Zelmite. Just don't\npush yourself too hard, kid."
			)
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 13 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"I love the smell of gunpowder!\nThis job is really made for me.<page>Then again, my boss is awfully\nstubborn and old-fashioned.\nOh, well."
			)
		else
			event.open_message_window_2(0, "You really like all this\nadventure, don't ya.")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	if var3 == 22 then
		event.apply_message_window_preset(0, 0)
		if var2 ~= 8 then
			event.open_message_window_2(
				0,
				"Apart from the fact that I started\nlife as a picture, I'm no different\nthan any other person."
			)
		else
			event.open_message_window_2(0, "I've got a bad feeling about Zelmite Mine.\nJust be careful, okay?")
		end
		helper_70e4ac93(chara_no, -1, 0, 0)
	end
	event.set_villager_ai_enabled(1, chara_no)
end

return helper_655d8f32
