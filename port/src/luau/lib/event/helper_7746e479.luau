--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_40ec498c = require("@lib/event/helper_40ec498c")
local helper_8a76ee53 = require("@lib/event/helper_8a76ee53")
local helper_b5473bd5 = require("@lib/event/helper_b5473bd5")
local helper_d75a0846 = require("@lib/event/helper_d75a0846")

--- Helper function.
local function helper_7746e479(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_8a76ee53(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_40ec498c(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_d75a0846(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_b5473bd5(arg0, arg1)
		return
	end
end

return helper_7746e479
