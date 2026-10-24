--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_97804c99 = require("@lib/event/helper_97804c99")
local helper_b4714303 = require("@lib/event/helper_b4714303")
local helper_b855451c = require("@lib/event/helper_b855451c")
local helper_d2cd91ac = require("@lib/event/helper_d2cd91ac")

--- Helper function.
local function helper_85550c55(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_d2cd91ac(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_97804c99(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b855451c(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b4714303(arg0, arg1)
		return
	end
end

return helper_85550c55
