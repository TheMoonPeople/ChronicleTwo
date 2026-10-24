--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_899661d6 = require("@lib/event/helper_899661d6")

--- Helper function.
local function helper_30ed1f1b(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"I don't really like to see a\nwoman waving a sword around.<page>The best women are the ladylike\nones. Take Adel, for example."
		)
	else
		event.MesMake_2(0, "If there's anything I can help you\nwith, don't you hesitate to ask.")
	end
	helper_899661d6(arg0, -1, 0, 0)
end

return helper_30ed1f1b
