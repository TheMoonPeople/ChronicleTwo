--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_3064b557 = require("@lib/event/helper_3064b557")
local helper_45160785 = require("@lib/event/helper_45160785")
local helper_4ea3437e = require("@lib/event/helper_4ea3437e")
local helper_9396eb0b = require("@lib/event/helper_9396eb0b")
local helper_cdb4ac20 = require("@lib/event/helper_cdb4ac20")

--- Helper function.
local function helper_9af7df2e(arg0: s32, arg1: s32)
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
		helper_9396eb0b(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_45160785(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_3064b557(arg0, arg1)
		return
	end
end

return helper_9af7df2e
