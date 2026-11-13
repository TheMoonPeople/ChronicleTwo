--!strict
--- Holds the Spanish shopkeeper greetings.

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
	event.open_message_window_2(0, "Bienvenido.")
	if npc_id == 18 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
		)
	end
	if npc_id == 4 then
		event.open_message_window_2(
			0,
			"Trabajando duro, [UNI00bf]no?\n[UNI00bf]Necesit[UNI00e1]is algo?<page>Pero por la cara, nada.\nNi siquiera para ti, Max."
		)
	end
	if npc_id == 34 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Necesitas m[UNI00e1]s elementos\nde Georama?<page>Si no tienes tiempo\npara conseguirlos t[UNI00fa] mismo, a lo mejor\npuedes solucionar tus problemas con un poco de dinero."
		)
	end
	if npc_id == 1012 then
		baker_apprentice_intro_flag = event.get_save_flag(45) or baker_apprentice_intro_flag
		if baker_apprentice_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"Hola. Soy un aprendiz de panadero.\nMe encargo de la panader[UNI00ed]a mientras\nPolly est[UNI00e1] fuera.<page>Estoy un poco nervioso, pero es\nparte de mi formaci[UNI00f3]n, supongo.\n[UNI00a1]Har[UNI00e9] lo que pueda!"
			)
			event.set_save_flag(45, 1)
		end
	end
	if npc_id == 1015 then
		weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
		if weapon_shop_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"No nos parecemos mucho...\nPero soy la hermana peque[UNI00f1]a de Milane.<page>Me pidi[UNI00f3] que cuidara de la tienda mientras ella no est[UNI00e1].\n[UNI00a1]Yo no s[UNI00e9] nada de armas!"
			)
			event.set_save_flag(46, 1)
		end
	end
	if npc_id == 1018 then
		church_stand_in_intro_flag = event.get_save_flag(47) or church_stand_in_intro_flag
		if church_stand_in_intro_flag == 0 then
			event.open_message_window_2(
				0,
				"[UNI00bf]Te he sorprendido, a que s[UNI00ed]? Cualquiera se sorprender[UNI00ed]a\nal ver a alguien\nvestido de esta manera aqu[UNI00ed].<page>Soy un buen amigo del Padre Bruno. Estoy\npara informar a la gente mientras [UNI00e9]l est[UNI00e1] de viaje.\nBueno, [UNI00bf]te puedo ayudar en algo?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"[UNI00bf]Quieres que te asista el\npoder de los dioses? Pues ten la amabilidad\nde hacer un donativo a la iglesia."
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
