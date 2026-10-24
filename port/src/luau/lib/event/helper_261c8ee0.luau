--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_01d4c23c = require("@lib/event/helper_01d4c23c")
local helper_3e1298f4 = require("@lib/event/helper_3e1298f4")
local helper_9bde0a9a = require("@lib/event/helper_9bde0a9a")
local helper_b20c4580 = require("@lib/event/helper_b20c4580")

--- Helper function.
local function helper_261c8ee0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_9bde0a9a(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_01d4c23c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_3e1298f4(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b20c4580(arg0, arg1)
		return
	end
end

return helper_261c8ee0
