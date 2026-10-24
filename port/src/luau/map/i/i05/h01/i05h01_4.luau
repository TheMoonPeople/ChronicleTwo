--!strict
-- map/i/i05/h01/i05h01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local helper_03ef7038 = require("@lib/event/helper_03ef7038")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_cbaafb13 = require("@lib/event/helper_cbaafb13")

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
	flag = event.GetFlag(304) or flag
	flag_2 = event.GetFlag(305) or flag_2
	if flag == 1 and flag_2 == 0 then
		var2 = event.SearchCharaNo(6) or var2
		event.SetAi(0, var2)
		event.CharaActive(0, var2)
		helper_cbaafb13()
		event.SetAi(1, var2)
		event.CharaActive(1, var2)
		event.GotoOutside(-1, "m05")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_03ef7038

--- Event 13050, which map data, a script or the engine runs by number.
function script.event_13050()
	local var0: s32 = 0
	var0 = event.SearchCharaNo(6) or var0
	event.SetAi(0, var0)
	event.CharaActive(0, var0)
	helper_cbaafb13()
	event.SetAi(1, var0)
	event.CharaActive(1, var0)
end

return script
