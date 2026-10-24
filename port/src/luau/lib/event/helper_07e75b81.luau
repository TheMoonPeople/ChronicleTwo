--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_006d3188 = require("@lib/event/helper_006d3188")
local helper_4ad449c6 = require("@lib/event/helper_4ad449c6")
local helper_7fe3e529 = require("@lib/event/helper_7fe3e529")
local helper_9fe49eb0 = require("@lib/event/helper_9fe49eb0")
local helper_affb975d = require("@lib/event/helper_affb975d")

--- Helper function.
local function helper_07e75b81(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_4ad449c6(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_9fe49eb0(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_006d3188(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_7fe3e529(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_affb975d(arg0, arg1)
		return
	end
end

return helper_07e75b81
