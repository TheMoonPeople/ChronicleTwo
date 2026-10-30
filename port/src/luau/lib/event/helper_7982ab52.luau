--!strict
-- Shared event helper used by 42 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7982ab52()
	local get_now_horl: s32 = 0
	event.set_active_camera_slot(1)
	event.set_previous_camera_slot(0)
	event.set_follow_camera_offset(0.0, 30.0, 0.0)
	event.set_follow_camera_height(5.0)
	event.set_follow_camera_distance(160.0)
	event.set_camera_speed(6.0)
	event.set_camera_rotation_cancel_mask(1)
	event.set_camera_control_range(18.0, 10.0, 100.0, 160.0)
	event.reset_follow_camera(0)
	get_now_horl = event.get_sphida_saved_hole() or get_now_horl
	if get_now_horl == 0 then
		event.load_event_script("d02/d02_sfida.stb", 6000)
		return
	end
	if get_now_horl == 1 then
		event.load_event_script("d03/d03_sfida.stb", 6000)
		return
	end
	if get_now_horl == 2 then
		event.load_event_script("d04/d04_sfida.stb", 6000)
		return
	end
	if get_now_horl == 3 then
		event.load_event_script("d05/d05_sfida.stb", 6000)
		return
	end
	if get_now_horl == 4 then
		event.load_event_script("d05/d05_sfida.stb", 6001)
		return
	end
	if get_now_horl == 5 then
		event.load_event_script("d06/d06_sfida.stb", 6000)
		return
	end
	if get_now_horl == 6 then
		event.load_event_script("d07/d07_sfida.stb", 6000)
		return
	end
	if get_now_horl == 7 then
		event.load_event_script("d01/d01_sfida.stb", 6001)
		return
	end
end

return helper_7982ab52
