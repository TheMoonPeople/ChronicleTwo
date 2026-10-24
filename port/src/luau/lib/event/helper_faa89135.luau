--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_712b711c = require("@lib/event/helper_712b711c")
local helper_b5e1e8d7 = require("@lib/event/helper_b5e1e8d7")
local helper_d1ef892a = require("@lib/event/helper_d1ef892a")
local helper_e607adde = require("@lib/event/helper_e607adde")

--- Helper function.
local function helper_faa89135(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e607adde(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_712b711c(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_d1ef892a(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_b5e1e8d7(arg0, arg1)
		return
	end
end

return helper_faa89135
