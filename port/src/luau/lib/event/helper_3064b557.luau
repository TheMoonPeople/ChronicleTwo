--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_3064b557(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"The book I got?\nActually, I haven't read it yet.<page>Just getting hold of it\nwas enough to make me happy."
		)
	else
		event.MesMake_2(0, "Zelmite Mine is a very scary place.\nYou must be sure to never let\nyour guard down.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_3064b557
