--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_3163b0d7(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah! Hallo!\nIch h[UNI00f6]re seit Kurzem schwer.<page>Ich verstehe dich nur, wenn\ndu ganz langsam sprichst."
	)
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_3163b0d7
