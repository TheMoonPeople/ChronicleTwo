--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_39e55245 = require("@lib/event/helper_39e55245")
local helper_45269b94 = require("@lib/event/helper_45269b94")
local helper_61638389 = require("@lib/event/helper_61638389")
local helper_66922375 = require("@lib/event/helper_66922375")
local helper_fa77555b = require("@lib/event/helper_fa77555b")

--- Helper function.
local function helper_81ec7156(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_61638389(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_39e55245(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_45269b94(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_66922375(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_fa77555b(arg0, arg1)
		return
	end
end

return helper_81ec7156
