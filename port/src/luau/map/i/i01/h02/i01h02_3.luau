--!strict
-- map/i/i01/h02/i01h02_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0499eecb = require("@lib/event/helper_0499eecb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_47e5dca9 = require("@lib/event/helper_47e5dca9")
local helper_fe0f3321 = require("@lib/event/helper_fe0f3321")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.initialize_event()
	event.set_character_position(0, -5.0, 0.0, 82.0)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.set_character_motion(0, "立ち")
	event.reset_follow_camera(1)
	event.fade_in_screen(30)
	event.finish_event()
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0499eecb

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	local var1: s32 = 0
	event.set_event_data_field(14, 12)
	var0 = 24
	event.set_event_data_field(13, var0)
	var1 = event.get_save_data_value(0) or var1
	if var1 == 100 then
		helper_47e5dca9()
		event.set_villager_ai_enabled(1, var0)
		return
	end
	helper_fe0f3321()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	local var1: s32 = 0
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_save_data_value(0) or var1
	if var1 == 100 then
		helper_47e5dca9()
		event.set_villager_ai_enabled(1, var0)
		return
	end
	helper_fe0f3321()
end

return script
