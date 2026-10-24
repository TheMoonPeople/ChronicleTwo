--!strict
-- event/test_arg.stb: event_arg script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event_arg.ExtTyped(0, "ifff", 0, 50.0, 104.2, 0.0)
	event_arg.ExtTyped(0, "ifff", 0, 60.0, 104.2, 0.0)
	event_arg.ExtTyped(0, "ifff", 0, 70.0, 104.2, 0.0)
	event_arg.ExtTyped(0, "ifff", 0, 80.0, 104.2, 0.0)
	event_arg.IdOffset(100)
	event_arg.ExtTyped(0, "isi", 0, "歩き", 2)
end

return script
