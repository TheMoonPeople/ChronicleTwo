--!strict
-- map/d/d02/b03/d02b03_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_809572a3 = require("@lib/event/helper_809572a3")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_bab47811 = require("@lib/event/helper_bab47811")
local helper_f7808303 = require("@lib/event/helper_f7808303")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.MesMake_2(0, "どどーん")
	helper_a3cc6850(0, -1, 8, 0, 0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	event.SetCharaPos(0, -124.13, 782.88, -644.77)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	print("event400\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"There's a huge sprout here.\nSeems something's still missing.<page>Maybe an item to make plants grow faster...?\n(Use (#) to open the menu.)"
				)
				helper_a3cc6850(0, -1, 5, 0, 0)
				event.SetMesShippo(0, 1)
			else
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"There's a tiny swamp here. There's something\nkind of mysterious about it...\n(Use (#) to open the menu.)"
				)
				helper_a3cc6850(0, -1, 5, 0, 0)
				event.SetMesShippo(0, 1)
			end
		end
	end
	if var0 == 2 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				var2 = event.GotoUseItem(356) or var2
				vm.wait(3)
				if var2 == 356 then
					helper_f7808303()
					event.SetFlag(24, 1)
				else
					helper_bab47811()
				end
			else
				var2 = event.GotoUseItem(361) or var2
				vm.wait(6)
				if var2 == 361 then
					helper_809572a3()
					event.SetFlag(23, 1)
				else
					helper_bab47811()
				end
			end
		end
	end
end

return script
