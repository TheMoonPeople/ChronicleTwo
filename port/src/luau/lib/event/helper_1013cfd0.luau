--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_1013cfd0(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Esta ciudad es demasiado pac[UNI00ed]fica y\nno hay trabajo para m[UNI00ed].<page>Ya s[UNI00e9] que eso es bueno,\npero..."
	)
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_1013cfd0
