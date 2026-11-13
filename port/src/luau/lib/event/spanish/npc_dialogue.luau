--!strict
--- Holds the Spanish dialogue and events of the town residents who can join the party.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local npc_chatter = vm.module("@lib/event/spanish/npc_chatter")
local object = vm.module("@lib/event/object")
local palm_brinks_villagers = vm.module("@lib/event/spanish/palm_brinks_villagers")
local party = vm.module("@lib/event/party")
local quest_dialogue = vm.module("@lib/event/spanish/quest_dialogue")
local villager_dialogue = vm.module("@lib/event/spanish/villager_dialogue")
local wait = vm.module("@lib/event/wait")

local npc_dialogue = {}

--- Has the villager greet Max or Monica by name and ask to be taken along on trips outside town.
function npc_dialogue.ask_to_join_party(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "[UNI00a1]Max! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	else
		event.open_message_window_2(0, "[UNI00a1]M[UNI00f3]nica! Me han dicho que\nhas estado fuera de la ciudad hace poco.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00a1]Qu[UNI00e9] bien! [UNI00bf]Por qu[UNI00e9] no\nme llevas contigo?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays chatter asking how the clothes fit and promising a prayer, depending on the chapter.
function npc_dialogue.chat_about_clothes(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] tal te queda?<page>[UNI00a1]No me mientas!")
	else
		event.open_message_window_2(0, "Rezar[UNI00e9] por ti...")
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays chatter urging Max to learn some mining.
function npc_dialogue.chat_about_mining(npc_slot: s32, player_slot: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Se te dan bien las m[UNI00e1]quinas,\n[UNI00bf]pero no crees que va siendo hora\nde que aprendas algo de miner[UNI00ed]a?"
	)
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the painter's chatter about his new power and the art of painting, depending on the chapter.
function npc_dialogue.chat_about_painting(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Usa mi nuevo poder\ncuando quieras.")
	else
		event.open_message_window_2(
			0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Plays the prayer for world peace in chapter 8 and otherwise the remark that a good cause needs wisdom.
function npc_dialogue.chat_about_world_peace(npc_slot: s32, player_slot: s32)
	npc_dialogue.chat_prayer_for_peace(npc_slot, player_slot, 1)
end

--- Plays amazed praise for Max outside chapter 8 (deferring to a separate remark when Monica leads) and asks how the Zelmite hunt is going in chapter 8.
function npc_dialogue.chat_about_zelmite_hunt(npc_slot: s32, player_slot: s32)
	local chapter: s32 = 0
	local active_character: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		active_character = event.get_playable_character() or active_character
		if active_character == 1 then
			palm_brinks_villagers.talk_about_max_absence(npc_slot, player_slot)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(
			0,
			"No me lo puedo creer. Nunca pens[UNI00e9] que\nfueras a conseguirlas.<page>[UNI00a1]Vaya pedazo de haza[UNI00f1]a, Max!"
		)
	else
		event.open_message_window_2(
			0,
			"[UNI00a1]Eh! [UNI00bf]C[UNI00f3]mo va la b[UNI00fa]squeda de Zelmite?\nSi puedo ayudar,\ndame una voz."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Has the villager talk about becoming the world's best chef, with a different line once the story reaches the final chapter.
function npc_dialogue.chat_aspiring_chef(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Claro, nunca te dir[UNI00ed]a\nque no.")
	else
		event.open_message_window_2(
			0,
			"Alg[UNI00fa]n d[UNI00ed]a ser[UNI00e9] el mejor chef\ndel mundo y entonces\npodr[UNI00e1]s comer gratis cuando quieras."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the shopkeeper describe a shop that specialises in blades and carries few guns.
function npc_dialogue.chat_blade_shop(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Mi tienda est[UNI00e1]\nespecializada en espadas.<page>Tengo pistolas,\npero las armas de fuego\nno son lo m[UNI00ed]o."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager promise help in return while asking not to be taken to places with insects, with a railroad remark in the final chapter.
function npc_dialogue.chat_bug_averse(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"T[UNI00fa] me has ayudado, as[UNI00ed] que te debo una,\npero no me lleves a ning[UNI00fa]n sitio donde haya insectos."
		)
	else
		event.open_message_window_2(
			0,
			"Si el Ferrocarril Blackstone se extiende\npor todo el mundo, quiz[UNI00e1]\nyo deba recorrer todo el mundo tambi[UNI00e9]n."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager say they are busy gathering materials for the town's safety and ask the player to wait until tomorrow.
function npc_dialogue.chat_busy_with_materials(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Max.\nLo siento, pero estoy\nalgo ocupado ahora mismo.<page>Estoy a punto\nde conseguir materiales importantes\npara la seguridad de la ciudad."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Si no es nada urgente,\n[UNI00bf]podr[UNI00ed]a esperar hasta ma[UNI00f1]ana?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager say hide-and-seek is for children and ask to hear about the player's adventures.
function npc_dialogue.chat_hide_and_seek(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "El escondite es\npara ni[UNI00f1]os.")
	else
		event.open_message_window_2(
			0,
			"A m[UNI00ed] no me enga[UNI00f1]as. T[UNI00fa] has\nestado por ah[UNI00ed] pas[UNI00e1]ndotelo\nbomba. [UNI00a1]Tienes que contarme tus andanzas alg[UNI00fa]n d[UNI00ed]a!"
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager wonder why the moon is so missed and if the villager came from there.
function npc_dialogue.chat_moon_longing(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] echo tanto de menos la luna?<page>A lo mejor yo he venido\nde all[UNI00ed]..."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager thank the player for the moon photo and look forward to the railroad in the final chapter.
function npc_dialogue.chat_moon_photo_thanks(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Me has dado esta foto de la luna.\nEres un humano bueno.")
	else
		event.open_message_window_2(
			0,
			"Si el Ferrocarril Blackstone recorre\ntodo el mundo, podremos visitar\nun mont[UNI00f3]n de sitios nuevos."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager mutter number sequences while ignoring the player, then shows a hint to come back later.
function npc_dialogue.chat_muttering_numbers(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.wait_facing_character(npc_character)
	event.open_message_window_2(0, "...1212,<page>No, no. Seguro que era 1122.<page>[UNI00bf]O era 1010?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Grrr, grrr..")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		'[(!)]Si ni siquiera se ha enterado\n de que le has dicho "hola".Debe de\ntener problemas graves.<page>[(!)][UNI00bf]Por qu[UNI00e9] no pruebas despu[UNI00e9]s?\n A lo mejor le puedes echar una mano\n o escucharle o algo.'
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Has the villager pray for world peace or speak of wisdom, depending on the chapter and whether the villager's own request is completed.
function npc_dialogue.chat_prayer_for_peace(npc_character: s32, player_character: any, request_completed: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if request_completed ~= 0 and chapter == 8 then
		event.open_message_window_2(0, "Rezo por que haya paz\nen el mundo a partir de hoy y para siempre.")
	else
		event.open_message_window_2(0, "Si luchas por una buena causa\nes que eres un sabio.")
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the maid say she dreams of becoming a seamstress although dreams rarely come true.
function npc_dialogue.chat_seamstress_dream(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"En estos momento trabajo de doncella\npero desde peque[UNI00f1]a he so[UNI00f1]ado\ncon ser sastre."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Los sue[UNI00f1]os no se hacen realidad,\npor eso digo que es un sue[UNI00f1]o.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Has the villager say the shop is closed and direct the player to the family shop up the stairs.
function npc_dialogue.chat_shop_closed(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"La tienda est[UNI00e1] cerrada. Tendr[UNI00e1]s que\nir a la tienda de mi padre.<page>Busca las calabazas. Est[UNI00e1]n a la vista,\nencima de la escalera."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager complain that the town is too peaceful to offer any work.
function npc_dialogue.chat_town_too_peaceful(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"Esta ciudad es demasiado pac[UNI00ed]fica y\nno hay trabajo para m[UNI00ed].<page>Ya s[UNI00e9] que eso es bueno,\npero..."
	)
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Has the villager warn about the danger of weapons, with a line about helping rebuild the world in the final chapter.
function npc_dialogue.chat_weapon_caution(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Las armas las carga el diablo.<page>Ten cuidado con\nellas o podr[UNI00ed]as hacerte da[UNI00f1]o."
		)
	else
		event.open_message_window_2(
			0,
			"A partir de ahora voy a ayudar\na Need y Cedric a reconstruir el mundo.\nTenemos que trabajar juntos."
		)
	end
	cutscene.talk_to_character(npc_character, -1, 0, 0)
end

--- Checks the stopwatch time of the player's run to the boat and recruits the villager when it beats the record.
function npc_dialogue.check_boat_run_time(npc_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local hundredths: s32 = 0
	local beat_record: s32 = 0
	local run_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		hundredths = out3 or hundredths
		beat_record = out4 or beat_record
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	run_state = event.get_save_counter(7) or run_state
	if run_state == 0 then
		event.open_message_window_2(0, "Hola, Max.\n[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if run_state == 1 then
		event.open_message_window_2(
			0,
			"Eh. No has ido hasta la barca,\n[UNI00bf]no? Quer[UNI00ed]as enga[UNI00f1]arme.\n[UNI00a1]No seas tramposo!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "[UNI00a1]Eh, no hagas trampas!")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "Has llegado.\nBien,<page>vamos a ver\ntu tiempo.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, hundredths)
	if beat_record == 0 then
		event.open_message_window_2(0, "[UNI00a1]Vaya por Dios!\n[数値２] minutos.[数値３] segundos.\nDemasiado lento.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "[UNI00bf]Quieres probar otra vez?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		npc_dialogue.offer_boat_run(npc_character, player_character)
		return
	end
	event.open_message_window_2(0, "[UNI00a1]Oh!\n[数値１] minutos [数値２] segundos[数値３].\nNo est[UNI00e1] mal.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Eres m[UNI00e1]s r[UNI00e1]pido de lo que parece. Vale,\nvamos a pelear contra los malos juntos."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- The baker checks whether the bread delivery to Morton is done, trades the 20 loaves for 20 of another item and joins the party.
function npc_dialogue.complete_baker_request(npc_slot: s32, player_slot: s32)
	local delivery_stage: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	delivery_stage = event.get_save_counter(12) or delivery_stage
	if delivery_stage < 3 then
		event.open_message_window_2(
			0,
			"Lo siento, todav[UNI00ed]a\nno estoy lista.<page>[UNI00bf]Puedes darme un poco m[UNI00e1]s de tiempo?"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Por cierto: [UNI00bf]has ido ya\na ver a Morton de mi parte?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9]? [UNI00bf]C[UNI00f3]mo puede ser tan\ndesconsiderado?<page>En fin,\npuedes qued[UNI00e1]rtelas."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "No importa.\nEn marcha.<page>[UNI00bf]A d[UNI00f3]nde\nvamos?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Greets Monica with the hair greeting when she leads, otherwise checks Max's flower photos, then praises them and joins the party or asks to see an unusual flower.
function npc_dialogue.complete_flower_photo_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
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
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "[UNI00bf]Tienes fotos de flores raras?\n[UNI00a1]A ver, a ver!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "[UNI00a1]Guau! [UNI00a1]Alucinante!\nAs[UNI00ed] que estas son las flores que se ven fuera.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Umm... [UNI00bf]Qu[UNI00e9] hago?<page>Bueno, venga. Me voy con vosotros.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Gordon asks Max for Holy Water to fix the tree, joins the party, explains party and train management and completes request 0.
function npc_dialogue.complete_gordon_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc_dialogue.hint_talk_to_gordon(npc_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Max, mi prioridad ahora es\ncurar este [UNI00e1]rbol.<page>Lo que necesito\nes...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(0, "Max, as[UNI00ed] no hacemos nada.<page>Lo que necesito es\nAgua bendita del Padre Bruno.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]S[UNI00ed]! [UNI00a1]Lo has conseguido, Max!\n[UNI00a1]Ya me ocupo yo del [UNI00e1]rbol!<page>Gracias, Max."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ya est[UNI00e1] todo resuelto\n por el momento.<page>[UNI00a1]Ya te puedo acompa[UNI00f1]ar\nen tu aventura!<page>[UNI00a1]Ah! Ni se te ocurra hablarle a\ntu padre del Agua bendita, [UNI00bf]entendido?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "Gordon se ha unido al grupo.")
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puedes emplear sus habilidades\n desde la opci[UNI00f3]n Estado del\napartado Personajes del men[UNI00fa] Principal.<page>[(!)]Si reclutas a m[UNI00e1]s personas\npara la aventura, se\nsubir[UNI00e1]n al tren."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Habla con ese pasajero\ndel tren para que se\nconvierta en el tercer miembro del grupo.<page>[(!)]Para que\nuno de tus amigos del tren entre en una casa, elige Mover persona\nen el men[UNI00fa] Puerta de la casa en cuesti[UNI00f3]n."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Puede que haya muchos m[UNI00e1]s\nque quieran unirse a tu grupo.\n[UNI00a1]B[UNI00fa]scalos!"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Mena reports whether enough stages were cleared since request 17 began and joins the party once ten were cleared.
function npc_dialogue.complete_mena_request(npc_slot: s32, player_slot: s32)
	local current_clear_count: s32 = 0
	local start_clear_count: s32 = 0
	local checkpoint: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		checkpoint = 1
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		current_clear_count = event.get_menu_value_2(0) or current_clear_count
		start_clear_count = event.get_save_counter(19) or start_clear_count
		print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", vm.i32(current_clear_count - start_clear_count), "\n")
		if vm.i32(current_clear_count - start_clear_count) < 10 then
			event.open_message_window_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
			checkpoint = 2
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.open_message_window_2(
				0,
				"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
			)
			checkpoint = 3
			message.say_bubble(0, -1, npc_slot, player_slot, 0)
			event.set_character_motion(npc_slot, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
		checkpoint = 4
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
		)
		checkpoint = 5
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
		)
		checkpoint = 6
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		checkpoint = 7
		party.add_talked_npc()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if checkpoint <= 3 then
			if checkpoint <= 1 then
				print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", current_clear_count - start_clear_count, "\n")
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 2 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			return 0
		end
		if checkpoint <= 7 then
			if checkpoint <= 4 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 5 then
				message.show_bubble_and_close(0, -1, npc_slot, player_slot, 0)
			end
			if checkpoint <= 6 then
				party.announce_new_member_alt_default()
			end
			return 0
		end
		return nil
	end)
end

--- Parn takes the Golden Paint from Max, joins the party and completes request 1.
function npc_dialogue.complete_parn_request(npc_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.set_npc_party_status(22, 130)
	party.announce_member_joined(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Walks through the safe's secret code puzzle, tests the code Max enters and joins the party once the safe opens.
function npc_dialogue.complete_safe_code_request(npc_slot: s32, player_slot: s32)
	local selection: any = 0
	local code_result: s32 = 0
	local unlock_sound_id: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_y: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local angle_toward_safe: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	while true do
		event.open_message_window_2(0, "Hace mucho le di un broche\ncon su signo del zodiaco.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"Holly se encarg[UNI00f3] de todo,\nas[UNI00ed] que no me acuerdo exactamente,\npero estoy seguro de que era un animal de 4 patas..."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"[UNI00bf]Que qu[UNI00e9] clase de\nregalos de cumplea[UNI00f1]os le he hecho?<page>Umm... Muchos abrigos\ny pa[UNI00f1]uelos, supongo.<page>Nunca s[UNI00e9] qu[UNI00e9] comprarle.\nTodos los a[UNI00f1]os es la misma historia."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"[UNI00a1]Y tanto! El cumplea[UNI00f1]os de Claire siempre es un sufrimiento.\nCae siempre en el d[UNI00ed]a que recogen la basura\nque se puede quemar y la que no.<page>A m[UNI00ed] me toca sacar\nla basura de casa."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(
			0,
			"La basura que no se puede quemar\nse recoge los d[UNI00ed]as divisibles por 7<page>y la que s[UNI00ed] se puede quemar\nlos divisibles por tres."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "[UNI00bf]A que t[UNI00fa] tampoco te olvidar[UNI00ed]as\nde eso, eh?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.open_message_window_2(
			0,
			"[UNI00a1]Ya est[UNI00e1]! [UNI00a1]Misterio resuelto!\nLa combinaci[UNI00f3]n es... <page>No s[UNI00e9]... Vamos a escuchar un poco m[UNI00e1]s."
		)
		selection = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
		if selection == 0 then
			break
		else
			if selection == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_slot, "会話")
		end
	end
	event.set_menu_value(0, "Introduce el c[UNI00f3]digo secreto.", "1221", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		code_result = out1 or code_result
	end
	if code_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.frames(15)
	unlock_sound_id = event.get_sound_id(2) or unlock_sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_slot)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_slot)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_y = out2 or npc_rotation_y
		npc_rotation_z = out3 or npc_rotation_z
	end
	event.set_character_position(npc_slot, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_slot, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_slot, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_y = out2 or player_rotation_y
		player_rotation_z = out3 or player_rotation_z
	end
	angle_toward_safe = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or angle_toward_safe
	event.set_character_rotation(0, 0.0, angle_toward_safe, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.frames(30)
	if code_result == 0 then
		event.set_character_motion(npc_slot, "会話")
		event.open_message_window_2(0, "Vaya, no se abre. Cachis la mar... <page>Dentro tengo documentos\nmuy importantes...")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.fade_out_screen(15)
		wait.frames(15)
		event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
		event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
		event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(0, "Esto... Um...\n1,<page>2,<page>2,<page>1...")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.play_sound_effect(unlock_sound_id, 66)
	event.open_message_window_2(0, "[UNI00a1]Yujuuuu!<page>Bien,\n[UNI00a1]ha funcionado!")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.attach_object_handle_to_character(0, npc_slot)
	event.clear_object_sequence(0, npc_slot)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(
		0,
		"[UNI00a1]Genial! Ahora podr[UNI00e9]\nsacar los documentos que necesito.<page>[UNI00a1]Muchas gracias!"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.fade_out_screen(15)
	wait.frames(15)
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	event.set_character_position(npc_slot, npc_x, npc_y, npc_z)
	event.set_character_rotation(npc_slot, npc_rotation_x, npc_rotation_y, npc_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.fade_in_screen(15)
	wait.frames(15)
	event.set_character_motion(npc_slot, "会話")
	event.open_message_window_2(
		0,
		"[UNI00bf]Qu[UNI00e9] documentos?<page>Unos que ayudar[UNI00e1]n al Teniente Alcalde Morton\na sustituirme mientras estoy fuera.<page>Me preocupa un poco,\npero no creo que pase nada."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Ahora ya estoy listo para marcharme.<page>Cedric me lo ha contado todo.<page>Venga, vamos.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Takes sturdy cloth, thick hide and a copper lump from the player so the seamstress can start making clothes, then removes her from the scene.
function npc_dialogue.deliver_tailoring_materials(npc_character: s32, player_character: s32)
	local sturdy_cloth_count: s32 = 0
	local thick_hide_count: s32 = 0
	local copper_lump_count: s32 = 0
	local answer: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	sturdy_cloth_count = event.get_item_count(214) or sturdy_cloth_count
	thick_hide_count = event.get_item_count(245) or thick_hide_count
	copper_lump_count = event.get_item_count(227) or copper_lump_count
	if sturdy_cloth_count <= 0 or thick_hide_count <= 0 or copper_lump_count <= 0 then
		event.open_message_window_2(
			0,
			"Sin los materiales\nno puedo hacer nada.<page>Necesito tela resistente,\nun trozo de cuero gordo y un cacho de cobre.<page>Siento dar\ntantos problemas."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "[UNI00a1]Toma, toma esto!\nMenudo derroche.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "Sin los materiales\nno puedo hacer nada.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(
		0,
		"Muchas gracias.\n[UNI00a1]Intentar[UNI00e9] confeccionar algo de ropa!<page>No dejar[UNI00e9] que tiren esto."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.finish_event()
	event.fade_in_screen(30)
end

--- Has the villager explain the speed test of running to the boat and back, then offers an attempt.
function npc_dialogue.explain_boat_run_test(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Eh, Max, [UNI00bf]has venido a buscarme?<page>Te he estado esperando.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Gracias a las murallas,\nla ciudad es segura.<page>Es hora de salir.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Me parece bien que te pases\nel d[UNI00ed]a manipulando m[UNI00e1]quinas,\npero me gustar[UNI00ed]a saber qu[UNI00e9] fuerza tienes."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"La lucha\nes cuesti[UNI00f3]n de velocidad y juego de pies.<page>Si eres m[UNI00e1]s lento que yo,\nest[UNI00e1]s listo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Por qu[UNI00e9] no te ponemos a prueba?\nCorre hasta la barca del lago y vuelve.<page>Mi r[UNI00e9]cord es de 2 minutos y 1 segundo.\nSi eres m[UNI00e1]s lento,\nno hay nada que hacer."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] dices, quieres probar?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	npc_dialogue.offer_boat_run(npc_character, player_character)
end

--- Greets Monica as Max's girlfriend and compliments her hair.
function npc_dialogue.greet_monica_about_hair(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Hola! [UNI00bf]Eres la novia\nde Max?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Qu[UNI00e9] color tan original tiene tu pelo.\nComo el de Erik, pero diferente...<page>El tuyo es muy bonito,\ncomo una joya."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.finish_event()
end

--- Plays the remark about the ailing tree and the hint that Monica must talk to Gordon to get his attention.
function npc_dialogue.hint_talk_to_gordon(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_slot, "立ち")
	event.open_message_window_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(0, "[(!)]Tendr[UNI00e1]s que hablar con\nGordon para atraer su atenci[UNI00f3]n.")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Asks whether the player wants to try the boat run and starts the stopwatch when accepted.
function npc_dialogue.offer_boat_run(npc_character: s32, player_character: s32)
	local answer: any = 0
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Claro, d[UNI00e9]jame probar.\nNo me apetece.")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(
			0,
			"Vale...<page>Bueno, si quieres volver a probar m[UNI00e1]s tarde,\nd[UNI00ed]melo. Te esperar[UNI00e9]."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(7, 0)
		return
	end
	event.open_message_window_2(0, "[UNI00a1]Preparado, listo,\nya!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.control_stopwatch(3, 32, 364, 0)
	event.control_stopwatch_1(0)
	event.set_save_counter(7, 1)
end

--- Has the villager pose the church candle puzzle as a test of wisdom and starts the quest request.
function npc_dialogue.pose_candle_puzzle(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]S[UNI00ed]? [UNI00bf]Necesitas mi ayuda?\nEntonces d[UNI00e9]jame que te plantee un problema."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Las velas de la iglesia\nest[UNI00e1]n controladas por un peque[UNI00f1]o mecanismo.<page>Cuando est[UNI00e1]n encendidas\nlas apaga y,\ncuando se apagan, las enciende.<page>Si una cambia,\nlas adyacentes a ella tambi[UNI00e9]n lo hacen."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Si apagas todas las velas,\nme demostrar[UNI00e1]s tu sabidur[UNI00ed]a y te acompa[UNI00f1]ar[UNI00e9].<page>Si resuelves el problema, estupendo.\nSi no, tendr[UNI00e1]s que entender que no puedo ayudarte."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Este es otro puzzle. Int[UNI00e9]ntalo\nun par de veces y f[UNI00ed]jate bien\nen lo que pasa."
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]Si vuelves a entrar en la iglesia,\n las velas volver[UNI00e1]n a su estado original.\n O sea que no hay de qu[UNI00e9] preocuparse.\n La soluci[UNI00f3]n podr[UNI00ed]a ser muy simple."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Checks whether the player has won the fish race and recruits the fish keeper if so.
function npc_dialogue.recruit_after_fish_race(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	story_flag = event.get_save_flag(41) or story_flag
	if story_flag == 0 then
		event.open_message_window_2(0, "Se dice que los peces se parecen a sus amos.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "No le voy a dirigir la palabra al\ndue[UNI00f1]o de una birria de pez.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"La he visto.\nHa sido una carrera muy emocionante.<page>No creo que yo hubiera\npodido criar un pez tan bueno.<page>Ll[UNI00e9]vame contigo, por favor.\nEns[UNI00e9][UNI00f1]ame c[UNI00f3]mo lo haces."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Counts how often the hiding villager is found and recruits the villager once the game of hide-and-seek is over.
function npc_dialogue.recruit_after_hide_and_seek(npc_character: s32, player_character: s32)
	local times_found: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	times_found = event.get_save_counter(11) or times_found
	if times_found < 1 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Eh! [UNI00a1]Me has encontrado!<page>[UNI00bf]Podr[UNI00e1]s tambi[UNI00e9]n la pr[UNI00f3]xima vez?"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, times_found + 1)
		event.fade_out_screen(30)
		wait.frames(30)
		event.set_villager_ai_enabled(1, npc_character)
		event.set_character_active(0, npc_character)
		event.delete_villager(npc_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Vaya! [UNI00a1]Me has encontrado!<page>Me estoy hartando.<page>Esconderse es\nmuy aburrido.<page>[UNI00a1]Bueno! V[UNI00e1]monos\nde aventura."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- The hard-of-hearing grandmother starts request 19, asks Max to enter "Let's go together." and joins the party when he does.
function npc_dialogue.recruit_grandmother(npc_slot: s32, player_slot: s32)
	npc_dialogue.recruit_hard_of_hearing_woman(npc_slot, player_slot)
end

--- Asks the hard-of-hearing old woman to join through a "go together" menu choice and recruits her on the right answer.
function npc_dialogue.recruit_hard_of_hearing_woman(npc_character: s32, player_character: s32)
	local menu_selection: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]C[UNI00f3]mo?<page>[UNI00bf]No puedes hablar m[UNI00e1]s despacio?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(0, 'Escribe: "Vamos juntos."', "Vamos juntos.", 0)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		menu_selection = out1 or menu_selection
	end
	if menu_selection == -1 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if menu_selection == 0 then
		event.open_message_window_2(0, "[UNI00bf]De qu[UNI00e9] me est[UNI00e1]s hablando?\nNo tengo ni idea...")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Una aventura?\nEso estar[UNI00ed]a bien.<page>Pero, [UNI00bf]de qu[UNI00e9] te servir[UNI00ed]a una\nvieja como yo?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Asks the player to hand over a chestnut and recruits the villager when the right item is used.
function npc_dialogue.recruit_with_chestnut(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "[UNI00bf]Has conseguido alguna Casta[UNI00f1]a?")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(0, "No puedes...<page>En fin, tendr[UNI00e9] que dejar\nel Castagnaccio.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"Muy bien. Muchas gracias.<page>Intentar[UNI00e9] preparar algo de Castagnaccio.<page>Te lo dar[UNI00e9] a probar en cuanto termine."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Puedo devolverte el favor de alguna manera?<page>[UNI00bf]C[UNI00f3]mo? [UNI00bf]Quieres que te acompa[UNI00f1]e en tu aventura?<page>[UNI00a1]Ja, ja! Eso est[UNI00e1] hecho.<page>[UNI00bf]Por qu[UNI00e9] no me has preguntado antes?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Checks whether the player has photographed the moon and, if so, recruits the moon-loving villager into the party.
function npc_dialogue.recruit_with_moon_photo(npc_character: s32, player_character: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"Pens[UNI00e9] que t[UNI00fa] eras diferente,\npero no, los humanos son humanos.<page>Da igual, estoy acostumbrado\na o[UNI00ed]r mentiras vuestras."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00a1]Guau! Es alucinante. Hay una luna en la foto.<page>Ahora podr[UNI00e9] verla cuando sea y donde sea."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00bf]Ir contigo?<page>Pues claro que s[UNI00ed].\nNo tengo otro sitio adonde ir.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Checks the length of the player's caught Nonky and recruits the fisherman if it is long enough.
function npc_dialogue.recruit_with_nonky_catch(npc_character: s32, player_character: s32)
	local fish_length: f32 = 0
	local length_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	fish_length = vm.bits_float(event.get_menu_value(2, 322)) or fish_length
	if fish_length <= 0 then
		event.open_message_window_2(
			0,
			"Apostar[UNI00ed]a a que nunca has\npescado un Nonky, [UNI00bf]eh?<page>Ja, ja. [UNI00a1]Tienes que ser p[UNI00e9]simo pescando!"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if fish_length < vm.f32(0.6) then
		length_centimeters = vm.ftoi(vm.f32(fish_length * 100.0))
		event.set_message_number(0, 1, length_centimeters)
		event.open_message_window_2(0, "[UNI00a1]Ja, ja! S[UNI00f3]lo has cogido\nun pezque[UNI00f1][UNI00ed]n de [数値１] cm.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"[UNI00a1]No me llegas ni a la altura del bet[UNI00fa]n!<page>Te recomiendo que empieces de nuevo."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "... Vaya, te he subestimado.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"En fin, soy un hombre de palabra.\nNo tienes que record[UNI00e1]rmelo.<page>Escuchar[UNI00e9] lo que tengas que decirme."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "[UNI00a1]Habla cuanto quieras!")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Asks for the Dark Coin and the Indestructible Coin, takes them after confirmation and recruits the coin collector.
function npc_dialogue.recruit_with_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local dark_coin_count: s32 = 0
	local indestructible_coin_count: s32 = 0
	local answer: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	dark_coin_count = event.get_item_count(201) or dark_coin_count
	indestructible_coin_count = event.get_item_count(202) or indestructible_coin_count
	if dark_coin_count <= 0 or indestructible_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"[UNI00bf]Qu[UNI00e9]? Ah, un coleccionista de monedas.<page>Estoy buscando la Moneda negra\ny la Moneda indestructible.<page>No se ven en ninguna parte. Las he buscado\npor todos lados pero no hay quien las encuentre."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"[UNI00bf]Eh? [UNI00bf]Las tienes? [UNI00a1]Incre[UNI00ed]ble!<page>[UNI00a1]No te quedes ah[UNI00ed]! [UNI00a1]Dame, dame, dame!"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "Vale.\n[UNI00bf]Qu[UNI00e9] tengo que hacer?")
	answer = message.ask_choice_signed(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if answer ~= 0 then
		event.open_message_window_2(0, "[UNI00a1]Agh! Si vas a cabrearme,\npaso de ayudarte.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"[UNI00a1]Guau! [UNI00a1]Ya las tengo todas!\nCre[UNI00ed]a que era imposible...<page>Bueno, ahora creo que no tengo alternativa.\nSer[UNI00e1] mejor que vaya contigo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has a fearful villager refuse to fight, ask Max for a flower photo and start the photo request, while Monica takes the alternate dialogue.
function npc_dialogue.request_flower_photo(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc_dialogue.greet_monica_about_hair(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Me gustar[UNI00ed]a ayudarte pero pelear\nme da miedo y, adem[UNI00e1]s, es muy sucio.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Adem[UNI00e1]s, no me gusta incordiar a nadie.\nLo siento pero no.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero tiene que haber muchas\ncosas interesantes fuera de la ciudad.<page>[UNI00c1]rboles que no hemos visto\ny flores de todas las clases."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Si ves una flor interesante, [UNI00bf]podr[UNI00ed]as\nsacarle una foto y tra[UNI00e9]rmela, Max?\nMe encantar[UNI00ed]a verla."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Ha dicho que no, pero si\nle ense[UNI00f1]as una foto de algo que\nle interese puede que acepte."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the magical artist introduce his painted fiancee and ask the player to bring Golden Paint, or says the player should try as Max when Monica talks.
function npc_dialogue.request_golden_paint(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
		event.open_message_window_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, "...")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]A M[UNI00f3]nica no se le dan muy bien\nestas situaciones. Podr[UNI00ed]a lograr algo,\npero es probable que no lo haga. Prueba m[UNI00e1]s tarde con Max."
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(0, "Hola, Max.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "...")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"Puedes re[UNI00ed]rte lo que quieras.\nYa s[UNI00e9] que es raro.<page>[UNI00bf]Qui[UNI00e9]n se enamorar[UNI00ed]a de\nun retrato?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero soy un artista m[UNI00e1]gico.\nTengo el poder de convertir en realidad las cosas que pinto.<page>Todo lo que pinto existe en el cuadro verdaderamente.\nA menos que se trate de un ser vivo..."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Ni siquiera un artista m[UNI00e1]gico puede pintar vida.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Aunque he o[UNI00ed]do que existe una forma.\nHay un Huevo dorado en un [UNI00e1]rbol grande y viejo."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Se cuenta que con el color dorado\nse puede dar vida a cualquier cosa que pintes.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Max, tengo entendido que\nte marchas de la ciudad, [UNI00bf]no?<page>[UNI00bf]Podr[UNI00ed]as traerme algo de Pintura dorada?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Por supuesto que no espero que lo hagas a cambio de nada.<page>Si me ayudas, usar[UNI00e9]\nmi nuevo poder para devolverte el favor."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un [UNI00e1]rbol grande y viejo...\n [UNI00a1]Con un Huevo dorado! [UNI00bf]Y d[UNI00f3]nde se supone\nque hay algo as[UNI00ed]?"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Has the coin collector refuse to help without payment and ask for the Dark Coin and the Indestructible Coin, or says the player should try as Max when Monica talks.
function npc_dialogue.request_rare_coins(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		palm_brinks_villagers.talk_about_max_absence(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"Deber[UNI00ed]as imaginarte la respuesta:\n[UNI00a1]ni hablar!<page>[UNI00bf]Por qu[UNI00e9] iba yo a trabajar por\nel bien de otros?"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Yo no saco nada y\nadem[UNI00e1]s me da mucho miedo.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Trat[UNI00e1]ndose de ti, supongo\nque me lo puedo pensar mejor.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "Pero soy hijo de comerciante:\nno hacemos nada gratis.")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Ya sabr[UNI00e1]s que colecciono monedas.<page>Son el s[UNI00ed]mbolo de los negocios. Quiero\nacabar mi colecci[UNI00f3]n."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"Pero soy incapaz de conseguir\nla Moneda negra\ny la Moneda indestructible.<page>Si me ayudas,<page>quiz[UNI00e1] te ayude yo a ti."
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

--- The baker agrees to join once Max delivers 20 loaves of bread to Morton, hands over the bread and starts request 8.
function npc_dialogue.start_baker_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00bf]Quieres que\nte acompa[UNI00f1]e?<page>S[UNI00f3]lo soy una mujer que hace Pan,\npero si crees que puedo ser [UNI00fa]til,\nir[UNI00e9] encantada."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ah, pero antes tengo\nque hacer un env[UNI00ed]o a Morton.<page>[UNI00bf]Te importar[UNI00ed]a llevarle 20 barras\nde Pan a Morton a su tienda?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Mientras vas y vienes,\nhar[UNI00e9] las maletas.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow_alt(1)
	event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] querr[UNI00e1] hacer\ncon 20 barras?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- The fisherman says Firbits only help those better than them, boasts of his fish knowledge, hints at the fish race beginner class and starts request 16.
function npc_dialogue.start_fisherman_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Cuando se trata de pescar,\nvoy muy seguro.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Me han dicho que los humanos\ncelebran un concurso en el que\nse enfrentan peces entre s[UNI00ed].<page>Si tienes un pez, [UNI00bf]por qu[UNI00e9]\nno intentas ganar?<page>Si lo consigues,\nme demostrar[UNI00e1]s que eres merecedor de mi ayuda."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Parece que se refiere a la Carrera\n de Peces. [UNI00bf]Por qu[UNI00e9] no pruebas en la categor[UNI00ed]a de Principiantes\n? A lo mejor as[UNI00ed] te ayuda."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Gerald hands Max a Trumpet Gun, asks him to build it up into a Bell Trigger and starts request 11.
function npc_dialogue.start_gerald_request(npc_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Seg[UNI00fa]n Cedric,\nhas estado fuera\npor ciertos asuntos.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Eres bueno en muchas cosas,\npero luego\nnunca terminas nada.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Por eso cuando me pides\nayuda me resulta dif[UNI00ed]cil tomarte\nen serio a la primera.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Ya. [UNI00bf]Por qu[UNI00e9] no mejoras esta Pistola Trompeta y la conviertes en Pistola Campana?<page>[UNI00bf]Ser[UNI00e1]s capaz?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	event.add_inventory_item(24)
	inventory.announce_received(24, 1)
	inventory.resolve_overflow_alt(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Para conseguir que Gerald te acepte,\n tendr[UNI00e1]s que\nconseguirle una Pistola Trompeta.<page>[(!)]Puedes mejorar el arma\n que te han dado, comprar una\n o conseguir una en las Mazmorras."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Mena describes her dizziness; when Monica leads she recognises it as an effect of time distortions, a hint explains how to fix them, and request 17 starts with the current clear count saved.
function npc_dialogue.start_mena_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local clear_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(
		0,
		"[UNI00da]ltimamente no me encuentro muy bien.<page>El Dr. Dell me ha examinado,\npero seg[UNI00fa]n [UNI00e9]l no me pasa nada."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Con s[UNI00f3]lo ponerme de pie\nme da la impresi[UNI00f3]n de que me voy a caer.<page>No  es f[UNI00e1]cil de explicar. Es como si\nel mundo estuviera alterado."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_character_motion(npc_slot, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(
			0,
			"Um...\nSi el Dr. Dell no sabe cu[UNI00e1]l es el problema,\nyo no voy a poder ayudar mucho..."
		)
		message.say_bubble(0, -1, player_slot, npc_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Recuerdo los s[UNI00ed]ntomas.")
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Cuando nac[UNI00ed],\nel mundo estaba en un estado lamentable:\nhab[UNI00ed]a m[UNI00e1]s distorsiones temporales de las\nque te puedas imaginar."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Adem[UNI00e1]s afectaban a personas\nfr[UNI00e1]giles f[UNI00ed]sicamente.<page>Los delgados se mareaban o se desmayaban\ny los m[UNI00e1]s rellenos no se pod[UNI00ed]an ni levantar."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"A lo mejor t[UNI00fa] eres especialmente\nsusceptible a estas cosas.<page>Incluso las pocas distorsiones temporales\nque hay aqu[UNI00ed] bastan para afectarte."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.open_message_window_2(
		0,
		"Si pudi[UNI00e9]ramos librarnos de las distorsiones\nm[UNI00e1]s pr[UNI00f3]ximas, seguro que te sentir[UNI00ed]as mejor."
	)
	message.say_bubble(0, -1, player_slot, npc_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)][UNI00bf]C[UNI00f3]mo se arregla una distorsi[UNI00f3]n temporal? [UNI00a1]Esfeda!\n Si pasas m[UNI00e1]s de 10 niveles,\n quiz[UNI00e1] Mena mejore un poco."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	clear_count = event.get_menu_value_2(0) or clear_count
	event.set_save_counter(19, clear_count)
	event.set_quest_request(0, 17, 1)
end

--- Routes Adel's conversation by whether Monica leads, the status of requests 0 and 7 and the tailoring progress.
function npc_dialogue.talk_to_adel(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	local tailoring_progress: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		palm_brinks_villagers.talk_worried_villager(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.chat_seamstress_dream(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 7) or request_status
	if request_status == 0 then
		palm_brinks_villagers.request_adel_confidence(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		tailoring_progress = event.get_save_counter(8) or tailoring_progress
		if tailoring_progress == 0 then
			quest_dialogue.request_tailor_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 1 then
			npc_dialogue.deliver_tailoring_materials(npc_slot, player_slot)
		end
		if tailoring_progress == 2 then
			quest_dialogue.receive_tailor_garment(npc_slot, player_slot)
		end
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_about_clothes(npc_slot, player_slot)
		return
	end
end

--- Chooses the coin collector's dialogue from the state of the main request and his own quest request.
function npc_dialogue.talk_to_coin_collector(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc_dialogue.chat_shop_closed(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		npc_dialogue.request_rare_coins(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.recruit_with_rare_coins(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_dialogue.chat_about_zelmite_hunt(npc_character, player_character)
		return
	end
end

--- Routes the fisherman's conversation by request 0 and 16 status and a story flag.
function npc_dialogue.talk_to_fisherman(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	local story_flag: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	story_flag = event.get_save_flag(424) or story_flag
	if request_status ~= 2 or story_flag == 0 then
		palm_brinks_villagers.explain_firbit_favours(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 16) or request_status
	if request_status == 0 then
		npc_dialogue.start_fisherman_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_after_fish_race(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		villager_dialogue.talk_about_fabio(npc_slot, player_slot)
		return
	end
end

--- Chooses the gardener's dialogue from the story flag and the state of his quest request.
function npc_dialogue.talk_to_gardener(npc_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(42) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_tree_gardener(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status == 0 then
		villager_dialogue.start_gordon_quest(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc_dialogue.complete_gordon_request(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc_chatter.talk_holy_water_keeper(npc_character, player_character)
		return
	end
end

--- Routes the hide-and-seek child's conversation by request 0 and 18 status.
function npc_dialogue.talk_to_hide_and_seek_child(npc_slot: s32, player_slot: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.ask_to_join_party(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status == 0 then
		villager_dialogue.start_corinne_hide_and_seek(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.recruit_after_hide_and_seek(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_hide_and_seek(npc_slot, player_slot)
		return
	end
end

--- Routes Mena's conversation by story flag and the status of request 17.
function npc_dialogue.talk_to_mena(npc_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local request_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		npc_chatter.talk_sick_villager(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 17) or request_status
	if request_status == 0 then
		npc_dialogue.start_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		npc_dialogue.complete_mena_request(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		npc_dialogue.chat_bug_averse(npc_slot, player_slot)
		return
	end
end

--- Parn introduces himself to Monica or greets Max.
function npc_dialogue.talk_to_parn(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		event.open_message_window_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.open_message_window_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Oye, Max.<page>[UNI00bf]C[UNI00f3]mo es que siempre tienes buen aspecto?")
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

return npc_dialogue
