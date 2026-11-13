--!strict
--- Holds the Spanish conversations with the Palm Brinks house owner.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local palm_brinks_house = {}

--- Runs the house owner's conversation: the refuel and core upgrade menu once flag 7 is set, otherwise the hints and invention events chosen from flags, materials and invention state.
function palm_brinks_house.reply_about_invention(character_slot: s32, unused_talk_id: any)
	local story_flag: s32 = 0
	local query_result: s32 = 0
	local player_slot: s32 = 0
	local menu_choice: any = 0
	local scrap_count: s32 = 0
	local hide_count: s32 = 0
	local copper_count: s32 = 0
	event.set_character_motion(0, "立ち", 0)
	wait.frames(9)
	story_flag = event.get_save_flag(7) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		message.set_window_mode(0, 1)
		cutscene.begin_talk(character_slot, 0, 0)
		player_slot = event.get_player_character_slot() or player_slot
		event.open_message_window_2(0, "[UNI00bf]Qu[UNI00e9] tal va Steve?")
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "Repostar\nMejorar el N[UNI00fa]cleo")
		menu_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
		event.set_message_window_option(0, 0, 0)
		event.set_message_bubble_tail(0, 1)
		if menu_choice == 0 then
			event.set_save_data_value(2)
			event.open_message_window_2(0, "[UNI00a1]Ya! [UNI00a1]Todo listo!")
			message.say_bubble(0, -1, character_slot, player_slot, 0)
		end
		if menu_choice == 1 then
			event.fade_out_screen(25)
			wait.frames(30)
			event.open_event_menu(6, 23)
			vm.wait(7)
			event.fade_in_screen(25)
		end
		event.set_villager_ai_enabled(1, 24)
		return
	end
	story_flag = event.get_save_flag(107) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(0, "[UNI00bf]Te rindes por algo tan insignificante\n? [UNI00a1]Nada de tirar la toalla!")
		cutscene.talk(character_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	story_flag = event.get_save_flag(20) or story_flag
	if story_flag == 1 then
		vm.wait(9)
		event.load_event_script("i01h01/i01h01c_1.stb", 500)
		return
	end
	query_result = event.get_item_count(165) or query_result
	if query_result > 0 then
		event.set_save_flag(20, 1)
		vm.wait(10)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	scrap_count = event.get_item_count(224) or scrap_count
	hide_count = event.get_item_count(245) or hide_count
	copper_count = event.get_item_count(227) or copper_count
	query_result = event.is_invention_created(165) or query_result
	if scrap_count >= 20 and hide_count >= 1 and copper_count >= 2 and query_result ~= -1 then
		vm.wait(11)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	story_flag = event.get_save_flag(19) or story_flag
	if story_flag == 1 then
		event.set_villager_ai_enabled(0, 24)
		event.open_message_window_2(
			0,
			"Sal fuera: el sitio\nde enfrente con el s[UNI00ed]mbolo de la calabaza es la\nTienda de Objetos.<page>Necesitas 20 trozos de metal,\n2 buenos cachos de cobre y una piel gruesa.\nVe a la tienda y c[UNI00f3]mpralo todo."
		)
		cutscene.talk(character_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, 24)
		return
	end
	query_result = event.is_invention_created(165) or query_result
	if query_result ~= -1 then
		vm.wait(13)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	query_result = event.has_invention_ideas(165) or query_result
	if query_result == 1 then
		vm.wait(14)
		event.load_event_script("i01h01/i01h01b_1.stb", 520)
		return
	end
	story_flag = event.get_save_flag(17) or story_flag
	if story_flag == 1 then
		vm.wait(15)
		event.load_event_script("i01h01/i01h01b_1.stb", 510)
		return
	end
	story_flag = event.get_save_flag(105) or story_flag
	if story_flag == 0 then
		event.open_message_window_2(0, "Max, no puedes saltarte el trabajo,\n[UNI00bf]me oyes?")
		cutscene.talk(character_slot, -1, 0, 0)
		return
	end
	event.set_villager_ai_enabled(0, 24)
	event.open_message_window_2(0, "Int[UNI00e9]ntalo t[UNI00fa] mismo\nprimero, muchacho.")
	cutscene.talk(character_slot, -1, 0, 0)
	event.open_message_window_2(0, "Te echar[UNI00e9] una mano si\ntienes problemas, no te preocupes.")
	cutscene.talk(character_slot, -1, 0, 0)
	event.open_message_window_2(0, "[UNI00a1]Hale, venga, vete!")
	cutscene.talk(character_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, 24)
end

--- Handles a talk with the house owner: talk target 1 runs the invention conversation and no target loads the follow-up event script when flag 6 is set and flag 7 is not.
function palm_brinks_house.talk_to_house_owner()
	local character_slot: s32 = 0
	local talk_id: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	event.set_message_window_mode(0, 1)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	talk_id = event.get_triggered_event_data_2(14) or talk_id
	print("[talk_chara]", talk_id, "\n")
	print("[talk_chara_id]", talk_id, "\n")
	if talk_id == 1 then
		palm_brinks_house.reply_about_invention(character_slot, talk_id)
	end
	if talk_id == -1 then
		flag_6 = event.get_save_flag(6) or flag_6
		flag_7 = event.get_save_flag(7) or flag_7
		if flag_6 == 1 and flag_7 == 0 then
			vm.wait(2)
			event.load_event_script("i01h01/i01h01c_1.stb", 520)
		end
	end
end

return palm_brinks_house
