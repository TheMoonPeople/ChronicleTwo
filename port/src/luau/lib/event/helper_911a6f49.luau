--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_170466f3 = require("@lib/event/helper_170466f3")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_911a6f49(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_170466f3(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Has estado fuera [UNI00fa]ltimamente,\n[UNI00bf]no, Max?<page>No lo niegues.\nLo s[UNI00e9] de buena tinta."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_911a6f49
