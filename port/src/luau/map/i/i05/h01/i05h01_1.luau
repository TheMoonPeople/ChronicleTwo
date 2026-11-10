--!strict
-- map/i/i05/h01/i05h01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_02d91c01 = require("@lib/event/helper_02d91c01")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_264b9d7e = require("@lib/event/helper_264b9d7e")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var2: s32 = 0
	flag = event.get_save_flag(304) or flag
	flag_2 = event.get_save_flag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		var2 = event.find_scene_character_slot(6) or var2
		event.set_villager_ai_enabled(0, var2)
		event.set_character_active(0, var2)
		helper_264b9d7e()
		event.set_villager_ai_enabled(1, var2)
		event.set_character_active(1, var2)
		event.go_to_outside_map(-1, "m05")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_02d91c01

--- Event 13050, which map data, a script or the engine runs by number.
function script.event_13050()
	local var0: s32 = 0
	var0 = event.find_scene_character_slot(6) or var0
	event.set_villager_ai_enabled(0, var0)
	event.set_character_active(0, var0)
	helper_264b9d7e()
	event.set_villager_ai_enabled(1, var0)
	event.set_character_active(1, var0)
end

return script
