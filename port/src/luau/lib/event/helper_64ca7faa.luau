--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_635ee3fd = require("@lib/event/helper_635ee3fd")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_64ca7faa(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b33603c6(arg0, -1, 0, 0)
		end
	end
	event.SetMesPreset(0, 0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMotion(arg1, "立ち")
		event.MesMake_2(0, "Umm. Este [UNI00e1]rbol... Le pasa\nalgo. Tengo que hacer algo.")
		helper_635ee3fd(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(1)
		end
	else
		event.MesMake_2(
			0,
			"[UNI00a1]Max! Qu[UNI00e9] susto.\nEstaba quit[UNI00e1]ndole los bichos\na este [UNI00e1]rbol.<page>No todos los [UNI00e1]rboles crecen bien\nsolos. A algunos, como\neste, hay que vigilarlos."
		)
		helper_b33603c6(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return helper_64ca7faa
