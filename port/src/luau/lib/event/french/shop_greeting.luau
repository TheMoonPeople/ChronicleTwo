--!strict
--- Holds the French shopkeeper greetings.

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
	event.open_message_window_2(0, "Bienvenue.")
	if npc_id == 18 then
		event.open_message_window_2(
			0,
			"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
		)
	end
	if npc_id == 4 then
		event.open_message_window_2(
			0,
			"[UNI00c7]a travaille dur, je vois ?\nIl te faut quelque chose ?<page>Ah mais, rien n'est gratuit.\nPas m[UNI00ea]me pour toi, Max."
		)
	end
	if npc_id == 34 then
		event.open_message_window_2(
			0,
			"Il te faut plus d'[UNI00e9]l[UNI00e9]ments de\nG[UNI00e9]orama ?<page>Si tu n'as pas le temps d'aller en\nchercher toi-m[UNI00ea]me, peut-[UNI00ea]tre que\nl'argent r[UNI00e9]soudra tes probl[UNI00e8]mes."
		)
	end
	if npc_id == 1012 then
		baker_apprentice_intro_flag = event.get_save_flag(45) or baker_apprentice_intro_flag
		if baker_apprentice_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Bonjour, je suis apprentie boulang[UNI00e8]re\net je m'occupe de la boulangerie\npendant l'absence de Polly.<page>Je suis un peu nerveuse, mais [UNI00e7]a\npassera avec l'exp[UNI00e9]rience, je\nsuppose. Je ferai de mon mieux !"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_id == 1015 then
		weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
		if weapon_shop_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"On se ressemble peu mais...\nJe suis la petite s[UNI0153]ur de Milane.<page>Je tiens le magasin pendant son absence.\nEt je suis archi-nulle en armes !"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_id == 1018 then
		church_stand_in_intro_flag = event.get_save_flag(47) or church_stand_in_intro_flag
		if church_stand_in_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Tu ne t'y attendais pas ? N'importe\nqui serait surpris de voir ici un\nindividu habill[UNI00e9] de cette mani[UNI00e8]re.<page>Je suis bon ami avec le P[UNI00e8]re Bruno.\nJe le remplace pendant son voyage.\nAlors, que puis-je faire pour toi ?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
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
