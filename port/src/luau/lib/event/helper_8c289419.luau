--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_8c289419(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Du hast mir dieses Bild\ndes Mondes gegeben.\nDu bist ein guter Mensch.")
	else
		event.MesMake_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, k[UNI00f6]nnen wir\nlauter coole neue Orte besuchen."
		)
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_8c289419
