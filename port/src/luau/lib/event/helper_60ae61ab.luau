--!strict
-- Shared event helper used by 21 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47e5dca9 = require("@lib/event/helper_47e5dca9")
local helper_70e4ac93 = require("@lib/event/helper_70e4ac93")

--- Helper function.
local function helper_60ae61ab()
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
		helper_47e5dca9()
		event.set_villager_ai_enabled(1, var1)
		return
	end
	if var2 == 50 then
		event.open_message_window_2(0, "Hey! Ab hier\nist abgesperrt.")
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
					"Sieh dir das an. Kaum zu\nglauben, dass das Ding\nfr[UNI00fc]her richtig gerast ist, was?<page>Ist es aber ... vor langer Zeit.<page>Ich tr[UNI00e4]ume davon, mit dem\nDing noch mal loszufahren. Darum\nhalte ich es auch in Schuss.<page>Wenn es je dazu kommt, kann\nich ihn sofort wieder\nauf die Gleise bringen."
				)
			else
				event.open_message_window_2(
					0,
					"Du wei[UNI00df]t doch, dass man immer ver-\nsteift, wenn man zu selten trainiert.\nDas gilt f[UNI00fc]r Maschinen auch."
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
					"Hallo Max!\nDie Bahn f[UNI00e4]hrt schon seit\neiner Ewigkeit nicht mehr.<page>Aber ich k[UNI00fc]mmere mich\ntrotzdem immer um den Bahnhof."
				)
			else
				event.open_message_window_2(
					0,
					"Der B[UNI00fc]rgermeister l[UNI00e4]sst die Bahn\nendlich wieder fahren. Aber\nnicht f[UNI00fc]r alle.<page>Oh Mann, ich w[UNI00fc]rde die\nLeute so gern einsteigen lassen ..."
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
					"Hi, Max. Wusstest du, dass der\nBahnhofsvorsteher mein Vater ist?\nWir k[UNI00fc]mmern uns um den Bahnhof.<page>Bis die Bahn eines Tages\nwieder fahren darf ..."
				)
			else
				event.open_message_window_2(
					0,
					"Die Bahn f[UNI00e4]hrt!\nAber es wird etwas dauern, bis\nder Bahnhof wieder normal ist ..."
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
					"Ich verehre Monica seit langem\nheimlich, aber in letzter\nZeit war sie nicht hier.<page>Darum kann ich mich so schlecht\nauf die Arbeit konzentrieren."
				)
			else
				active_chr_no_2 = event.get_playable_character() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.open_message_window_2(0, "He, Max!\nMonica ist zur[UNI00fc]ck, ja?\nDa werden sich alle freuen!")
				else
					event.open_message_window_2(0, "Monica! Wie geht's dir?\nIch hab dich echt vermisst.")
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
					"Ich konnte gerade normal mit\nMonica reden, da ist sie\nverschwunden.<page>Komm schon,  Max,\nsag mir doch, wo sie ist!"
				)
			else
				active_chr_no_3 = event.get_playable_character() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.open_message_window_2(0, "Monica ist zur[UNI00fc]ck.\nWie kann das sein?")
				else
					event.open_message_window_2(0, "Monica, du bist zur[UNI00fc]ck!\nWie kann das sein?")
				end
			end
			helper_70e4ac93(var1, -1, 0, 0)
			event.set_villager_ai_enabled(1, var1)
			return
		end
	end
	event.open_message_window_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_70e4ac93(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

return helper_60ae61ab
