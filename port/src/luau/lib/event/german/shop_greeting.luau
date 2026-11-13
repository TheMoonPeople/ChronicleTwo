--!strict
--- Holds the German shopkeeper greetings.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local menu = vm.module("@lib/event/menu")

local shop_greeting = {}

--- Speaks the shopkeeper's greeting, introducing the stand-in clerks on first visit, then faces the player and opens the shop menu for that shopkeeper.
function shop_greeting.greet_and_open_shop()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	local baker_apprentice_intro_flag: s32 = 0
	local weapon_shop_intro_flag: s32 = 0
	local church_stand_in_intro_flag: s32 = 0
	print("IN go_shop_up()\n")
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	print("talk_chara=", npc_id, "talk_chara_id=", character_slot, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Willkommen.")
	if npc_id == 18 then
		event.open_message_window_2(
			0,
			"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
		)
	end
	if npc_id == 4 then
		event.open_message_window_2(
			0,
			"Schwer besch[UNI00e4]ftigt, was?\nBrauchst du was?<page>Aber gratis gibt's nichts.\nNicht mal f[UNI00fc]r dich, Max."
		)
	end
	if npc_id == 34 then
		event.open_message_window_2(
			0,
			"Du brauchst noch mehr Georama-\nTeile?<page>Falls du keine Zeit hast, sie\nselbst zu sammeln, kannst du vielleicht\nmit etwas Geld nachhelfen."
		)
	end
	if npc_id == 1012 then
		baker_apprentice_intro_flag = event.get_save_flag(45) or baker_apprentice_intro_flag
		if baker_apprentice_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Hallo, ich bin B[UNI00e4]cker-Lehrling.\nIch k[UNI00fc]mmere mich um die B[UNI00e4]ckerei,\nsolange Polly fort ist.<page>Ich bin etwas nerv[UNI00f6]s, aber es\ngeh[UNI00f6]rt wohl auch zur Ausbildung.\nIch tue mein Bestes!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_id == 1015 then
		weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
		if weapon_shop_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Wir sehen uns kaum [UNI00e4]hnlich ...\naber ich bin Milanes kleine\nSchwester.<page>Sie hat gesagt, ich soll auf den\nLaden aufpassen, w[UNI00e4]hrend sie\nweg ist.<page>Dabei hab ich gar\nkeine Ahnung von Waffen!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_id == 1018 then
		church_stand_in_intro_flag = event.get_save_flag(47) or church_stand_in_intro_flag
		if church_stand_in_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Hab ich dich [UNI00fc]berrascht, ja?\nEs ist ja auch [UNI00fc]berraschend, wenn hier\njemand in diesen Klamotten steht.<page>Ich bin mit Priester Bruno befreundet\nund vertrete ihn, solange er weg ist.\nKann ich dir denn helfen?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
			)
		end
	end
	if character_slot ~= -1 then
		cutscene.talk(character_slot, -1, 0, 0)
	end
	if npc_id == 18 then
		menu.open_type_6_alt(15)
	end
	if npc_id == 12 then
		menu.open_type_6_alt(1)
	end
	if npc_id == 4 then
		menu.open_type_6_alt(6)
	end
	if npc_id == 15 then
		menu.open_type_6_alt(0)
	end
	if npc_id == 33 then
		menu.open_type_6_alt(4)
	end
	if npc_id == 34 then
		menu.open_type_6_alt(31)
	end
	if npc_id == 1012 then
		menu.open_type_6_alt(35)
	end
	if npc_id == 1015 then
		menu.open_type_6_alt(36)
	end
	if npc_id == 1018 then
		menu.open_type_6_alt(37)
	end
end

return shop_greeting
