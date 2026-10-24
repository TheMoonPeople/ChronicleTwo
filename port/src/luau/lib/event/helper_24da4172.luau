--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_24da4172(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"Du hast mich im Zirkus gesehen?\nNicht schlecht, was?<page>Es ist weniger mein Beruf\nals mein Hobby."
		)
	else
		event.MesMake_2(0, "Na, wie steht's? Bist du in der\nMine schon Fieslingen begegnet?")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_24da4172
