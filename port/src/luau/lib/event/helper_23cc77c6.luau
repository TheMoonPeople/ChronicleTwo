--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_frames = require("@lib/event/wait_frames")

--- Helper function.
local function helper_23cc77c6()
	local time: f32 = 0
	event.initialize_event()
	vm.wait(1)
	event.stop_music(0)
	wait_frames(4)
	event.load_music(39)
	event.play_music(0)
	time = event.get_scene_time_of_day() or time
	event.set_save_counter(10, time)
	event.set_time_of_day(24.0)
	event.set_time_of_day_advancing(0)
	event.load_dungeon_monster(621, 1)
	event.load_dungeon_monster(622, 0)
	event.place_dungeon_monster(621, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
	event.place_dungeon_monster(622, -3.84976, 5016.45, 9390.18, 1.0471976, 0.0, 0.0)
	event.control_stopwatch(3, 350, 370, 1)
	event.control_stopwatch(2, 18000)
	event.control_stopwatch_1(0)
	vm.wait(3)
	event.fade_in_screen(30)
	event.finish_event()
end

return helper_23cc77c6
