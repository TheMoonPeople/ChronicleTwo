--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_907c711b = require("@lib/event/helper_907c711b")

--- Helper function.
local function helper_f96c15b3(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_907c711b(arg0, arg1)
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Tu as quitt[UNI00e9] la ville r[UNI00e9]cemment,\nnon, Max ?<page>Ne dis pas le contraire.\nJe le sais."
	)
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_f96c15b3
