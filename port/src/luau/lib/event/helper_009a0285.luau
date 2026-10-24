--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_3064b557 = require("@lib/event/helper_3064b557")
local helper_4ea3437e = require("@lib/event/helper_4ea3437e")
local helper_755803e8 = require("@lib/event/helper_755803e8")
local helper_8217d9d7 = require("@lib/event/helper_8217d9d7")
local helper_cdb4ac20 = require("@lib/event/helper_cdb4ac20")

--- Helper function.
local function helper_009a0285(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_4ea3437e(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_cdb4ac20(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_755803e8(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_8217d9d7(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_3064b557(arg0, arg1)
		return
	end
end

return helper_009a0285
