--!strict
--- German dialogue for the swordsmith.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local swordsmith = {}

--- Plays the swordsmith's idle chat about swords and polished stones, with a different line in chapter 8.
function swordsmith.chat_about_swords(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"Das Glitzern eines guten\nSchwertes ist einfach unvergleichlich.<page>Es raubt einem den Atem."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "Ich verstehe nicht, wie man\nimmer nur Steine polieren kann.")
	else
		event.open_message_window_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

return swordsmith
