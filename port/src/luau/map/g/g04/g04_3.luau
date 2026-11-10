--!strict
-- map/g/g04/g04_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10d6108d = require("@lib/event/helper_10d6108d")
local helper_36d61aed = require("@lib/event/helper_36d61aed")
local helper_43769d3d = require("@lib/event/helper_43769d3d")
local helper_5a735084 = require("@lib/event/helper_5a735084")
local helper_981c86d9 = require("@lib/event/helper_981c86d9")
local helper_9c5b9382 = require("@lib/event/helper_9c5b9382")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9e1e3514 = require("@lib/event/helper_9e1e3514")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_d622cd71 = require("@lib/event/helper_d622cd71")
local helper_e6350d48 = require("@lib/event/helper_e6350d48")
local helper_ebad0649 = require("@lib/event/helper_ebad0649")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local var1: s32 = 0
	local mc_load: s32 = 0
	event.initialize_event()
	event_99()
	mc_load = event.take_memory_card_load_state() or mc_load
	if mc_load == 1 then
		event.set_character_position(0, -1349.6, 0.0, -1351.7)
		event.set_character_rotation(0, 0.0, 1.03, 0.0)
		event.set_character_motion(0, "立ち", 4)
		event.update_character_motion(0)
		event.reset_character_cloth_and_hair(0)
		event.reset_follow_camera(1, 0.0, 20.0)
	else
		old_map_no = event.get_previous_map() or old_map_no
		var1 = event.get_map_type(old_map_no) or var1
		if var1 ~= -1 then
			if old_map_no ~= 3 then
				if var1 == 7 or var1 == 8 then
					helper_43769d3d()
				elseif old_map_no == 102 then
					helper_9dafbc83(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
					event.reset_follow_camera(1, 0.0, 10.0)
					event.fade_in_screen(15)
				else
					helper_9c5b9382()
				end
			end
		end
	end
	helper_9e1e3514(1)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	helper_ebad0649(vm.f32(1773.7), 0.0, -418.0, vm.f32(-1.22))
	if (if helper_d622cd71() == 0 and helper_10d6108d() == 0 then helper_981c86d9() else 0) ~= 0 then
		event.skip_next_music_play()
	end
	if helper_5a735084() ~= 0 then
		event.jump_to_map_2(-1, "s39")
		vm.wait(2)
		return
	end
	event.jump_to_map_2(-1, "f04")
	vm.wait(3)
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	helper_9e1e3514(0)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.initialize_event()
	event_99()
	helper_9dafbc83(1680.0, 0.0, -420.0, vm.f32(1.57))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
	helper_9e1e3514(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.initialize_event()
	helper_9dafbc83(vm.f32(1982.08), 0.0, vm.f32(-201.51), vm.f32(-1.58))
	event.reset_follow_camera(1, 3.14, 10.0)
	event.fade_in_screen(30)
	vm.wait(1)
end

--- Event 551, which map data, a script or the engine runs by number.
function script.event_551()
	if helper_36d61aed() ~= 0 then
		event.jump_to_map_2(-1, "s10")
		vm.wait(2)
	end
end

--- Event 552, which map data, a script or the engine runs by number.
function script.event_552()
	local var2: s32 = 0
	if helper_e6350d48() ~= 0 then
		event.set_dungeon_stage_id(4)
		event.open_event_menu(3, 4)
		vm.wait(2)
		do
			local _, _, out3, _ = event.get_menu_results_4()
			var2 = out3 or var2
		end
		if var2 == 0 then
			helper_43769d3d()
		else
			if var2 == 21 then
				event.skip_next_music_load()
			end
			event.go_to_dungeon(4, var2, 1010)
		end
	end
end

return script
