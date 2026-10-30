--!strict
-- map/g/g05/g05_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b5f317 = require("@lib/event/helper_19b5f317")
local helper_2b32f1e8 = require("@lib/event/helper_2b32f1e8")
local helper_38a7fa45 = require("@lib/event/helper_38a7fa45")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_f38eabca = require("@lib/event/helper_f38eabca")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_f8f4d75e = require("@lib/event/helper_f8f4d75e")
local wait_frames = require("@lib/event/wait_frames")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	event_99()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.reset_follow_camera(1, 3.14, 10.0)
		event.fade_in_screen(30)
	else
		old_map_no = event.get_previous_map() or old_map_no
		var2 = event.get_map_type(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_9dafbc83(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			else
				helper_9dafbc83(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.reset_follow_camera(1, 3.14, 10.0)
				event.fade_in_screen(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_f8f4d75e(155) ~= 0 then
		event.jump_to_map_2(-1, "s34")
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	if helper_f8f4d75e(109) ~= 0 then
		flag = event.get_save_flag(702) or flag
		if flag == 0 then
			event.skip_next_music_load()
		end
		event.jump_to_map_2(-1, "d06e01")
	end
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	if (if helper_38a7fa45() ~= 0 then helper_2b32f1e8() else 0) ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_flag(744, 1)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 570)
		vm.wait(2)
	end
	if helper_38a7fa45() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_flag(744, 1)
		event.jump_to_map_3(-1, "s44", 550)
		vm.wait(4)
	end
	if helper_2b32f1e8() ~= 0 then
		event.set_character_motion(0, "立ち")
		event.fade_out_screen(30)
		wait_frames(30)
		event.set_save_flag(748, 1)
		event.jump_to_map_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_19b5f317()
	event.set_save_data_value(0, 9)
	event.load_map_sounds(7000)
	helper_9dafbc83(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.set_camera_look_at(0.0, 30.0, -1000.0)
	event.set_camera_position(0.0, 50.0, -880.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.set_camera_look_at(0.0, 30.0, -1100.0)
	event.set_camera_position(0.0, 50.0, -1220.0)
	event.reset_follow_camera(0)
	event.fade_in_screen(30)
	wait_frames(30)
	event.add_inventory_item(198, 1)
	event.add_inventory_item(199, 1)
	helper_f38eabca(198, 1)
	helper_f38eabca(199, 1)
	helper_a87eb945(1)
end

return script
