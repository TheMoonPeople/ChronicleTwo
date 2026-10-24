--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5ad564b3 = require("@lib/event/helper_5ad564b3")
local helper_8fea9efb = require("@lib/event/helper_8fea9efb")
local helper_b2d44402 = require("@lib/event/helper_b2d44402")
local helper_de2f7f42 = require("@lib/event/helper_de2f7f42")

--- Helper function.
local function helper_fc9ca1c3(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_de2f7f42(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_8fea9efb(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_b2d44402(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_5ad564b3(arg0, arg1)
		return
	end
end

return helper_fc9ca1c3
