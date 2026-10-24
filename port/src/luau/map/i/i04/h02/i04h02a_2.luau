--!strict
-- map/i/i04/h02/i04h02a_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_3da8a7c5 = require("@lib/event/helper_3da8a7c5")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.Initialize()
	event.SetAi(0, 8)
	event.CharaActive(0, 8)
	event.SetCameraPos(19.51, 30.7, -34.38)
	event.SetCameraRef(49.07, 14.1, 12.65)
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetCharaPos(0, 30.65, 0.0, -2.05)
	event.SetCharaRot(0, 0.0, 1.3, 0.0)
	event.SetMotion(0, "立ち")
	event.LoadChara(5, "chara/tp01_16a.gltf", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, 48.62, 0.0, 3.43)
	event.SetCharaRot(8, 0.0, -1.78, 0.0)
	event.SetMotion(8, "待機")
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_3da8a7c5

return script
