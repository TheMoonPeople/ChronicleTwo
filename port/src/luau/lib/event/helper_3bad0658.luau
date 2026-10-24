--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_43b86bec = require("@lib/event/helper_43b86bec")
local helper_86f2c735 = require("@lib/event/helper_86f2c735")
local helper_a990e02e = require("@lib/event/helper_a990e02e")
local helper_dbfcf131 = require("@lib/event/helper_dbfcf131")

--- Helper function.
local function helper_3bad0658(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_a990e02e(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_dbfcf131(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_43b86bec(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_86f2c735(arg0, arg1)
		return
	end
end

return helper_3bad0658
