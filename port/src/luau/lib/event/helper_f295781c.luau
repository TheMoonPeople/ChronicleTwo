--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_055fefad = require("@lib/event/helper_055fefad")
local helper_1721f014 = require("@lib/event/helper_1721f014")
local helper_3128739b = require("@lib/event/helper_3128739b")
local helper_5bb30dc8 = require("@lib/event/helper_5bb30dc8")
local helper_a9960655 = require("@lib/event/helper_a9960655")
local helper_e3d1781e = require("@lib/event/helper_e3d1781e")
local helper_e5fbed05 = require("@lib/event/helper_e5fbed05")

--- Helper function.
local function helper_f295781c(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_3128739b(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_a9960655(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_055fefad(arg0, arg1)
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_1721f014(arg0, arg1)
		end
		if var4 == 1 then
			helper_e5fbed05(arg0, arg1)
		end
		if var4 == 2 then
			helper_e3d1781e(arg0, arg1)
		end
		return
	end
	if var3 == 2 then
		helper_5bb30dc8(arg0, arg1)
		return
	end
end

return helper_f295781c
