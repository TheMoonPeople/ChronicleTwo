--!strict
-- map/i/i01/h04/i01h04.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_4e319702 = require("@lib/event/helper_4e319702")

--- Helper function.
local function helper_35ab4()
	local chara_no: s32 = 0
	event.stop_camera_control_movement()
	chara_no = 24
	event.set_villager_ai_enabled(0, chara_no)
	event.open_message_window_2(0, "Claire? I don't know.<page>She might be at the \nsquare drinking tea.")
	helper_1c04a0eb(chara_no, -1, 0, 0)
	event.set_villager_ai_enabled(1, chara_no)
end

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
		helper_35ab4()
		return
	end
	event.set_event_data_field(14, 15)
	chara_id = event.get_character_slot_by_number(15) or chara_id
	event.set_event_data_field(13, chara_id)
	helper_4e319702()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.get_save_data_value(0) or var0
	if var0 == 100 then
		helper_35ab4()
		return
	end
	helper_4e319702()
end

return script
