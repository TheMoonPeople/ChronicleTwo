--!strict
--- French dialogue for the NPC worried about Max's safety.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local message = vm.module("@lib/event/message")

local max_concern = {}

--- Plays the idle chat in which the NPC worries about Max, with a different line in chapter 8.
function max_concern.chat_about_max(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Je t'en prie, arr[UNI00ea]te de mettre Max\ndans des situations dangereuses.")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "S'il a ne serait-ce qu'une\n[UNI00e9]gratignure, jamais je ne te\nle pardonnerai !")
	else
		event.open_message_window_2(0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

return max_concern
