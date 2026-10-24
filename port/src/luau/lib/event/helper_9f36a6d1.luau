--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_038c8cda = require("@lib/event/helper_038c8cda")
local helper_4f827424 = require("@lib/event/helper_4f827424")
local helper_5c4888fd = require("@lib/event/helper_5c4888fd")
local helper_ceb5cdb0 = require("@lib/event/helper_ceb5cdb0")
local helper_e508c7a5 = require("@lib/event/helper_e508c7a5")

--- Helper function.
local function helper_9f36a6d1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 0 then
		helper_4f827424(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_5c4888fd(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_038c8cda(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_ceb5cdb0(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_e508c7a5(arg0, arg1)
		return
	end
end

return helper_9f36a6d1
