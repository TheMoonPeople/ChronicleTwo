--!strict
--- Spanish recruitment and request conversations of Palm Brinks NPCs.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local i04_girard_house = vm.module("@lib/event/i04_girard_house")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local villager_recruitment = vm.module("@lib/event/spanish/villager_recruitment")

local palm_brinks_quests = {}

--- Reads the stopwatch for the boat race and has the NPC join the party if the time is fast enough.
function palm_brinks_quests.check_boat_race_time(npc: s32, player: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local seconds_fraction: s32 = 0
	local is_fast_enough: s32 = 0
	local race_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		seconds_fraction = out3 or seconds_fraction
		is_fast_enough = out4 or is_fast_enough
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	race_state = event.get_save_counter(7) or race_state
	if race_state == 0 then
		event.open_message_window_2(0, "Hola, Max.\n[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(
			0,
			"Eh. No has ido hasta la barca,\n[UNI00bf]no? Quer[UNI00ed]as enga[UNI00f1]arme.\n[UNI00a1]No seas tramposo!"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "[UNI00a1]Eh, no hagas trampas!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "Has llegado.\nBien,<page>vamos a ver\ntu tiempo.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, seconds_fraction)
	if is_fast_enough == 0 then
		event.open_message_window_2(0, "[UNI00a1]Vaya por Dios!\n[数値２] minutos.[数値３] segundos.\nDemasiado lento.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc, player, 0)
		npc_dialogue.offer_boat_run(npc, player)
		return
	end
	event.open_message_window_2(0, "[UNI00a1]Oh!\n[数値１] minutos [数値２] segundos[数値３].\nNo est[UNI00e1] mal.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Eres m[UNI00e1]s r[UNI00e1]pido de lo que parece. Vale,\nvamos a pelear contra los malos juntos."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- Has the flower expert check the player has photographed any unusual flower and, if so, join the party.
function palm_brinks_quests.check_flower_photos(npc: s32, player: s32)
	local playable_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	photo_count_2009 = event.get_photo_count_of_subject(2009) or photo_count_2009
	photo_count_52 = event.get_photo_count_of_subject(52, 3) or photo_count_52
	photo_count_53 = event.get_photo_count_of_subject(53, 3) or photo_count_53
	photo_count_54 = event.get_photo_count_of_subject(54, 3) or photo_count_54
	photo_count_55 = event.get_photo_count_of_subject(55, 3) or photo_count_55
	if vm.i32(vm.i32(vm.i32(vm.i32(photo_count_2009 + photo_count_52) + photo_count_53) + photo_count_54) + photo_count_55) <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Tienes fotos de flores raras?<page>S[UNI00e9] mucho de flores, as[UNI00ed] que si\nno es algo especial, no me va a interesar."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00bf]Tienes fotos de flores raras?\n[UNI00a1]A ver, a ver!")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "[UNI00a1]Guau! [UNI00a1]Alucinante!\nAs[UNI00ed] que estas son las flores que se ven fuera.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Umm... [UNI00bf]Qu[UNI00e9] hago?<page>Bueno, venga. Me voy con vosotros.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Has the NPC pose the church-candle puzzle as the condition for joining the party and starts the candle request.
function palm_brinks_quests.explain_candle_puzzle(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]S[UNI00ed]? [UNI00bf]Necesitas mi ayuda?\nEntonces d[UNI00e9]jame que te plantee un problema."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Las velas de la iglesia\nest[UNI00e1]n controladas por un peque[UNI00f1]o mecanismo.<page>Cuando est[UNI00e1]n encendidas\nlas apaga y,\ncuando se apagan, las enciende.<page>Si una cambia,\nlas adyacentes a ella tambi[UNI00e9]n lo hacen."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Si apagas todas las velas,\nme demostrar[UNI00e1]s tu sabidur[UNI00ed]a y te acompa[UNI00f1]ar[UNI00e9].<page>Si resuelves el problema, estupendo.\nSi no, tendr[UNI00e1]s que entender que no puedo ayudarte."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Este es otro puzzle. Int[UNI00e9]ntalo\nun par de veces y f[UNI00ed]jate bien\nen lo que pasa."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Si vuelves a entrar en la iglesia,\n las velas volver[UNI00e1]n a su estado original.\n O sea que no hay de qu[UNI00e9] preocuparse.\n La soluci[UNI00f3]n podr[UNI00ed]a ser muy simple."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Has Mena describe her dizziness and, for Monica, explain time distortions, record the cleared-stage count and start the distortion request.
function palm_brinks_quests.explain_time_distortions(npc: s32, player: s32)
	local playable_character: s32 = 0
	local cleared_stage_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00da]ltimamente no me encuentro muy bien.<page>El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Con s[UNI00f3]lo ponerme de pie\nme da la impresi[UNI00f3]n de que me voy a caer.<page>No  es f[UNI00e1]cil de explicar. Es como si\nel mundo estuviera alterado."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"Um...\nSi el Dr. Dell no sabe cu[UNI00e1]l es el problema,\nyo no voy a poder ayudar mucho..."
		)
		message.say_bubble(0, -1, player, npc, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Recuerdo los s[UNI00ed]ntomas.")
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Cuando nac[UNI00ed],\nel mundo estaba en un estado lamentable:\nhab[UNI00ed]a m[UNI00e1]s distorsiones temporales de las\nque te puedas imaginar."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Adem[UNI00e1]s afectaban a personas\nfr[UNI00e1]giles f[UNI00ed]sicamente.<page>Los delgados se mareaban o se desmayaban\ny los m[UNI00e1]s rellenos no se pod[UNI00ed]an ni levantar."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"A lo mejor t[UNI00fa] eres especialmente\nsusceptible a estas cosas.<page>Incluso las pocas distorsiones temporales\nque hay aqu[UNI00ed] bastan para afectarte."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.open_message_window_2(
		0,
		"Si pudi[UNI00e9]ramos librarnos de las distorsiones\nm[UNI00e1]s pr[UNI00f3]ximas, seguro que te sentir[UNI00ed]as mejor."
	)
	message.say_bubble(0, -1, player, npc, 0)
	event.set_character_motion(player, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)][UNI00bf]C[UNI00f3]mo se arregla una distorsi[UNI00f3]n temporal? [UNI00a1]Esfeda!\n Si pasas m[UNI00e1]s de 10 niveles,\n quiz[UNI00e1] Mena mejore un poco."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	cleared_stage_count = event.get_menu_value_2(0) or cleared_stage_count
	event.set_save_counter(19, cleared_stage_count)
	event.set_quest_request(0, 17, 1)
end

--- Has a preoccupied NPC mutter guesses at a safe combination and shows a hint to come back later.
function palm_brinks_quests.mutter_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.wait_facing_character(npc)
	event.open_message_window_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.say_bubble(0, -1, npc, player, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has Gerald hand over a Trumpet Gun and challenge the player to build it up into a Bell Trigger.
function palm_brinks_quests.offer_bell_trigger_challenge(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Seg[UNI00fa]n Cedric,\nhas estado fuera\npor ciertos asuntos.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Eres bueno en muchas cosas,\npero luego\nnunca terminas nada.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Por eso cuando me pides\nayuda me resulta dif[UNI00ed]cil tomarte\nen serio a la primera.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ya. [UNI00bf]Por qu[UNI00e9] no mejoras esta Pistola Trompeta y la conviertes en Pistola Campana?<page>[UNI00bf]Ser[UNI00e1]s capaz?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(24)
	inventory.show_obtained_message_for_item_id(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Para conseguir que Gerald te acepte,\n tendr[UNI00e1]s que\nconseguirle una Pistola Trompeta.<page>[(!)]Puedes mejorar el arma\n que te han dado, comprar una\n o conseguir una en las Mazmorras."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Has the coin collector take the Dark Coin and Indestructible Coin from the player and join the party.
function palm_brinks_quests.recruit_coin_collector(npc: s32, player: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9]? Ah, un coleccionista de monedas.<page>Estoy buscando la Moneda negra\ny la Moneda indestructible.<page>No se ven en ninguna parte. Las he buscado\npor todos lados pero no hay quien las encuentre."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Eh? [UNI00bf]Las tienes? [UNI00a1]Incre[UNI00ed]ble!<page>[UNI00a1]No te quedes ah[UNI00ed]! [UNI00a1]Dame, dame, dame!"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Vale.\n[UNI00bf]Qu[UNI00e9] tengo que hacer?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "[UNI00a1]Agh! Si vas a cabrearme,\npaso de ayudarte.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"[UNI00a1]Guau! [UNI00a1]Ya las tengo todas!\nCre[UNI00ed]a que era imposible...<page>Bueno, ahora creo que no tengo alternativa.\nSer[UNI00e1] mejor que vaya contigo."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has Gordon ask Max for Holy Water to fix the tree and, once it is handed over, join the party.
function palm_brinks_quests.recruit_gordon(npc: s32, player: s32)
	local playable_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_recruitment.hint_talk_to_gordon(npc, player)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Max, mi prioridad ahora es\ncurar este [UNI00e1]rbol.<page>Lo que necesito\nes...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, as[UNI00ed] no hacemos nada.<page>Lo que necesito es\nAgua bendita del Padre Bruno.")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]S[UNI00ed]! [UNI00a1]Lo has conseguido, Max!\n[UNI00a1]Ya me ocupo yo del [UNI00e1]rbol!<page>Gracias, Max."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Ya est[UNI00e1] todo resuelto\n por el momento.<page>[UNI00a1]Ya te puedo acompa[UNI00f1]ar\nen tu aventura!<page>[UNI00a1]Ah! Ni se te ocurra hablarle a\ntu padre del Agua bendita, [UNI00bf]entendido?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon se ha unido al grupo.")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puedes emplear sus habilidades\n desde la opci[UNI00f3]n Estado del\napartado Personajes del men[UNI00fa] Principal.<page>[(!)]Si reclutas a m[UNI00e1]s personas\npara la aventura, se\nsubir[UNI00e1]n al tren."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Habla con ese pasajero\ndel tren para que se\nconvierta en el tercer miembro del grupo.<page>[(!)]Para que\nuno de tus amigos del tren entre en una casa, elige Mover persona\nen el men[UNI00fa] Puerta de la casa en cuesti[UNI00f3]n."
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puede que haya muchos m[UNI00e1]s\nque quieran unirse a tu grupo.\n[UNI00a1]B[UNI00fa]scalos!"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Has Milane check that the player owns item 67 or 69 and, if so, join the party.
function palm_brinks_quests.recruit_milane(npc: s32, player: s32)
	local sword_67_count: s32 = 0
	local sword_69_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	sword_67_count = event.get_item_count(67) or sword_67_count
	sword_69_count = event.get_item_count(69) or sword_69_count
	if sword_67_count <= 0 and sword_69_count <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] clase de espada es esa?\n[UNI00bf]Hablabas por hablar?<page>[UNI00a1]Fuera de aqu[UNI00ed]!\nMe est[UNI00e1]s estorbando."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Guau, vaya espada\nm[UNI00e1]s bonita.<page>Siento haber\ntenido que ponerte a prueba.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Es que si lucho contra\nun aficionado me pongo yo tambi[UNI00e9]n en peligro.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Aunque me parece que\ncontigo no hay de qu[UNI00e9] preocuparse.<page>Venga, vamos\na luchar.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

--- Has Polly ask about the bread delivery to Morton, then once the order is cancelled trade the 20 delivery loaves for 20 of item 299 and join the party.
function palm_brinks_quests.recruit_polly(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(
			0,
			"Lo siento, todav[UNI00ed]a\nno estoy lista.<page>[UNI00bf]Puedes darme un poco m[UNI00e1]s de tiempo?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(0, "Por cierto: [UNI00bf]has ido ya\na ver a Morton de mi parte?")
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9]? [UNI00bf]C[UNI00f3]mo puede ser tan\ndesconsiderado?<page>En fin,\npuedes qued[UNI00e1]rtelas."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "No importa.\nEn marcha.<page>[UNI00bf]A d[UNI00f3]nde\nvamos?")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Has Rufio check the player has photographed the moon and, if so, join the party.
function palm_brinks_quests.recruit_rufio_with_moon_photo(npc: s32, player: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Pens[UNI00e9] que t[UNI00fa] eras diferente,\npero no, los humanos son humanos.<page>Da igual, estoy acostumbrado\na o[UNI00ed]r mentiras vuestras."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Guau! Es alucinante. Hay una luna en la foto.<page>Ahora podr[UNI00e9] verla cuando sea y donde sea."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "[UNI00bf]Ir contigo?<page>Pues claro que s[UNI00ed].\nNo tengo otro sitio adonde ir.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

return palm_brinks_quests
