--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_cc3bc91c(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
	else
		event.MesMake_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	helper_907fd9a8(arg0, -1, 0, 0)
end

return helper_cc3bc91c
