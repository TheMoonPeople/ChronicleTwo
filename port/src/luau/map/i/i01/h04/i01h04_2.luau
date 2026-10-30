--!strict
-- map/i/i01/h04/i01h04_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_2a9040b5 = require("@lib/event/helper_2a9040b5")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	local var0: s32 = 0
	local chara_id: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		helper_1ef0d4b2()
		return
	end
	event.set_event_data_field(14, 15)
	chara_id = event.get_character_slot_by_number(15) or chara_id
	event.set_event_data_field(13, chara_id)
	helper_2a9040b5()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		helper_1ef0d4b2()
		return
	end
	helper_2a9040b5()
end

return script
