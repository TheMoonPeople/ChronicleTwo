--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_c4777c25(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Tu m'as donn[UNI00e9] cette photo de la\nlune. Tu es g[UNI00e9]n[UNI00e9]reux.")
	else
		event.MesMake_2(
			0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_c4777c25
