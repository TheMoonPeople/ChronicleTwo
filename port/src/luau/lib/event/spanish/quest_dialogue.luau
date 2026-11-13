--!strict
--- Holds the Spanish quest dialogue events for requests, recruits and request-progress routing.

local vm = require("@lib/vm")
local baker = vm.module("@lib/event/spanish/baker")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local npc_dialogue = vm.module("@lib/event/spanish/npc_dialogue")
local npc_recruit = vm.module("@lib/event/spanish/npc_recruit")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local villager_dialogue = vm.module("@lib/event/spanish/villager_dialogue")
local villager_recruitment = vm.module("@lib/event/spanish/villager_recruitment")

local quest_dialogue = {}

--- Plays the scene where the tailor hands over her first finished garment and joins the party.
function quest_dialogue.receive_tailor_garment(npc: s32, player: s32)
	local garment_item: s32 = 0
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Ah, Max! Ya he acabado una prenda.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"No quer[UNI00ed]a dejar\nque desecharan los materiales que me trajiste\ny gracias a eso llegu[UNI00e9] hasta el final."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "No me he quedado completamente satisfecha,\n[UNI00bf]pero te lo pondr[UNI00ed]as igualmente?")
	message.say_bubble(0, -1, npc, player, 0)
	garment_item = 259
	item_count = event.get_item_count(258) or item_count
	if item_count <= 0 then
		garment_item = 258
	else
		item_count = event.get_item_count(260) or item_count
		if item_count <= 0 then
			garment_item = 260
		end
	end
	event.add_inventory_item(garment_item)
	inventory.announce_received(garment_item, 1)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(
		0,
		"Ah, qu[UNI00e9] bien sienta\nterminar algo.<page>Ahora siento mucha\nm[UNI00e1]s confianza.<page>Har[UNI00e9] todo lo que pueda.\nLlevadme con vosotros."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Has the servant explain his need for money to bid on a rare book, then starts that request.
function quest_dialogue.request_book_funds(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"Si necesitas algo,\nhar[UNI00e9] lo que pueda para ayudarte.<page>T[UNI00fa] d[UNI00e9]jame a m[UNI00ed]."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "No s[UNI00e9] si podr[UNI00e1]s solucionar algo,<page>pero escucha.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Me he tirado 30 a[UNI00f1]os trabajando\ncomo un mulo en esta casa.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Es todo lo que hago, pero\nmi afici[UNI00f3]n es la lectura.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "En estos momentos est[UNI00e1]n subastando\nun libro muy valioso.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "La gente se pega por [UNI00e9]l.\nCreo que con una oferta\nde 1000 Gildas bastar[UNI00ed]a.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Yo no dispongo de ese dinero y, si se\nlo pidiera a mi maestro, se escandalizar[UNI00ed]a y\nseguramente me echar[UNI00ed]a."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Eres mi [UNI00fa]nica esperanza.<page>Pero no quiere decir\nque si no me ayudas yo no vaya a echarte una mano."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A pesar de lo que diga, Stewart seguramente\n no te ayudar[UNI00e1] si no le consigues 1000 Gildas.\n En fin, ser[UNI00e1] mejor que empieces a ahorrar."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Has Rufio ask for a photo of the moon before he trusts the player, then starts that request.
function quest_dialogue.request_moon_photo(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "Bah, no me importa acompa[UNI00f1]arte,\npero... [UNI00bf]Hay luna en el lugar al que vamos?")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "[UNI00bf]De verdad? A lo mejor te lo inventas.\nS[UNI00e9] que los humanos mienten.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"En realidad he cambiado de opini[UNI00f3]n.\nEsperar[UNI00e9] aqu[UNI00ed] a que salga la luna."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Quiz[UNI00e1] se deba a alg[UNI00fa]n suceso pasado,\npero Rufio no se f[UNI00ed]a\n nada de los humanos."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tienes que conseguir que Rufio\nte crea. Si le dieras una\nfoto de la luna quiz[UNI00e1] lo lograr[UNI00ed]as."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Has the mayor ask the player to work out his forgotten safe combination, then starts that request.
function quest_dialogue.request_safe_combination(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player, npc)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir con\neso de que qu[UNI00e9] estoy murmullando?<page>Estoy intentando\nrecordar la combinaci[UNI00f3]n de la caja fuerte."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] quieres decir?\n[UNI00bf]Qu[UNI00e9] caja?<page>La caja fuerte escondida\ndetr[UNI00e1]s del cuadro de mi despacho, claro..."
	)
	message.say_bubble(0, -1, npc, player, 0)
	character.face_toward(npc, player)
	event.set_character_motion(npc, "会話")
	event.open_message_window_2(
		0,
		"[UNI00a1]Ah, qu[UNI00e9] susto!<page>[UNI00a1]Porras!<page>Me he ido y he desvelado\nmi mayor secreto.<page>Bueno, ya lo sabes.<page>A lo mejor me puedes\nechar una mano."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Tengo muchos problemas\nporque he olvidado\nla combinaci[UNI00f3]n de la caja fuerte.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Es un n[UNI00fa]mero de\n4 d[UNI00ed]gitos. Us[UNI00e9]\nla fecha de nacimiento de Claire\npara no olvidarme nunca."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo lo habr[UNI00e9] olvidado?<page>Vaya padre soy...")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]El alcalde parece muy preocupado.\n Escucha lo que te dice sobre\nel cumplea[UNI00f1]os de Claire y trata de descifrar la combinaci[UNI00f3]n."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Hands Monica a Gladius and asks her to build it up two levels, then starts that request.
function quest_dialogue.request_sword_upgrade(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(0, "T[UNI00fa] eres M[UNI00f3]nica,\n[UNI00bf]no?<page>Me han dicho que no\nmanejas mal la espada.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Pero las espadas no\nson ning[UNI00fa]n juguete.<page>Tienes que darte cuenta de lo que tienes enfrente."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Si puedes mejorar dos niveles una espada,\nadmitir[UNI00e9] que tienes aptitudes.")
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "Empieza con este\nGladius.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Si quieres que Milane te acepte, deber[UNI00e1]s\nmejorar el Gladius\ndos niveles.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Tambi[UNI00e9]n se pueden comprar o recoger armas.\n Consigue un arma fuerte y\n Milane te ayudar[UNI00e1]."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Has the would-be tailor ask the player to fetch cloth, hide and copper, then starts that request.
function quest_dialogue.request_tailor_materials(npc: s32, player: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	event.open_message_window_2(
		0,
		"S[UNI00ed], si lo intento otra vez\ny logro terminar algo,\nquiz[UNI00e1] vuelva a creer en m[UNI00ed] misma."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Pero no tengo los materiales que necesito.<page>[UNI00bf]Podr[UNI00ed]as consegu[UNI00ed]rmelos?"
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(0, "S[UNI00f3]lo necesito tela resistente,\nun trozo de cuero gordo y un cacho de cobre.")
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	event.finish_event()
	event.set_save_counter(8, 1)
end

--- Routes the angler conversation by request progress.
function quest_dialogue.talk_angler(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_fishing_hobby(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_catch_big_nonky(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_nonky_catch(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_angler_done(npc, player)
		return
	end
end

--- Routes the baker conversation by playable character and request progress.
function quest_dialogue.talk_baker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		baker.chat_about_max(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		villager_dialogue.talk_about_business_trust(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 8) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_baker_request(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_baker_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_baker_done(npc, player)
		return
	end
end

--- Plays the bread-delivery recipient dialogue for the current delivery stage.
function quest_dialogue.talk_bread_delivery_recipient(npc: s32, player: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage == 0 then
		event.open_message_window_2(0, "Ah, [UNI00bf]est[UNI00e1]s ayudando\na Polly?<page>Muy bien.")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"[UNI00bf]Para qu[UNI00e9] se\nnecesitan 20 barras?<page>Pues para hacer\nuna fondue de queso hoy mismo."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			'Hablando en t[UNI00e9]rminos de tus famosas "invenciones",\nes una combinaci[UNI00f3]n culinaria de queso,<page>pan y vino.'
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"Est[UNI00e1] de muerte. Todo el mundo repite,\npor eso me hace falta tanto pan.<page>Pero no quer[UNI00ed]a que me\nlo trajeran aqu[UNI00ed], en realidad."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"[UNI00bf]No podr[UNI00ed]as llev[UNI00e1]rmelo\na casa, no Max?<page>Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas."
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_stage == 1 then
		event.open_message_window_2(0, "Ya sabes donde est[UNI00e1], [UNI00bf]no?\nCerca del campo de calabazas.")
		message.say_bubble(0, -1, npc, player, 0)
	end
	if delivery_stage == 2 then
		event.open_message_window_2(0, "[UNI00bf]Cancelado?\n[UNI00a1]Qu[UNI00e9] pena!")
		message.say_bubble(0, -1, npc, player, 0)
		event.open_message_window_2(
			0,
			"En tal caso, no necesito el pan.\n[UNI00bf]Puedes devolv[UNI00e9]rselo a Polly por m[UNI00ed]?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_stage == 3 then
		event.open_message_window_2(0, "Lo siento. [UNI00bf]Podr[UNI00ed]as devolverle el pan\na Polly por m[UNI00ed]?")
		message.say_bubble(0, -1, npc, player, 0)
	end
	event.set_character_motion(npc, "立ち")
	event.finish_event()
end

--- Picks the resident's conversation from the progress of the girl's hide-and-seek request, speaking an idle line before the requests open.
function quest_dialogue.talk_by_request_status(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.ask_to_join_party(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status == 0 then
		npc_recruit.challenge_hide_and_seek(npc_character, player_character)
		return
	end
	if request_status == 1 then
		villager_recruitment.finish_hide_and_seek(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_hide_and_seek(npc_character, player_character)
		return
	end
end

--- Routes the candy maker conversation by playable character and request progress.
function quest_dialogue.talk_candy_maker(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_aspiring_chef(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		palm_brinks_villagers.talk_cooking_experiments(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 3) or quest_status
	if quest_status == 0 then
		palm_brinks_villagers.request_chestnuts(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_chestnut(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_aspiring_chef(npc, player)
		return
	end
end

--- Routes the gun fighter conversation by playable character and request progress.
function quest_dialogue.talk_gun_fighter(npc: s32, player: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		villager_dialogue.talk_villager_16_as_monica(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_about_mining(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		npc_dialogue.start_gerald_request(npc, player)
		return
	end
	if quest_status == 1 then
		quest_dialogue.test_gun_for_recruit(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_weapon_caution(npc, player)
		return
	end
end

--- Routes the painter conversation by request progress.
function quest_dialogue.talk_painter(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.talk_to_parn(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_golden_paint(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_parn_request(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_painting(npc, player)
		return
	end
end

--- Routes the Rufio conversation by request progress.
function quest_dialogue.talk_rufio(npc: s32, player: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_moon_longing(npc, player)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		quest_dialogue.request_moon_photo(npc, player)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_moon_photo(npc, player)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_moon_photo_thanks(npc, player)
		return
	end
end

--- Checks that the player owns the required gun and, if so, recruits the gun fighter and completes the request.
function quest_dialogue.test_gun_for_recruit(npc: s32, player: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9] pasa?\n[UNI00bf]Te rindes otra vez?<page>Me decepcionas.\n[UNI00bf]Es eso todo lo que sabes\nhacer despu[UNI00e9]s de pasarte toda la vida entre m[UNI00e1]quinas?"
		)
		message.say_bubble(0, -1, npc, player, 0)
		event.set_character_motion(npc, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Vaya! Parece que te\nhas acostumbrado a manejar armas.<page>No me hace falta ni verte disparar.\nBasta con ver c[UNI00f3]mo la coges."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.open_message_window_2(
		0,
		"Vale, te ayudar[UNI00e9].\nPero no lo hago por ti.<page>No me puedo\nquedar aqu[UNI00ed] parado si\nla ciudad est[UNI00e1] en peligro."
	)
	message.say_bubble(0, -1, npc, player, 0)
	event.set_character_motion(npc, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Checks that the player owns one of the required swords and, if so, recruits the swordsman and completes the request.
function quest_dialogue.test_sword_for_recruit(npc: s32, player: s32)
	local first_item_count: s32 = 0
	local second_item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc, 0, 0)
	first_item_count = event.get_item_count(67) or first_item_count
	second_item_count = event.get_item_count(69) or second_item_count
	if first_item_count <= 0 and second_item_count <= 0 then
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
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

return quest_dialogue
