--!strict
-- map/f/f03/i03/f03i0301_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_57a574ab = require("@lib/event/helper_57a574ab")
local helper_9923d5d6 = require("@lib/event/helper_9923d5d6")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_daeaeed0 = require("@lib/event/helper_daeaeed0")
local helper_e2ebceb9 = require("@lib/event/helper_e2ebceb9")
local helper_f2d7de86 = require("@lib/event/helper_f2d7de86")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	helper_daeaeed0()
	flag = event.get_save_flag(400) or flag
	flag_2 = event.get_save_flag(408) or flag_2
	if flag == 1 then
		if flag_2 == 0 then
			flag_3 = event.get_save_flag(414) or flag_3
			if flag_3 == 0 then
				helper_57a574ab()
				return
			end
		else
			flag_4 = event.get_save_flag(412) or flag_4
			if flag_4 == 0 then
				event.add_inventory_item(360)
				helper_f2d7de86()
				return
			end
		end
	end
	helper_9dafbc83(0.0, vm.f32(69.1), -200.0, vm.f32(-1.57))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_f2d7de86

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	helper_3300e99f(vm.f32(3.1415927))
	event.set_character_motion(0, "立ち")
	var0 = event.get_sound_id(2) or var0
	event.play_sound_effect(var0, 94)
	event.fade_out_screen(30)
	wait_frames(30)
	event.jump_to_map_2(-1, "f03")
	vm.wait(3)
end

--- Event 504, which map data, a script or the engine runs by number.
function script.event_504()
	helper_daeaeed0()
	event.add_inventory_item(154)
	helper_9923d5d6()
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_e2ebceb9

--- Event 14120, which map data, a script or the engine runs by number.
function script.event_14120()
	event.set_save_flag(408, 1)
	helper_daeaeed0()
	helper_f2d7de86()
end

--- Event 14140, which map data, a script or the engine runs by number.
function script.event_14140()
	event.set_save_flag(408, 0)
	helper_daeaeed0()
	helper_57a574ab()
end

--- Event 14680, which map data, a script or the engine runs by number.
function script.event_14680()
	helper_daeaeed0()
	helper_9923d5d6()
end

return script
