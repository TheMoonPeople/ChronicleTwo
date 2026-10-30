--!strict
-- Shared event helper used by 55 scripts, translated by tools/luau/stb2luau.

local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_5a4034b0(arg0: s32, param: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	event.initialize_event()
	event.set_dungeon_pause_flags(513, 1)
	event.start_crossfade(15)
	event.set_nearest_treasure_box_state(0)
	event.set_character_active(0, 0)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	do
		local out1, out2, out3, out4 = event.get_dungeon_event_point(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.set_event_world_coordinate(var2, var3, var4, var5)
	event.copy_monster_to_scene_character(5, arg0, 12)
	event.set_character_active(12)
	event.set_character_position(12, var2, var3, var4)
	event.set_character_rotation(12, 0.0, var5, 0.0)
	event.set_character_motion(12, "閉め", 4)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(0.0, 29.0, 57.0)
	event.set_camera_sequence_look_at(0.0, 10.0, 0.0)
	event.move_camera_sequence(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	wait_frames(15)
	event.set_character_motion(12, "出現", 6)
	wait_frames(36)
	event.delete_character(12, 0)
	event.set_character_active(0, 12)
	event.place_dungeon_monster(arg0, var2, var3, var4, 0.0, var5, 0.0, param)
	event.set_character_active(1, 0)
	event.set_dungeon_pause_flags(513, 0)
	event.finish_event()
end

return helper_5a4034b0
