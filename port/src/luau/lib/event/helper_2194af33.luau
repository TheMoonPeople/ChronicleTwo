--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_218a6e5c = require("@lib/event/helper_218a6e5c")
local helper_24da4172 = require("@lib/event/helper_24da4172")
local helper_4fbbcd13 = require("@lib/event/helper_4fbbcd13")
local helper_deebbc9f = require("@lib/event/helper_deebbc9f")
local helper_f9384a28 = require("@lib/event/helper_f9384a28")

--- Helper function.
local function helper_2194af33(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_24da4172(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_4fbbcd13(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_218a6e5c(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_deebbc9f(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_f9384a28(arg0, arg1)
		return
	end
end

return helper_2194af33
