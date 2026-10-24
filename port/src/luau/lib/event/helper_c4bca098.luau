--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_024d6b41 = require("@lib/event/helper_024d6b41")
local helper_180b9cba = require("@lib/event/helper_180b9cba")
local helper_19f3b04d = require("@lib/event/helper_19f3b04d")
local helper_2e68fae0 = require("@lib/event/helper_2e68fae0")
local helper_48d04578 = require("@lib/event/helper_48d04578")
local helper_4fed2cde = require("@lib/event/helper_4fed2cde")
local helper_7a914133 = require("@lib/event/helper_7a914133")

--- Helper function.
local function helper_c4bca098(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_19f3b04d(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_180b9cba(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_48d04578(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_2e68fae0(arg0, arg1)
		end
		if var4 == 1 then
			helper_7a914133(arg0, arg1)
		end
		if var4 == 2 then
			helper_024d6b41(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_4fed2cde(arg0, arg1)
		return
	end
end

return helper_c4bca098
