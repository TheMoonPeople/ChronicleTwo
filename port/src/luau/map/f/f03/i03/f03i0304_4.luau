--!strict
-- map/f/f03/i03/f03i0304_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3300e99f = require("@lib/event/helper_3300e99f")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_e2ebceb9 = require("@lib/event/helper_e2ebceb9")
local wait_frames = require("@lib/event/wait_frames")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	helper_1ef0d4b2()
	event.fade_in_screen(20)
	helper_7d7eee8f(vm.f32(87.9), vm.f32(69.1), -196.5, vm.f32(1.55))
	event.reset_follow_camera(1, 3.14)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

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
script.event_1000 = helper_e2ebceb9

return script
