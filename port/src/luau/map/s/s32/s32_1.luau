--!strict
-- map/s/s32/s32_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01056549 = require("@lib/event/helper_01056549")
local helper_10731042 = require("@lib/event/helper_10731042")
local helper_1e6f252b = require("@lib/event/helper_1e6f252b")
local helper_4e42f7c7 = require("@lib/event/helper_4e42f7c7")
local helper_67ecfdb4 = require("@lib/event/helper_67ecfdb4")
local helper_b17402aa = require("@lib/event/helper_b17402aa")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_99() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.Initialize()
	vm.wait(1)
	event.CmrsSetPos(0.0, 1000.0, -100.0)
	event.CmrsSetRef(0.0, 1000.0, 0.0)
	event.AssignStack(5)
	event.ClearStack(5)
	event.EsmInitialize(5)
	event.EsmLoadBase("Ｅ７３２光雨")
	event.EsmInitFix(5)
	event.EsmCreate("Ｅ７３２光雨")
	event.EsmSetVect1(0.0, 1000.0, 0.0)
	event.EsmSetVect2(100.0, 100.0, 100.0)
	event.EsmSetValue(0, 240)
	vm.wait(2)
	helper_c956b4a2(64)
	event.EsmClear()
	event.Finish()
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1e6f252b()
	event.MapJump_3(-1, "s70", 530)
	vm.wait(2)
end

--- Event 600, which map data, a script or the engine runs by number.
function script.event_600()
	helper_01056549()
	event.MapJump_3(-1, "s30", 620)
	vm.wait(2)
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	helper_b17402aa()
	event.MapJump_3(-1, "s66", 610)
	vm.wait(2)
end

--- Event 620, which map data, a script or the engine runs by number.
function script.event_620()
	helper_67ecfdb4()
	event.MapJump_3(-1, "s66", 620)
	vm.wait(2)
end

--- Event 630, which map data, a script or the engine runs by number.
function script.event_630()
	helper_10731042()
	event.MapJump_3(-1, "s66", 630)
	vm.wait(2)
end

--- Event 640, which map data, a script or the engine runs by number.
function script.event_640()
	helper_4e42f7c7()
	event.MapJump_3(-1, "s66", 650)
	vm.wait(2)
end

return script
