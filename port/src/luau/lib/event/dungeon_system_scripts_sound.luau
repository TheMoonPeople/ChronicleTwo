--!strict
--- Sound helpers for the dungeon system scripts: stage-specific sound numbers.


local dungeon_system_scripts_sound = {}

--- Returns the sound number of the treasure box opening sound for the current dungeon stage.
function dungeon_system_scripts_sound.get_stage_sound_number()
	local stage_id: s32 = 0
	local sound_number: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	sound_number = 0
	if stage_id == 0 or stage_id == 1 then
		sound_number = 110
	end
	if false then
		sound_number = 111
	end
	if stage_id == 2 or stage_id == 3 or stage_id == 4 or stage_id == 5 then
		sound_number = 112
	end
	return sound_number
end

return dungeon_system_scripts_sound
