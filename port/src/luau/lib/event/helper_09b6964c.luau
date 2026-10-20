--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b33603c6 = require("@lib/event/helper_b33603c6")

--- Helper function.
local function helper_09b6964c(arg0: s32, arg1: any)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			event.MesMake_2(0, "Oh, bonjour jeune dame.\nQue puis-je faire pour vous ?")
		else
			event.MesMake_2(
				0,
				"Max, ne parle pas de cette eau\nsacr[UNI00e9]e [UNI00e0] ton p[UNI00e8]re, tu m'entends ?"
			)
		end
	else
		event.MesMake_2(0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	helper_b33603c6(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_09b6964c
