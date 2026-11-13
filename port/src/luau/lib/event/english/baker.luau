--!strict
--- English dialogue for the baker who comments on Max.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local baker = {}

--- Plays the baker's idle chat about Max, with a different line in chapter 8.
function baker.chat_about_max(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"You're the girl that's been\nhanging around with Max lately.<page>I know a good man\nwhen I see one."
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "If I was just a little bit younger,\nI wouldn't let that one go.")
	else
		event.open_message_window_2(0, "If you're ever in the mood for\nbread, you know where to find me.")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

return baker
