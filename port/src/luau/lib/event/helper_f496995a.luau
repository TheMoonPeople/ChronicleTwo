--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_f496995a(arg0: s32, arg1: any)
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
	event.MesMake_2(0, "Los Firbit s[UNI00f3]lo\nconceder[UNI00e1]n favores a\nlos que sean mejores que ellos.")
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_f496995a
