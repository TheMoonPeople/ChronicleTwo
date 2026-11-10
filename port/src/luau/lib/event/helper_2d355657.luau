--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")
local helper_9d930a76 = require("@lib/event/helper_9d930a76")

--- Helper function.
local function helper_2d355657()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	event.get_player_character_slot()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.get_playable_character() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_9d930a76()
		event.set_villager_ai_enabled(1, var1)
		return
	end
	if var2 == 50 then
		event.open_message_window_2(0, "Hey! No admittance\nbeyond this point.")
		helper_70e4ac93(var1, -1, 0, 0)
		event.set_villager_ai_enabled(1, var1)
		return
	end
	var7 = event.get_chapter() or var7
	if var7 == 1 then
		flag = event.get_save_flag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"Take a look at that. Hard to\nbelieve this thing used to zoom\nalong, eh?<page>It really did...a long time ago.<page>It's my dream to set off on another\njourney in this thing. That's why I\nmake sure to keep 'er in top shape.<page>That way, if I ever get"
				)
			else
				event.open_message_window_2(
					0,
					"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
				)
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"Hey there, Max!\nIt's been ages since the\nrailroad stopped running.<page>But I'm still here patrolling\nthe station, every day."
				)
			else
				event.open_message_window_2(
					0,
					"The Mayor finally got off his duff\nand got the trains going again. But\nthey're still not ready for the public.<page>Boy, I really want to let the\ntownspeople on board..."
				)
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.open_message_window_2(
					0,
					"Hi, Max. Did you know that the\nStationmaster is my dad? We watch\nover this station together.<page>Until the day the railway is back\nup and running..."
				)
			else
				event.open_message_window_2(
					0,
					"The train's running!\nBut it'll take a while before\nthe station's back to normal..."
				)
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.get_save_flag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"I've been a secret admirer\nof Monica for ages, but I\nain't seen her around lately.<page>That's why I can't seem\nto concentrate on work."
				)
			else
				active_chr_no_2 = event.get_playable_character() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.open_message_window_2(0, "Hey, Max!\nSeems Monica's back.\nEveryone'll be really pleased!")
				else
					event.open_message_window_2(0, "Monica! How've you been?\nI really missed you.")
				end
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"I'd just got to the point where\nI could talk to Monica normally,\nand then she disappeared.<page>Come on Max,\ntell me where she is, will ya?"
				)
			else
				active_chr_no_3 = event.get_playable_character() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.open_message_window_2(0, "Monica's back.\nHow on earth??")
				else
					event.open_message_window_2(0, "Monica, you're back!\nHow on earth??")
				end
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
	end
	event.open_message_window_2(0, "Hello there.\nGreat weather, isn't it.")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_70e4ac93(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

return helper_2d355657
