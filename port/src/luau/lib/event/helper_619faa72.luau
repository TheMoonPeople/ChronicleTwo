--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_36a3d8ba = require("@lib/event/helper_36a3d8ba")
local helper_36a6359e = require("@lib/event/helper_36a6359e")
local helper_529b7eb9 = require("@lib/event/helper_529b7eb9")
local helper_585e5741 = require("@lib/event/helper_585e5741")
local helper_774a2231 = require("@lib/event/helper_774a2231")
local helper_791b8b66 = require("@lib/event/helper_791b8b66")
local helper_d272bace = require("@lib/event/helper_d272bace")

--- Helper function.
local function helper_619faa72(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_791b8b66(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_529b7eb9(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_585e5741(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_36a6359e(arg0, arg1)
		end
		if var4 == 1 then
			helper_d272bace(arg0, arg1)
		end
		if var4 == 2 then
			helper_774a2231(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_36a3d8ba(arg0, arg1)
		return
	end
end

return helper_619faa72
