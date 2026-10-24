--!strict
-- event/tbox/ntbox_arg.stb: event_arg script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event_arg.ExtTyped(0, "fff", 0.0, 29.0, 57.0)
	event_arg.ExtTyped(0, "fff", 0.0, 10.0, 0.0)
	event_arg.ExtTyped(0, "ffffffi", 0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	event_arg.ExtTyped(0, "ifff", 1, 0.0, 0.0, 0.0)
	event_arg.ExtTyped(0, "ifff", 1, 0.0, 0.0, 0.0)
	event_arg.ExtTyped(0, "isi", 1, "ゲット", 6)
	event_arg.ExtTyped(0, "ifff", 0, 0.0, -5.0, 0.0)
	event_arg.ExtTyped(0, "ifff", 0, 0.0, 0.0, 0.0)
	event_arg.ExtTyped(0, "iffffi", 0, 0.0, 17.0, 0.0, -0.3, 20)
	event_arg.ExtTyped(0, "iffffi", 0, 0.0, 17.0, 0.0, -0.4, 8)
	event_arg.ExtTyped(0, "iffffi", 0, 0.0, 17.0, 0.0, -0.2, 5)
end

return script
