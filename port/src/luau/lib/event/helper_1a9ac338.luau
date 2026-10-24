--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_095e3981 = require("@lib/event/helper_095e3981")
local helper_577dc059 = require("@lib/event/helper_577dc059")
local helper_7e7248fb = require("@lib/event/helper_7e7248fb")
local helper_a57041ea = require("@lib/event/helper_a57041ea")

--- Helper function.
local function helper_1a9ac338(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_095e3981(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_a57041ea(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_577dc059(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_7e7248fb(arg0, arg1)
		return
	end
end

return helper_1a9ac338
