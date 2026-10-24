--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_06ec3e6a = require("@lib/event/helper_06ec3e6a")
local helper_86f2c735 = require("@lib/event/helper_86f2c735")
local helper_a990e02e = require("@lib/event/helper_a990e02e")
local helper_dbfcf131 = require("@lib/event/helper_dbfcf131")

--- Helper function.
local function helper_ba5cb7eb(arg0: s32, arg1: s32)
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
		helper_06ec3e6a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_86f2c735(arg0, arg1)
		return
	end
end

return helper_ba5cb7eb
