--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_27e5be1d = require("@lib/event/helper_27e5be1d")
local helper_4463601d = require("@lib/event/helper_4463601d")
local helper_ccde7766 = require("@lib/event/helper_ccde7766")
local helper_db12dafd = require("@lib/event/helper_db12dafd")

--- Helper function.
local function helper_b49f2b6a(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_27e5be1d(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_4463601d(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_ccde7766(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_db12dafd(arg0, arg1)
		return
	end
end

return helper_b49f2b6a
