--!strict
-- map/i/i02/h03/i02h03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_0fc04819 = require("@lib/event/helper_0fc04819")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_4e319702 = require("@lib/event/helper_4e319702")

--- Helper function.
local function helper_35c84()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	flag = event.get_save_flag(22) or flag
	event.stop_camera_control_movement()
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	event.set_villager_ai_enabled(0, var1)
	if var2 == 13 then
		if flag ~= 0 then
			event.open_message_window_2(
				0,
				"Maximilian! I found something\ninteresting. Come to the usual\nplace and I'll show you."
			)
		else
			event.open_message_window_2(0, "Claire? No idea.")
		end
	else
		event.open_message_window_2(
			0,
			"Oh Claire. I just saw her.\nShe sure is a pretty one.<page>I was just looking at her,\nbut I don't remember where\nshe went."
		)
	end
	helper_1c04a0eb(var1, -1, 0, 0)
	event.set_villager_ai_enabled(1, var1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_1ef0d4b2()
	event.set_character_position(0, 5.0, -0.54, 25.0)
	event.set_character_rotation(0, 0, 3.14, 0)
	event.reset_follow_camera(1, 0.0, 10.0)
end

--- Event 200, which map data, a script or the engine runs by number.
script.event_200 = helper_0fc04819

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		helper_35c84()
		return
	end
	helper_4e319702()
end

return script
