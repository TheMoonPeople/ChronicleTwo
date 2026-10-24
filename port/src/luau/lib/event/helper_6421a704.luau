--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_1449e05c = require("@lib/event/helper_1449e05c")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_6421a704(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_1449e05c(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Du warst au[UNI00df]erhalb der Stadt,\nstimmt's, Max?<page>Streite es nicht ab.\nIch wei[UNI00df], dass es stimmt."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_6421a704
