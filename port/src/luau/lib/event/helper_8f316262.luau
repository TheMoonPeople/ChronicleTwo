--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01c605c5 = require("@lib/event/helper_01c605c5")
local helper_07557f61 = require("@lib/event/helper_07557f61")
local helper_081a0c09 = require("@lib/event/helper_081a0c09")
local helper_08215022 = require("@lib/event/helper_08215022")
local helper_17b4bfd0 = require("@lib/event/helper_17b4bfd0")
local helper_186ac573 = require("@lib/event/helper_186ac573")
local helper_24e7ae04 = require("@lib/event/helper_24e7ae04")
local helper_25b52de7 = require("@lib/event/helper_25b52de7")
local helper_320250a8 = require("@lib/event/helper_320250a8")
local helper_3ac5d5b9 = require("@lib/event/helper_3ac5d5b9")
local helper_4371df7b = require("@lib/event/helper_4371df7b")
local helper_6780ab6d = require("@lib/event/helper_6780ab6d")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_75a1d435 = require("@lib/event/helper_75a1d435")
local helper_7e8e3888 = require("@lib/event/helper_7e8e3888")
local helper_82561000 = require("@lib/event/helper_82561000")
local helper_864f1f55 = require("@lib/event/helper_864f1f55")
local helper_9d930a76 = require("@lib/event/helper_9d930a76")
local helper_a047ab7c = require("@lib/event/helper_a047ab7c")
local helper_a8f37a11 = require("@lib/event/helper_a8f37a11")
local helper_ac02d4a5 = require("@lib/event/helper_ac02d4a5")
local helper_e697122e = require("@lib/event/helper_e697122e")
local helper_f0757175 = require("@lib/event/helper_f0757175")
local helper_f25981b6 = require("@lib/event/helper_f25981b6")
local helper_fcc0a77e = require("@lib/event/helper_fcc0a77e")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_8f316262(chara_no: s32, arg1: s32)
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
		helper_f25981b6(chara_no, arg1)
	end
	if var3 == 5 then
		helper_25b52de7(chara_no, arg1)
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
				if helper_864f1f55(0) ~= 0 then
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
				if helper_864f1f55(0) ~= 0 then
					event.fade_out_screen(25)
					wait_frames(30)
					event.open_event_menu(6, 33)
					vm.wait(11)
					event.fade_in_screen(30)
				end
				event.set_villager_ai_enabled(1, chara_no)
				return
			else
				helper_01c605c5(chara_no, arg1)
			end
		end
	end
	if var3 == 7 then
		helper_320250a8(chara_no, arg1)
	end
	if var3 == 8 then
		helper_75a1d435(chara_no, arg1)
	end
	if var3 == 10 then
		helper_186ac573(chara_no, arg1)
	end
	if var3 == 11 then
		helper_7e8e3888(chara_no, arg1)
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
				helper_081a0c09(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 28 then
			helper_9d930a76()
		else
			helper_081a0c09(chara_no, arg1)
		end
	end
	if var3 == 14 then
		helper_a8f37a11(chara_no, arg1)
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
				helper_fcc0a77e(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 30 then
			helper_9d930a76()
		else
			helper_fcc0a77e(chara_no, arg1)
		end
	end
	if var3 == 16 then
		helper_24e7ae04(chara_no, arg1)
	end
	if var3 == 17 then
		helper_08215022(chara_no, arg1)
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
				helper_a047ab7c(chara_no, arg1)
				event.set_villager_ai_enabled(1, chara_no)
				return
			end
		end
		if now_sub_map_no == 33 then
			helper_9d930a76()
		else
			helper_a047ab7c(chara_no, arg1)
		end
	end
	if var3 == 19 then
		helper_07557f61(chara_no, arg1)
	end
	if var3 == 20 then
		helper_3ac5d5b9(chara_no, arg1)
	end
	if var3 == 21 then
		helper_82561000(chara_no, arg1)
	end
	if var3 == 23 then
		helper_6780ab6d(chara_no, arg1)
	end
	if var3 == 24 then
		helper_4371df7b(chara_no, arg1)
	end
	if var3 == 25 then
		helper_e697122e(chara_no, arg1)
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

return helper_8f316262
