--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local wait_camera = require("@lib/event/wait_camera")

--- Helper function.
local function helper_7595bb3d()
	local var0: f32 = 0
	event.set_camera_sequence_position(396.92, 146.86, -175.05)
	event.set_camera_sequence_look_at(744.44, 257.9, -23.8)
	event.set_time_of_day(6.5)
	var0 = 6.5
	while true do
		var0 = vm.f32(var0 + vm.f32(0.004))
		event.set_time_of_day(var0)
		vm.wait(1)
		if var0 > vm.f32(6.8) then
			break
		end
	end
	event.mark_camera_sequence_fade_track()
	event.delay_camera_sequence_fade_track(190)
	event.fade_out_camera_sequence(60, 0.0, 0.0, 0.0)
	event.clear_camera_sequence_path()
	event.set_camera_sequence_path_frames(250)
	event.add_camera_sequence_path_point(396.92, 146.86, -175.05, 744.44, 257.9, -23.8)
	event.add_camera_sequence_path_point(104.88, 122.77, 6.77, 326.18, 70.53, 147.12)
	event.start_camera_sequence_path()
	wait_camera()
end

return helper_7595bb3d
