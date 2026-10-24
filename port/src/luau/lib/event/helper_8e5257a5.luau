--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_27e5be1d = require("@lib/event/helper_27e5be1d")
local helper_67fac240 = require("@lib/event/helper_67fac240")
local helper_b177e1ef = require("@lib/event/helper_b177e1ef")
local helper_db12dafd = require("@lib/event/helper_db12dafd")

--- Helper function.
local function helper_8e5257a5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_27e5be1d(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_67fac240(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b177e1ef(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_db12dafd(arg0, arg1)
		return
	end
end

return helper_8e5257a5
