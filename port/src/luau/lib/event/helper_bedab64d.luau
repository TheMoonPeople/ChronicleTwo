--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_473930cd = require("@lib/event/helper_473930cd")
local helper_59c8e763 = require("@lib/event/helper_59c8e763")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_bedab64d(arg0: s32, arg1: s32)
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	event.open_message_window_2(0, "Ich hab dich erwartet.<page>Schnell, gib mir die Farbe,\ndann kann ich das Bild beleben.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if item ~= 376 then
		event.open_message_window_2(0, "Du machst Witze!<page>Ich brauche goldene Farbe.\nUnd nichts anderes!")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "Das ist die goldene Farbe ...\nIch probiere sie sofort aus.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "S ... sie ... sie lebt ...<page>Unglaublich, sie ist perfekt!")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Danke, Max.\nIch halte mein Versprechen. Nutze\nmeine neue Kraft, wann du willst.")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_473930cd()
	event.set_npc_party_status(22, 130)
	helper_59c8e763(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

return helper_bedab64d
