--!strict
--- Event script for the i05h01 house interior, which plays the e305 cutscene when its save flags are set.

local cutscene = require("@lib/event/cutscene")
local i05_house_h01 = require("@lib/event/i05_house_h01")
local villager_dialogue = require("@lib/event/english/villager_dialogue")

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script[99] = cutscene.noop

--- Plays the e305 cutscene on entry when its save flag is set and not yet finished, then leaves for map m05.
function script.default_event()
	local cutscene_ready_flag: s32 = 0
	local cutscene_done_flag: s32 = 0
	local npc_slot: s32 = 0
	cutscene_ready_flag = event.get_save_flag(304) or cutscene_ready_flag
	cutscene_done_flag = event.get_save_flag(305) or cutscene_done_flag
	if cutscene_ready_flag == 1 and cutscene_done_flag == 0 then
		npc_slot = event.find_scene_character_slot(6) or npc_slot
		event.set_villager_ai_enabled(0, npc_slot)
		event.set_character_active(0, npc_slot)
		i05_house_h01.play_e305_cutscene()
		event.set_villager_ai_enabled(1, npc_slot)
		event.set_character_active(1, npc_slot)
		event.go_to_outside_map(-1, "m05")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button handler with nothing.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script[1000] = villager_dialogue.talk_to_triggered_villager

--- Plays the e305 cutscene with the villager's AI paused.
function script.cutscene_e305()
	local npc_slot: s32 = 0
	npc_slot = event.find_scene_character_slot(6) or npc_slot
	event.set_villager_ai_enabled(0, npc_slot)
	event.set_character_active(0, npc_slot)
	i05_house_h01.play_e305_cutscene()
	event.set_villager_ai_enabled(1, npc_slot)
	event.set_character_active(1, npc_slot)
end
script[13050] = script.cutscene_e305

return script
