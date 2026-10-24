--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_18fe774e(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Du hast mir geholfen, dann\nhelfe ich dir auch - aber bitte\nschlepp mich nicht zu Insekten!"
		)
	else
		event.MesMake_2(
			0,
			"Wenn die Blackstone-Bahn die\nganze Welt bef[UNI00e4]hrt, muss\nich vielleicht auch mal hier raus."
		)
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_18fe774e
