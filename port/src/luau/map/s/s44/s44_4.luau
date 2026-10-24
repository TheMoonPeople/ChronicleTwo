--!strict
-- map/s/s44/s44_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18329443 = require("@lib/event/helper_18329443")
local helper_4e838289 = require("@lib/event/helper_4e838289")
local helper_8d7534ab = require("@lib/event/helper_8d7534ab")
local helper_a18f8f8b = require("@lib/event/helper_a18f8f8b")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.Initialize()
	vm.wait(1)
	event.CmrsSetPos(31.07, 49.02, 53.789978)
	event.CmrsSetRef(-33.5, 41.8, 200.70001)
	vm.wait(2)
	helper_c956b4a2(64)
	event.EsmClear()
	event.Finish()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_4e838289()
	event.MapJump_3(-1, "d06b03", 510)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	helper_8d7534ab()
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	vm.wait(2)
	event.LoadDungeonMapFile("d06b01")
	event.LoadScript("d06b01/d06b01.stb", 512)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_18329443()
	event.MapJump_3(-1, "g05", 550)
	vm.wait(2)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_a18f8f8b()
	event.MapJump_3(-1, "g05", 560)
	vm.wait(2)
end

--- Event 570, which map data, a script or the engine runs by number.
function script.event_570()
	helper_18329443()
	helper_a18f8f8b()
	event.MapJump_3(-1, "g05", 560)
	vm.wait(3)
end

--- Event 17440, which map data, a script or the engine runs by number.
script.event_17440 = helper_18329443

--- Event 17480, which map data, a script or the engine runs by number.
function script.event_17480()
	helper_a18f8f8b()
	event.MapJump_3(-1, "g05", 560)
	vm.wait(2)
end

return script
