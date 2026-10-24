--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_0cc8378f = require("@lib/event/helper_0cc8378f")
local helper_e0821a7c = require("@lib/event/helper_e0821a7c")
local helper_ef26a4fe = require("@lib/event/helper_ef26a4fe")
local helper_f170752b = require("@lib/event/helper_f170752b")

--- Helper function.
local function helper_cc0bf002(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_0cc8378f(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_f170752b(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_ef26a4fe(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_e0821a7c(arg0, arg1)
		return
	end
end

return helper_cc0bf002
