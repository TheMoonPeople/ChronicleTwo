--!strict
--- Floor script for a small swamp room where a sprout is grown with items.

local vm = require("@lib/vm")
local message = require("@lib/event/message")
local rainbow_butterfly_wood_boss_3 = require("@lib/event/rainbow_butterfly_wood_boss_3")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded.
function script.setup() end

--- Shows a placeholder message when the square button is pressed.
function script.key_open()
	event.open_message_window_2(0, "どどーん")
	message.show(0, -1, 8, 0, 0)
end

--- Places the player at the room entrance and fades in.
function script.enter_floor()
	event.set_character_position(0, -124.13, 782.88, -644.77)
	event.fade_in_screen(30)
	event.reset_follow_camera(0)
end
script[200] = script.enter_floor

--- Describes the swamp or sprout and lets the player use items to grow it.
function script.examine_sprout_spot()
	local trigger_type: s32 = 0
	local flag: s32 = 0
	local item: s32 = 0
	print("event400\n")
	trigger_type = event.get_triggered_event_data_2(6) or trigger_type
	if trigger_type == 1 then
		flag = event.get_save_flag(24) or flag
		if flag ~= 0 then
		else
			flag = event.get_save_flag(23) or flag
			if flag ~= 0 then
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(
					0,
					"Il y a une pousse [UNI00e9]norme ici.\nMais quelque chose manque on dirait.<page>Une sorte d'engrais pour plantes... ?\n(Choisis (#) pour ouvrir le menu.)"
				)
				message.show(0, -1, 5, 0, 0)
				event.set_message_bubble_tail(0, 1)
			else
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(
					0,
					"Il y a un petit [UNI00e9]tang ici. Il\na l'air plut[UNI00f4]t myst[UNI00e9]rieux...\n(Choisis (#) pour ouvrir le menu.)"
				)
				message.show(0, -1, 5, 0, 0)
				event.set_message_bubble_tail(0, 1)
			end
		end
	end
	if trigger_type == 2 then
		flag = event.get_save_flag(24) or flag
		if flag ~= 0 then
		else
			flag = event.get_save_flag(23) or flag
			if flag ~= 0 then
				event.open_use_item_menu(356)
				vm.wait(3)
				item = vmhost.used_item() or item
				if item == 356 then
					rainbow_butterfly_wood_boss_3.show_event_255b_message()
					event.set_save_flag(24, 1)
				else
					rainbow_butterfly_wood_boss_3.show_wrong_item_message()
				end
			else
				event.open_use_item_menu(361)
				vm.wait(6)
				item = vmhost.used_item() or item
				if item == 361 then
					rainbow_butterfly_wood_boss_3.show_event_255a_message()
					event.set_save_flag(23, 1)
				else
					rainbow_butterfly_wood_boss_3.show_wrong_item_message()
				end
			end
		end
	end
end
script[400] = script.examine_sprout_spot

return script
