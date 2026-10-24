--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_06048908 = require("@lib/event/helper_06048908")
local helper_20c4b829 = require("@lib/event/helper_20c4b829")
local helper_4f3fd099 = require("@lib/event/helper_4f3fd099")
local helper_546b409a = require("@lib/event/helper_546b409a")
local helper_e0f20121 = require("@lib/event/helper_e0f20121")

--- Helper function.
local function helper_e9438054(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_546b409a(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_20c4b829(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_4f3fd099(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_06048908(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e0f20121(arg0, arg1)
		return
	end
end

return helper_e9438054
