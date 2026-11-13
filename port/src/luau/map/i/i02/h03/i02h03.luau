--!strict
--- Train Town house interior script that places the player on entry and handles villager dialogue.

local cutscene = require("@lib/event/cutscene")
local map = require("@lib/event/map")
local npc = require("@lib/event/npc")

--- Shows the villager reply about Claire, or the invitation to the usual place when the story flag is set.
local function talk_to_villager_about_claire()
	local flag: s32 = 0
	local villager_slot: s32 = 0
	local talk_target: s32 = 0
	flag = event.get_save_flag(22) or flag
	event.stop_camera_control_movement()
	villager_slot = event.get_triggered_event_data_2(13) or villager_slot
	talk_target = event.get_triggered_event_data_2(14) or talk_target
	event.set_villager_ai_enabled(0, villager_slot)
	if talk_target == 13 then
		if flag ~= 0 then
			event.open_message_window_2(
				0,
				"Maximilian! I found something\ninteresting. Come to the usual\nplace and I'll show you."
			)
		else
			event.open_message_window_2(0, "Claire? No idea.")
		end
	else
		event.open_message_window_2(
			0,
			"Oh Claire. I just saw her.\nShe sure is a pretty one.<page>I was just looking at her,\nbut I don't remember where\nshe went."
		)
	end
	cutscene.talk(villager_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, villager_slot)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs once when the script loads and needs no setup.
function script.setup() end

--- Places the player at the entrance and resets the follow camera when the interior is entered.
function script.default_event()
	cutscene.noop()
	event.set_character_position(0, 5.0, -0.54, 25.0)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Event 200, which map data, a script or the engine runs by number.
script[200] = map.enter_door

--- Starts the dialogue with the villager that was spoken to unless the story has progressed past the point where they talk.
function script.on_talk()
	local story_progress: s32 = 0
	story_progress = event.get_save_data_value(0) or story_progress
	if story_progress == 100 then
		talk_to_villager_about_claire()
		return
	end
	npc.talk_to_triggered_npc()
end
script[1000] = script.on_talk

return script
