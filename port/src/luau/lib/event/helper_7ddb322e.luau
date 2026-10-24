--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_cfca5edb = require("@lib/event/helper_cfca5edb")
local helper_dd00ae6e = require("@lib/event/helper_dd00ae6e")
local helper_f4fb7e7a = require("@lib/event/helper_f4fb7e7a")
local helper_fbc0d2b3 = require("@lib/event/helper_fbc0d2b3")

--- Helper function.
local function helper_7ddb322e(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_fbc0d2b3(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_cfca5edb(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_f4fb7e7a(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_dd00ae6e(arg0, arg1)
		return
	end
end

return helper_7ddb322e
