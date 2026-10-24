--!strict
-- event/e200/e209/e209.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(47.85, 34.92, -87.81)
	event.GetPadon(38.72, 33.02, 92.47)
	event.GetPadon(0, 15.36, 21.69, 79.32)
	event.GetPadon(0, 0.0, 1.48, 0.0)
	event.GetPadon(1, 15.0, 21.86, 98.31)
	event.GetPadon(1, 0.0, 1.48, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(61.85, 30.75, 55.74)
	event.GetPadon(57.45, 21.42, -9.43)
	event.GetPadon(2, 58.4, 0.0, 1.06)
	event.GetPadon(2, 0.0, 0.0, 0.0)
	event.GetPadon(3, 28.34, 0.57, -39.22)
	event.GetPadon(3, 0.0, 1.96, 0.0)
	event.GetPadon(4, 71.48, 0.0, -107.07)
	event.GetPadon(4, 0.0, -0.36, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(56.12, 35.66, 3.04)
	event.GetPadon(56.18, 35.01, 32.48)
	event.GetPadon(0, 49.74, 12.34, 47.06)
	event.GetPadon(0, 0.0, 3.02, 0.0)
	event.GetPadon(1, 63.93, 12.34, 50.38)
	event.GetPadon(1, 0.0, -3.05, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(86.4, 35.58, 37.63)
	event.GetPadon(34.19, 32.85, 34.56)
	event.GetPadon(0, 21.33, 12.34, 45.09)
	event.GetPadon(0, 0.0, 3.02, 0.0)
	event.GetPadon(1, 42.69, 12.34, 41.7)
	event.GetPadon(1, 0.0, 2.75, 0.0)
	event.GetPadon(2, 24.11, 0.0, -20.65)
	event.GetPadon(2, 0.0, 0.0, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(52.55, 35.58, 13.03)
	event.GetPadon(44.12, 34.89, 36.23)
	event.GetPadon(1, 42.69, 12.34, 41.7)
	event.GetPadon(1, 0.0, 2.75, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(2.18, 46.91, 68.63)
	event.GetPadon(38.99, 24.26, 23.48)
	event.GetPadon(1, 29.12, 12.34, 47.22)
	event.GetPadon(1, 0.0, 2.75, 0.0)
	event.GetPadon(2, 30.83, 4.65, 14.67)
	event.GetPadon(2, 0.0, -0.06, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(43.67, 33.43, 12.97)
	event.GetPadon(41.83, 34.76, 50.66)
	event.GetPadon(0, 44.19, 12.34, 52.18)
	event.GetPadon(0, 0.0, 2.78, 0.0)
	event.GetPadon(1, 30.91, 12.34, 48.78)
	event.GetPadon(1, 0.0, 2.39, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(94.01, 39.28, 10.79)
	event.GetPadon(59.46, 32.19, 37.99)
	event.GetPadon(0, 32.17, 12.34, 42.65)
	event.GetPadon(0, 0.0, 0.26, 0.0)
	event.GetPadon(1, 49.66, 12.34, 42.45)
	event.GetPadon(1, 0.0, -0.01, 0.0)
	event.GetPadon(2, 53.24, 12.34, 59.33)
	event.GetPadon(2, 0.0, 2.98, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(56.03, 40.34, 44.22)
	event.GetPadon(56.81, 27.88, -5.86)
	event.GetPadon(0, 50.37, 0.0, 0.02)
	event.GetPadon(0, 0.0, 3.06, 0.0)
	event.GetPadon(1, 67.45, 0.0, 0.38)
	event.GetPadon(1, 0.0, 0.27, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(55.08, 35.17, 42.09)
	event.GetPadon(56.63, 30.41, -0.63)
	event.GetPadon(0, 87.97, 0.0, -36.63)
	event.GetPadon(0, 0.0, -2.02, 0.0)
	event.GetPadon(1, 98.53, 0.0, -70.67)
	event.GetPadon(1, 0.0, -2.73, 0.0)
	event.GetPadon(2, 33.17, 2.88, -34.15)
	event.GetPadon(2, 0.0, 2.74, 0.0)
	event.GetPadon(3, 25.37, 0.0, -58.45)
	event.GetPadon(3, 0.0, 1.96, 0.0)
	event.GetPadon(4, 71.48, 0.0, -105.0)
	event.GetPadon(4, 0.0, -0.36, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(63.0, 27.34, -51.57)
	event.GetPadon(60.59, 22.58, -83.91)
	event.GetPadon(4, 61.29, 0.0, -105.37)
	event.GetPadon(4, 0.0, -0.0, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(45.9, 27.34, -63.38)
	event.GetPadon(85.47, 22.58, -55.29)
	event.GetPadon(0, 92.42, 0.0, -40.24)
	event.GetPadon(0, 0.0, -2.02, 0.0)
	event.GetPadon(1, 98.01, 0.0, -62.77)
	event.GetPadon(1, 0.0, -2.73, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(63.0, 27.34, -51.57)
	event.GetPadon(60.59, 22.58, -83.91)
	event.GetPadon(4, 61.29, 0.0, -105.37)
	event.GetPadon(4, 0.0, -0.0, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(109.45, 27.34, -66.58)
	event.GetPadon(55.6, 22.58, -83.5)
	event.GetPadon(3, 23.32, 0.0, -69.64)
	event.GetPadon(3, 0.0, 1.96, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(63.06, 23.11, -82.13)
	event.GetPadon(85.85, 22.58, -60.45)
	event.GetPadon(1, 98.35, 0.0, -54.99)
	event.GetPadon(1, 0.0, -1.65, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(60.48, 23.11, -56.97)
	event.GetPadon(59.79, 22.58, -94.77)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(69.53, 18.95, -50.32)
	event.GetPadon(62.12, 22.58, -3.68)
	event.GetPadon(0, 56.83, 0.0, -13.26)
	event.GetPadon(0, 0.0, -2.98, 0.0)
	event.GetPadon(1, 69.02, 0.0, -18.59)
	event.GetPadon(1, 0.0, -2.73, 0.0)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(67.9, 35.32, 32.04)
	event.GetPadon(64.63, 22.72, -37.88)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(74.26, 19.77, -50.17)
	event.GetPadon(63.44, 22.72, -11.94)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(90.32, 19.77, -83.29)
	event.GetPadon(50.68, 19.94, -102.21)
	event.GetPaddown() -- retail: argument 1 is a value where the handler writes an output; the output is discarded
	event.GetPadon(74.26, 19.77, -50.17)
	event.GetPadon(63.44, 22.72, -11.94)
end

return script
