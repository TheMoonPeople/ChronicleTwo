--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")
local helper_be04aa4a = require("@lib/event/helper_be04aa4a")

--- Helper function.
local function helper_86f2c735(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_be04aa4a(arg0, arg1)
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"I can't believe it. I never\nreally imagined you could get them.<page>That's really something, Max!"
		)
	else
		event.MesMake_2(0, "Hey! How goes the Zelmite hunt?\nIf there's anything I can do,\njust gimme a holler.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_86f2c735
