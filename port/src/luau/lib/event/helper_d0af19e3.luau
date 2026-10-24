--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_db3ae7e7 = require("@lib/event/helper_db3ae7e7")

--- Helper function.
local function helper_d0af19e3(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_db3ae7e7(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Sei stato fuori citt[UNI00e0] ultimamente,\nvero Max?<page>Non negarlo.\nSo che [UNI00e8] cos[UNI00ec]!"
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_d0af19e3
