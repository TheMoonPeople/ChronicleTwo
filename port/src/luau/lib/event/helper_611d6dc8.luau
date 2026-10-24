--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_096ef555 = require("@lib/event/helper_096ef555")
local helper_64baeed8 = require("@lib/event/helper_64baeed8")
local helper_811dabdb = require("@lib/event/helper_811dabdb")
local helper_8f10bcfe = require("@lib/event/helper_8f10bcfe")

--- Helper function.
local function helper_611d6dc8(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_096ef555(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_8f10bcfe(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_811dabdb(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_64baeed8(arg0, arg1)
		return
	end
end

return helper_611d6dc8
