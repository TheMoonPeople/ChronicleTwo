--!strict
--- Holds the German scoop memo and Photography level conversations.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")

local scoop_exchange = {}

--- Reads the scoop menu result, then has the collector either demand more scoops or explain how the Photography level and its rewards work.
function scoop_exchange.answer_scoop_menu(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local menu_status: s32 = 0
	local selected_option: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		do
			local out1, out2 = event.get_menu_value_3(6)
			menu_status = out1 or menu_status
			selected_option = out2 or selected_option
		end
		if 0 < menu_status then
			return 1
		end
		if selected_option == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
			if current_map == 22 then
				resume_point = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_point = 2
				message.show_and_wait(window, -1, 3, 256, 208)
			end
		end
		if selected_option == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
			)
			if current_map == 22 then
				resume_point = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_point = 4
				message.show_and_wait(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_point <= 4 then
			if resume_point <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_point <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_point <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

--- Asks for a Scoop Memo when none is held, otherwise announces how many new scoops it turned up and ends with the scoop hint.
function scoop_exchange.report_scoops(window: s32)
	local character_slot: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local scoop_memo_count: s32 = 0
	local found_scoops: s32 = 0
	local total_scoops: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		scoop_memo_count = event.get_owned_item_count(355) or scoop_memo_count
		if scoop_memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, character_slot, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			found_scoops = out1 or found_scoops
			total_scoops = out2 or total_scoops
		end
		if found_scoops == total_scoops then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, character_slot, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
			resume_step = 5
			return scoop_exchange.show_scoop_hint(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
			event.set_message_draw_speed(window, 0)
			resume_step = 6
			message.show(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(
				window,
				"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
			)
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
		end
		if map_id == 22 then
			resume_step = 7
			message.say_bubble(window, -1, character_slot, player_slot, 0)
		else
			resume_step = 8
			message.show(window, -1, 3, 256, 208)
		end
		resume_step = 9
		return scoop_exchange.show_scoop_hint(window)
	end, function(received: { any })
		if resume_step <= 2 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_step <= 5 then
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_step <= 9 then
			if resume_step <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_then_close(window, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Has the collector ask for a Scoop Memo when the player has none, otherwise reports the scoops figured out and the new scoops gained, then answers the scoop menu.
function scoop_exchange.report_scoops_and_answer_menu(window: s32)
	local npc_character: s32 = 0
	local player_character: s32 = 0
	local current_map: s32 = 0
	local memo_count: s32 = 0
	local scoops_found: s32 = 0
	local scoops_total: s32 = 0
	local new_scoop_count: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_character = event.get_triggered_event_data_2(13) or npc_character
		player_character = event.get_player_character_slot() or player_character
		current_map = event.get_current_map() or current_map
		memo_count = event.get_owned_item_count(355) or memo_count
		if memo_count <= 0 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Bring mir mal ein paar\nKn[UNI00fc]ller-Notizen, ja?")
			if current_map == 22 then
				resume_point = 1
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_point = 2
				message.show_and_wait(window, -1, 3, 256, 208)
			end
			return 0
		end
		do
			local out1, out2 = event.get_menu_value_3(5)
			scoops_found = out1 or scoops_found
			scoops_total = out2 or scoops_total
		end
		if scoops_found == scoops_total then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Sieht aus, als g[UNI00e4]be es\nkeine weiteren Kn[UNI00fc]ller mehr.")
			if current_map == 22 then
				resume_point = 3
				message.say_bubble(window, -1, npc_character, player_character, 0)
			else
				resume_point = 4
				message.show_and_wait(window, -1, 3, 256, 208)
			end
			resume_point = 5
			return scoop_exchange.answer_scoop_menu(window)
		end
		new_scoop_count = event.get_menu_value_2(3) or new_scoop_count
		if 0 < new_scoop_count then
			message.set_window_mode(window, 8)
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Ich hab noch [Number1] Kn[UNI00fc]ller\nherausgefunden.")
			event.set_message_draw_speed(window, 0)
			resume_point = 6
			message.show_and_wait(window, -1, 8, 0, 0)
		end
		message.set_window_mode(window, 1)
		new_scoop_count = event.get_menu_value_2(4) or new_scoop_count
		if new_scoop_count <= 0 then
			event.open_message_window_2(
				window,
				"Komm schon, Mann! H[UNI00e4]ng nicht nur rum!\nWo bleiben deine neuen\nInsider-Kn[UNI00fc]ller?"
			)
		else
			event.set_message_number(window, 1, new_scoop_count)
			event.open_message_window_2(window, "Juhu! Du hast [Number1] neue(n) Kn[UNI00fc]ller!\nIch wusste, dass du's schaffst!")
		end
		if current_map == 22 then
			resume_point = 7
			message.say_bubble(window, -1, npc_character, player_character, 0)
		else
			resume_point = 8
			message.show_and_wait(window, -1, 3, 256, 208)
		end
		resume_point = 9
		return scoop_exchange.answer_scoop_menu(window)
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		if resume_point <= 5 then
			if resume_point <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		if resume_point <= 9 then
			if resume_point <= 6 then
				message.set_window_mode_stub(window, 1)
				message.show_bubble_and_close(window, -1, npc_character, player_character, 0)
			end
			if resume_point <= 7 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return message.is_ready(window)
		end
		return nil
	end)
end

--- Shows the scoop reminder or the Photography level explanation selected by the photo menu state, returning 1 without showing anything when the first menu value is positive.
function scoop_exchange.show_scoop_hint(window: s32)
	local character_slot: s32 = 0
	local player_slot: s32 = 0
	local map_id: s32 = 0
	local first_menu_value: s32 = 0
	local hint_kind: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		player_slot = event.get_player_character_slot() or player_slot
		map_id = event.get_current_map() or map_id
		do
			local out1, out2 = event.get_menu_value_3(6)
			first_menu_value = out1 or first_menu_value
			hint_kind = out2 or hint_kind
		end
		if 0 < first_menu_value then
			return 1
		end
		if hint_kind == 1 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(window, "Wenn du mir keine Kn[UNI00fc]ller lieferst,\nkann ich dir nichts geben!")
			if map_id == 22 then
				resume_step = 1
				message.say_bubble(window, -1, character_slot, player_slot, 0)
			else
				resume_step = 2
				message.show(window, -1, 3, 256, 208)
			end
		end
		if hint_kind == 2 then
			message.set_window_mode(window, 1)
			event.open_message_window_2(
				window,
				"Deine Fotografie-Stufe h[UNI00e4]ngt ab\nvon der Anzahl Ideen und Kn[UNI00fc]ller,\ndie du hast.<page>Je weiter deine Stufe steigt, umso\nmehr coole Belohnungen kriegst du."
			)
			if map_id == 22 then
				resume_step = 3
				message.say_bubble(window, -1, character_slot, player_slot, 0)
			else
				resume_step = 4
				message.show(window, -1, 3, 256, 208)
			end
		end
		return 0
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			if resume_step <= 2 then
				message.set_window_mode_stub(window, 1)
				message.show_then_close(window, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 3 then
				message.show_and_close(window, -1, 3, 256, 208)
			end
			return 0
		end
		return nil
	end)
end

return scoop_exchange
