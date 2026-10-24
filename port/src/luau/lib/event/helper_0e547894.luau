--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")

--- Helper function.
local function helper_0e547894()
	local var0: s32 = 0
	local flag: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	helper_125385ee(0, 1)
	flag = event.GetFlag(648) or flag
	if flag == 0 then
		event.MesMake_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.MesMake_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	helper_907fd9a8(var0, -1, 0, 0)
end

return helper_0e547894
