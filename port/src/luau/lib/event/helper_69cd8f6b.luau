--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_3fcbcef1 = require("@lib/event/helper_3fcbcef1")
local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_69cd8f6b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_3fcbcef1(arg0, arg1)
			return
		end
		event.SetMesPreset(0, 0)
		event.MesMake_2(
			0,
			"Ich fass es nicht. Ich habe nicht\ngedacht, dass du sie findest.<page>Das war echt gut, Max!"
		)
	else
		event.MesMake_2(0, "He! Wie l[UNI00e4]uft die Zelmit-Suche?\nWenn ich helfen kann,\nsag einfach Bescheid.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_69cd8f6b
