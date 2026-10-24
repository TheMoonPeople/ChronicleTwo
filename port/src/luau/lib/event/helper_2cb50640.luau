--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_7df9ae2f = require("@lib/event/helper_7df9ae2f")
local helper_9b24f47f = require("@lib/event/helper_9b24f47f")
local helper_d96e5272 = require("@lib/event/helper_d96e5272")
local helper_e7b28db9 = require("@lib/event/helper_e7b28db9")

--- Helper function.
local function helper_2cb50640(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_9b24f47f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_e7b28db9(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_7df9ae2f(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_d96e5272(arg0, arg1)
		return
	end
end

return helper_2cb50640
