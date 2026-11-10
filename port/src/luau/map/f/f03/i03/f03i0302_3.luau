--!strict
-- map/f/f03/i03/f03i0302_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_421a3242 = require("@lib/event/helper_421a3242")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_ca023157 = require("@lib/event/helper_ca023157")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	helper_1ef0d4b2()
	flag = event.get_save_flag(400) or flag
	if flag == 1 then
		flag_2 = event.get_save_flag(428) or flag_2
		if flag_2 == 0 then
			event.add_inventory_item(373)
			helper_ca023157()
			return
		end
	end
	helper_9dafbc83(62.0, vm.f32(69.1), -197.0, vm.f32(1.57))
	event.reset_follow_camera(1, 3.14, 10)
	event.fade_in_screen(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_ca023157

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

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_421a3242

--- Event 14280, which map data, a script or the engine runs by number.
function script.event_14280()
	helper_1ef0d4b2()
	helper_ca023157()
end

return script
