--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_40e84721 = require("@lib/event/helper_40e84721")

--- Helper function.
local function helper_66ac1f76()
	local chara_id: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	flag = event.GetFlag(275) or flag
	var1 = event.GetAnalyze(104) or var1
	if var1 == 0 or flag == 0 then
		chara_id = event.GetCharaId(102) or chara_id
		event.CharaActive(0, chara_id)
	else
		chara_id = event.GetCharaId(102) or chara_id
		event.CharaActive(1, chara_id)
	end
	var1 = event.GetAnalyze(105) or var1
	if var1 == 0 or flag == 0 then
		chara_id = event.GetCharaId(103) or chara_id
		event.CharaActive(0, chara_id)
	else
		chara_id = event.GetCharaId(103) or chara_id
		event.CharaActive(1, chara_id)
	end
	var1 = event.GetAnalyze(106) or var1
	if var1 == 0 or flag == 0 then
		chara_id = event.GetCharaId(101) or chara_id
		event.CharaActive(0, chara_id)
	else
		chara_id = event.GetCharaId(101) or chara_id
		event.CharaActive(1, chara_id)
	end
	var1 = event.GetAnalyze(107) or var1
	helper_40e84721(104, var1)
	var1 = event.GetAnalyze(103) or var1
	helper_40e84721(105, var1)
end

return helper_66ac1f76
