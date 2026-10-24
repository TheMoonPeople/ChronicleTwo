--!strict
-- map/r01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("chara/")
	event.LoadChara(4, "c002a.chr", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, -100.0, 0.0, 0.0)
	event.LoadChara(4, "c005a.chr", "info", 9)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, -50.0, 0.0, 0.0)
	event.LoadChara(4, "sraim.chr", "info", 10)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, 0.0, 0.0, 0.0)
	event.LoadChara(4, "a_ku.chr", "info", 11)
	event.CharaActive(1, 11)
	event.SetCharaPos(11, 50.0, 0.0, 0.0)
	event.ChangeDir("")
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(32)
end

return script
