--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_5ad564b3 = require("@lib/event/helper_5ad564b3")
local helper_82d3e8a8 = require("@lib/event/helper_82d3e8a8")
local helper_bf3febd1 = require("@lib/event/helper_bf3febd1")
local helper_de2f7f42 = require("@lib/event/helper_de2f7f42")

--- Helper function.
local function helper_5f94bc55(arg0: s32, arg1: s32)
	local var2: s32 = 0
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_de2f7f42(arg0, arg1)
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_bf3febd1(arg0, arg1)
		return
	end
	if var2 == 1 then
		helper_82d3e8a8(arg0, arg1)
		return
	end
	if var2 == 2 then
		helper_5ad564b3(arg0, arg1)
		return
	end
end

return helper_5f94bc55
