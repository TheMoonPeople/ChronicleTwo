--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_69d65e1a()
	local stage_id: s32 = 0
	local var1: s32 = 0
	local argc: s32 = 0
	stage_id = event.get_dungeon_stage_id() or stage_id
	var1 = event.get_dungeon_floor() or var1
	argc = event.get_dungeon_next_floor(var1, 0) or argc
	event.set_dungeon_floor(argc)
	event.set_dungeon_floor_info(stage_id, var1, 5, 2)
	event.set_dungeon_floor_info(stage_id, argc, 5, 1)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(13)
	event.delete_character(14)
	event.delete_character(15)
	event.initialize_sphida()
	event.set_dungeon_pause_flags(8192, 0)
	event.reset_action_character_motion(0)
	event.set_save_control_bits(1, 0)
	event.set_character_change_unmasked(0, 1)
	event.set_character_change_unmasked(2, 1)
	event.set_character_change_unmasked(1, 1)
	event.set_character_change_unmasked(3, 1)
	event.stop_music(0)
	event.stop_environment_music()
	event.stop_map_object_sounds()
	wait_frames(6)
	event.load_music(17)
	event.load_map_sounds(3601)
	event.play_music(0)
	event.load_event_script("d03/d03.stb", 1000)
end

return helper_69d65e1a
