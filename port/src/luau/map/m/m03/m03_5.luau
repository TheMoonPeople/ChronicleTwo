--!strict
-- map/m/m03/m03_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_7dfaaca0 = require("@lib/event/helper_7dfaaca0")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event_99()
	print("e109a kita----------\n")
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	vm.section(function()
		event.Initialize()
		event.AssignStack(5)
		event.ClearStack(5)
		event.LoadChara(5, "event/e100/e109/e109_starble.chr", "info", 32)
		event.EohSyncChara(0, 32)
		event.ObjsInit(0)
		event.ObjsSyncObj(0, 0)
		print("m03-e109a---------------------------------\n")
		event.InitDramaScene()
		event.CharaActive(0, 0)
		event.CharaActive(1, 32)
		event.CmrsSetPos(1984.9, 50.0, 3002.6)
		event.CmrsSetRef(1984.9, 30.0, 2882.6)
		event.ObjsSetPos(0, 1984.9, 0.0, 2882.6)
		event.ObjsSetRot(0, 0.0, 0.0, 0.0)
		vm.wait(1)
		helper_c956b4a2(64)
		event.CancelDramaScene()
	end)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.DeleteChara(32)
	event.CharaActive(1, 0)
	event.SetFadeIn(30)
end

--- Event 11091, which map data, a script or the engine runs by number.
function script.event_11091()
	helper_7dfaaca0()
	event.CancelLoadVillager()
	vm.wait(2)
	event.GotoInterior(-1, "i03h01a", 500)
	vm.wait(3)
end

return script
