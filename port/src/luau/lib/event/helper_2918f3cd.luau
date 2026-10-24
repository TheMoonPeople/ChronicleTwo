--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_2918f3cd(arg0: s32, arg1: any)
	local var2: s32 = 0
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(
			0,
			"あのさ、気が向いた時で\n良いから、釣りのコツってのを\n教えてくんねぇか。"
		)
	else
		event.MesMake_2(0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	helper_907fd9a8(arg0, -1, 0, 0)
end

return helper_2918f3cd
